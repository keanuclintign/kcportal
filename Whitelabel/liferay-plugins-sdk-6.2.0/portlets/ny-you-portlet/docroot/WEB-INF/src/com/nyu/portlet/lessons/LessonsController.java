package com.nyu.portlet.lessons;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.rmi.RemoteException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.TreeMap;
import java.util.UUID;
import java.util.concurrent.CopyOnWriteArrayList;

import javax.imageio.ImageIO;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletRequest;
import javax.portlet.PortletSession;
import javax.portlet.PortletURL;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.portlet.WindowState;
import javax.portlet.WindowStateException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ArrayUtils;
import org.apache.velocity.VelocityContext;
import org.sakaiproject.esb.client.impl.ServiceRegistryImpl;
import org.sakaiproject.esb.model.xsd.CloudStorageServiceClass_CloudStorageRequest;
import org.sakaiproject.esb.model.xsd.MediaMetaData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.mail.service.MailServiceUtil;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.OrderFactoryUtil;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.mail.MailMessage;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Layout;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.User;
import com.liferay.portal.model.UserGroup;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.LayoutLocalServiceUtil;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.service.UserNotificationEventLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.liferay.portlet.asset.model.AssetCategory;
import com.liferay.portlet.asset.model.AssetEntry;
import com.liferay.portlet.asset.model.AssetTag;
import com.liferay.portlet.asset.model.AssetVocabulary;
import com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetTagLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil;
import com.liferay.portlet.asset.service.persistence.AssetEntryQuery;
import com.liferay.portlet.documentlibrary.model.DLFileEntry;
import com.liferay.portlet.messageboards.model.MBMessage;
import com.liferay.portlet.messageboards.service.MBMessageLocalServiceUtil;
import com.liferay.portlet.social.model.SocialActivity;
import com.liferay.portlet.social.model.SocialActivityFeedEntry;
import com.liferay.portlet.social.model.SocialRelationConstants;
import com.liferay.portlet.social.service.SocialActivityLocalServiceUtil;
import com.liferay.portlet.social.service.SocialRelationLocalServiceUtil;
import com.liferay.util.portlet.PortletProps;
import com.nyu.model.AuditReport;
import com.nyu.model.DocumentFile;
import com.nyu.model.FavouriteLessons;
import com.nyu.model.Lesson;
import com.nyu.model.Lesson_Usergroups;
import com.nyu.model.RequestLesson;
import com.nyu.model.impl.DocumentFileImpl;
import com.nyu.model.impl.FavouriteLessonsImpl;
import com.nyu.model.impl.Lesson_UsergroupsImpl;
import com.nyu.portlet.social.activities.NyuMemberActivityKeys;
import com.nyu.portlet.social.activities.NyuMembersActivityInterpreter;
import com.nyu.service.AuditReportLocalServiceUtil;
import com.nyu.service.DocumentFileLocalServiceUtil;
import com.nyu.service.FavouriteLessonsLocalServiceUtil;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.Lesson_UsergroupsLocalServiceUtil;
import com.nyu.service.RequestLessonLocalServiceUtil;
import com.nyu.util.AuditNyuUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;
import com.nyu.util.NyuUtil;
import com.nyu.util.RenderHelper;
import com.nyu.util.SortLessonUtil;
import com.nyu.util.StringUtils;
import com.nyu.util.UUIDMigrationUtil;

@Controller
@RequestMapping(value = "VIEW")
public class LessonsController {
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(LessonsController.class);
	
	@Autowired
	private ServiceRegistryImpl serviceRegistry;

	@Autowired
    private MessageSource messageSource;
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RenderMapping
	public String load(RenderRequest request,RenderResponse response)throws SystemException {  
		PortletSession session = request.getPortletSession();
		session.removeAttribute(Constant.COMMON_STRING_CONSTANT_CATEGORY_ID, PortletSession.PORTLET_SCOPE);
		LOG.info("[LOADING NY-YOU]");
		HttpServletRequest httpRequest = PortalUtil.getOriginalServletRequest(PortalUtil.getHttpServletRequest(request));
		String action = httpRequest.getParameter(Constant.COMMON_STRING_CONSTANT_ACTION);
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		if(Constant.CREATE_LESSON.equalsIgnoreCase(action)){
			List<RequestLesson> requestedLessons = RequestLessonLocalServiceUtil.getRequestLessons(themeDisplay.getCompanyId());
			List<RequestLesson> reverseReqLes=new CopyOnWriteArrayList<RequestLesson>(requestedLessons);
			Collections.reverse(reverseReqLes);
			for(RequestLesson temp : reverseReqLes) 
			{
				if(temp.getStatus().equalsIgnoreCase(Constant.SMALL_OPEN) || temp.getStatus().equalsIgnoreCase(Constant.CLOSED) || temp.getAcceptedBy() != themeDisplay.getUserId())
				{
					reverseReqLes.remove(temp);
				}
				
			}
			request.setAttribute(Constant.REQUEST_LESSONS, reverseReqLes);
			return Constant.CREATE_LESSON; 
		}
		
		return Constant.USER_PROFILE_VIEW_JSP;    
	}
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RenderMapping(params = "action=createLesson")  
	public String createLesson(RenderRequest request,RenderResponse response) {  
		LOG.info("[LOADING CREATE LESSON]");
		
		return Constant.CREATE_LESSON;
	}

	/**
	 * 
	 * @param request
	 * @param response
	 * @throws SystemException
	 */
	@ActionMapping(params = "action=saveLesson")
	public void saveLesson(ActionRequest actionRequest,ActionResponse actionResponse)throws PortalException, SystemException
	{
		try {
				
				LOG.info("[SAVE LESSON]");
				ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
				UploadPortletRequest request = PortalUtil.getUploadPortletRequest(actionRequest);
				Lesson lesson = updateLesson(request,actionRequest);
					
				/** Add Documents and Publish Resources **/
				addAndPublish(request, lesson, Constant.DOCUMENT_PATH_ARR, Constant.UNPUBLISH_DOC_PATH_ARR, Constant.EMBED_MEDIA_PATH_ARR, Constant.EXISTING_EMBED_MEDIA_PATH_ARR );
				
				if(request.getParameter(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON)!=null && request.getParameter(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON).equals(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON)){
					actionRequest.setAttribute(Constant.LESSON_SUCCESS, CommonUtil.JavaClassI18N(actionRequest, themeDisplay, "lesson-updated-successfully"));
				}else{
					actionRequest.setAttribute(Constant.LESSON_SUCCESS, CommonUtil.JavaClassI18N(actionRequest, themeDisplay, "lesson-created-successfully"));
				}
				
				if(request.getParameter(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON)!=null && request.getParameter(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON).equals(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON)){
					Layout layout=themeDisplay.getLayout();
					long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_HOME).getPlid();
					PortletURL url = PortletURLFactoryUtil.create(request, PortalUtil.getPortletId(request),targetPlId, PortletRequest.RENDER_PHASE);
					url.setParameter(Constant.UPDATE_LESSON,  Constant.UPDATE_LESSON);
					url.setParameter(Constant.LESSON_SUCCESS, CommonUtil.JavaClassI18N(actionRequest, themeDisplay, "lesson-updated-successfully"));
					url.setWindowState(WindowState.MAXIMIZED);
					url.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lesson.getLessonId()+StringPool.BLANK);
					url.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);
					actionResponse.sendRedirect(url.toString());
				}else{
					String site = themeDisplay.getScopeGroup().getFriendlyURL();
					String layoutType = themeDisplay.getLayout().isPrivateLayout()? (StringPool.FORWARD_SLASH+Constant.LIFERAY_VENDOR_LESSON_PRIVACY_GROUP) : (StringPool.FORWARD_SLASH+Constant.WEB);
					actionResponse.sendRedirect(PortalUtil.getPortalURL(request)+layoutType+site+Constant.PAGE_HOME);
				}
				
				sendLessonNotification(lesson, request, Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH);
				
		} catch (IOException e) {
			LOG.error("[LessonsController: saveLesson() ]"+e);
		} catch (Exception e) {
			LOG.error("[LessonsController: saveLesson() ]"+e);
		}

	}
	
	
	@ActionMapping(params = "action=saveLessonAsDraft")
	public void saveLessonAsDraft(ActionRequest actionRequest,ActionResponse actionResponse)throws PortalException, SystemException{
		ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		try{
			UploadPortletRequest request = PortalUtil.getUploadPortletRequest(actionRequest);
			
			Lesson lesson = updateLesson(request,actionRequest);
			addAndPublish(request, lesson, Constant.DOCUMENT_PATH_ARR, Constant.UNPUBLISH_DOC_PATH_ARR, Constant.EMBED_MEDIA_PATH_ARR, Constant.EXISTING_EMBED_MEDIA_PATH_ARR );
			request.setAttribute(Constant.LESSON_SUCCESS, CommonUtil.JavaClassI18N(actionRequest, themeDisplay, "lesson-saved-successfully"));
			
			request.setAttribute(Constant.LESSON_SUCCESS, CommonUtil.JavaClassI18N(actionRequest, themeDisplay, "lesson-successfully-saved-as-a-draft"));
			actionResponse.setRenderParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID, String.valueOf(lesson.getLessonId()));
			actionResponse.setRenderParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_STRING_CONSTANT_EDIT_LESSON);
		
		} catch (IOException e) {
			LOG.error("[LessonsController: saveLessonAsDraft() ]"+e);
		} catch (Exception e) {
			LOG.error("[LessonsController: saveLessonAsDraft() ]"+e);
		}
		
	}
	
	@ActionMapping(params = "action=unPublishLesson")
	public void unPublishLesson(ActionRequest actionRequest,ActionResponse actionResponse)throws PortalException, SystemException{
		ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		try{
			UploadPortletRequest request = PortalUtil.getUploadPortletRequest(actionRequest);
			
			
			Lesson lesson = LessonLocalServiceUtil.getLesson(Long.parseLong(request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID)));
			
			unPublishLesson(lesson.getLessonId());
			
			
			lesson.setStatus(request.getParameter(Constant.SAVE_LESSON).toString());
			
			request.setAttribute(Constant.LESSON_UNPUBLISHED, CommonUtil.JavaClassI18N(actionRequest, themeDisplay, "lesson-successfully-unpublished-and-saved-as-a-draft"));
			
			LessonLocalServiceUtil.updateLesson(lesson);
			actionResponse.setRenderParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID, request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID));
			actionResponse.setRenderParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_STRING_CONSTANT_EDIT_LESSON);
		
			
		} catch (Exception e) {
			LOG.error("[LessonsController: unPublishLesson() ]"+e);
		}
		
	}
	
	private Lesson updateLesson(UploadPortletRequest request,ActionRequest actionRequest)throws PortalException, SystemException{
		Lesson lesson = null;
		
		try {
				ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
				if(request.getParameter(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON)!=null && request.getParameter(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON).equals(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON)){
					lesson = LessonLocalServiceUtil.getLesson(Long.parseLong(request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID)));
				} else { //new lesson
					lesson = LessonLocalServiceUtil.createLesson(CounterLocalServiceUtil.increment(Lesson.class.getName()));
				}
				
				long[] checkedSecondaryAuthorIds=ParamUtil.getLongValues(request,Constant.SECONDARY_AUTHOR_IDS_CHECK_BOX);
				StringBuffer sbfNumbers = new StringBuffer();
				String strSeparator = StringPool.COMMA;
				if(checkedSecondaryAuthorIds.length > 0){
                    sbfNumbers.append(checkedSecondaryAuthorIds[0]);
                    for(int i=1; i < checkedSecondaryAuthorIds.length; i++){
                            sbfNumbers.append(strSeparator).append(checkedSecondaryAuthorIds[i]);
                    }
				}
                String strNumbers = Arrays.toString(checkedSecondaryAuthorIds);
                strNumbers = strNumbers.replaceAll(StringPool.COMMA+StringPool.SPACE, strSeparator).replace(StringPool.OPEN_BRACKET, StringPool.BLANK).replace(StringPool.CLOSE_BRACKET, StringPool.BLANK);
				lesson.setSecondaryAuthor(strNumbers);
				lesson.setLessonName(request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_NAME));
				lesson.setCreator(request.getParameter(Constant.CREATOR));
				String collectionTag = request.getParameter(Constant.CATEGORY);
				collectionTag =  (collectionTag!=null) ? collectionTag.trim() : collectionTag;
				
				String subCategoryTag = request.getParameter(Constant.SUB_CATEGORY);
				subCategoryTag =  (subCategoryTag!=null) ? subCategoryTag.trim() : subCategoryTag;
				
				lesson.setDescription(request.getParameter(Constant.COMMON_STRING_CONSTANT_DESCRIPTION));
				lesson.setUploadedTime(new Date(System.currentTimeMillis()));
				lesson.setStatus(PortletProps.get(Constant.LIFERAY_SITE_LESSON_STATUS_PERIOD+request.getParameter(Constant.SAVE_LESSON).toString()));
				if(Validator.isNotNull(request.getParameter(Constant.COMMON_REQUEST_LESSON))){
					lesson.setRequestLessonId(Long.parseLong((String)request.getParameter(Constant.COMMON_REQUEST_LESSON)));
					List<RequestLesson> requestedLessons = RequestLessonLocalServiceUtil.getRequestLessons(themeDisplay.getCompanyId());
					for(RequestLesson temp : requestedLessons) 
					{
						if(lesson.getRequestLessonId() != 00){
							
							if(lesson.getRequestLessonId() == temp.getRequestLessonId() && lesson.getStatus().equalsIgnoreCase(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH))
							{
								temp.setStatus(Constant.CLOSED);
								RequestLessonLocalServiceUtil.updateRequestLesson(temp);
							}
						}
					}
				}
					
				lesson.setLessonPrivacy(request.getParameter(Constant.PRIVACY_CHECK));
				lesson.setUploadedByName(Constant.ADMIN);//lesson.setUploadedByName( themeDisplay.getUser().getFirstName() );
				
				if(request.getParameter(Constant.COMPANY_ID)!=null)
					lesson.setCompanyId(Long.parseLong(request.getParameter(Constant.COMPANY_ID)));
				else
					lesson.setCompanyId(PortalUtil.getCompanyId(request));
				
				lesson.setGroupId(themeDisplay.getScopeGroupId());
				
				String courseId = StringUtils.isEmpty(request.getParameter(Constant.COURSE_ID)) ?  
						Constant.PORTLET_PROP_REQUEST_COURSE_ID_PREP + lesson.getLessonId() : (String)request.getParameter(Constant.COURSE_ID);
				
				lesson.setCourseId(courseId);
	
				ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
				if(request.getParameter(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON)!=null && request.getParameter(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON).equals(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON)){
					lesson.setUploadedById(lesson.getUploadedById());
					if(Validator.isNotNull(request.getParameter(Constant.LESSON_CONTRIBUTOR))){
						lesson.setAuthor(Long.parseLong((String)request.getParameter(Constant.LESSON_CONTRIBUTOR)));
					}
					lesson.setAuthor(lesson.getCurrentAuthor());
						List<Lesson_Usergroups> lesson_groups=Lesson_UsergroupsLocalServiceUtil.getLesson_UserGroupLessonId(lesson.getLessonId()); 
						for(Lesson_Usergroups lesson_group:lesson_groups)
						{
							Lesson_UsergroupsLocalServiceUtil.deleteLesson_Usergroups(lesson_group);
						}
					//unPublishLesson(lesson.getLessonId());
						if(request.getParameter(Constant.UNPUBLISH_RESOURCE_ID_ARR)!=null && !request.getParameter(Constant.UNPUBLISH_RESOURCE_ID_ARR).equals(StringPool.BLANK)){
							unPublishObjects(  lesson, request.getParameter(Constant.UNPUBLISH_RESOURCE_ID_ARR).split(StringPool.COMMA) );
						}
					LessonLocalServiceUtil.updateLesson(lesson, serviceContext, NyuMemberActivityKeys.UPDATE_LESSON, 
							request.getParameter(Constant.UNPUBLISHED_DOC_IDS)!=null ? request.getParameter(Constant.UNPUBLISHED_DOC_IDS).split(StringPool.COMMA) : null); //UPDATE Lesson
					AuditReport auditReport=AuditNyuUtil.createReport(PortalUtil.getHttpServletRequest(actionRequest), CommonUtil.JavaClassI18N(actionRequest, themeDisplay, "update-lesson"),lesson.getLessonId()+StringPool.BLANK, CommonUtil.JavaClassI18N(actionRequest, themeDisplay, "lesson"),lesson.getLessonName());
					AuditReportLocalServiceUtil.addAuditReport(auditReport);
				} else { //new lesson
					lesson.setCurrentAuthor(Long.parseLong(request.getParameter(Constant.AUTHOR)));
					lesson.setUploadedById(themeDisplay.getUserId());
					LessonLocalServiceUtil.updateLesson(lesson, serviceContext, NyuMemberActivityKeys.ADD_LESSON, null);
					AuditReport auditReport=AuditNyuUtil.createReport(PortalUtil.getHttpServletRequest(actionRequest), CommonUtil.JavaClassI18N(actionRequest, themeDisplay, "create-lesson"),lesson.getLessonId()+StringPool.BLANK,CommonUtil.JavaClassI18N(actionRequest, themeDisplay, "lesson"),lesson.getLessonName());
					AuditReportLocalServiceUtil.addAuditReport(auditReport);
				}
				
				LOG.info("[INSERT-LESSON]["+ lesson.getCourseId()+"]["+ lesson.getLessonName()+"]["+ lesson.getDescription()+"]");
				
				serviceContext = ServiceContextFactory.getInstance(
		                DLFileEntry.class.getName(), request);
				
				File file=null;
				if(Validator.isNotNull(request.getParameter(Constant.FILE)))
				{
					String filename=request.getParameter(Constant.FILE).split(StringPool.FORWARD_SLASH)[4];
					file= new File(actionRequest.getPortletSession().getPortletContext().getRealPath(StringPool.FORWARD_SLASH)+Constant.IMAGES_SLASH_TEMP_SLASH+filename);
				}
				
				if(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON.equalsIgnoreCase(request.getParameter(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON))){
					if(file != null){
						if(!file.isFile()){
							NyuUtil.deleteDLFileEntry(Lesson.class, lesson.getLessonId());
						}else{
							thumbnailProcess(file, lesson, themeDisplay, serviceContext);
						}
					}
						
				} else { // new Lesson
					if(file != null){
					if(file.isFile()){
						thumbnailProcess(file, lesson, themeDisplay, serviceContext);
					}
					}
					
				}
				long[] groupIds=ParamUtil.getLongValues(request,Constant.USER_GROUPS_CHECK_BOX);
				
				for(long groupId:groupIds)
				{
					Lesson_Usergroups lesson_group=new Lesson_UsergroupsImpl();
					lesson_group.setGroupId(groupId);
					lesson_group.setLessonId(lesson.getLessonId());
					Lesson_UsergroupsLocalServiceUtil.addLesson_Usergroups(lesson_group);
					SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(request),PortalUtil.getScopeGroupId(request),UserGroup.class.getName(),groupId, NyuMemberActivityKeys.ADD_LESSON_TO_GROUP,"Added <code>"+lesson.getLessonName()+Constant.TAG_CLOSE_CODE+StringPool.SPACE+CommonUtil.JavaClassI18N(actionRequest, themeDisplay, "to"),0l);
				}
		
			} catch (Exception e) {
				LOG.error("[LessonsController: updateLesson() ]"+e);
			}
		
		return lesson;
	}
		
	
	private void thumbnailProcess(File file, Lesson lesson, ThemeDisplay themeDisplay, ServiceContext serviceContext){
		String fileFormat = getFileExtension(file);
		try {
			BufferedImage originalImage = ImageIO.read(file);
			int type = originalImage.getType() == 0? BufferedImage.TYPE_INT_ARGB : originalImage.getType();
			BufferedImage resizeImageJpg = CommonUtil.resizeImage(originalImage, type, 
													Constant.LESSON_THUMBNAIL_IMAGE_WIDTH, Constant.LESSON_THUMBNAIL_IMAGE_HEIGHT);
			ImageIO.write(resizeImageJpg, fileFormat, file); 
			NyuUtil.uploadFile(Lesson.class, lesson.getLessonId(), file, themeDisplay.getScopeGroupId(), Constant.LESSONS_HYPHEN_THUMBNAIL, file.getName(), serviceContext);
		} catch (Exception e) {
			LOG.error("[LessonsController: thumbnailProcess() ]"+e);
		}
	}
	
	private String getFileExtension(File file) {
		String name = file.getName();
	    try {
	        return name.substring(name.lastIndexOf(StringPool.PERIOD)+1);
	    } catch (Exception e) {
	    	LOG.error("[LessonsController: getFileExtension() ]"+e);
	        return StringPool.BLANK;
	    }
	}
	
	
	@ResourceMapping(value="appreciateLesson")
	public void appreciateLesson(ResourceRequest request,ResourceResponse response){
		int appreciatedCount = 0;
		try {
			Lesson lesson = LessonLocalServiceUtil.getLesson(Long.parseLong(request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID)));
			String appreciatedUserIds = lesson.getAppreciatedUserIds();
			List<String> items = new ArrayList<String>();
			if(!appreciatedUserIds.isEmpty()){
				items = Arrays.asList(appreciatedUserIds.split(StringPool.COMMA));
				appreciatedCount = items.size();
			}
			if(!items.contains(request.getParameter(Constant.COMMON_STRING_CONSTANT_USER_ID))){
				if(appreciatedUserIds.isEmpty()){
					appreciatedUserIds = request.getParameter(Constant.COMMON_STRING_CONSTANT_USER_ID);
				} else {
					appreciatedUserIds = appreciatedUserIds+StringPool.COMMA+request.getParameter(Constant.COMMON_STRING_CONSTANT_USER_ID);
				}
				lesson.setAppreciatedUserIds(appreciatedUserIds);
				appreciatedCount = items.size()+1;
				lesson.setAppreciateCount(appreciatedCount);
				LessonLocalServiceUtil.updateLesson(lesson);
				SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(request),lesson.getGroupId(),Lesson.class.getName(),lesson.getLessonId(),
						NyuMemberActivityKeys.APPRECIATE_LESSON, StringPool.BLANK, 0);
				
			}
			response.getWriter().write(appreciatedCount+StringPool.BLANK);
		} catch (NumberFormatException e) {
			LOG.error("[LessonsController: appreciate() ]"+e);
		} catch (IOException e) {
			LOG.error("[LessonsController: appreciate() ]"+e);
		} catch (PortalException e) {
			LOG.error("[LessonsController: appreciate() ]"+e);
		} catch (SystemException e) {
			LOG.error("[LessonsController: appreciate() ]"+e);
		}
		
	}
	
	@ResourceMapping(value="unAppreciateLesson")
	public void unAppreciateLesson(ResourceRequest request,ResourceResponse response){
		try {
			Lesson lesson = LessonLocalServiceUtil.getLesson(Long.parseLong(request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID)));
			int appreciatedCount = lesson.getAppreciateCount();
			String appreciatedUserIds = lesson.getAppreciatedUserIds();
			if(appreciatedUserIds.contains(request.getParameter(Constant.COMMON_STRING_CONSTANT_USER_ID))){
				
				appreciatedUserIds=removeAppreciateUserIds(appreciatedUserIds, PortalUtil.getUserId(request),appreciatedCount);
				if(appreciatedCount > 0){
					appreciatedCount = appreciatedCount-1;
				}
				lesson.setAppreciateCount(appreciatedCount);
				
				lesson.setAppreciatedUserIds(appreciatedUserIds);
				LessonLocalServiceUtil.updateLesson(lesson);
			}
			response.getWriter().write(appreciatedCount+StringPool.BLANK);

		} catch (PortalException e) {
			LOG.error("[RequestLessonController: unAppreciateRequest() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: unAppreciateRequest() ]"+e);
		} catch (IOException e) {
			LOG.error("[RequestLessonController: unAppreciateRequest() ]"+e);
		}
	}
	
	
private String removeAppreciateUserIds(String appreciatedUserIds,long userId,int appreciatedCount){
	List<String> items = new ArrayList<String>();
		if(!appreciatedUserIds.isEmpty()){
			items = Arrays.asList(appreciatedUserIds.split(StringPool.COMMA));
		}
		if(items.contains(String.valueOf(userId))){
			String appreciateUserId=String.valueOf(userId);
			appreciatedUserIds=StringPool.BLANK;
			if(items.size()>0){
				for(String item:items){
					System.out.println("item "+item);
					if(!item.equals(appreciateUserId)){
						if(appreciatedUserIds.isEmpty()){
							appreciatedUserIds = item+StringPool.BLANK;
						} else {
							appreciatedUserIds = appreciatedUserIds+StringPool.COMMA+item;
						}
					}
					System.out.println("appreciatedUserIds "+appreciatedUserIds);
				}
			}
		}
		return appreciatedUserIds;
	}
	
	
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RenderMapping(params = "action=thumbnail")
	public String thumbnail(RenderRequest request,RenderResponse response) {   
		return Constant.THUMBNAIL_JSP;   
	}	
	
	private void addAndPublish(UploadPortletRequest request, Lesson lesson, String documentPath, String unpublishDocPath, 
			String embedMediaPath, String existingEmbedMediaPath)
			throws SystemException, UnsupportedEncodingException {
		LOG.info("[ADD DOCUMENTS AND PUBLISH RESOURCES]");
		
		Set<String> vedioTranscSet = null;
		
		if(request.getParameter(Constant.SAVE_LESSON)!=null && request.getParameter(Constant.SAVE_LESSON).toString().equals(Constant.PUBLISH)){
			vedioTranscSet = checkVideoHasTranscript(request);
			
			saveDraftedDocs(request, lesson, existingEmbedMediaPath, vedioTranscSet);
		}
		
		if(request.getParameter(documentPath)!=null && !request.getParameter(documentPath).equals(StringPool.BLANK)){
			addDocuments(request, lesson, Constant.DOCUMENT_PATH_ARR, Constant.RESOURCE_ID_ARR, Constant.COLLECTION_ID_ARR, Constant.DOCUMENT_NAME_ARR, Constant.DOCUMENT_TITLE_ARR, Constant.DOCUMENT_DESC_ARR);
			
			if(request.getParameter(Constant.SAVE_LESSON)!=null && request.getParameter(Constant.SAVE_LESSON).toString().equals(Constant.PUBLISH))
				publishObjects( lesson, request.getParameter(Constant.RESOURCE_ID_ARR).split(StringPool.COMMA), vedioTranscSet ); //ESB Service Call for PUBLISH OBJECT
		}
		
		if(request.getParameter(embedMediaPath)!=null && !request.getParameter(embedMediaPath).trim().equals(StringPool.BLANK) && request.getParameter(embedMediaPath).split(StringPool.COMMA).length > 0){
			insertEmbedDocs(request, lesson, Constant.EMBED_MEDIA_TITLE_ARR, Constant.EMBED_MEDIA_DESC_ARR, Constant.EMBED_MEDIA_PATH_ARR);
		}
		
	}
	
	private void saveDraftedDocs(UploadPortletRequest request, Lesson lesson,
			String existingEmbedMediaPath, Set<String> vedioTranscSet)
			throws SystemException {
		if(request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_STATUS)!=null && !request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_STATUS).equals(StringPool.BLANK) && request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_STATUS).equalsIgnoreCase(Constant.LIFERAY_VENDOR_LESSON_STATUS_DRAFT)){
			
			if(request.getParameter(existingEmbedMediaPath)!=null && !request.getParameter(existingEmbedMediaPath).trim().equals(StringPool.BLANK) && request.getParameter(existingEmbedMediaPath).split(StringPool.COMMA).length > 0){
				insertEmbedDocs(request, lesson, Constant.EXISTING_EMBED_MEDIA_TITLE_ARR, Constant.EXISTING_EMBED_MEDIA_DESC_ARR, Constant.EXISTING_EMBED_MEDIA_PATH_ARR);
			}
			
			if(request.getParameter(Constant.EXISTING_RESOURCE_ID_ARR)!=null && !request.getParameter(Constant.EXISTING_RESOURCE_ID_ARR).equals(StringPool.BLANK) && request.getParameter(Constant.EXISTING_RESOURCE_ID_ARR).split(StringPool.COMMA).length > 0){
				publishObjects( lesson, request.getParameter(Constant.EXISTING_RESOURCE_ID_ARR).split(StringPool.COMMA), vedioTranscSet ); //ESB Service Call for PUBLISH OBJECT
			}
			
		}
	}
	
	private Set<String> checkVideoHasTranscript(UploadPortletRequest request) throws UnsupportedEncodingException {
		Set<String> vedioTranscSet = null;
		
		String[] allDocPaths = null;
		String[] allResIds = null; 
		String[] allDocTitles = null; 
		
		
		if(request.getParameter(Constant.DOCUMENT_PATH_ARR) != null && request.getParameter(Constant.EXISTING_DOC_PATH_ARR) != null)
			allDocPaths = (String[]) ArrayUtils.addAll(request.getParameter(Constant.DOCUMENT_PATH_ARR).split(StringPool.COMMA), request.getParameter(Constant.EXISTING_DOC_PATH_ARR).split(StringPool.COMMA));
		else if(request.getParameter(Constant.DOCUMENT_PATH_ARR) != null)
			allDocPaths = request.getParameter(Constant.DOCUMENT_PATH_ARR).split(StringPool.COMMA);
		else if(request.getParameter(Constant.EXISTING_DOC_PATH_ARR) != null)
			allDocPaths = request.getParameter(Constant.EXISTING_DOC_PATH_ARR).split(StringPool.COMMA);
		
		if(request.getParameter(Constant.DOCUMENT_TITLE_ARR) != null && request.getParameter(Constant.EXISTING_DOC_NAME) != null)
			allDocTitles = (String[]) ArrayUtils.addAll(request.getParameter(Constant.DOCUMENT_TITLE_ARR).split(StringPool.COMMA), request.getParameter(Constant.EXISTING_DOC_NAME).split(StringPool.COMMA));
		else if(request.getParameter(Constant.DOCUMENT_TITLE_ARR) != null)
			allDocTitles = request.getParameter(Constant.DOCUMENT_TITLE_ARR).split(StringPool.COMMA);
		else if(request.getParameter(Constant.EXISTING_DOC_NAME) != null)
			allDocTitles = request.getParameter(Constant.EXISTING_DOC_NAME).split(StringPool.COMMA);
		
		if(request.getParameter(Constant.RESOURCE_ID_ARR) != null && request.getParameter(Constant.EXISTING_RESOURCE_ID_ARR) != null)
			allResIds = (String[]) ArrayUtils.addAll(request.getParameter(Constant.RESOURCE_ID_ARR).split(StringPool.COMMA), request.getParameter(Constant.EXISTING_RESOURCE_ID_ARR).split(StringPool.COMMA));
		else if(request.getParameter(Constant.RESOURCE_ID_ARR) != null)
			allResIds = request.getParameter(Constant.RESOURCE_ID_ARR).split(StringPool.COMMA);
		else if(request.getParameter(Constant.EXISTING_RESOURCE_ID_ARR) != null)
			allResIds = request.getParameter(Constant.EXISTING_RESOURCE_ID_ARR).split(StringPool.COMMA);
				
		if(allDocPaths!=null && allResIds!=null && allDocTitles!=null){
			vedioTranscSet = new HashSet<String>();
			for(String rId : allResIds){
				if(hasTranscript(rId,allDocPaths,allDocTitles))
					vedioTranscSet.add(rId);
			}
		}
		
		return vedioTranscSet;
	}
	
	private boolean hasTranscript(String resourceId, String[] allDocPaths, String[] allDocTitles){
		boolean hasTranscript = false;
		String vUUID = null;
		String[] temp = allDocPaths;
		for(int i = 0; i < allDocPaths.length; i++){
			if(allDocPaths[i].contains(resourceId) && allDocTitles[i].endsWith(Constant.DOT_MP4)){
				temp = (String[])ArrayUtils.removeElement(temp, allDocPaths[i]);
				vUUID = allDocPaths[i].substring(allDocPaths[i].indexOf(Constant.AMPERSAND_UUID_EQUAL)+6, allDocPaths[i].length());
				for(int j = 0; j < temp.length; j++){
					if(temp[j].contains(vUUID))
						hasTranscript = true;
				}
			}
		}
		
		return hasTranscript;
	}
	
	private void addDocuments(UploadPortletRequest request, Lesson lesson, String documentPath, String resourceId, 
			String collectionId, String documentName, String documentTitle, String documentDesc) throws SystemException {
		LOG.info("[ADD DOCUMENTS]");
		DocumentFile document;
		String documentPathDate = null;
		String docPath = null;
		String []autoTranscriptArray = request.getParameter(Constant.AUTO_TRANSCRIPT_ARR).split(StringPool.COMMA);
		String uuid = null;
		SimpleDateFormat sdf = new SimpleDateFormat(Constant.YYYY_MM_DD_HH_mm_SS);
		String currentDateTime = sdf.format(new Date());
		
		int fileLength = request.getParameter(documentPath).split(StringPool.COMMA).length;
		if( fileLength == 0 ) 
			LOG.error ("[ERROR] Documents not uploaded" );
		for (int i = 0; i < fileLength; i++) {
			if(!request.getParameter(documentPath).split(StringPool.COMMA)[i].equals(StringPool.BLANK)){
			document = new DocumentFileImpl();
			document.setLessonId(lesson.getLessonId());
			document.setCompanyId(PortalUtil.getCompanyId(request));
			document.setGroupId(((ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY)).getScopeGroupId());
			docPath = request.getParameter(documentPath).split(StringPool.COMMA)[i];
			document.setDocumentPath(docPath);
			//document.setDocumentDesc(request.getParameter(documentDesc).split(StringPool.COMMA)[i]);
			document.setResourceId(new Long(request.getParameter(resourceId).split(StringPool.COMMA)[i]));
			//document.setCollectionId(new Long(request.getParameter(collectionId).split(StringPool.COMMA)[i]));
			//document.setDocumentName(request.getParameter(documentTitle).split(StringPool.COMMA)[i].equals(StringPool.BLANK)?request.getParameter(documentName).split(StringPool.COMMA)[i]:request.getParameter(documentTitle).split(StringPool.COMMA)[i]);
			//document.setDocumentName(StringUtils.encodeHTML(request.getParameter(documentTitle)).split(StringPool.COMMA)[i]);
			document.setDocumentName(request.getParameter(documentTitle).split(StringPool.COMMA)[i]);
			//document.setDocumentName(request.getParameter(documentName).split(StringPool.COMMA)[i]);
			document.setResourceType(Constant.COMMON_STRING_CONSTANT_RESOURCE_SPACE_STRING);
			
			if(autoTranscriptArray!=null && autoTranscriptArray.length > 0){
				for(String tRsrc : autoTranscriptArray){
					if(!tRsrc.equals(StringPool.BLANK) && tRsrc.substring(0, tRsrc.indexOf(StringPool.UNDERLINE)).equals(request.getParameter(resourceId).split(StringPool.COMMA)[i].toString().trim())){
						LOG.info("hasAutoTranscript "+tRsrc);
						//document.setHasAutoTranscript(Boolean.parseBoolean(tRsrc.substring(tRsrc.indexOf(StringPool.UNDERLINE)+1, tRsrc.length())));
					}
				}
			}
			
			uuid = docPath.substring(docPath.indexOf(Constant.AMPERSAND_UUID_EQUAL)+6, docPath.length());
			document.setDocUuid(uuid);
			int j = document.getDocumentPath().lastIndexOf(Constant.V_EQUAL);
			try {
	            if (j > 0) {
	            	documentPathDate = java.net.URLDecoder.decode(document.getDocumentPath().substring(j+2), Constant.UTF_EIGHT);
					document.setCreatedDate(sdf.parse(documentPathDate));
	            }else{
					document.setCreatedDate(sdf.parse(currentDateTime));
	            }
            } catch (ParseException e) {
            	LOG.error("[LessonsController: addDocuments() ]"+e);
			} catch (UnsupportedEncodingException e) {
				LOG.error("[LessonsController: addDocuments() ]"+e);
			}
			
			DocumentFileLocalServiceUtil.addDocumentFile(document); //INSERT into Document
			LOG.info("[INSERT-DOCUMENT]["+ document.getDocumentName()+"]["+ document.getResourceId()+"]["+ document.getDocumentPath()+"]");
		 }
		}
		//addEmbedDocuments(request, lesson, Constant.EMBED_MEDIA_TITLE_ARR, Constant.EMBED_MEDIA_DESC_ARR, Constant.EMBED_MEDIA_PATH_ARR, Constant.EXISTING_EMBED_MEDIA_PATH_ARR);
		
	}
	
	private void insertEmbedDocs(UploadPortletRequest request, Lesson lesson, String embedMediaTitle, String embedMediaDesc, String mediaPath)
			throws SystemException {
		
		LOG.info("[INSERT EMBED DOCUMENTS IN DB]");
		
		DocumentFile document = null;
		//String documentPathDate = null;
		if(!request.getParameter(mediaPath).equals(Constant.EMBED_MEDIA_PATH_ARR)){
			for (int i = 0; i < request.getParameter(mediaPath).split(StringPool.COMMA).length; i++) {
				document = new DocumentFileImpl(); 
				
				document.setCompanyId(PortalUtil.getCompanyId(request));
				document.setGroupId(((ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY)).getScopeGroupId());
				document.setLessonId(lesson.getLessonId());
				document.setDocumentName(request.getParameter(embedMediaTitle).split(StringPool.COMMA)[i]);
			//	document.setDocumentDesc(request.getParameter(embedMediaDesc).split(StringPool.COMMA)[i]);
				document.setDocumentPath(request.getParameter(mediaPath).split(StringPool.COMMA)[i]);
				if(document.getDocumentPath().indexOf(Constant.YOUTUBE_COM)>-1 || document.getDocumentPath().indexOf(Constant.YOUTU_BE)>-1 ){
					document.setResourceType(Constant.COMMON_YOUTUBE);
					if(document.getDocumentPath().indexOf(Constant.YOUTU_BE)>-1){
						String yurl = request.getParameter(mediaPath).split(StringPool.COMMA)[i];
						yurl = yurl.substring(yurl.indexOf(StringPool.FORWARD_SLASH+StringPool.FORWARD_SLASH+Constant.YOUTU_BE+StringPool.FORWARD_SLASH)+11);
						document.setDocumentPath(Constant.YOUTUBE_URL+yurl);
					}
					
				}else
					document.setResourceType(Constant.EMBED);
				document.setCreatedDate(new Date(System.currentTimeMillis()));
				DocumentFileLocalServiceUtil.addDocumentFile(document); //INSERT into Document
			}
		}
	}
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @param lessonId
	 * @return
	 */
	@RenderMapping(params = "action=showDocument")  
	public String showDocument(RenderRequest request,RenderResponse response, 
			@RequestParam("lessonId") long lessonId) {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long loginUserId=PortalUtil.getUserId(request);
		LOG.info("[LOADING SHOW DOCUMENT]["+ lessonId +"]");
		Lesson lesson = null;
		//String tag = null;
		try {
			lesson = LessonLocalServiceUtil.getLesson(lessonId);
			if(!lesson.getStatus().equalsIgnoreCase(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH)){
				boolean isRedirectToEditPage = CommonUtil.hasEditRights(request, loginUserId, lesson);
				request.setAttribute("isRedirectToEditPage", isRedirectToEditPage);
				request.setAttribute("lessonId", lesson.getLessonId());
				if(!isRedirectToEditPage){
					request.setAttribute(Constant.USER_PERMISSION_TO_ACCESS, false);
					String privacyCheckMessage = CommonUtil.JavaClassI18N(request, themeDisplay, "this-lesson-in-draft-mode");
					request.setAttribute(Constant.COMMON_STRING_CONSTANT_PRIVACY_CHECK_MESSAGE, privacyCheckMessage);
				}
				return Constant.COMMON_SHOW_DOCUMENT;
			}
			if(request.getParameter(Constant.UPDATE_LESSON)==null && request.getParameter(Constant.ADD_LESSON)==null 
					&& lesson.getCurrentAuthor() != themeDisplay.getUserId()){
					LessonLocalServiceUtil.performCleanUp(lesson.getLessonId(),Constant.VIEWLESSON_VIEWLESSON,themeDisplay.getUserId(),NyuMemberActivityKeys.VIEW_LESSON, null);
					LessonLocalServiceUtil.addSocialActivity(themeDisplay.getUserId(), lesson.getGroupId(), Lesson.class.getName(), lesson.getPrimaryKey(), NyuMemberActivityKeys.VIEW_LESSON);
			}
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID, request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID) );
			request.setAttribute(Constant.DOCUMENT_ID,ParamUtil.getLong(request,Constant.DOCUMENT_ID));
			request.setAttribute(Constant.LESSON, lesson );
			
			String lessonTags = CommonUtil.getTagSelectedNamesAsString(
					ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_LESSON_ID),Lesson.class.getName());
			if(lessonTags!=null && !lessonTags.trim().equals(StringPool.BLANK) && lessonTags.contains(StringPool.COMMA)){
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_TAGS, lessonTags.replaceAll(StringPool.COMMA, StringPool.COMMA+StringPool.SPACE));
			}else{
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_TAGS, lessonTags);
			}
			
			String str = request.getAttribute(Constant.COMMON_STRING_CONSTANT_TAGS).toString();
			StringTokenizer st = new StringTokenizer(str, StringPool.COMMA);
			int tagsSize = st.countTokens();
			request.setAttribute(Constant.TAGS_SIZE, tagsSize);
			
			boolean addToMyFavourite=LessonLocalServiceUtil.getFavouriteLesson(PortalUtil.getUserId(request), lessonId);
			request.setAttribute(Constant.ADD_TO_MY_FAVOURITE, addToMyFavourite );
			
			request.setAttribute(Constant.MARKED_AS, lesson.getMarkedAs());
			if(lesson.getMarkedAs().equalsIgnoreCase(Constant.INAPPROPRIATE)){
				request.setAttribute(Constant.MARKED_BY_USER, UserLocalServiceUtil.getUser(lesson.getMarkedBy()).getFullName());
			}else{
				request.setAttribute(Constant.MARKED_BY_USER,StringPool.BLANK);
			}			//String checkMarkedAs=ParamUtil.getString(request, Constant.CHECK_MARKED_AS);
			if(PortalUtil.isOmniadmin(loginUserId) || request.isUserInRole(Constant.PORTAL_ADMIN_ROLE)){
				if(lesson.getMarkedAs().equals(Constant.INAPPROPRIATE) || lesson.getMarkedAs().equals(Constant.MARKEDAS_QUARANTINE) || lesson.getMarkedAs().equals(Constant.LESSON_DELETED_BY_USER)){
					request.setAttribute(Constant.CHECK_MARKED_AS,lesson.getMarkedAs());
				}
			}
			
			
			long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
			
			DynamicQuery lessonDiscussionQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
			lessonDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(lessonId));
			lessonDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(lessonClassNameId));
			lessonDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.THREAD_ID).eq(lessonId));
			lessonDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.PARENT_MESSAGE_ID).eq(0l));
			List<MBMessage> lessonDiscussionList = MBMessageLocalServiceUtil.dynamicQuery(lessonDiscussionQuery);
			List<List<MBMessage>> lessonSubDiscussionList=new ArrayList<List<MBMessage>>();
			for(MBMessage lessonDiscussion:lessonDiscussionList){
				DynamicQuery lessonSubDiscussionQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
				lessonSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(lessonId));
				lessonSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(lessonClassNameId));
				lessonSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.THREAD_ID).eq(lessonId));
				lessonSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.ROOT_MESSAGE_ID).eq(lessonDiscussion.getRootMessageId()));
				List<MBMessage> lessonSubDiscussion = MBMessageLocalServiceUtil.dynamicQuery(lessonSubDiscussionQuery);
				lessonSubDiscussionList.add(lessonSubDiscussion);
			}
			request.setAttribute(Constant.LESSON_SUB_DISCUSSION_LIST, lessonSubDiscussionList );
			/** view Complete Document **/
			CommonUtil.getViewAdvanceLesson(request, response);
			
			/** People You are Following **/
			getFollowingAuthorsAndActivity(request);
			
			/** Who Else Viewed this Lesson ? **/
			getLessonViewedBy(request, lesson.getLessonId());
			
			/** You Might Also Like **/
			Set<Lesson> lessonsByCategoryAndTags = LessonLocalServiceUtil.getLessonsByCategoryAndTags(Lesson.class.getName(), lesson.getPrimaryKey(),themeDisplay.getUserId());
			Set<Lesson> lessonsByUserInterest = LessonLocalServiceUtil.getLessonsByCategoryAndTags(User.class.getName(), themeDisplay.getUserId(),themeDisplay.getUserId());
			if(lessonsByCategoryAndTags!=null)
				request.setAttribute(Constant.LESSON_BY_CATEGORY_AND_TAGS, CommonUtil.getlessonVOList(lessonsByCategoryAndTags, themeDisplay));
			if(lessonsByUserInterest !=null)	
				request.setAttribute(Constant.LESSON_BY_USER_INTEREST, CommonUtil.getlessonVOList(lessonsByUserInterest, themeDisplay));
			
			if(PortalUtil.getUser(request).getUserId()>0)
			{
				AuditReport auditReport=AuditNyuUtil.createReport(PortalUtil.getHttpServletRequest(request), CommonUtil.JavaClassI18N(request, themeDisplay, "view-lesson"),lesson.getLessonId()+StringPool.BLANK,CommonUtil.JavaClassI18N(request, themeDisplay, "lesson"),lesson.getLessonName());
				AuditReportLocalServiceUtil.addAuditReport(auditReport);
			}
		
		} catch (NumberFormatException e) {
			LOG.error("[LessonsController: showDocument() ]"+e);
		} catch (PortalException e) {
			LOG.error("[LessonsController: showDocument() ]"+e);
		} catch (SystemException e) {
			LOG.error("[LessonsController: showDocument() ]"+e);
		} catch (Exception e) {
			LOG.error("[LessonsController: showDocument() ]"+e);
		}
		
		return Constant.COMMON_SHOW_DOCUMENT;     
	}	
	
	@SuppressWarnings("deprecation")
	private void getFollowingAuthorsAndActivity(RenderRequest request){
		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
		Map<Map<User,SocialActivity>, SocialActivityFeedEntry> authActivityFeedMap = null; 
		Map<User,SocialActivity> authorsActivityMap = null; 
		Map<Long, Long> recentActivityMap = null;
		try{
				Map<Long, Long> userFollowingAuthors = LessonLocalServiceUtil.findFollowingAuthors(themeDisplay.getUserId());
				if(userFollowingAuthors!=null && userFollowingAuthors.size()>0){
					NyuMembersActivityInterpreter actIntr = new NyuMembersActivityInterpreter();

					//Create Map which will store items with SocialActivity created date by default
					authActivityFeedMap = new TreeMap<Map<User,SocialActivity>, SocialActivityFeedEntry>(
															  new Comparator<Map<User,SocialActivity>>() {
															    @Override public int compare(Map<User,SocialActivity> u1, Map<User,SocialActivity> u2) {
															      return (new Date(u2.entrySet().iterator().next().getValue().getCreateDate())).compareTo(new Date(u1.entrySet().iterator().next().getValue().getCreateDate())); 
															    }
															  }
														);
					
					for(Map.Entry<Long, Long> entry : userFollowingAuthors.entrySet()){
						recentActivityMap = LessonLocalServiceUtil.findRecentActivity(ClassNameLocalServiceUtil.getClassNameId(Lesson.class), entry.getKey());
						authorsActivityMap = new HashMap<User,SocialActivity>();
						if(recentActivityMap != null && recentActivityMap.size() > 0){
							authorsActivityMap.put(UserLocalServiceUtil.getUser(entry.getKey()), 
									SocialActivityLocalServiceUtil.getActivity((Long) recentActivityMap.keySet().toArray()[0]));
							SocialActivity socialActivity = SocialActivityLocalServiceUtil.getActivity((Long) recentActivityMap.keySet().toArray()[0]);
							authActivityFeedMap.put(authorsActivityMap, actIntr.interpret(socialActivity, ServiceContextFactory.getInstance(request)));
							 
						}else{
							User user = UserLocalServiceUtil.getUser(entry.getKey());
							authorsActivityMap.put(user, null);
							authActivityFeedMap.put(authorsActivityMap, null);
						}
					}
				}
				
		} catch (SystemException e) {
			LOG.error("LessonsController: getFollowingAuthorsAndActivity(): SystemException >> "+e);
		}catch (Exception e) {
			LOG.error("LessonsController: getFollowingAuthorsAndActivity(): Exception >> "+e);
		}
		request.setAttribute(Constant.AUTH_ACTIVITY_FEED_MAP, authActivityFeedMap );
	}
	 
	
	private void getLessonViewedBy(RenderRequest request, long lessonId){
		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
		
		Map<User, String> lessonViewedAuthorsMap = null;
		Map<User, Date> lessonDateMap = null;
														
		Map<Long, Long> lessonViewedBy = LessonLocalServiceUtil.findLessonByType(ClassNameLocalServiceUtil.getClassNameId(Lesson.class), lessonId, NyuMemberActivityKeys.VIEW_LESSON);
		
		if(lessonViewedBy!=null && lessonViewedBy.size()>0){
			try {
					lessonDateMap = new HashMap<User, Date>();
					for(Map.Entry<Long, Long> entry : lessonViewedBy.entrySet()){
							if(entry.getKey()!=themeDisplay.getUserId())
								lessonDateMap.put( UserLocalServiceUtil.getUser(entry.getKey()), new Date(entry.getValue()));
					}
					
					/** Sort Map by activity created date **/
					List<Map.Entry<User, Date>> list = new LinkedList<Map.Entry<User, Date>>(lessonDateMap.entrySet());
					Collections.sort( list, new Comparator<Map.Entry<User, Date>>()
									        {
									            public int compare( Map.Entry<User, Date> o1, Map.Entry<User, Date> o2 )
									            {
									                return (o2.getValue()).compareTo( o1.getValue() );
									            }
									        } 
									);
					
					lessonViewedAuthorsMap = new LinkedHashMap<User, String>();//LinkedHashMap will keep the keys in the order they are inserted which is currently sorted on natural ordering
					for(Map.Entry<User, Date> entry: list){
						lessonViewedAuthorsMap.put(entry.getKey(),  CommonUtil.getDatesDuration(entry.getValue().getTime(), 0));
					}
					
				} catch (PortalException e) {
					LOG.error("[ ERROR: LessonsController > PortalException ] " + e);
				} catch (SystemException e) {
					LOG.error("[ ERROR: LessonsController > SystemException ] " + e);
				}
		}
		
		request.setAttribute(Constant.LESSON_VIEWED_AUTHORS_MAP, lessonViewedAuthorsMap );
		
	}
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @param lessonId
	 * @return
	 */
	@RenderMapping(params = "action=editLesson")  
	public String editLesson(RenderRequest request,RenderResponse response, @RequestParam("lessonId") String lessonId ) {  
		LOG.info("[EDIT LESSON]["+ lessonId +"]");
		Lesson lesson = null;
		List<DocumentFile> updateDocsUuidList = null;
		List<DocumentFile> updateDocsList = null;
        try {
	            List<DocumentFile> documentFileList = LessonLocalServiceUtil.getDocumentFileList(Long.parseLong(lessonId));
	           
	            /** IMPORTANT: This code should be removed while Code Refactor - Start **/
		           
		           List<DocumentFile> otherDocs = new ArrayList<DocumentFile>();
		           List<DocumentFile> otherUpdatedDocs = new ArrayList<DocumentFile>();
		           if(documentFileList!=null && documentFileList.size()>0){
		        	   updateDocsUuidList = new ArrayList<DocumentFile>();
		        	   for(DocumentFile df : documentFileList){
		        		   if(df.getResourceType().equalsIgnoreCase(Constant.COMMON_STRING_CONSTANT_RESOURCE_SPACE_STRING) 
		        				   && (df.getDocUuid()==null || df.getDocUuid().equalsIgnoreCase(StringPool.BLANK))){
		        			   
		        			   updateDocsUuidList.add(df);
		        		   }else{
		        			   otherDocs.add(df);
		        		   }
		        	   }
		        	   
		        	   if(updateDocsUuidList.size()>0){
		        		   updateDocsList = new ArrayList<DocumentFile>();
		        		   
		        		   for(DocumentFile df : updateDocsUuidList){
		        			   if(df.getDocumentName().endsWith(Constant.DOT_MP4))
		        				   updateDocsList.add(df);
		        			   else
		        				   otherUpdatedDocs.add(df);
		        			   
		        		   }
		        		   
		        		   if(otherUpdatedDocs.size()>0)
		        			   updateDocsList.addAll(otherUpdatedDocs);
		        		   
		        		   updateDocsUuidList = null;
		        		   updateDocsUuidList = UUIDMigrationUtil.updateDocUUID(updateDocsList);
			        	   documentFileList = new ArrayList<DocumentFile>();//create modifiable list
			        	   documentFileList.addAll(updateDocsUuidList);
			        	   if(otherDocs.size()>0)
			        		   documentFileList.addAll(otherDocs);
		        	   }
		           }
	           /********************* IMPORTANT: END ***************************/ 
	           
			    request.setAttribute(Constant.DOCUMENT_FILE_LIST, documentFileList );
	            request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lessonId+StringPool.BLANK );
	            request.setAttribute(Constant.COMMON_STRING_CONSTANT_EDIT_LESSON, Constant.COMMON_STRING_CONSTANT_EDIT_LESSON);
	            request.setAttribute(Constant.LESSON, lesson );
	            
	            ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
	    			List<RequestLesson> requestedLessons = RequestLessonLocalServiceUtil.getRequestLessons(themeDisplay.getCompanyId());
	    			List<RequestLesson> reverseReqLes=new CopyOnWriteArrayList<RequestLesson>(requestedLessons);
	    			Collections.reverse(reverseReqLes);
	    			for(RequestLesson temp : reverseReqLes) 
	    			{
	    				if(temp.getStatus().equalsIgnoreCase(Constant.SMALL_OPEN) || temp.getStatus().equalsIgnoreCase(Constant.CLOSED) || temp.getAcceptedBy() != themeDisplay.getUserId())
	    				{
	    					reverseReqLes.remove(temp);
	    				}
	    			}
	    			request.setAttribute(Constant.REQUEST_LESSONS, reverseReqLes);
	    			
	    			Lesson thisLesson=LessonLocalServiceUtil.getLesson(Long.parseLong((String)lessonId));
	    			long lessonAuthor = thisLesson.getCurrentAuthor();
	    			List<User> allUsersList = UserLocalServiceUtil.getUsers(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
	    			List<User> usersList = new CopyOnWriteArrayList<User>(allUsersList);
	    			for(User author : usersList) 
	    			{
	    				if(author.getUserId() == lessonAuthor)
	    				{
	    					usersList.remove(author);
	    				}
	    			}
	    			request.setAttribute(Constant.LIST_OF_USERS, usersList);
	           
	        } catch (NumberFormatException e) {
	        	LOG.error("[LessonsController: editLesson() ]"+e);
	        }  catch (SystemException e) {
	        	LOG.error("[LessonsController: editLesson() ]"+e);
	        } catch (Exception e){
	        	LOG.error("[LessonsController: editLesson() ]"+e);
	        }

		return Constant.COMMON_STRING_CONSTANT_EDIT_LESSON;    
	}
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @param lessonId
	 */
	public void unPublishLesson(@RequestParam("lessonId") long lessonId ) {  
		LOG.info("[UNPUBLISH LESSON]["+ lessonId +"]");
		List<DocumentFile> documentFileList = null; Lesson lesson = null;
		try {
			lesson = LessonLocalServiceUtil.getLesson(lessonId);
			documentFileList = LessonLocalServiceUtil.getDocumentFileList(lessonId);
			List<String> resourceIdList = new ArrayList<String>();
			int pos = 0;
			for( DocumentFile documentFile : documentFileList ){
				if(documentFile.getResourceId() > 0){
					List<DocumentFile> DocumentFileListByDocId = DocumentFileLocalServiceUtil.getDocumentFilesByDocUuid(documentFile.getDocUuid(),lessonId);	
					if(DocumentFileListByDocId == null || DocumentFileListByDocId.size() <= 0){
						resourceIdList.add(documentFile.getResourceId()+StringPool.BLANK);
					}
				}
			}
			String[] resourceIdArray = new String[resourceIdList.size()];
			for(String resourceId :resourceIdList){
				resourceIdArray[pos] = resourceId;
				pos++;
			}
			//ESB Service Call for UNPUBLISH OBJECT
			unPublishObjects(  lesson, resourceIdArray );
		} catch (NumberFormatException e) {
			LOG.error("[LessonsController: unPublishLesson() ]"+e);
		}catch (PortalException e) {
			LOG.error("[LessonsController: unPublishLesson() ]"+e);
		}
		catch (SystemException e) {
			LOG.error("[LessonsController: unPublishLesson() ]"+e);
		}
	}
	/**
	 * 
//	 * @param request
	 * @param response
	 * @param lessonId
	 */
	@ActionMapping(params = "action=deleteLesson")  
	public void deleteLesson(ActionRequest request, ActionResponse response, @RequestParam("lessonId") long lessonId ) {
		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
		LOG.info("[DELETE LESSON]["+ lessonId +"]");
		try {
		Lesson lesson=LessonLocalServiceUtil.getLesson(lessonId);
		String lessonName=lesson.getLessonName();
		doCleanup(request, response, lessonId);
			AuditReport auditReport=AuditNyuUtil.createReport(PortalUtil.getHttpServletRequest(request), CommonUtil.JavaClassI18N(request, themeDisplay, "delete-lesson"),lessonId+StringPool.BLANK,CommonUtil.JavaClassI18N(request, themeDisplay, "lesson"),lessonName);
			AuditReportLocalServiceUtil.addAuditReport(auditReport);
		} catch (PortalException e) {
			LOG.error("[LessonsController: deleteLesson() ]"+e);
		} catch (SystemException e) {
			LOG.error("[LessonsController: deleteLesson() ]"+e);
		}
		try {
			themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
			String site = themeDisplay.getScopeGroup().getFriendlyURL();
			String layoutType = themeDisplay.getLayout().isPrivateLayout()? StringPool.FORWARD_SLASH+Constant.LIFERAY_VENDOR_LESSON_PRIVACY_GROUP : StringPool.FORWARD_SLASH+Constant.WEB;
			response.sendRedirect(PortalUtil.getPortalURL(request)+layoutType+site+Constant.PAGE_HOME);
		} catch (IOException e) {
			LOG.error("[LessonsController: deleteLesson() ]"+e);
		}
	}
	
	/**
	 * 
//	 * @param request
	 * @param response
	 * @param lessonId
	 */
	@ActionMapping(params = "action=deleteLessons")  
	public void deleteLessons(ActionRequest request, ActionResponse response) {  
	//	LOG.info("[DELETE LESSON]["+ lessonId +"]");
		List<Lesson> lessons = null;
		try {
			lessons = LessonLocalServiceUtil.getLessons(-1, -1); 
		} catch (SystemException e1) {
			LOG.error("[LessonsController: deleteLessons() ]"+e1);
		}
		
		if(Validator.isNull(lessons)) return;
		
		if(lessons.size() > 0){
			for(Lesson lesson : lessons){
				doCleanup(request, response, lesson.getLessonId());
			}	
		}
	}
	
	/**
	 * 
	 * @param resourceIdArray
	 */
	private void publishObjects( Lesson lesson, String[] resourceIdArray,Set<String> vedioTranscSet ) {
		LOG.info("[PUBLISH OBJECT]" + Arrays.toString(resourceIdArray));
		String damSecretKey = Constant.PORTLET_PROP_DAM_SECRET_KEY;
		try {
			CloudStorageServiceClass_CloudStorageRequest csr = new CloudStorageServiceClass_CloudStorageRequest();
			csr.setDamSecretKey( damSecretKey );
			String[] temp = resourceIdArray;
			List<String> residList = new ArrayList<String>();
			for ( int i = 0; i < temp.length ; i++) {
				if(!temp[i].trim().equals(StringPool.BLANK)){
					residList.add(temp[i]);
				}
			}
			
			resourceIdArray = residList.toArray(new String[residList.size()]);
			
			csr.setObjectIdList(resourceIdArray);
			String putObjectsToCloudStorageResponse = serviceRegistry.getCloudStorageServiceHandler().putObjectsToCloudStorage(csr);
			LOG.info("[PutObjectsToCloudStorageResponse][" + putObjectsToCloudStorageResponse +"]" );
			
			List<MediaMetaData> mediaMetaDataList = new ArrayList<MediaMetaData>();
			MediaMetaData mediaMetaData = null;
			//String documentPathDate = null;
			if( ! ArrayUtils.isEmpty( resourceIdArray )){
				for ( String resourceId : resourceIdArray ) {
					if(!resourceId.trim().equals(StringPool.BLANK)){
						mediaMetaData = new MediaMetaData();
						String location = getMediaLocationUrl( null, resourceId.trim(), null);
						DocumentFile document = DocumentFileLocalServiceUtil.getDocumentFile(Long.parseLong(resourceId.trim()),lesson.getLessonId() );
						document.setDownloadUrl(location);
						DocumentFileLocalServiceUtil.updateDocumentFile(document);
						mediaMetaData.setUUID(document.getDocUuid());
						mediaMetaData.setLocation(location);
						mediaMetaData.setCourseId(lesson.getCourseId());
						mediaMetaData.setResourceId(resourceId.trim());
						if(document.getDocumentName().endsWith(Constant.DOT_ZIP) && document.getDocumentName().contains(Constant.DOT_SCORM)){
							mediaMetaData.setMediaType(Constant.SCORM);
						}else{
							mediaMetaData.setMediaType(StringPool.BLANK);
						}
						
						if(vedioTranscSet.contains(resourceId.trim()))
							mediaMetaData.setWithTranscript(Constant.CAPITAL_T_TRUE);
						
						/*if(document.getHasAutoTranscript())
							mediaMetaData.setWithTranscript(Constant.CAPITAL_F_FALSE);*/
							
						mediaMetaDataList.add( mediaMetaData );
					}
					
				}
			}
			MediaMetaData[] mediaMetaDataArray = mediaMetaDataList.toArray(new MediaMetaData[mediaMetaDataList.size()]);
			for(MediaMetaData m : mediaMetaDataArray)
				LOG.info("mediaMetaDataArray: loc: "+m.getLocation()+" course id: "+m.getCourseId()+" Date: "+m.getDate()+" Resourseid: "+m.getResourceId());
			String addMediaResponse = serviceRegistry.getMediaServiceHandler().addMedia(mediaMetaDataArray);
			LOG.info("[AddMediaResponse][" + addMediaResponse  +"]");
		} catch (Exception e) {
			LOG.error( e.getMessage(), e );
		}
		LOG.info("[PUBLISH LESSON SUCCESSFUL]" + Arrays.toString(resourceIdArray));
	}

	private void sendLessonNotification(Lesson lesson,
			UploadPortletRequest request, String type) throws PortalException,
			SystemException {
		
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),themeDisplay.getLayout().isPrivateLayout(),themeDisplay);
		String lessonUrl=siteFriendlyUrl+Constant.PAGE_LESSON_BROWSE;
		ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
		SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(request),lesson.getGroupId(),Lesson.class.getName(),lesson.getLessonId(),
				NyuMemberActivityKeys.SEND_LESSON_NOTIFICATION, StringPool.BLANK, 0);
		
		JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, PortalUtil.getUserId(request));
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lesson.getLessonId());
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,lesson.getLessonName());
		payloadJSON.put(Constant.LESSON_URL,lessonUrl);
		payloadJSON.put(Constant.TYPE,type);
		
		UserNotificationEventLocalServiceUtil
				.addUserNotificationEvent(
						PortalUtil.getUserId(request),
						com.nyu.notification.LessonNotificationHandler.PORTLET_ID,
						(new Date()).getTime(), lesson.getGroupId(),
						payloadJSON.toString(), false,
						serviceContext);
	}
	
	/**
	 * 
	 * @param distributionId
	 * @param videoFileId
	 * @param mediaType
	 * @return
	 */
	private String getMediaLocationUrl( String distributionId, String videoFileId, String mediaType ){
		String location = null;
		try {
			location = serviceRegistry.getCdnServiceHandler().getDomainName( distributionId, videoFileId, mediaType );
			LOG.info("[LocationResponse][" + location +"]" );
		} catch (RemoteException e) {
			LOG.error( e.getMessage(), e );
		}
		
		return location;
	}
	/**
	 * 
	 * @param resourceIdArray
	 */
	private void unPublishObjects(Lesson lesson, String[] resourceIdArray ) {
		LOG.info("[UNPUBLISH OBJECT]" + Arrays.toString(resourceIdArray));
		String damSecretKey = Constant.PORTLET_PROP_DAM_SECRET_KEY;
		try {
			if( ! ArrayUtils.isEmpty( resourceIdArray )){
				CloudStorageServiceClass_CloudStorageRequest csr = new CloudStorageServiceClass_CloudStorageRequest();
				csr.setDamSecretKey( damSecretKey );
				csr.setObjectIdList(resourceIdArray);
				String deleteObjectsFromCloudStorageResponse = serviceRegistry.getCloudStorageServiceHandler().deleteObjectsFromCloudStorage(csr);
				LOG.info("[DeleteObjectsFromCloudStorageResponse][" + deleteObjectsFromCloudStorageResponse +"]" );
				List<MediaMetaData> mediaMetaDataList = new ArrayList<MediaMetaData>();
				MediaMetaData mediaMetaData = null;
				for ( String resourceId : resourceIdArray ) {
					mediaMetaData = new MediaMetaData();
					String location = getMediaLocationUrl( null, resourceId.trim(), null);
					DocumentFile document = DocumentFileLocalServiceUtil.getDocumentFile(Long.parseLong(resourceId.trim()),lesson.getLessonId());
					mediaMetaData.setLocation(location);
					mediaMetaData.setCourseId( lesson.getCourseId() );
					mediaMetaData.setUUID(document.getDocUuid());
					mediaMetaData.setMediaType(StringPool.BLANK);
					mediaMetaData.setResourceId(resourceId);
					mediaMetaDataList.add( mediaMetaData );
				}
				MediaMetaData[] mediaMetaDataArray = mediaMetaDataList.toArray(new MediaMetaData[mediaMetaDataList.size()]);
				String removeMediaResponse = serviceRegistry.getMediaServiceHandler().removeMedia( mediaMetaDataArray );
				LOG.info("[removeMediaResponse][" + removeMediaResponse  +"]");
			}
			
		} catch (Exception e) {
			LOG.error( e.getMessage(), e );
		}
		LOG.info("[UNPUBLISH LESSON SUCCESSFUL]" + Arrays.toString(resourceIdArray));
	}
	
	private void doCleanup(ActionRequest actionRequest,ActionResponse actionResponse, long lessonId ){
		LOG.info("[DO CLEAN-UP]");
		ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		unPublishLesson(lessonId);
		LessonLocalServiceUtil.performCleanUp(lessonId,Constant.DELETE_LESSON,themeDisplay.getUserId(), NyuMemberActivityKeys.DELETE_LESSON, null);
	}
	
	
	@ActionMapping(params = "action=addLessonToPlaylist")
	public void addLessonToPlaylist(ActionRequest actionRequest,ActionResponse actionResponse)throws PortalException, SystemException	{
		long lessonId = Long.valueOf(actionRequest.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID));
		//String selectedPlaylistIds[]= actionRequest.getParameterValues(Constant.SELECTED_PLAY_IDS);
		try {
			ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
			PortletURL url = PortletURLFactoryUtil.create(actionRequest, PortalUtil.getPortletId(actionRequest), themeDisplay.getPlid(), PortletRequest.RENDER_PHASE);
			url.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lessonId+StringPool.BLANK);
			url.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);
			try {
				url.setWindowState(WindowState.MAXIMIZED);
			} catch (WindowStateException e) {
				LOG.error("[LessonsController: addLessonToPlaylist() ]"+e);
			}
			actionResponse.sendRedirect(url.toString());
		} catch (IOException e) {
			LOG.error("[LessonsController: addLessonToPlaylist() ]"+e);
		}
	}
	
	@ActionMapping(params = "action=followUser")
	public void followUser(ActionRequest actionRequest,ActionResponse actionResponse)throws SystemException
	{
		LOG.info("[FOLLOW AUTHOR]");
		SocialRelationConstants s;
		try {
				int type = ParamUtil.getInteger(actionRequest, Constant.TYPE);
				LOG.info("[CURRENT AUTHOR ID] "+ Long.parseLong(actionRequest.getParameter(Constant.COMMON_STRING_CONSTANT_USER_ID)));
				LOG.info("[FOLLOW AUTHOR ID] "+ Long.parseLong(actionRequest.getParameter(Constant.FOLLOW_USER)));
				SocialRelationLocalServiceUtil.addRelation(Long.parseLong(actionRequest.getParameter(Constant.COMMON_STRING_CONSTANT_USER_ID)), Long.parseLong(actionRequest.getParameter(Constant.FOLLOW_USER)), type);
				
		} catch (PortalException e) {
			LOG.error("LessonsController: followUser(): PortalException >> "+e);
		}catch (Exception e) {
			LOG.error("LessonsController: followUser(): Exception >> "+e);
		}
	}
	
	@ActionMapping(params = "action=unFollowUser")
	public void unFollowUser(ActionRequest actionRequest,ActionResponse actionResponse)throws SystemException
	{
		LOG.info("[UNFOLLOW AUTHOR]");
		SocialRelationConstants s;
		try {
				int type = ParamUtil.getInteger(actionRequest, Constant.TYPE);
				LOG.info("[CURRENT AUTHOR ID] "+ Long.parseLong(actionRequest.getParameter(Constant.COMMON_STRING_CONSTANT_USER_ID)));
				LOG.info("[UNFOLLOW AUTHOR ID] "+ Long.parseLong(actionRequest.getParameter(Constant.UN_FOLLOW_USER)));
				SocialRelationLocalServiceUtil.deleteRelation(Long.parseLong(actionRequest.getParameter(Constant.COMMON_STRING_CONSTANT_USER_ID)), Long.parseLong(actionRequest.getParameter(Constant.UN_FOLLOW_USER)), type);
				
		} catch (PortalException e) {
			LOG.error("LessonsController: unFollowUser(): PortalException >> "+e);
			LOG.error(e);
		}catch (Exception e) {
			LOG.error("LessonsController: unFollowUser(): Exception >> "+e);
			LOG.error(e);
		}
	}
	
	@RenderMapping(params = "action=showFollowing")
	public String showFollowing(RenderRequest request,RenderResponse response) {
		LOG.info("[SHOW FOLLOWING]");
		Map<User,List<Lesson>> userLessonsMap = null;
		try {
			
			ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
			List<User> followingUserList = UserLocalServiceUtil.getSocialUsers(themeDisplay.getUserId(), ParamUtil.getInteger(request, Constant.TYPE),  QueryUtil.ALL_POS, QueryUtil.ALL_POS, null);
			if(followingUserList!=null && followingUserList.size()>0){
				LOG.info("[AUTHORS FOLLOWED]");
				userLessonsMap = new HashMap<User, List<Lesson>>();
				for(User usr : followingUserList){
					userLessonsMap.put(UserLocalServiceUtil.getUser(usr.getUserId()), LessonLocalServiceUtil.getLessonsUploadedByAuthor(usr.getUserId()));
				}
				request.removeAttribute(Constant.NOT_FOLLOWING);
			}else{
				
				//bring most followed authors
				
				LOG.info("[MOST FOLLOWED AUTHORS]");
				ThemeDisplay tDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
				Map<Long, Long> mostFollowedAuthors = LessonLocalServiceUtil.findMostFollowedAuthors();  
				if(mostFollowedAuthors!=null && mostFollowedAuthors.size()>0){
					userLessonsMap = new HashMap<User, List<Lesson>>();
					for(Map.Entry<Long, Long> entry : mostFollowedAuthors.entrySet()){
						if(entry.getKey() != tDisplay.getUserId()){
							userLessonsMap.put(UserLocalServiceUtil.getUser(entry.getKey()), LessonLocalServiceUtil.getLessonsUploadedByAuthor(entry.getKey()));
						}
					}
				}
				
				request.setAttribute(Constant.NOT_FOLLOWING, Constant.NOT_FOLLOWING);
			}
			
		} catch (SystemException e) {
			LOG.error("LessonsController: showFollowing(): SystemException >> "+e);
			LOG.error(e);
		}catch (Exception e) {
			LOG.error("LessonsController: showFollowing(): Exception >> "+e);
			LOG.error(e);
		}
		
		request.setAttribute(Constant.USER_LESSON_MAP, userLessonsMap);
		request.setAttribute(Constant.COUNTS,Constant.PORTLET_PROP_SHOW_LESSONS_COUNT_VALUE);
		
		return Constant.SHOW_FOLLOWING;  
	}
	
	@RenderMapping(params = "action=showFollowingBasedTag")
	public String showFollowingBasedTag(RenderRequest request,RenderResponse response) {
		LOG.info("[SHOW FOLLOWING]");
		Map<User,List<Lesson>> userLessonsMap = null;
		try {
			
			AssetEntryQuery entryQuery = new AssetEntryQuery();
			entryQuery.setClassName(Lesson.class.getName());
			entryQuery.setAllTagIds(new long[] {Long.parseLong(request.getParameter(Constant.COMMON_STRING_CONSTANT_TAG_ID))});
			List<AssetEntry> assetEntries = AssetEntryLocalServiceUtil.getEntries(entryQuery);
			
				
			ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
			List<User> followingUserList = UserLocalServiceUtil.getSocialUsers(themeDisplay.getUserId(), ParamUtil.getInteger(request, Constant.TYPE),  QueryUtil.ALL_POS, QueryUtil.ALL_POS, null);
			if(followingUserList!=null && followingUserList.size()>0){
				LOG.info("[AUTHORS FOLLOWED]");
				userLessonsMap = new HashMap<User, List<Lesson>>();
				for(User usr : followingUserList){
					List<Lesson> tagLessons = new ArrayList<Lesson>();
					for(AssetEntry assetEntry:assetEntries){
						Lesson l = LessonLocalServiceUtil.getLessonsUploadedByAuthor(assetEntry.getClassPK(), usr.getUserId());
						if (l != null){
							tagLessons.add(l);
						}
					}
					userLessonsMap.put(UserLocalServiceUtil.getUser(usr.getUserId()), tagLessons);
				}
				request.removeAttribute(Constant.NOT_FOLLOWING);
			}else{
				//bring most followed authors
				LOG.info("[MOST FOLLOWED AUTHORS]");
				
				ThemeDisplay tDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
				Map<Long, Long> mostFollowedAuthors = LessonLocalServiceUtil.findMostFollowedAuthors();  
				if(mostFollowedAuthors!=null && mostFollowedAuthors.size()>0){
					userLessonsMap = new HashMap<User, List<Lesson>>();
					for(Map.Entry<Long, Long> entry : mostFollowedAuthors.entrySet()){
						if(entry.getKey() != tDisplay.getUserId()){
							List<Lesson> tagLessons = new ArrayList<Lesson>();
								for(AssetEntry assetEntry:assetEntries){
									Lesson l = LessonLocalServiceUtil.getLessonsUploadedByAuthor(assetEntry.getClassPK(), entry.getKey());
									if (l != null){
										tagLessons.add(l);
									}
								}
								userLessonsMap.put(UserLocalServiceUtil.getUser(entry.getKey()), tagLessons);
						}
						
						
					}
					
					
				}
				
				request.setAttribute(Constant.NOT_FOLLOWING, Constant.NOT_FOLLOWING);
			}
			
		} catch (SystemException e) {
			LOG.error("LessonsController: showFollowing(): SystemException >> "+e);
			LOG.error(e);
		}catch (Exception e) {
			LOG.error("LessonsController: showFollowing(): Exception >> "+e);
			LOG.error(e);
		}
		
		request.setAttribute(Constant.USER_LESSON_MAP, userLessonsMap);
		request.setAttribute(Constant.COUNTS,Constant.PORTLET_PROP_SHOW_LESSONS_COUNT_VALUE);
		
		return Constant.SHOW_FOLLOWING;  
	}	
	

	@ResourceMapping(value="authorLessons")
	public void authorLessons(ResourceRequest request, ResourceResponse response) { 
		HttpServletRequest  httpRequest = PortalUtil.getHttpServletRequest(request);
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		long authorId = Long.valueOf(request.getParameter(Constant.AUTHOR_ID));
		LOG.info("[AUTHOR LESSONS]["+ authorId +"]");
		List<Lesson> lessons = new ArrayList<Lesson>();
		 try {
				 lessons = LessonLocalServiceUtil.getLessonsUploadedByAuthor(authorId);
				 lessons = lessons.subList(3, lessons.size()); 
				 
				 httpRequest.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSONS, lessons);
				 httpRequest.setAttribute(Constant.FOLLOW_LEFT_SPACE,Constant.COMMON_NO);
				 httpRequest.setAttribute(Constant.COUNTS,Constant.PORTLET_PROP_SHOW_LESSONS_COUNT_VALUE);
				 
		         ServletContext context = httpRequest.getSession().getServletContext();
		         String jspFile = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.LESSONS_INCLUDE_RESULTS_JSP);
		         jspFile=Constant.TAG_DIV_CATEGORY_CONTENT_ROW_FLUID+jspFile;
		         response.getWriter().write(jspFile);
             } catch (Exception e) {
            	 LOG.error("[LessonsController: authorLessons() ]"+e);
	        } 

	}
	
	
	@ResourceMapping(value="saveComment")
    public void insertComments(ResourceRequest request, ResourceResponse response) throws IOException
	{
		
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long lessonId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_CLASS_PK);
		long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
		int defaultMaxComments= ParamUtil.getInteger(request, Constant.DEFAULT_MAX_COMMENTS);
		String body = ParamUtil.getString(request,Constant.USER_COMMENTS);
		boolean role=request.isUserInRole(Constant.CAPITAL_ADMINISTRATOR);
		
		try {
			long messageId = 0l;
			messageId = CounterLocalServiceUtil.increment();
			MBMessage mbMessage = MBMessageLocalServiceUtil.createMBMessage(messageId);
			mbMessage.setGroupId(themeDisplay.getScopeGroupId());
			mbMessage.setCompanyId(themeDisplay.getCompanyId());
			mbMessage.setUserId(themeDisplay.getUserId());
			mbMessage.setCreateDate(new Date());
			mbMessage.setClassNameId(lessonClassNameId);
			mbMessage.setClassPK(lessonId);
			mbMessage.setUserName(themeDisplay.getUser().getFullName());
			mbMessage.setBody(body);
			MBMessageLocalServiceUtil.addMBMessage(mbMessage);
			LessonLocalServiceUtil.performCleanUp(lessonId,Constant.LESSON_PERFORM_CLEAN_UP_DELETE_COMMENT,themeDisplay.getUserId(),NyuMemberActivityKeys.ADD_COMMENT, null);
			LessonLocalServiceUtil.addSocialActivity(themeDisplay.getUserId(), themeDisplay.getScopeGroupId(), Lesson.class.getName(), lessonId, NyuMemberActivityKeys.ADD_COMMENT);

		} catch (Exception e) {
			LOG.error("[LessonsController: insertComments() ]"+e);
		}
			DynamicQuery dynamicQuery1 = DynamicQueryFactoryUtil.forClass(MBMessage.class);
			dynamicQuery1.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(lessonId));
			dynamicQuery1.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(lessonClassNameId));
			dynamicQuery1.add(PropertyFactoryUtil.forName(Constant.THREAD_ID).eq(0l));
			String comments = StringPool.BLANK;
			
			try {
				List<MBMessage> reverseList = MBMessageLocalServiceUtil.dynamicQuery(dynamicQuery1);
				List<MBMessage> commentsList =  new ArrayList<MBMessage>();	
				List<MBMessage> commentsSubList = new ArrayList<MBMessage>();
					
					for(int i=reverseList.size()-1;i>=0;i--)
					{
						commentsList.add(reverseList.get(i));
						
					}
					if(commentsList.size()> defaultMaxComments)
					{	commentsSubList =  commentsList.subList(0, defaultMaxComments);
						for(MBMessage mbMessage:commentsSubList){
							if(role){
								comments = comments+Constant.THREE_SPACES+Constant.TAG_DIV_CLASS_COMMENT_NAME_CLEARFIX+mbMessage.getUserName()+Constant.TAG_ANCHOR_ONCLICK_DELETE_COMMENT+mbMessage.getMessageId()+Constant.TAG_SPAN_CLASS_ICON_PEN_DIV_PARA_OPEN+ mbMessage.getBody()+Constant.TAG_PARA_CLOSE ;	
							} else{
								comments = comments+Constant.THREE_SPACES+Constant.THREE_SPACES+mbMessage.getUserName()+Constant.TAG_STRONG_CLOSE+Constant.TAG_DIV_CLOSE+Constant.TAG_PARA_OPEN+ mbMessage.getBody()+Constant.TAG_PARA_CLOSE ; 
							}
						}
						comments=comments+Constant.TAG_SPAN_DISPLAY_NONE_SHOW_MORE_BUTTON;
					}
					else
					{
						commentsSubList = commentsList.subList(0,commentsList.size());
						for(MBMessage mbMessage:commentsSubList){
							if(role){
								comments = comments+Constant.THREE_SPACES+Constant.THREE_SPACES+mbMessage.getUserName()+Constant.TAG_ANCHOR_ONCLICK_DELETE_COMMENT+mbMessage.getMessageId()+Constant.TAG_SPAN_CLASS_ICON_PEN_DIV_PARA_OPEN+ mbMessage.getBody()+Constant.TAG_PARA_CLOSE ;	
							} else{
								comments = comments+Constant.THREE_SPACES+Constant.THREE_SPACES+mbMessage.getUserName()+Constant.TAG_STRONG_CLOSE+Constant.TAG_DIV_CLOSE+Constant.TAG_PARA_OPEN+ mbMessage.getBody()+Constant.TAG_PARA_CLOSE ; 
							}
						}
					}
					
					
				response.getWriter().write(Constant.TAG_LINE_BREAK+comments+Constant.SIZE_OF_INSERT_COMMENT_COLON+commentsList.size());
			} catch (SystemException e) {
				LOG.error("[LessonsController: insertComments() ]"+e);
			}
	 } 
	
	@ResourceMapping(value="nextComments")
    public void getNextComments(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException  {
		
		int numberOfCommentsOnload = ParamUtil.getInteger(resourceRequest, Constant.NUMBER_OF_COMMENTS_ON_LOAD);
    	int numberOfCommentsOnclick = ParamUtil.getInteger(resourceRequest, Constant.NUMBER_OF_COMMENTS_ON_CLICK);
    	long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
    	
		long classPK = ParamUtil.getLong(resourceRequest,Constant.COMMON_STRING_CONSTANT_CLASS_PK);
		DynamicQuery dynamicQuery1 = DynamicQueryFactoryUtil.forClass(MBMessage.class);
		dynamicQuery1.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(classPK));
		dynamicQuery1.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(lessonClassNameId));
		
		String comments = StringPool.BLANK;
		
		try {
				List<MBMessage> reverseList = MBMessageLocalServiceUtil.dynamicQuery(dynamicQuery1);
				List<MBMessage> commentsList =  new ArrayList<MBMessage>();	
				List<MBMessage> commentsSubList = new ArrayList<MBMessage>();
				boolean role=resourceRequest.isUserInRole(Constant.CAPITAL_ADMINISTRATOR);
				
				for(int i=reverseList.size()-1;i>=0;i--)
				{
					commentsList.add(reverseList.get(i));
					
				}
								
				if(commentsList.size()-numberOfCommentsOnload<numberOfCommentsOnclick){
					commentsSubList =  commentsList.subList(numberOfCommentsOnload, (commentsList.size()-numberOfCommentsOnload)+numberOfCommentsOnload);
				}else{
					commentsSubList = commentsList.subList(numberOfCommentsOnload, numberOfCommentsOnload+numberOfCommentsOnclick);
				}
				for(MBMessage mbMessage:commentsSubList){
					if(role){
						comments = comments+Constant.THREE_SPACES+Constant.THREE_SPACES+mbMessage.getUserName()+Constant.TAG_ANCHOR_ONCLICK_DELETE_COMMENT+mbMessage.getMessageId()+Constant.TAG_SPAN_CLASS_ICON_PEN_DIV_PARA_OPEN+ mbMessage.getBody()+Constant.TAG_PARA_CLOSE ;	
					} else{
						comments = comments+Constant.THREE_SPACES+Constant.THREE_SPACES+mbMessage.getUserName()+Constant.TAG_STRONG_CLOSE+Constant.TAG_DIV_CLOSE+Constant.TAG_PARA_OPEN+ mbMessage.getBody()+Constant.TAG_PARA_CLOSE ; 
					}
				}
			
			resourceResponse.getWriter().write(comments);
		} catch (SystemException e) {
			LOG.error("[LessonsController: getNextComments() ]"+e);
		}
	}
	
	@ResourceMapping(value="deleteComment")
    public void deleteComment(ResourceRequest request, ResourceResponse response) throws IOException
	{
		long messageId=ParamUtil.getLong(request,Constant.MESSAGE_ID);
		long lessonId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_CLASS_PK);
		long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
		int defaultMaxComments= ParamUtil.getInteger(request,Constant.DEFAULT_MAX_COMMENTS);
		boolean role=request.isUserInRole(Constant.CAPITAL_ADMINISTRATOR);
		try {
			MBMessageLocalServiceUtil.deleteMBMessage(messageId);
		} catch (PortalException e) {
			LOG.error("[LessonsController: deleteComment() ]"+e);
		} catch (SystemException e) {
			LOG.error("[LessonsController: deleteComment() ]"+e);
		}
		DynamicQuery dynamicQuery1 = DynamicQueryFactoryUtil.forClass(MBMessage.class);
		dynamicQuery1.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(lessonId));
		dynamicQuery1.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(lessonClassNameId));
		dynamicQuery1.add(PropertyFactoryUtil.forName(Constant.THREAD_ID).eq(0l));
		String comments = StringPool.BLANK;
		
		try {
			List<MBMessage> reverseList = MBMessageLocalServiceUtil.dynamicQuery(dynamicQuery1);
			List<MBMessage> commentsList =  new ArrayList<MBMessage>();	
			List<MBMessage> commentsSubList = new ArrayList<MBMessage>();
				
				for(int i=reverseList.size()-1;i>=0;i--)
				{
					commentsList.add(reverseList.get(i));
					
				}
				if(commentsList.size()> defaultMaxComments)
				{	
					commentsSubList =  commentsList.subList(0, defaultMaxComments);
					for(MBMessage mbMessage:commentsSubList){
						if(role){
							comments = comments+Constant.THREE_SPACES+Constant.THREE_SPACES+mbMessage.getUserName()+Constant.TAG_ANCHOR_ONCLICK_DELETE_COMMENT+mbMessage.getMessageId()+Constant.TAG_SPAN_CLASS_ICON_PEN_DIV_PARA_OPEN+ mbMessage.getBody()+Constant.TAG_PARA_CLOSE ;			
						} else{
							comments = comments+Constant.THREE_SPACES+Constant.THREE_SPACES+mbMessage.getUserName()+Constant.TAG_STRONG_CLOSE+Constant.TAG_DIV_CLOSE+Constant.TAG_PARA_OPEN+ mbMessage.getBody()+Constant.TAG_PARA_CLOSE ; 
						}
					}
					comments=comments+Constant.TAG_SPAN_DISPLAY_NONE_SHOW_MORE_BUTTON;
					
				}
				else
				{
					commentsSubList = commentsList.subList(0,commentsList.size());
					for(MBMessage mbMessage:commentsSubList){
						if(role){
							comments = comments+Constant.THREE_SPACES+Constant.THREE_SPACES+mbMessage.getUserName()+Constant.TAG_ANCHOR_ONCLICK_DELETE_COMMENT+mbMessage.getMessageId()+Constant.TAG_SPAN_CLASS_ICON_PEN_DIV_PARA_OPEN+ mbMessage.getBody()+Constant.TAG_PARA_CLOSE ;	
						} else{
							comments = comments+Constant.THREE_SPACES+Constant.THREE_SPACES+mbMessage.getUserName()+Constant.TAG_STRONG_CLOSE+Constant.TAG_DIV_CLOSE+Constant.TAG_PARA_OPEN+ mbMessage.getBody()+Constant.TAG_PARA_CLOSE ; 
						}
					}
				}
				
			response.getWriter().write(Constant.TAG_LINE_BREAK+comments+Constant.SIZE_OF_INSERT_COMMENT_COLON+commentsList.size());
		} catch (SystemException e) {
			LOG.error("[LessonsController: deleteComment() ]"+e);
		}
	}
	
	@RenderMapping(params ="action=email")
	public String showEmail(RenderRequest request,RenderResponse response)throws IOException, Exception {  
		 ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
	     
		 JSONArray jsonResult = com.liferay.portal.kernel.json.JSONFactoryUtil.createJSONArray();
	     List<User> userEmailList=UserLocalServiceUtil.getCompanyUsers(themeDisplay.getCompanyId(),-1, -1);
		 for(User user:userEmailList){
			jsonResult.put(user.getEmailAddress());
		 }
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID, ParamUtil.getShort(request, Constant.EMAIL_LESSON_ID));
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_EMAIL_ADDRESS,jsonResult.toString());
		return Constant.REQUEST_LESSON_EMAIL_JSP;   
	}
	
	@ResourceMapping(value="sendEmailAction")  
	public void sendEmail(ResourceRequest request, ResourceResponse response) throws AddressException, PortalException, SystemException, IOException {  
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		String fromAddress=UserLocalServiceUtil.getUser(themeDisplay.getUserId()).getEmailAddress();
		String[] toAddress=ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_TO_ADDRESS).split(StringPool.SEMICOLON);
		String message=ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_MESSAGE);
		String body=StringPool.BLANK;
		String subject=ParamUtil.getString(request, Constant.REQUEST_LESSON_SUBJECT_JSP);
		String url=ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_URL);
		String PublicUrl=ParamUtil.getString(request, Constant.PUBLIC_URL);
		MailMessage mailMessage = new MailMessage();
		InternetAddress from = new InternetAddress(fromAddress);
		InternetAddress to ;
		for(int i=0;i<toAddress.length;i++){
			to = new InternetAddress(toAddress[i]);
			if(toAddress[i].endsWith(Constant.PORTLET_PROP_AT_RATE_SITE_EXTENSION)){
				body=message+StringPool.DOUBLE_SPACE+Constant.COMMON_STRING_CONSTANT_DOUBLE_NEW_LINE+url;
			}else{
				body=message+StringPool.DOUBLE_SPACE+Constant.COMMON_STRING_CONSTANT_DOUBLE_NEW_LINE+PublicUrl;
			}
			mailMessage.setFrom(from);
			mailMessage.setTo(to);
			mailMessage.setBody(body);
			mailMessage.setSubject(subject);
			MailServiceUtil.sendEmail(mailMessage);
		}
		response.getWriter().write(CommonUtil.JavaClassI18N(request, themeDisplay, "send-email-successfully")+ toAddress);
	}
	
@ResourceMapping(value="lessonPrivacy")
	public void lessonPrivacy(ResourceRequest request, ResourceResponse response) throws IOException {
	ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
	String message=StringPool.BLANK;
	long nolessonId=0l;

		try {
			if(Validator.isNotNull(ParamUtil.getString(request, Constant.LESSON_IDS))){
				long[] lessonIds=GetterUtil.getLongValues(ParamUtil.getString(request, Constant.LESSON_IDS).split(StringPool.COMMA));
				for(long lessonId:lessonIds){
					nolessonId=lessonId;
					Lesson lesson=LessonLocalServiceUtil.getLesson(lessonId);
					if(lesson.getLessonPrivacy().equalsIgnoreCase(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE)){
						message= CommonUtil.JavaClassI18N(request, themeDisplay, "you-can-not-embed-private-lesson-s-for-public-lesson");
						break;
					}
				}
			}
		
		} catch (Exception e) {
			LOG.error("[LessonsController: lessonPrivacy() ]"+e);
			message=CommonUtil.JavaClassI18N(request, themeDisplay, "no-lesson-exists-with-lesson-Id")+"   ("+nolessonId+")";
			
		 }
		response.getWriter().write(message);  
		
	}
	
	@ResourceMapping(value="generateDocUUID")
	public void generateUUID(ResourceRequest request, ResourceResponse response) throws IOException {
		
		response.getWriter().write(UUID.randomUUID().toString());  
		
	}
	
	@RenderMapping(params = "action=createGroupLesson")  
	public String createGroupLesson(RenderRequest request,RenderResponse response){
		return Constant.CREATE_LESSON;
	}
	
	
	
	
	
	@RenderMapping(params="action=uploadImage")
	public String uploadImage(RenderRequest request,RenderResponse response) throws PortalException, SystemException {
		return Constant.COMMON_LESSON_THUMBNAIL;  
	}
	
	@ResourceMapping(value="updateProfilePicture")  
	public void updateProfilePicture(ResourceRequest request, ResourceResponse response, ServiceContext serviceContext) throws IOException, SystemException, NumberFormatException, PortalException  {  
		//ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		UploadPortletRequest uploadPortletRequest = PortalUtil.getUploadPortletRequest(request);
		File file = uploadPortletRequest.getFile(Constant.USER_PROFILE_FILE_UPLOAD);
		int cropRegion_x = ParamUtil.getInteger(uploadPortletRequest, Constant.CROP_REGION_X);
		int cropRegion_y = ParamUtil.getInteger(uploadPortletRequest, Constant.CROP_REGION_Y);
		int cropRegion_width = ParamUtil.getInteger(uploadPortletRequest, Constant.CROP_REGION_WIDTH);
		int cropRegion_height = ParamUtil.getInteger(uploadPortletRequest, Constant.CROP_REGION_HEIGHT);
		//Lesson lesson = null;
		
		
		String fileFormat = getFileExtension1(file);
		BufferedImage originalImage = ImageIO.read(file);
		int type = originalImage.getType() == 0? BufferedImage.TYPE_INT_ARGB : originalImage.getType();
		BufferedImage resizeImageJpg =CommonUtil.resizeImage(originalImage, type,ParamUtil.getInteger(uploadPortletRequest, Constant.ORIGINAL_WIDTH, 0), ParamUtil.getInteger(uploadPortletRequest, Constant.ORIGINAL_HEIGHT, 0));
		ImageIO.write(resizeImageJpg, fileFormat, file); 
		
		file = thumbnailProcess(file, cropRegion_x, cropRegion_y, cropRegion_width, cropRegion_height);
		String userId=PortalUtil.getUserId(request)+StringPool.BLANK;
		
		SimpleDateFormat sdf = new SimpleDateFormat(Constant.DDMMYYYY_HHmmSS);  
		String strDate = sdf.format(new Date());  
		String fileName = request.getPortletSession().getPortletContext().getRealPath(StringPool.FORWARD_SLASH)+ Constant.IMAGES_SLASH_TEMP_SLASH+strDate+userId+Constant.DUMMY+StringPool.PERIOD+fileFormat;  
		File tempFile = new File(fileName);  
		
		BufferedImage tempImage = ImageIO.read(file);
		ImageIO.write(tempImage, fileFormat, tempFile);
		
		FileInputStream fileInputStream=null;
		byte[] bFile = new byte[(int) file.length()];
		fileInputStream = new FileInputStream(file);
		fileInputStream.read(bFile);
		fileInputStream.close();
		
		    response.getWriter().write(Constant.PORTLET_PROP_SITE_NAME_PORTLET_IMAGE_TEMP+tempFile.getName());
	}
	
	
	private File thumbnailProcess(File file, int cropRegion_x, int cropRegion_y, int cropRegion_width, int cropRegion_height){
		String fileFormat = getFileExtension(file);
		try {
			BufferedImage originalImage = ImageIO.read(file);
			int type = originalImage.getType() == 0? BufferedImage.TYPE_INT_ARGB : originalImage.getType();
			BufferedImage resizeImageJpg =resizeLessonImage(originalImage,type,cropRegion_x,cropRegion_y,cropRegion_width, cropRegion_height);
			ImageIO.write(resizeImageJpg, fileFormat, file); 
		} catch (Exception e) {
			LOG.error("[LessonsController: thumbnailProcess() ]"+e);
		}
		return file;
	}
	
	
	private String getFileExtension1(File file) {
	    String name = file.getName();
	    try {
	        return name.substring(name.lastIndexOf(StringPool.PERIOD)+1);

	    } catch (Exception e) {
	    	LOG.error("[LessonsController: getFileExtension1() ]"+e);
	        return StringPool.BLANK;
	    }
	}
	
	public static BufferedImage resizeLessonImage(BufferedImage originalImage, int type,int x,int y, int resizedWidth, int resizedHeight){
		
		BufferedImage resizedImage = new BufferedImage(resizedWidth, resizedHeight, type);
		Graphics2D g = resizedImage.createGraphics();
		g.drawImage(originalImage, 0, 0, resizedWidth, resizedHeight,x,y,x+resizedWidth,y+resizedHeight,null);
		g.dispose();
		return resizedImage;
	}
	
	@ResourceMapping(value="lessonDiscussion")
    public String lessonDiscussion(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException, PortalException, SystemException, ServletException  {
	
		ThemeDisplay themeDisplay = (ThemeDisplay) resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
		long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
		long lessonId = Long.parseLong(resourceRequest.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID));
		long parentMessageId =Long.parseLong(resourceRequest.getParameter(Constant.MESSAGE_ID));
		String body=resourceRequest.getParameter(Constant.USER_NOTE);
		String title=resourceRequest.getParameter(Constant.COMMON_STRING_CONSTANT_TITLE);
		boolean hasAdminRights = false;
		try {
			if(PortalUtil.isOmniadmin(themeDisplay.getUserId()) || PortalUtil.isCompanyAdmin(themeDisplay.getUser()) || resourceRequest.isUserInRole(Constant.PORTAL_ADMIN_ROLE)){
				hasAdminRights = true;
			}
			MBMessage mbParentMessage=null;
			if(parentMessageId>0){
				 mbParentMessage = MBMessageLocalServiceUtil.getMBMessage(parentMessageId);
				if(!mbParentMessage.getSubject().contains(Constant.RE_COLON))
					title=Constant.RE_COLON+mbParentMessage.getSubject();
				else
					title=mbParentMessage.getSubject();
			}
			long messageId = 0l;
			messageId = CounterLocalServiceUtil.increment();
			MBMessage mbMessage = MBMessageLocalServiceUtil.createMBMessage(messageId);
			mbMessage.setGroupId(themeDisplay.getScopeGroupId());
			mbMessage.setCompanyId(themeDisplay.getCompanyId());
			mbMessage.setUserId(themeDisplay.getUserId());
			mbMessage.setCreateDate(new Date());
			mbMessage.setClassNameId(lessonClassNameId);
			mbMessage.setClassPK(lessonId);
			mbMessage.setUserName(themeDisplay.getUser().getFullName());
			mbMessage.setBody(body);
			mbMessage.setSubject(title);
			mbMessage.setParentMessageId(parentMessageId);
			mbMessage.setThreadId(lessonId);
			
			if(Validator.isNotNull(mbParentMessage) && mbParentMessage.getMessageId()>0)
				mbMessage.setRootMessageId(mbParentMessage.getRootMessageId());
			else
				mbMessage.setRootMessageId(mbMessage.getMessageId());
			
			mbMessage=MBMessageLocalServiceUtil.addMBMessage(mbMessage);
			
			DynamicQuery lessonDiscussionQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
			
			lessonDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(lessonId));
			lessonDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(lessonClassNameId));
			lessonDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.THREAD_ID).eq(lessonId));
			lessonDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.PARENT_MESSAGE_ID).eq(0l));
						
			List<MBMessage> lessonDiscussionList = MBMessageLocalServiceUtil.dynamicQuery(lessonDiscussionQuery);
			List<List<MBMessage>> lessonSubDiscussionList=new ArrayList<List<MBMessage>>();
			for(MBMessage lessonDiscussion:lessonDiscussionList){
				DynamicQuery lessonSubDiscussionQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
				lessonSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(lessonId));
				lessonSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(lessonClassNameId));
				lessonSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.THREAD_ID).eq(lessonId));
				lessonSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.ROOT_MESSAGE_ID).eq(lessonDiscussion.getRootMessageId()));
				List<MBMessage> lessonSubDiscussion = MBMessageLocalServiceUtil.dynamicQuery(lessonSubDiscussionQuery);
				lessonSubDiscussionList.add(lessonSubDiscussion);
			}
			resourceRequest.setAttribute(Constant.COMMON_HAS_ADMIN_RIGHTS,hasAdminRights);
			resourceRequest.setAttribute(Constant.LESSON_SUB_DISCUSSION_LIST, lessonSubDiscussionList);
				return Constant.DISCUSSION_RESULTS;
		} catch (Exception e) {
			LOG.error("[LessonsController: lessonDiscussion() ]"+e);
			return Constant.DISCUSSION_RESULTS;
		}
	}
	
	@ResourceMapping(value="deleteDiscussion")
    public void deleteDiscussion(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException, PortalException, SystemException, ServletException  {
	
		//ThemeDisplay themeDisplay = (ThemeDisplay) resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
		long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
		long lessonId = Long.parseLong(resourceRequest.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID));
		long messageId =Long.parseLong(resourceRequest.getParameter(Constant.MESSAGE_ID));
		boolean isHeader = ParamUtil.getBoolean(resourceRequest, Constant.IS_HEADER);
		if(isHeader){
			DynamicQuery lessonDiscussionQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
			lessonDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(lessonId));
			lessonDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(lessonClassNameId));
			lessonDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.ROOT_MESSAGE_ID).eq(messageId));
			List<MBMessage> lessonDiscussionList = MBMessageLocalServiceUtil.dynamicQuery(lessonDiscussionQuery);
			for(MBMessage message : lessonDiscussionList){
				MBMessageLocalServiceUtil.deleteMBMessage(message.getMessageId());
			}
		}else{
			MBMessageLocalServiceUtil.deleteMBMessage(messageId);
		}
		resourceResponse.getWriter().write(Constant.DELETED);
	}
	
	
	@ResourceMapping(value="deleteImageURL")
    public void deleteProfileImage(ResourceRequest request, ResourceResponse response) throws IOException  {
		NyuUtil.deleteDLFileEntry(Lesson.class, ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID));
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		response.getWriter().write(themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER );
	}
	
	@ResourceMapping(value="latestLessons")
	public void getLatestLessons(ResourceRequest request,ResourceResponse response) {
		List<Lesson> lessons = new ArrayList<Lesson>();
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		String userGroupId = ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID, null);
		try {
			int start=ParamUtil.getInteger(request, Constant.START, -1);
			int end=ParamUtil.getInteger(request, Constant.END, -1);
			long categoryId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_CATEGORY_ID,0l);
			long tagId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_TAG_ID,0l);
			if(Validator.isNotNull(userGroupId)){
				lessons = SortLessonUtil.getUserGroupLessonsByItem(GetterUtil.getLong(userGroupId), categoryId, tagId, Constant.MOST_RECENT, start, end);
			} else {
				lessons = SortLessonUtil.getLessonsByItem(categoryId,themeDisplay.getUserId(), tagId, Constant.MOST_RECENT, start, end);
			}
			LOG.info("start: "+start);
			LOG.info("end: "+end);
			if(lessons.size()<(end-start)){
				request.setAttribute(Constant.END_RESULT, true);
			}else{
				request.setAttribute(Constant.END_RESULT, false);
			}
			LOG.info("Lessons to display: "+lessons.size());
			setJsonData(request, response, lessons, start, end, themeDisplay);
		} catch (IOException e) {
			LOG.error("[LessonsController: getLatestLessons() ]"+e);
		} catch (PortalException e) {
			LOG.error("[LessonsController: getLatestLessons() ]"+e);
		} catch (SystemException e) {
			LOG.error("[LessonsController: getLatestLessons() ]"+e);
		}
		
	}	
	
	@ResourceMapping(value="popularLessons")
	public void getPopularLessons(ResourceRequest request,ResourceResponse response) {
		List<Lesson> lessons = new ArrayList<Lesson>();
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		String userGroupId = ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID, null);
		try {
			int start=ParamUtil.getInteger(request, Constant.START, -1);
			int end=ParamUtil.getInteger(request, Constant.END, -1);
			String filterType=ParamUtil.getString(request, Constant.FILTER_TYPE, Constant.COMMON_VIEW_COUNT);
			long categoryId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_CATEGORY_ID,0l);
			long tagId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_TAG_ID,0l);
			LOG.info("filterType:"+filterType);
			if(Validator.isNotNull(userGroupId)){
				lessons = SortLessonUtil.getUserGroupLessonsByItem(GetterUtil.getLong(userGroupId), categoryId, tagId, filterType, start, end);
			} else {
				lessons = SortLessonUtil.getLessonsByItem(categoryId,themeDisplay.getUserId(), tagId, filterType, start, end);
			}
			LOG.info("start: "+start);
			LOG.info("end: "+end);
			if(lessons.size()<(end-start)){
				request.setAttribute(Constant.END_RESULT, true);
			}else{
				request.setAttribute(Constant.END_RESULT, false);
			}
			LOG.info("Lessons to display:"+lessons.size());
			setJsonData(request, response, lessons, start, end, themeDisplay);
		} catch (IOException e) {
			LOG.error("[LessonsController: getPopularLessons() ]"+e);
		} catch (PortalException e) {
			LOG.error("[LessonsController: getPopularLessons() ]"+e);
		} catch (SystemException e) {
			LOG.error("[LessonsController: getPopularLessons() ]"+e);
		}
		
	}	
	
	@ResourceMapping(value="featuredLessons")
	public void getFeaturedLessons(ResourceRequest request,ResourceResponse response) {
		List<Lesson> lessons = new ArrayList<Lesson>();
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		String userGroupId = ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID, null);
		String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
		String[] userGroupLessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE};
		String[] notMarkedAs = {Constant.MARKEDAS_QUARANTINE,Constant.LESSON_DELETED_BY_USER,Constant.LESSON_FROM_DELETED_GROUP};
		long tagId = ParamUtil.getLong(request,"tagId",0l);
		try {
			if(tagId > 0){
				if(Validator.isNotNull(userGroupId)){
					lessons = LessonLocalServiceUtil.findAssetFeaturedUserGroupLessonsByTag(GetterUtil.getLong(userGroupId), tagId, Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH, userGroupLessonPrivacy, "uploadedTime", notMarkedAs, -1, -1);
				}else{
					lessons = LessonLocalServiceUtil.findAssetFeaturedLessonsByTag(tagId, themeDisplay.getUserId(), Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH, lessonPrivacy, "uploadedTime", notMarkedAs, -1, -1);
				}
			}else{
				if(Validator.isNotNull(userGroupId)){
					lessons = SortLessonUtil.getFeaturedUserGroupLessons(GetterUtil.getLong(userGroupId), -1, -1);
				}
				else{
					lessons = LessonLocalServiceUtil.findAssetFeaturedLessons(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH, themeDisplay.getUserId(), lessonPrivacy, "uploadedTime", notMarkedAs, -1, -1);
				}
			}
			
			setJsonData(request, response, lessons, -1, -1, themeDisplay);
			
		} catch (IOException e) {
			LOG.error("[LessonsController: getFeaturedLessons() ]"+e);
		} catch (PortalException e) {
			LOG.error("[LessonsController: getFeaturedLessons() ]"+e);
		} catch (SystemException e) {
			LOG.error("[LessonsController: getFeaturedLessons() ]"+e);
		}
		
	}
	
	
	@RenderMapping(params ="action=addFeaturedLessons")
	public String makeLessonsFeatured(RenderRequest request,RenderResponse response){  
		String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
		String closePopup = ParamUtil.getString(request, Constant.CLOSE_POPUP,Constant.COMMON_STRING_CONSTANT_FALSE);
		request.setAttribute(Constant.CLOSE_POPUP, closePopup);
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_LESSON_PRIVACY).in(lessonPrivacy));
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.MARKED_AS).ne(Constant.MARKEDAS_QUARANTINE));
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.MARKED_AS).ne(Constant.LESSON_DELETED_BY_USER));
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.MARKED_AS).ne(Constant.LESSON_FROM_DELETED_GROUP));
		try {
			List<Lesson> lessons = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_ALL_LESSONS,lessons);
			
		} catch (SystemException e1) {
			LOG.error("[LessonsController: makeLessonsFeatured() ]"+e1);
		}
		return Constant.MAKE_LESSON_AS_FEATURED;   
	}
	
	
	@ActionMapping(params = "action=processAddLessonToFeatured")
	public void processAddLessonToFeatured(ActionRequest actionRequest,ActionResponse actionResponse)
	{
		try {
			long[] CheckedlessonIds=ParamUtil.getLongValues(actionRequest,Constant.LESSON_IDS_CHECKBOX);
			long[] checkedLesson=ParamUtil.getLongValues(actionRequest, Constant.CHECKED_LESSON);
			long[] unCheckedLesson=ParamUtil.getLongValues(actionRequest, Constant.UNCHECKED_LESSON);
			String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
			String[] markedAs ={Constant.MARKEDAS_RELEASE,StringPool.BLANK};
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_LESSON_PRIVACY).in(lessonPrivacy));
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.MARKED_AS).in(markedAs));
			List<Lesson> allLessons = new ArrayList<Lesson>();
			
			try {
				allLessons = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
			} catch (SystemException e2) {
				LOG.error("[LessonsController: makeLessonsFeatured() ]"+e2);
			}
			/*if(allLessons!=null && allLessons.size()>0){
			for(Lesson lesson:allLessons){
				lesson.setFeatured(false);
				LessonLocalServiceUtil.updateLesson(lesson);
			}
			}*/
			Lesson lesson=null;
			for(int i=0; i<unCheckedLesson.length;i++){
				lesson=LessonLocalServiceUtil.getLesson(unCheckedLesson[i]);
				lesson.setFeatured(false);
				LessonLocalServiceUtil.updateLesson(lesson);
			}
			
			Lesson lessons=null;
			for(int i=0; i<checkedLesson.length;i++){
				lessons=LessonLocalServiceUtil.getLesson(checkedLesson[i]);
				lessons.setFeatured(true);
				LessonLocalServiceUtil.updateLesson(lessons);
			}
			for(long lessonId:CheckedlessonIds){
				lessons=LessonLocalServiceUtil.getLesson(lessonId);
				lessons.setFeatured(true);
				LessonLocalServiceUtil.updateLesson(lessons);
			}
			actionResponse.setRenderParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.ADD_FEATURED_LESSONS);
			actionResponse.setRenderParameter(Constant.CLOSE_POPUP,Constant.COMMON_STRING_CONSTANT_TRUE);
		} catch (Exception e) {
			LOG.error("[LessonsController: makeLessonsFeatured() ]"+e);
		}

	}
	@ResourceMapping(value="userLessons")
	public void showAuthroLessons(ResourceRequest request,ResourceResponse response) throws IOException { 
	DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
	dynamicQuery.add(PropertyFactoryUtil.forName(Constant.UPLOAD_BY_ID).eq(new Long(ParamUtil.getLong(request, Constant.AUTHOR_ID))));
	dynamicQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
	dynamicQuery.addOrder(OrderFactoryUtil.desc(Constant.USER_GROUP_UPLOAD_TIMES_VAR));
	
	try {
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSONS,LessonLocalServiceUtil.dynamicQuery(dynamicQuery));
	} catch (SystemException e1) {
		LOG.error("[LessonsController: showAuthroLessons() ]"+e1);
	}
	HttpServletRequest httpRequest = PortalUtil
			.getHttpServletRequest(request);
	HttpServletResponse httpResponse = PortalUtil
			.getHttpServletResponse(response);
	ServletContext context = httpRequest.getServletContext().getContext(Constant.PORTLET_PROP_CONTEXT_NAME);
	
	RequestDispatcher requestDispatcher =
			context.getRequestDispatcher(Constant.LESSONS_AUTHOR_LESSON_JSP);
	try {
		requestDispatcher.include(httpRequest, httpResponse);
	} catch (ServletException e) {
		LOG.error("[LessonsController: showAuthroLessons() ]"+e);
	}
	}	
	
	@ResourceMapping(value="backToUserStatURL")
	public void showUserStats(ResourceRequest request,ResourceResponse response) throws IOException { 
		
		HttpServletRequest httpRequest = PortalUtil
				.getHttpServletRequest(request);
		HttpServletResponse httpResponse = PortalUtil
				.getHttpServletResponse(response);
		ServletContext context = httpRequest.getServletContext().getContext(Constant.PORTLET_PROP_CONTEXT_NAME);
		
		RequestDispatcher requestDispatcher =
				context.getRequestDispatcher(Constant.LESSONS_USER_STATS_JSP);

		try {
			requestDispatcher.include(httpRequest, httpResponse);
		} catch (ServletException e) {
			LOG.error("[LessonsController: showUserStats() ]"+e);
		}
	}	
	
	private void setJsonData(ResourceRequest request, ResourceResponse response, List<Lesson> lessons,
			int start, int end, ThemeDisplay themeDisplay) throws SystemException, PortalException,
			IOException {
		List<AssetCategory> categories = null;
		List<AssetVocabulary> vocabularies = null;
		List<AssetTag> tags=null;
		vocabularies = AssetVocabularyLocalServiceUtil.getGroupVocabularies(themeDisplay.getScopeGroupId(), Constant.CATEGORY_VOCABULARY, 0, 1, null);
		if(vocabularies!=null && vocabularies.size()>0){
			categories = AssetCategoryLocalServiceUtil.getVocabularyRootCategories(vocabularies.get(0).getVocabularyId(), 0, vocabularies.get(0).getCategories().size(), null);
			tags=AssetTagLocalServiceUtil.getGroupTags(themeDisplay.getScopeGroupId());
		}
		String jsonCategorys=CommonUtil.getJSONCategorys(categories);
		String jsonTags=CommonUtil.getJSONTags(tags);
		String jsonLessons = CommonUtil.getJSONLessons(lessons, themeDisplay);
		
		JSONObject AllLessonData=JSONFactoryUtil.createJSONObject();
		
		AllLessonData.put(Constant.GET_LESSONS,jsonLessons);
		AllLessonData.put(Constant.GET_CATEGORIES,jsonCategorys);
		AllLessonData.put(Constant.GET_TAGS,jsonTags);
		AllLessonData.put(Constant.START,start);
		AllLessonData.put(Constant.END,end);
		if(request.getAttribute(Constant.END_RESULT)!=null){
			AllLessonData.put(Constant.END_RESULT,(Boolean)request.getAttribute(Constant.END_RESULT));
		}
		response.getWriter().write(AllLessonData.toString());
	}	
	
	
	@RenderMapping(params ="action=categoryAddLessons")
    public String filterByCategory(RenderRequest request, RenderResponse response) throws IOException  {
		
			long categoryId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_CATEGORY_ID);
			//long userId = PortalUtil.getUserId(request);
			List<Lesson> lessons=null;
			String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
			String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
			String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.LESSON_FROM_DELETED_GROUP,Constant.MARKEDAS_QUARANTINE,Constant.INAPPROPRIATE};
			if(categoryId>0){
				lessons =LessonLocalServiceUtil.findAssetLessonsByCategoryAndFeatured(categoryId, true, status, lessonPrivacy, Constant.USER_GROUP_UPLOAD_TIMES_VAR,markedAs, -1, -1);
			}else{
				String[] markedAs2 ={Constant.MARKEDAS_RELEASE,StringPool.BLANK};
				DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
				dynamicQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_LESSON_PRIVACY).in(lessonPrivacy));
				dynamicQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
				dynamicQuery.add(PropertyFactoryUtil.forName(Constant.MARKED_AS).in(markedAs2));
				try {
					lessons = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
				} catch (SystemException e) {
					LOG.error("[LessonsController: filterByCategory() ]"+e);
				}
			}
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_ALL_LESSONS,lessons);
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_CATEGORY_ID,categoryId+StringPool.BLANK);
			return Constant.MAKE_LESSON_AS_FEATURED;
	}
	
	@RenderMapping(params ="action=tagAddLessons")
    public String filterByTag(RenderRequest request, RenderResponse response) throws IOException  {
		long tagId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_TAG_ID);
		//long userId=PortalUtil.getUserId(request);
		List<Lesson> lessons=null;
		String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
		String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
		String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.LESSON_FROM_DELETED_GROUP,Constant.MARKEDAS_QUARANTINE,Constant.INAPPROPRIATE};
		if(tagId>0){
			lessons =LessonLocalServiceUtil.findAssetLessonsByTagAndFeatured(tagId, true, status, lessonPrivacy,Constant.USER_GROUP_UPLOAD_TIMES_VAR,markedAs, -1, -1);
		}else{
			String[] markedAs2 ={Constant.MARKEDAS_RELEASE,StringPool.BLANK};
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_LESSON_PRIVACY).in(lessonPrivacy));
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.MARKED_AS).in(markedAs2));
			try {
				lessons = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
			} catch (SystemException e) {
				LOG.error("[LessonsController: filterByTag() ]"+e);
			}
		}
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_ALL_LESSONS,lessons);
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_TAG_ID,tagId+StringPool.BLANK);
		return Constant.MAKE_LESSON_AS_FEATURED;
	}
	
	/*@ResourceMapping(value="generateReport")
	private void generateReport(ResourceRequest request,
			ResourceResponse response) {
		
		try {                
			String msg = "NY-YOU REPORT";

			Document document = new Document();

			ByteArrayOutputStream baos = new ByteArrayOutputStream();

			PdfWriter.getInstance(document, baos);
			
			
			List<Lesson> lessons = new ArrayList<Lesson>();
			//List<User> authors = new ArrayList<User>();
			List<Lesson> lessonsList = null;

				lessonsList=SortLessonUtil.getLessonsByItem(0l,0l ,Constant.MOST_RECENT, -1,-1);
				if(lessonsList!=null && lessonsList.size()>0){
					for(Lesson lsn : lessonsList){
						//if(lsn!=null && lsn.getLessonPrivacy().equalsIgnoreCase(PortletProps.get("liferay.nyu.lesson.privacy.nyu")))
							lessons.add(lsn);
					}
				}
				//authors = UserLocalServiceUtil.getu
				request.setAttribute("lessons",lessons);
			

			document.open();
			document.add(new Paragraph(msg));
			document.add(Chunk.NEWLINE);
			//document.add(new Paragraph("Lesson Details."));
			HTMLWorker htmlWorker = new HTMLWorker(document);
			//String str = "<b>It is a Rainy day today..."+Constant.BOLD_TAG_CLOSE;
			
			HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
			HttpServletResponse httpResponse = PortalUtil
					.getHttpServletResponse(response);
			ServletContext context = httpRequest.getSession()
					.getServletContext();
			String jspFile = StringPool.BLANK;

				jspFile = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.SITE_HOME_LESSON_REPORT_JSP);
				

			//htmlWorker.parse(new StringReader(str));
			htmlWorker.parse(new StringReader(jspFile));
			document.close();

			response.setContentType(Constant.SET_CONTENT_TYPE_APPLICATION_PDF);
			//response.addProperty(HttpHeaders.CACHE_CONTROL, "max-age=3600, must-revalidate");

			response.setContentLength(baos.size());

			java.io.OutputStream out = response.getPortletOutputStream();
			baos.writeTo(out);

			out.flush();
			out.close();
		} catch (Exception e2) {
			LOG.info("Error in " + getClass().getName() + "\n" + e2);
		}

	}*/

	@RenderMapping(params = "action=openDocumentPreview")
	public String openDocumentPreview(RenderRequest request,RenderResponse response) { 
		String previewUrl = Constant.PORTLET_PROP_RESOURCE_SPACE_PREVIEW_URL+request.getParameter(Constant.COMMON_STRING_CONSTANT_RESOURCE_ID);
		previewUrl = previewUrl+Constant.AMPERSAND_KEY_EQUAL+Constant.PORTLET_PROP_RESOURCE_SPACE_PREVIEW_KEY;
		request.setAttribute(Constant.RESOURCE_URL,previewUrl);
		return Constant.PREVIEW_DOCUMENTS;   
	}

	
	@ResourceMapping(value="addToMyFavourite")
    public void addToMyFavourite(ResourceRequest resourceRequest, ResourceResponse resourceResponse){
		
		long lessonId=ParamUtil.getLong(resourceRequest,Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		long userId=PortalUtil.getUserId(resourceRequest);
		Boolean notExsist=LessonLocalServiceUtil.getFavouriteLesson(userId, lessonId);
		
		if(notExsist){
			
			FavouriteLessons lesson=new FavouriteLessonsImpl();
			lesson.setUserId(userId);
			lesson.setLessonId(lessonId);
			try {
				FavouriteLessonsLocalServiceUtil.addFavouriteLessons(lesson);
			} catch (SystemException e) {
				LOG.error("[LessonsController: addToMyFavourite() ]"+e);
			}
		}
	}
	
	@ResourceMapping(value="removeFromMyFavourite")
    public void removeFromMyFavourite(ResourceRequest resourceRequest, ResourceResponse resourceResponse){
	
		long lessonId=ParamUtil.getLong(resourceRequest,Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		long userId=PortalUtil.getUserId(resourceRequest);
		
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(FavouriteLessons.class);
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.PRIMARY_KEY_USER_ID).eq(userId));
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.PRIMARY_KEY_LESSON_ID).eq(lessonId));
		List<FavouriteLessons> favouriteLesson=null;
	
			try {
				favouriteLesson = FavouriteLessonsLocalServiceUtil.dynamicQuery(dynamicQuery);
				if(!favouriteLesson.isEmpty()){
					
					FavouriteLessonsLocalServiceUtil.deleteFavouriteLessons(favouriteLesson.get(0));
				}
			} catch (SystemException e) {
				LOG.error("[LessonsController: removeFromMyFavourite() ]"+e);
			}
	}
	
	@ResourceMapping(value="makeLessonInappropriate")
    public void makeLessonInappropriate(ResourceRequest resourceRequest, ResourceResponse resourceResponse){
		
		UploadPortletRequest uploadReq = PortalUtil.getUploadPortletRequest(resourceRequest);
		long lessonId=ParamUtil.getLong(resourceRequest,Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		long markedBy=PortalUtil.getUserId(resourceRequest);
		String markedContent=ParamUtil.getString(resourceRequest,Constant.MARKED_AS_CONTENT);
		String markedAs=ParamUtil.getString(resourceRequest,Constant.MARKED_AS);
		ThemeDisplay themeDisplay = (ThemeDisplay) uploadReq.getAttribute(WebKeys.THEME_DISPLAY);
		
		try {
			String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),themeDisplay.getLayout().isPrivateLayout(),themeDisplay);
			String lessonUrl=siteFriendlyUrl+StringPool.FORWARD_SLASH+Constant.BROWSE;
			ServiceContext serviceContext = ServiceContextFactory.getInstance(uploadReq);
			long fromUserId=PortalUtil.getUserId(resourceRequest);
			long companyId= themeDisplay.getCompanyId();
			Role role = RoleLocalServiceUtil.getRole(companyId,Constant.PORTAL_ADMIN_ROLE);
			List<User> nyuAdminUsers = UserLocalServiceUtil.getRoleUsers(role.getRoleId());
			Lesson lesson = LessonLocalServiceUtil.getLesson(lessonId);
			long lessonCreator=lesson.getCurrentAuthor();
			String lessonName = lesson.getLessonName();
			lesson.setMarkedBy(markedBy);
			lesson.setMarkedAs(markedAs);
			lesson.setMarkedContent(markedContent);
			String reason = lesson.getMarkedContent();
			LessonLocalServiceUtil.updateLesson(lesson);
			String message= Constant.CAPITAL_LESSON+StringPool.BLANK+Constant.BOLD_OPEN_STYLE_COLOR+"'"+lessonName+"'"+Constant.BOLD_TAG_CLOSE+StringPool.SPACE+ CommonUtil.JavaClassI18N(resourceRequest, themeDisplay, "has-been-reported-inappropriate-by")+StringPool.SPACE+Constant.BOLD_OPEN_STYLE_COLOR_ROYAL_BLUE+StringPool.SPACE + themeDisplay.getUser().getFirstName()+ StringPool.SPACE+themeDisplay.getUser().getLastName()+Constant.BOLD_TAG_CLOSE;
			String subject= CommonUtil.JavaClassI18N(resourceRequest, themeDisplay, "inappropriate-lesson");
			
			VelocityContext velocityContext = new VelocityContext();
			velocityContext.put(Constant.COMMON_DATE, CommonUtil.dateAsPerFormat(Constant.EEEE_MMM_D_YYYY));
			velocityContext.put(Constant.FROM, UserLocalServiceUtil.getUser(fromUserId).getFullName());
			velocityContext.put(Constant.TO,UserLocalServiceUtil.getUser(lessonCreator).getFullName());
			velocityContext.put(Constant.REQUEST_LESSON_SUBJECT_JSP,subject);
			velocityContext.put(Constant.LESSON_HYPER_LINK,generateLessonUrl(lesson.getLessonId(),resourceRequest));
			velocityContext.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,lessonName);
			velocityContext.put(Constant.REASON,reason);
			CommonUtil.emailNotification(fromUserId, lessonCreator, subject, message,Constant.LESSON_MADE_AS_INAPPROPRIATE_VM,velocityContext);
			for(User user : nyuAdminUsers){
				if(user.getUserId() != lessonCreator){
				velocityContext.put(Constant.TO,user.getFullName());
				CommonUtil.emailNotification(fromUserId, user.getUserId(), subject, message,Constant.LESSON_MADE_AS_INAPPROPRIATE_VM,velocityContext);
				}
			}
			
			JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, PortalUtil.getUserId(uploadReq));
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,UserLocalServiceUtil.getUser(PortalUtil.getUserId(uploadReq)).getFullName());
			payloadJSON.put(Constant.TYPE, Constant.IN_APPROPRIATE);
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lesson.getLessonId());
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,lesson.getLessonName());
			payloadJSON.put(Constant.LESSON_URL,lessonUrl);
			/************notification for the author of the lesson**************/
			UserNotificationEventLocalServiceUtil.addUserNotificationEvent(lessonCreator,
				com.nyu.notification.LessonNotificationHandler.PORTLET_ID,
				(new Date()).getTime(), fromUserId,
				payloadJSON.toString(), false,
				serviceContext);
			
			/************notification for user marked as inapproprate **************/
			for(User user : nyuAdminUsers){
				if(user.getUserId() != lessonCreator){
				UserNotificationEventLocalServiceUtil.addUserNotificationEvent(user.getUserId(),
						com.nyu.notification.LessonNotificationHandler.PORTLET_ID,
						(new Date()).getTime(), fromUserId,
						payloadJSON.toString(), false,
						serviceContext);
				}
			}
			
		} catch (PortalException e) {
			LOG.error(e);
		} catch (SystemException e) {
			LOG.error(e);
		}catch (AddressException e) {
			LOG.error(e);
		} catch (IOException e) {
			LOG.error(e);
		}
	}
	
	@ResourceMapping(value="markedAsLessonByAdmin")
    public void markedAsLessonByAdmin(ResourceRequest resourceRequest, ResourceResponse resourceResponse){
		
		long lessonId=ParamUtil.getLong(resourceRequest,Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		
		String markedAs=ParamUtil.getString(resourceRequest,Constant.MARKED_AS);
		long fromUserId=PortalUtil.getUserId(resourceRequest);
		ThemeDisplay themeDisplay = (ThemeDisplay) resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
	
		try {
			
			Role role = RoleLocalServiceUtil.getRole(themeDisplay.getCompanyId(),Constant.PORTAL_ADMIN_ROLE);
			List<User> nyuAdminUsers = UserLocalServiceUtil.getRoleUsers(role.getRoleId());
			
			String fromUserName=UserLocalServiceUtil.getUser(fromUserId).getFullName();
			Lesson lesson = LessonLocalServiceUtil.getLesson(lessonId);
			long markedAs_InAppropriateBy=lesson.getMarkedBy();
			
			lesson.setMarkedAs(markedAs);
			LessonLocalServiceUtil.updateLesson(lesson);
			String subject=StringPool.BLANK;
			String message=StringPool.BLANK;
			if(markedAs.equalsIgnoreCase(Constant.MARKEDAS_RELEASE)){
				subject = CommonUtil.JavaClassI18N(resourceRequest, themeDisplay, "lesson-has-been-released");
				message=Constant.BOLD_OPEN_STYLE_COLOR+fromUserName+Constant.BOLD_TAG_CLOSE+StringPool.SPACE + CommonUtil.JavaClassI18N(resourceRequest, themeDisplay, "has-released-the-lesson") +StringPool.SPACE +Constant.BOLD_OPEN_STYLE_COLOR_ROYAL_BLUE+lesson.getLessonName()+Constant.BOLD_TAG_CLOSE;
			}else if(markedAs.equalsIgnoreCase(Constant.MARKEDAS_QUARANTINE)){
				subject = CommonUtil.JavaClassI18N(resourceRequest, themeDisplay, "lesson-has-been-quarantined");
				message= Constant.BOLD_OPEN_STYLE_COLOR +fromUserName+Constant.BOLD_TAG_CLOSE+StringPool.SPACE + CommonUtil.JavaClassI18N(resourceRequest, themeDisplay, "has-quarantined-the-lesson")+StringPool.SPACE + Constant.BOLD_OPEN_STYLE_COLOR_ROYAL_BLUE+lesson.getLessonName()+Constant.BOLD_TAG_CLOSE;
			}
			
			/************notification and email for user marked as inapproprate **************/
			
			sendEmailNotification(markedAs_InAppropriateBy,markedAs,fromUserId,fromUserName,subject,message,lesson,resourceRequest);
			
			/************notification and email for the author of the lesson **************/
			sendEmailNotification(lesson.getCurrentAuthor(),markedAs,fromUserId,fromUserName,subject,message,lesson,resourceRequest);
			
			/************notification and email for the NYU ADMINS **************/
			for(User nyuAdmin:nyuAdminUsers){
				if(nyuAdmin.getUserId()!=fromUserId){
					sendEmailNotification(nyuAdmin.getUserId(),markedAs,fromUserId,fromUserName,subject,message,lesson,resourceRequest);
				}
			}
			
		} catch (PortalException e) {
			LOG.error(e);
		} catch (SystemException e) {
			LOG.error(e);
		}
	}
	
	@ResourceMapping(value=Constant.LESSON_DELETED_BY_USER)
    public void lessonDeletedByUser(ResourceRequest resourceRequest, ResourceResponse resourceResponse){
		long lessonId=ParamUtil.getLong(resourceRequest,Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		long markedBy=PortalUtil.getUserId(resourceRequest);
		try {
			Lesson lesson = LessonLocalServiceUtil.getLesson(lessonId);
			lesson.setMarkedBy(markedBy);
			lesson.setMarkedAs(Constant.LESSON_DELETED_BY_USER);
			LessonLocalServiceUtil.updateLesson(lesson);
		} catch (PortalException e) {
			LOG.error(e);
		} catch (SystemException e) {
			LOG.error(e);
		}
	}
	private void sendEmailNotification(long sendToUserId,String markedAs,long fromUserId,String fromUserName,String subject,String message,Lesson lesson,PortletRequest request){
		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
		try {
			ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
			JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, sendToUserId);
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,UserLocalServiceUtil.getUser(sendToUserId).getFullName());
			payloadJSON.put(Constant.TYPE,markedAs);
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,lesson.getLessonName());
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_ID,lesson.getLessonId());
			payloadJSON.put(Constant.ADDITIONAL_DATA,CommonUtil.JavaClassI18N(request, themeDisplay, "has")+ StringPool.SPACE+markedAs);
			
			UserNotificationEventLocalServiceUtil.addUserNotificationEvent(sendToUserId,
					com.nyu.notification.LessonNotificationHandler.PORTLET_ID,
					(new Date()).getTime(), fromUserId,
					payloadJSON.toString(), false,
					serviceContext);
			
			
			VelocityContext velocityContext = new VelocityContext();
			velocityContext.put(Constant.COMMON_DATE, CommonUtil.dateAsPerFormat(Constant.EEEE_MMM_D_YYYY));
			velocityContext.put(Constant.FROM, fromUserName);
			velocityContext.put(Constant.TO,UserLocalServiceUtil.getUser(sendToUserId).getFullName());
			velocityContext.put(Constant.REQUEST_LESSON_SUBJECT_JSP,subject);
			velocityContext.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,lesson.getLessonName());
			if(lesson.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR)){
				velocityContext.put(Constant.COMMON_STRING_CONSTANT_PRIVACY, CommonUtil.JavaClassI18N(request, themeDisplay, "x-community-any-alumnus-faculty-staff-or-student",Constant.CURRENT_BRAND_NAME));
			}else if(lesson.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE) || lesson.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_USER)){
				velocityContext.put(Constant.COMMON_STRING_CONSTANT_PRIVACY, CommonUtil.JavaClassI18N(request, themeDisplay, "private-list-via-group-or-by-invitation-only"));
			}else{
				velocityContext.put(Constant.COMMON_STRING_CONSTANT_PRIVACY, CommonUtil.JavaClassI18N(request, themeDisplay, "general-public-via-social-media-etc"));
			}
			
			if(markedAs.equalsIgnoreCase(Constant.MARKEDAS_RELEASE)){
				velocityContext.put(Constant.LESSON_HYPER_LINK,generateLessonUrl(lesson.getLessonId(),request));	
				CommonUtil.emailNotification(fromUserId, sendToUserId, subject, message, Constant.RELEASE_LESSON_VM,velocityContext);
			}else if(markedAs.equalsIgnoreCase(Constant.MARKEDAS_QUARANTINE)){
				
				CommonUtil.emailNotification(fromUserId, sendToUserId, subject, message,Constant.QURANTINE_LESSON_VM,velocityContext);
			}
			
		} catch (PortalException e) {
			LOG.error(e);
		} catch (SystemException e) {
			LOG.error(e);
		} catch (AddressException e) {
			LOG.error(e);
		} catch (IOException e) {
			LOG.error(e);
		}
		
	}
	private String generateLessonUrl(long lessonId,PortletRequest request){
		try {
			ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
			String portletId = Constant.PORTLET_LESSON;
			long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true, Constant.PAGE_LESSON_BROWSE).getPlid();		
			PortletURL showDocumentURL=PortletURLFactoryUtil.create(request, portletId, targetPlId, PortletRequest.RENDER_PHASE);
			showDocumentURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);	
			showDocumentURL.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID,lessonId+StringPool.BLANK);
			return showDocumentURL.toString();
		} catch (PortalException e) {
			LOG.error("[NyuLessonsController: generateLessonUrl() ]"+e);
		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: generateLessonUrl() ]"+e);
		} 
		return StringPool.POUND;
	}
}