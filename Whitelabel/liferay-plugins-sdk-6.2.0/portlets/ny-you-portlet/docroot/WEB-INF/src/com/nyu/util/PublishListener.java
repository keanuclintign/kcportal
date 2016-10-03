package com.nyu.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.sakaiproject.esb.client.impl.ServiceRegistryImpl;
import org.sakaiproject.esb.model.xsd.CloudStorageServiceClass_CloudStorageRequest;
import org.sakaiproject.esb.model.xsd.MediaMetaData;
import org.springframework.beans.factory.annotation.Autowired;

import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.messaging.Message;
import com.liferay.portal.kernel.messaging.MessageListener;
import com.liferay.portal.kernel.messaging.MessageListenerException;
import com.liferay.portal.kernel.search.Indexer;
import com.liferay.portal.kernel.search.IndexerRegistryUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.model.User;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.service.UserNotificationEventLocalServiceUtil;
import com.liferay.portlet.social.service.SocialActivityLocalServiceUtil;
import com.nyu.model.AuditReport;
import com.nyu.model.DocumentFile;
import com.nyu.model.Lesson;
import com.nyu.model.LessonCollaboration;
import com.nyu.model.Lesson_Usergroups;
import com.nyu.model.impl.LessonCollaborationImpl;
import com.nyu.model.impl.Lesson_UsergroupsImpl;
import com.nyu.portlet.social.activities.NyuMemberActivityKeys;
import com.nyu.service.AuditReportLocalServiceUtil;
import com.nyu.service.DocumentFileLocalServiceUtil;
import com.nyu.service.LessonCollaborationLocalServiceUtil;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.Lesson_UsergroupsLocalServiceUtil;

public class PublishListener implements MessageListener {
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(PublishListener.class);
	@Autowired
	private ServiceRegistryImpl serviceRegistry;
	
	public ServiceRegistryImpl getServiceRegistry() {
		return serviceRegistry;
	}

	public void setServiceRegistry(ServiceRegistryImpl serviceRegistry) {
		this.serviceRegistry = serviceRegistry;
	}
	
	@Override
	public void receive(Message publish) throws MessageListenerException {
		try {
			JSONObject publishDetails = JSONFactoryUtil.createJSONObject(publish.getPayload().toString());
			
			if(publishDetails.getString(Constant.TYPE) != null && publishDetails.getString(Constant.TYPE).equals(Constant.GENERATE_PREVIEW)){
				if(!Constant.ENABLE_OFFICE_PREVIEW_IN_ENGAGE)
					generateResourcePreview(publishDetails.getString(Constant.GENERATE_PREVIEW_URL));
			}else{
				Map<String,Object> test = publish.getValues();
				Long lessonId = GetterUtil.getLong(publishDetails.getString(Constant.COMMON_STRING_CONSTANT_LESSON_ID));
				Long userId = GetterUtil.getLong(publishDetails.getString(Constant.COMMON_STRING_CONSTANT_USER_ID));
				String share = publishDetails.getString(Constant.SHARE);
				String permission = publishDetails.getString(Constant.COMMON_STRING_CONSTANT_PERMISSION);
				String privateType = publishDetails.getString(Constant.PRIVATE_TYPE);
				String privateValue = publishDetails.getString(Constant.PRIVATE_VALUE);
				boolean isCreateLesson = publishDetails.getBoolean(Constant.IS_CREATE_LESSON);
							
				String lessonUrl = GetterUtil.getString(publishDetails.getString(Constant.LESSON_URL));
				Lesson lesson = LessonLocalServiceUtil.getLesson(lessonId);
				lesson.setPermission(permission);
				
				
				if(share.equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE)){
					processPriavteSetup(lesson, privateType, privateValue);
					if(privateType.equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE)){
						lesson.setLessonPrivacy(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE);
					}else{
						lesson.setLessonPrivacy(share);
					}
				}else{
					removePriavteSetup(lesson);
					lesson.setLessonPrivacy(share.equals(Constant.PORTLET_PROP_SITE_NAME_SMALL)? Constant.PORTLET_PROP_SITE_NAME_CAPITAL:share);
				}
				String status = publishObjects(lesson,permission);
				ServiceContext sc = (ServiceContext) test.get(Constant.STRING_SERVICE_CONTEXT);
				sendLessonNotification(lesson,sc,userId,lessonUrl,Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH,status);
				if(!(status.equalsIgnoreCase(Constant.FAILED))){
					AuditReport lessonReport = createReport(sc, isCreateLesson?Constant.CREATE_LESSON_STRING:Constant.UPDATE_LESSON_STRING, lesson.getLessonId()+StringPool.BLANK, Constant.CAPITAL_LESSON, lesson.getLessonName());
					AuditReportLocalServiceUtil.addAuditReport(lessonReport);
					SocialActivityLocalServiceUtil.addActivity(Validator.isNotNull(lesson.getCurrentAuthor())?lesson.getCurrentAuthor():userId,lesson.getGroupId(),Lesson.class.getName(),lesson.getLessonId(),
							isCreateLesson?NyuMemberActivityKeys.ADD_LESSON:NyuMemberActivityKeys.UPDATE_LESSON, StringPool.BLANK, 0);
				}
				Indexer indexer = IndexerRegistryUtil.getIndexer(Lesson.class);
				indexer.reindex(lesson);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (PortalException e) {
			e.printStackTrace();
		} catch (SystemException e) {
			e.printStackTrace();
		}
	}
	
	private String publishObjects( Lesson lesson,String permission) {
		//String damSecretKey = NyuUtil.getProperty( messageSource, "dam.secret.key");
		
		List<DocumentFile> documentFiles = null;
		List<MediaMetaData> mediaMetaDataList = new ArrayList<MediaMetaData>();
		List<String> SupportedPreviewFormat = Arrays.asList(Constant.EXPLICIT_PREVIEW_FORMATS.split(","));
		MediaMetaData mediaMetaData = null;
		String damSecretKey = Constant.PORTLET_PROP_DAM_SECRET_KEY;
		String LessonPublishStatus =Constant.FAILED;
		String resourceIdArray[] =null;
		try {
			//FROM ACHIVE TO S3 PUSH	
			documentFiles = DocumentFileLocalServiceUtil.findResourceDocumentsBylessonIdAndStatus(lesson.getLessonId(),Constant.COMMON_STRING_CONSTANT_RESOURCE_SPACE,Constant.DOCUMENT_STATUS_ARCHIVE);
			resourceIdArray = getDocumentResourseIds(documentFiles);
			if(resourceIdArray != null){
				try{		
					CloudStorageServiceClass_CloudStorageRequest csr = new CloudStorageServiceClass_CloudStorageRequest();
					csr.setDamSecretKey( damSecretKey );
					csr.setObjectIdList(resourceIdArray);
					String putObjectsToCloudStorageResponse = serviceRegistry.getCloudStorageServiceHandler().putObjectsToCloudStorage(csr);
					String s3ResultArray[] = putObjectsToCloudStorageResponse.trim().split(",");
					updateDocumentsStatus(documentFiles, s3ResultArray,Constant.DOCUMENT_STATUS_S3,"");
					LOG.info("[PutObjectsToCloudStorageResponse][" + putObjectsToCloudStorageResponse +"]" );
				}catch(Exception e){
					LOG.info("[PutObjectsToCloudStorageResponse][" + e.getMessage() +"]" );
				}
			}
			
			//CDN SERVICE		
			documentFiles = DocumentFileLocalServiceUtil.findResourceDocumentsBylessonIdAndStatus(lesson.getLessonId(),Constant.COMMON_STRING_CONSTANT_RESOURCE_SPACE,Constant.DOCUMENT_STATUS_S3);		
			for ( DocumentFile document : documentFiles ){
				String location = getMediaLocationUrl( null, Long.toString(document.getResourceId()), null);
				if( Validator.isNotNull(location) && (!location.trim().equals("")) && (!location.equalsIgnoreCase(Constant.ERROR)) && (!location.equalsIgnoreCase(Constant.NO_ID))){
					document.setStatus(Constant.DOCUMENT_STATUS_CDN);
					document.setDownloadUrl(location);
					DocumentFileLocalServiceUtil.updateDocumentFile(document);
				}
			}
			
			//ENGAGE ADD MEDIA
			documentFiles = DocumentFileLocalServiceUtil.findResourceDocumentsBylessonIdAndStatus(lesson.getLessonId(),Constant.COMMON_STRING_CONSTANT_RESOURCE_SPACE,Constant.DOCUMENT_STATUS_CDN);	
			for (DocumentFile document:documentFiles){			
				mediaMetaData = new MediaMetaData();
				String location = document.getDownloadUrl();
				mediaMetaData.setUUID(document.getDocUuid());
				String documentExt = document.getDocumentName().substring(document.getDocumentName().lastIndexOf(".")+1).toLowerCase();
				if(Constant.ENABLE_OFFICE_PREVIEW_IN_ENGAGE && SupportedPreviewFormat.contains("."+documentExt)){
					String previewUrlDomain = location.substring(0,location.lastIndexOf("/"));
					String previewUrlName = location.substring(location.lastIndexOf("/")+1);
					previewUrlName ="preview_"+previewUrlName.substring(0,previewUrlName.lastIndexOf("."))+".pdf";
					String PreviewUrl = previewUrlDomain+"/"+previewUrlName;
					mediaMetaData.setLocation(PreviewUrl);
				}else{
					mediaMetaData.setLocation(location);
				}
				mediaMetaData.setCourseId(lesson.getCourseId());
				mediaMetaData.setResourceId(Long.toString(document.getResourceId()));
				if(document.getDocumentName().endsWith(Constant.DOT_ZIP) && document.getDocumentName().contains(Constant.DOT_SCORM)){
					mediaMetaData.setMediaType(Constant.SCORM);
				}else{
					mediaMetaData.setMediaType(StringPool.BLANK);
				}
				
				if(Validator.isNotNull(document.getHasAutoTranscript()) && !document.getHasAutoTranscript().equals(StringPool.BLANK)){
					mediaMetaData.setTranscribe(document.getHasAutoTranscript());
				}else{
					mediaMetaData.setTranscribe(Constant.TRANSCRIBE_NONE);
				}
						mediaMetaDataList.add( mediaMetaData );
			}
			MediaMetaData[] mediaMetaDataArray = mediaMetaDataList.toArray(new MediaMetaData[mediaMetaDataList.size()]);
			for(MediaMetaData m : mediaMetaDataArray){
				LOG.info("mediaMetaDataArray: loc: "+m.getLocation()+" course id: "+m.getCourseId()+" Date: "+m.getDate()+" Resourseid: "+m.getResourceId());
			}
			
			
			if(documentFiles != null && documentFiles.size()>0){
				try{
					String addMediaResponse = serviceRegistry.getMediaServiceHandler().addMedia(mediaMetaDataArray);
					String engageResultArray[] = addMediaResponse.trim().split(",");
					updateDocumentsStatus(documentFiles, engageResultArray,Constant.DOCUMENT_STATUS_COMPLETED,permission);
					LOG.info("addMediaResponse"+addMediaResponse);
				}catch (Exception e){
					LOG.info("addMediaResponse"+"ERROR");
				}
			}
			
			//LESSON PUBLISH
			boolean isLessonPublishable = DocumentFileLocalServiceUtil.isLessonIsPublishable(lesson.getLessonId(),Constant.COMMON_STRING_CONSTANT_RESOURCE_SPACE,Constant.DOCUMENT_STATUS_COMPLETED);
			
			if(isLessonPublishable){
				lesson.setStatus(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH);
				lesson.setUpdatedDate(new Date(System.currentTimeMillis()));
				lesson.setUploadedTime(new Date(System.currentTimeMillis()));
				if(Validator.isNotNull(lesson.getMarkedAs()) && (lesson.getMarkedAs().equalsIgnoreCase(Constant.LESSON_FROM_DELETED_GROUP) ||lesson.getMarkedAs().equalsIgnoreCase(Constant.LESSON_DELETED_BY_USER) || lesson.getMarkedAs().equalsIgnoreCase(Constant.MARKEDAS_QUARANTINE))){
					lesson.setMarkedAs(Constant.MARKEDAS_RELEASE);
				}
				LessonLocalServiceUtil.updateLesson(lesson);
				LessonPublishStatus = Constant.SUCCESS;
			}
			
		} catch (Exception e) {
			LOG.info(e.getMessage());
		}
		return LessonPublishStatus;
	}

	private void updateDocumentsStatus(List<DocumentFile> documentFiles,
			String[] ResultArray,String Status,String permission) throws SystemException {
		for(String Response:ResultArray){
			String[] resourceStatus = (Response!= null && !Response.trim().equals(""))?Response.split("-"):null;
			if(resourceStatus != null && resourceStatus[0] != null && resourceStatus[0].trim().length() > 0){
				long documentResourceId = GetterUtil.getLong(resourceStatus[0]);
				boolean documentResourceStatus = GetterUtil.getBoolean(resourceStatus[1]);
				for (DocumentFile document:documentFiles){
					if(documentResourceId == document.getResourceId() && documentResourceStatus){
						document.setStatus(Status);
						if(Status.equals(Constant.DOCUMENT_STATUS_COMPLETED)){
							document.setPermission(permission);
						}
						DocumentFileLocalServiceUtil.updateDocumentFile(document);
					}
				}
			}
			
		}
	}
	
	private String getMediaLocationUrl( String distributionId, String videoFileId, String mediaType ){
		String location = null;
		try {
			location = serviceRegistry.getCdnServiceHandler().getDomainName( distributionId, videoFileId, mediaType );
		} catch (RemoteException e) {
		}
		
		return location;
	}
	
	private void processPriavteSetup( Lesson lesson, String privateType, String privateValue ){
		
		String[] privateValues = privateValue.split(StringPool.COMMA);
		removePriavteSetup(lesson);
		try {
			if(privateType.equals(Constant.USER_CAPITAL_GROUP)){
					for(String groupId:privateValues){
					Lesson_Usergroups lesson_group=new Lesson_UsergroupsImpl();
					lesson_group.setGroupId(GetterUtil.getLong(groupId));
					lesson_group.setLessonId(lesson.getLessonId());
					Lesson_UsergroupsLocalServiceUtil.addLesson_Usergroups(lesson_group);
					//SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(request),PortalUtil.getScopeGroupId(request),UserGroup.class.getName(),groupId, NyuMemberActivityKeys.ADD_LESSON_TO_GROUP,"Added <code>"+lesson.getLessonName()+"</code> to",0l);
				}
			}else{
				
					LessonCollaboration lessonOwner=new LessonCollaborationImpl();
					lessonOwner.setAccessPermission(Constant.COMMON_STRING_CONSTANT_TRUE);
					lessonOwner.setLessonId(lesson.getLessonId());
					lessonOwner.setUserId(GetterUtil.getLong(lesson.getCurrentAuthor()));
					lessonOwner.setMemberStatus(Constant.LESSON_MEMBER_STATUS_PENDING);
					lessonOwner.setType(Constant.LESSON_ACCESS_VIEWONLY);
					LessonCollaborationLocalServiceUtil.addLessonCollaboration(lessonOwner);
				for(String userId:privateValues){
					if(!(userId.equalsIgnoreCase(lesson.getCurrentAuthor()+StringPool.BLANK))){
						LessonCollaboration lessonCollaboration=new LessonCollaborationImpl();
						lessonCollaboration.setAccessPermission(Constant.COMMON_STRING_CONSTANT_TRUE);
						lessonCollaboration.setLessonId(lesson.getLessonId());
						lessonCollaboration.setUserId(GetterUtil.getLong(userId));
						lessonCollaboration.setMemberStatus(Constant.LESSON_MEMBER_STATUS_PENDING);
						lessonCollaboration.setType(Constant.LESSON_ACCESS_VIEWONLY);
						LessonCollaborationLocalServiceUtil.addLessonCollaboration(lessonCollaboration);
					}
					//SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(request),PortalUtil.getScopeGroupId(request),UserGroup.class.getName(),groupId, NyuMemberActivityKeys.ADD_LESSON_TO_GROUP,"Added <code>"+lesson.getLessonName()+"</code> to",0l);
				}
			}
		} catch (Exception e) {
			
		}
	}
	private void removePriavteSetup( Lesson lesson){
		List<Lesson_Usergroups> lesson_groups = null;
		List<LessonCollaboration> lesson_users = null;
		lesson_groups = Lesson_UsergroupsLocalServiceUtil.getLesson_UserGroupLessonId(lesson.getLessonId()); 
			for(Lesson_Usergroups lesson_group:lesson_groups){
				try{
					Lesson_UsergroupsLocalServiceUtil.deleteLesson_Usergroups(lesson_group);
				}catch (Exception e){
					
				}
			}
			lesson_users = LessonCollaborationLocalServiceUtil.getallLessonAccessPermissionByLessonId(lesson.getLessonId(), Constant.COMMON_STRING_CONSTANT_TRUE);
			for(LessonCollaboration lesson_user:lesson_users){
				try{
				LessonCollaborationLocalServiceUtil.deleteLessonCollaboration(lesson_user);
				}catch(Exception e){
					
				}
			}
	}
	
	private String[] getDocumentResourseIds(List<DocumentFile> documentFiles){
		String[] resourceIds = null;
		List<String> resourceIdList =new ArrayList<String>();
		if(documentFiles!=null && documentFiles.size()>0){
			for(int i=0; i < documentFiles.size(); i++){
				if(documentFiles.get(i).getResourceId()!=0l){
					resourceIdList.add(Long.toString(documentFiles.get(i).getResourceId()));
				}
			}
		}
		if(resourceIdList.size() > 0)
			resourceIds = resourceIdList.toArray(new String[resourceIdList.size()]);
		return resourceIds;
	}
	
	private void sendLessonNotification(Lesson lesson,
			ServiceContext serviceContext,long userId,String lessonUrl, String type,String status) throws PortalException,
			SystemException {
		LOG.info("ok");
		
		SocialActivityLocalServiceUtil.addActivity(userId,lesson.getGroupId(),Lesson.class.getName(),lesson.getLessonId(),
				NyuMemberActivityKeys.SEND_LESSON_NOTIFICATION, StringPool.BLANK, 0);
		if(status.contains(Constant.FAILED)){
			type = Constant.FAILED;	
		}
		JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID,userId);
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lesson.getLessonId());
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,lesson.getLessonName());
		payloadJSON.put(Constant.LESSON_URL,lessonUrl);
		payloadJSON.put(Constant.TYPE,type);
		
		UserNotificationEventLocalServiceUtil
				.addUserNotificationEvent(
						userId,
						com.nyu.notification.LessonNotificationHandler.PORTLET_ID,
						(new Date()).getTime(), lesson.getGroupId(),
						payloadJSON.toString(), false,
						serviceContext);
	}
	
	private void generateResourcePreview(String url) {
		try {
			URL resourceUrl = new URL(url);
			URLConnection resourceConnection = resourceUrl.openConnection();
			resourceConnection.setDoInput(true);
			BufferedReader reader;
			reader = new BufferedReader(new InputStreamReader(
					resourceConnection.getInputStream()));
			StringBuffer documentResult = new StringBuffer();
			String line = null;
			while ((line = reader.readLine()) != null) {
				documentResult.append(line);
			}
			LOG.info("final Response From Resource :::"+ documentResult);
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	private AuditReport createReport(ServiceContext serviceContext,String eventType,String classPK,String className,String addInfo) throws PortalException, SystemException
	{
		long companyId = serviceContext.getCompanyId();
		User user = UserLocalServiceUtil.getUser(serviceContext.getUserId());
		String ipAddress =serviceContext.getHeaders().get(Constant.X_FORWARD_FOR);  
		   if (ipAddress == null) {  
			   ipAddress =serviceContext.getRemoteAddr();  
		   }
		
		AuditReport auditReport= AuditReportLocalServiceUtil.createAuditReport((CounterLocalServiceUtil.increment(AuditReport.class.getName())));
		
		auditReport.setCompanyId(companyId);
		auditReport.setGroupId(companyId);
		auditReport.setUserId(user.getUserId());
		auditReport.setUserName(user.getFullName());
		auditReport.setCreateDate(new Date());
		auditReport.setClassName(className);
		auditReport.setClassPK(classPK);
		auditReport.setClientIP(ipAddress);
		auditReport.setClientHost(ipAddress);
		auditReport.setEventType(eventType);
		auditReport.setServerName(serviceContext.getRemoteHost());
		auditReport.setAdditionalInfo(addInfo);
		return auditReport;
	}
}
