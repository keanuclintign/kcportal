package com.nyu.web.resource;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

/*import org.slf4j.Logger;
import org.slf4j.LoggerFactory;*/
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.StringPool;
import com.nyu.model.DocumentFile;
import com.nyu.model.Lesson;
import com.nyu.service.DocumentFileLocalServiceUtil;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.util.Constant;
import com.nyu.util.DateUtil;

/**
 * 
 * @author Allwins Rajaiah
 *
 */
@Path("/launcher")
public class EngageResource {

	//private PropertyUtil propertyUtil;
	
	//Logger LOG = LoggerFactory.getLogger(EngageResource.class);
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(EngageResource.class);
	/**
	 * 
	 * @param lessonId
	 * @return
	 */
	@GET
	@Path("resourceId/{resourceId}/lessonId/{lessonId}/authorId/{authorId}/chapterId/{chapterId}")
	@Produces(MediaType.TEXT_HTML)
	public String getLauncher( @PathParam("resourceId") long resourceId, @PathParam("lessonId") long lessonId, @PathParam("authorId") long authorId, @PathParam("chapterId") long chapterId, @Context HttpServletResponse res  ) {
		String html = null; 
		try {
			Lesson lesson = LessonLocalServiceUtil.getLesson( lessonId );
			DocumentFile document = DocumentFileLocalServiceUtil.getDocumentFile(resourceId,lesson.getLessonId() );

			html = buildHtml( prepareUrl ( document, lesson, authorId, chapterId ) ).toString();
			setHttpHeader(res);
		} catch (NumberFormatException e) {
			LOG.error(e);
		} catch (PortalException e) {
			LOG.error(e);
		} catch (SystemException e) {
			LOG.error(e);
		}
		return html;
	}
	/**
	 * 
	 * @param lesson
	 * @return
	 */
	private String prepareUrl ( DocumentFile document, Lesson lesson, long  authorId, long  chapterId ) {
		//propertyUtil = new PropertyUtil();

		//propertyUtil.loadProps();  //load props

		//String engageLaunchUrl = propertyUtil.getProperty("engage.launch.url");
		String engageLaunchUrl = Constant.PORTLET_PROP_ENGAGE_LAUNCH_URL;
		//String hasAutoTranscript = Boolean.toString(document.getHasAutoTranscript());
		if(document.getDocUuid().equals(StringPool.BLANK)){
			engageLaunchUrl = engageLaunchUrl.replaceAll(Constant.REFERENCE_ID_DOC_UUID_AMPERSAND, StringPool.BLANK);
		}else{
			engageLaunchUrl = engageLaunchUrl.replaceAll(Constant.DATE_ULOADED_TIME_AMPERSAND, StringPool.BLANK);
		}
		if(chapterId > 0){
			engageLaunchUrl = engageLaunchUrl+Constant.AMPERSAND_CHAPTER_ID_CHAPTER_ID;
		}
		
		Map<String,String> replaceMap = new HashMap<String,String>();
		//replaceMap.put(Constant.HASH_LAUNCHER_KEY, propertyUtil.getProperty( "launcher.key"));
		replaceMap.put(Constant.HASH_LAUNCHER_KEY, Constant.PORTLET_PROP_LAUNCHER_KEY);
		if(lesson.getCurrentAuthor()==authorId)
			replaceMap.put(Constant.HASH_MODERATOR, Constant.CAPITAL_T_TRUE);
		else
			replaceMap.put(Constant.HASH_MODERATOR, Constant.CAPITAL_F_FALSE);
		replaceMap.put(Constant.HASH_UPLOADED_TIME, DateUtil.toString(document.getCreatedDate()));
		replaceMap.put(Constant.HASH_DOC_UUID, document.getDocUuid()); 
		replaceMap.put(Constant.HASH_COURSE_ID, lesson.getCourseId());
		replaceMap.put(Constant.HASH_UPLOADED_BY_NAME, lesson.getUploadedByName());
		replaceMap.put(Constant.HASH_TRANSCRIBE, (document.getHasAutoTranscript() == null || document.getHasAutoTranscript().equals(StringPool.BLANK))?Constant.TRANSCRIBE_NONE:document.getHasAutoTranscript()); 
		replaceMap.put(Constant.HASH_CHAPTER_ID, chapterId+StringPool.BLANK);
		//replaceMap.put("#withTranscript", hasAutoTranscript.substring(0, 1).toUpperCase() + hasAutoTranscript.substring(1) ); 
		
		//replaceMap.put("#liveMode", lesson.getLivemode().equals("true")? Constant.CAPITAL_T_TRUE : Constant.CAPITAL_F_FALSE);

		for( String key : replaceMap.keySet() ){
			engageLaunchUrl = engageLaunchUrl.replaceAll( key, replaceMap.get(key));
		}
		
		//LOG.info("engage Url:"+engageLaunchUrl);
		
		if(chapterId>0)
			engageLaunchUrl+=Constant.AMPERSAND_CHAPTER+chapterId;
		//LOG.info("[engageLaunchUrl][" + engageLaunchUrl +"]");
		return engageLaunchUrl;
	}
	/**
	 * 
	 * @param targetUrl
	 * @return
	 */
	public StringBuilder buildHtml ( String targetUrl ) 
	{
		StringBuilder htmlStr = new StringBuilder(Constant.TAG_HTML_OPEN_NEWLINE);
		if(Constant.LAUNCH_ERROR.equals(targetUrl))//send error response
		{
			htmlStr.append(Constant.TAG_HEAD_TITLE_ERROR_NEWLINE).append(Constant.TAG_BODY_HEADER_FOUR+"Resource you are trying to access is unavailable."+Constant.TAG_HEADER_FOUR_BODY_HTML);
			return htmlStr;
		}
		String[] paramStr = targetUrl.split(Constant.DOUBLE_BACK_SLASH_QUESTION_MARK)[1].split(StringPool.AMPERSAND);
		String[] param = new String[2];

		htmlStr.append(Constant.TAG_HEAD_NEWLINE)
				.append(Constant.TAG_META_DATA_HTTP_CACHE_CONTROL)
				.append(Constant.TAG_META_DATA_HTTP_EQUIV_EXPIRES)
				.append(Constant.TAG_META_DATA_HTTP_QEUIV_PRAGMA)
				.append(Constant.TAG_HEAD_END_NEWLINE)
				.append(Constant.TAG_BODY_OPEN_NEWLINE)
				.append(Constant.TAG_FORM_OPNE_ACTION + targetUrl + Constant.TAG_QOUTE_METHOD_GET);
				for( int i=0; i < paramStr.length; i++ ){
					param = paramStr[i].split(StringPool.EQUAL);
					htmlStr.append(Constant.TAG_INPUT_TYPE_HIDDEN+ param[0]+ Constant.VALUE_STRING_INSIDE_SINGLE_QUOTE+ param[1]+ Constant.TAG_CLOLSE_NEWLINE);
				}
		htmlStr.append(Constant.TAG_FORM_CLOSE_NEWLINE)
				.append(Constant.TAG_SCRIPT_JAVASCRIPT_SUBMITPAGE_METHOD)
				.append(Constant.TAG_BODY_CLOSE_NEWLINE)
				.append(Constant.TAG_HTML_CLOSE);
		
	


		return htmlStr;
	}
	
	private void setHttpHeader(HttpServletResponse res) {
		long currentTime = System.currentTimeMillis();
		res.setDateHeader(Constant.CAPITAL_D_DATE, currentTime);
        res.setDateHeader(Constant.EXPIRES, currentTime + 1000);

        res.setHeader(Constant.CACHE_CONTROL, Constant.MUST_VALIDATE);
        res.addHeader(Constant.CACHE_CONTROL, Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE);
        res.addHeader(Constant.CACHE_CONTROL, Constant.NOT_STORE);
        res.addHeader(Constant.CACHE_CONTROL, Constant.MAX_AGE_EQUAL_ZERO);
        res.addHeader(Constant.CACHE_CONTROL, Constant.S_MAX_AGE_EQUAL_ZERO);
	}
	
	
	/**
	 * 
	 * @param lessonId
	 * @return
	 */
	@GET
	@Path("referenceId/{referenceId}/chapterId/{chapterId}")
	@Produces(MediaType.TEXT_HTML)
	public String getChapterLauncher( @PathParam("referenceId") String referenceId, @PathParam("chapterId") long chapterId, @Context HttpServletResponse res  ) {
		String html = null; 
		try {
			DocumentFile document = DocumentFileLocalServiceUtil.getDocumentFilesByReferenceId(referenceId);
			Lesson lesson =LessonLocalServiceUtil.getLesson(document.getLessonId());
			html = buildHtml( prepareUrl ( document, lesson, lesson.getAuthor(), chapterId ) ).toString();
			setHttpHeader(res);
		} catch (NumberFormatException e) {
			LOG.error(e);
		} catch (PortalException e) {
			LOG.error(e);
		} catch (SystemException e) {
			LOG.error(e);
		}
		return html;
	}
	
}
