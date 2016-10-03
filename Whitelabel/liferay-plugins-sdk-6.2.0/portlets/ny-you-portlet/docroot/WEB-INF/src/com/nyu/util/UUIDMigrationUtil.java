package com.nyu.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.StringPool;
import com.nyu.model.DocumentFile;
import com.nyu.model.Lesson;
import com.nyu.service.DocumentFileLocalServiceUtil;
import com.nyu.service.LessonLocalServiceUtil;

/** IMPORTANT: REMOVE THIS COMPLETE CLASS WHILE CODE REFACTORING **/


public class UUIDMigrationUtil{
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(UUIDMigrationUtil.class);
	/***
	 * Send an HTTP POST request to an Endpoint.
	 * @param url : Target endpoint url
	 * @param params : Target endpoint url params in the form of key/value pairs stored as a map.
	 * @return : Returns the response of the Endpoint url
	 */
	
	private static long LessonId = 0l;
	private static Lesson lesson = null;
	
	public static List<DocumentFile> updateDocUUID(List<DocumentFile> docs){
		List<DocumentFile> updatedUUIDDocsList = null;
		
		try {
				//Remove all docs from Ngage 
				callForRemoveMedia(docs);
				
				/** 1. Separate video-transcript map & other docs.
				 *  2. Generate & Update UUID of all docs. Call Add Media on each doc
				 *  3. Get all docs with updated UUID 
				 */
				
			  //1. Separate video-transcript map & other docs.
				Map<List<DocumentFile>, Map<DocumentFile, DocumentFile>> vtAndOtherDocstMap = new HashMap<List<DocumentFile>, Map<DocumentFile, DocumentFile>>();
				vtAndOtherDocstMap = getVTAndOtherDocsMap(docs);
				
			  //2. Generate & Update UUID of all docs. Call Add Media on each doc
				uuidUpdateAndAddMedia(vtAndOtherDocstMap, lesson);
				
			  //3. Get all docs with updated UUID
				updatedUUIDDocsList = LessonLocalServiceUtil.getDocumentFileList(LessonId);
				
				
		} catch (SystemException e) {
			LOG.error(e);
		}
		
		lesson = null;
		
		return updatedUUIDDocsList;
	}
	
	private static Map<List<DocumentFile>, Map<DocumentFile, DocumentFile>> getVTAndOtherDocsMap(List<DocumentFile> docs){
		Map<DocumentFile, DocumentFile> videoTranscriptMap = new HashMap<DocumentFile, DocumentFile>();
		
		List<DocumentFile> otherDocs = new ArrayList<DocumentFile>();
		List<DocumentFile> videoList = null;
		List<DocumentFile> transcriptList = null;//new ArrayList<DocumentFile>();
		
		Map<List<DocumentFile>, Map<DocumentFile, DocumentFile>> finalMap = new HashMap<List<DocumentFile>, Map<DocumentFile, DocumentFile>>();
				
		for(DocumentFile vDoc : docs){
			if(vDoc.getDocumentName().endsWith(Constant.DOT_MP4)){
				for(DocumentFile tDoc : docs){
					if(!vDoc.equals(tDoc) && tDoc.getDocumentName().endsWith(Constant.PERIOD_TEXT) && vDoc.getCreatedDate().equals(tDoc.getCreatedDate())){
						videoTranscriptMap.put(vDoc, tDoc);
					}
				}
				
				//if video has no transcript
				if(videoTranscriptMap.size()>0){
					videoList = new ArrayList<DocumentFile>(videoTranscriptMap.keySet());
					if(!videoList.contains((DocumentFile)vDoc))
						otherDocs.add(vDoc);
				}else{
					otherDocs.add(vDoc);
				}
				
				
			}else{
				if(videoTranscriptMap.size()>0){
					transcriptList = new ArrayList<DocumentFile>(videoTranscriptMap.values());
					if(!transcriptList.contains((DocumentFile)vDoc))
						otherDocs.add(vDoc);
					
				}else{
					otherDocs.add(vDoc);
				}
			}
			
		}
		
		finalMap.put(otherDocs, videoTranscriptMap);
		
		return finalMap;
	}
	
	
	private static void callForRemoveMedia(List<DocumentFile> docs){
		
		for(DocumentFile df : docs){
			
			try {
				
				if(lesson == null){
					LessonId = df.getLessonId();
					LOG.info("LESSON ID: "+LessonId);
					lesson = LessonLocalServiceUtil.getLesson(LessonId);
				}
				
				Map<String, String> params = new HashMap<String, String>();
				
			
				params.put(Constant.COURSE_ID, lesson.getCourseId());
				params.put(Constant.CAPITAL_D_DATE, DateUtil.toString(df.getCreatedDate()));
				//params.put("MediaType", "");
				params.put(Constant.LOCATION,df.getDownloadUrl());//download url
				params.put(Constant.LAUNCHER_KEY, Constant.PORTLET_PROP_LAUNCHER_KEY);
				LOG.info("REMOVE MEDIA Params : courseId > "+params.get(Constant.COURSE_ID)+" Date > "+params.get(Constant.CAPITAL_D_DATE)+" Location > "+params.get(Constant.LOCATION)+" LauncherKey > "+params.get(Constant.LAUNCHER_KEY));
				
				String response = httpPostRequest(Constant.PORTLET_PROP_ENGAGE_REMOVE_MEDIA_URL, params);
				
				LOG.info("REMOVE MEDIA:  Doc Name: "+df.getDocumentName() +" Resource Id: "+df.getResourceId()+" Responce from Ngage: "+response);
				
			} catch (PortalException e) {
				LOG.error(e);
			} catch (SystemException e) {
				LOG.error(e);
			}
		}
		
	}
	
	private static void callForAddMedia(DocumentFile doc, Lesson lesson, boolean hasTranscript){
		
		if(doc!=null){
			
			Map<String, String> params = new HashMap<String, String>();
			
			params.put(Constant.COURSE_ID, lesson.getCourseId());
			if(doc.getDocUuid()!=null || doc.getDocUuid()!=StringPool.BLANK){
				params.put(Constant.REFERENCE_ID, doc.getDocUuid());
			}
			
			/*if(doc.getCreatedDate()!=null || doc.getCreatedDate().toString()!=""){//TO-DO remove Date field later as Engage is not going to use date.
				params.put(Constant.CAPITAL_D_DATE, doc.getCreatedDate().toString());
			}*/
			
			/*if(doc.getDocumentName().endsWith(Constant.DOT_ZIP) && doc.getDocumentName().contains(Constant.DOT_SCORM)){
				params.put("MediaType", Constant.SCORM);
			}else{
				params.put("MediaType", "");
			}*/
			
			params.put(Constant.LOCATION, doc.getDownloadUrl());
			params.put(Constant.LAUNCHER_KEY,  Constant.PORTLET_PROP_LAUNCHER_KEY);
			if(hasTranscript){
				params.put(Constant.WITH_TRANSCRIPT, Constant.CAPITAL_T_TRUE);
			}else{
				params.put(Constant.WITH_TRANSCRIPT, Constant.CAPITAL_F_FALSE);
			}
			
			LOG.info("ADD MEDIA: Params : courseId > "+params.get(Constant.COURSE_ID)+" ReferenceId > "+params.get(Constant.REFERENCE_ID)+" MediaType > "+params.get("MediaType")+" Location > "+params.get(Constant.LOCATION)+" LauncherKey > "+params.get(Constant.LAUNCHER_KEY) + " WithTranscript > "+params.get(Constant.WITH_TRANSCRIPT));
			
			String response = httpPostRequest(Constant.PORTLET_PROP_ENGAGE_RECORDER_URL, params);
			
			LOG.info("ADD MEDIA:  Doc Name: "+doc.getDocumentName() +" Resource Id: "+doc.getResourceId()+" Responce from Ngage: "+response);
		}
		
	
	}
	
	private static void uuidUpdateAndAddMedia(Map<List<DocumentFile>, Map<DocumentFile, DocumentFile>> vtAndOtherDocstMap, Lesson lesson){
		
		DocumentFile vDoc = null;
		DocumentFile tDoc = null;
		
		List<DocumentFile> otherDocs = null;
		String docUUID = null;
		Map<DocumentFile, DocumentFile> videoTranscriptMap = null;
		Map.Entry<List<DocumentFile>, Map<DocumentFile, DocumentFile>> docEntry = null;
		Map.Entry<DocumentFile, DocumentFile> entry  = null;
		try {
			if(vtAndOtherDocstMap.size()>0){
				docEntry = vtAndOtherDocstMap.entrySet().iterator().next();//(Entry<List<DocumentFile>, Map<DocumentFile, DocumentFile>>) vtAndOtherDocstMap.entrySet();
				otherDocs = docEntry.getKey();
				videoTranscriptMap = docEntry.getValue();
				if(otherDocs!=null && otherDocs.size()>0){
					for(DocumentFile df : otherDocs){
						docUUID = UUID.randomUUID().toString();//UUID Generation
						df.setDocUuid(docUUID);
						df.setDocumentPath(df.getDocumentPath()+Constant.AMPERSAND_UUID_EQUAL+docUUID);//Append UUID to Resource URL
						DocumentFileLocalServiceUtil.updateDocumentFile(df);
						
						callForAddMedia(df, lesson, false);// Add media
					}
				}
				
				if(videoTranscriptMap!=null && videoTranscriptMap.size()>0){
					
					for(Iterator<Map.Entry<DocumentFile, DocumentFile>> it = videoTranscriptMap.entrySet().iterator(); it.hasNext();){
						
						docUUID = UUID.randomUUID().toString();//UUID Generation
						
						entry = it.next();
						vDoc = 	entry.getKey();
						vDoc.setDocUuid(docUUID);
						vDoc.setDocumentPath(vDoc.getDocumentPath()+Constant.AMPERSAND_UUID_EQUAL+docUUID);//Append UUID to Resource URL
						DocumentFileLocalServiceUtil.updateDocumentFile(vDoc);//Update Video UUID
						callForAddMedia(vDoc, lesson, true);// Add media for video 
						
						tDoc =  entry.getValue();
						tDoc.setDocUuid(docUUID);
						tDoc.setDocumentPath(tDoc.getDocumentPath()+Constant.AMPERSAND_UUID_EQUAL+docUUID);//Append UUID to Resource URL 
						DocumentFileLocalServiceUtil.updateDocumentFile(tDoc);//Update Transcript UUID with same Video UUID
						callForAddMedia(tDoc, lesson, false);// Add media for Transcript
						
					}
					
					
				}
				
				
			}
		
		} catch (SystemException e) {
			LOG.error(e);
		}
		
		
	}
	
	public static String httpPostRequest(String url, Map<String, String> params)
	{
		
		HttpClient httpClient = new DefaultHttpClient();
		HttpPost postRequest = new HttpPost(url);
	

		HttpResponse response = null;
		BufferedReader reader = null;
		
		StringBuilder sb = new StringBuilder();
		
		try
		{
			// Build http params if any
			if(params != null)
			{
				Iterator itr = params.keySet().iterator();
				
				List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();

				while(itr.hasNext())
				{
					String key = (String)itr.next();
					String value = (String)params.get(key);
					nameValuePairs.add(new BasicNameValuePair(key, value ));
					LOG.info("UUIDMigrationUtil>httpPostRequest:  Key: "+key+"Value: "+value);
				}
				
				UrlEncodedFormEntity form = new UrlEncodedFormEntity(nameValuePairs, Constant.UTF_EIGHT);
				postRequest.setEntity(form);
			}
			
			response = httpClient.execute(postRequest);
			
			response.getEntity().getContent();
			reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
			
			String line = null;
			while( (line = reader.readLine()) != null)
			{
				sb.append(line);
			}			
		}
		catch(Exception e)
		{
			LOG.error(e);
		}
		finally
		{
			try
			{
				reader.close();
			}
			catch (Exception e) 
			{
				LOG.error(e);
			}
		}
		
		return sb.toString();
	}
	
	/**
	 * *
	 * Send an HTTP POST request to an Endpoint.
	 *
	 * @param url : Target endpoint url
	 * @return : Returns the response of the Endpoint url
	 */
	public static String httpGetRequest(String url)
	{
		
		HttpClient httpClient = new DefaultHttpClient();
		HttpGet getRequest = new HttpGet(url);
	

		HttpResponse response = null;
		BufferedReader reader = null;
		
		StringBuilder sb = new StringBuilder();
		
		try
		{		
			response = httpClient.execute(getRequest);
			
			response.getEntity().getContent();
			reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
			
			String line = null;
			while( (line = reader.readLine()) != null)
			{
				sb.append(line);
			}			
		}
		catch(Exception e)
		{
			LOG.error(e);
		}
		finally
		{
			try
			{
				reader.close();
			}
			catch (Exception e) 
			{
				LOG.error(e);
			}
		}
		
		return sb.toString();
	}
	
}
