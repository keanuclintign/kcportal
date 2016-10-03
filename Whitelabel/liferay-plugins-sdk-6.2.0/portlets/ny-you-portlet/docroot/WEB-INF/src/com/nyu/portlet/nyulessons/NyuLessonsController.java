package com.nyu.portlet.nyulessons;

import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.awt.image.RenderedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.CopyOnWriteArrayList;

import javax.imageio.ImageIO;
import javax.mail.internet.AddressException;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.MimeResponse;
import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.ServletException;

import org.apache.velocity.VelocityContext;
import org.sakaiproject.esb.client.impl.ServiceRegistryImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.portal.ImageTypeException;
import com.liferay.portal.NoSuchRepositoryException;
import com.liferay.portal.kernel.dao.orm.Criterion;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.OrderFactoryUtil;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.image.ImageBag;
import com.liferay.portal.kernel.image.ImageToolUtil;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.messaging.Message;
import com.liferay.portal.kernel.messaging.MessageBusUtil;
import com.liferay.portal.kernel.repository.model.FileEntry;
import com.liferay.portal.kernel.upload.UploadException;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.Base64;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.MimeTypesUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StreamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.TempFileUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.User;
import com.liferay.portal.model.UserNotificationEvent;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.LayoutLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.service.UserNotificationEventLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.liferay.portlet.asset.model.AssetTag;
import com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetTagLocalServiceUtil;
import com.liferay.portlet.documentlibrary.NoSuchFileEntryException;
import com.liferay.portlet.messageboards.model.MBMessage;
import com.liferay.portlet.messageboards.service.MBMessageLocalServiceUtil;
import com.nyu.NoSuchDocumentFileException;
import com.nyu.model.AnswerRequest;
import com.nyu.model.DocumentFile;
import com.nyu.model.DocumentSection;
import com.nyu.model.Lesson;
import com.nyu.model.LessonCollaboration;
import com.nyu.model.LessonObjectives;
import com.nyu.model.RequestLesson;
import com.nyu.model.impl.AnswerRequestImpl;
import com.nyu.model.impl.DocumentFileImpl;
import com.nyu.model.impl.DocumentSectionImpl;
import com.nyu.model.impl.LessonCollaborationImpl;
import com.nyu.model.impl.LessonImpl;
import com.nyu.model.impl.LessonObjectivesImpl;
import com.nyu.portlet.vo.DocumentVO;
import com.nyu.service.AnswerRequestLocalServiceUtil;
import com.nyu.service.DocumentFileLocalServiceUtil;
import com.nyu.service.DocumentSectionLocalServiceUtil;
import com.nyu.service.LessonCollaborationLocalServiceUtil;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.LessonObjectivesLocalServiceUtil;
import com.nyu.service.RequestLessonLocalServiceUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;
import com.nyu.util.NyuUtil;
import com.nyu.util.StringUtils;

@Controller
@RequestMapping(value = "VIEW")
public class NyuLessonsController {
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(NyuLessonsController.class);
	
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
		long userGroupId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);

		if(Validator.isNotNull(userGroupId)){
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,userGroupId);
		}
		
		if(Validator.isNotNull(ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID))){
			long lessonId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID);
			try {
				LessonLocalServiceUtil.deleteLesson(lessonId);
				LessonLocalServiceUtil.deleteObjectivesOfLesson(lessonId);
			} catch (PortalException e) {
				LOG.error("[NyuLessonsController: load() ]"+e);
			}
		}
		
		if(request.getParameter(Constant.COLLABORATION_REQUEST_ID)!=null){
			request.setAttribute(Constant.COLLABORATION_REQUEST_ID, Long.parseLong(request.getParameter(Constant.COLLABORATION_REQUEST_ID)));
		}
		
		request.removeAttribute(Constant.BASIC_LESSON);
		
		return Constant.CHOOSE_LESSON_TYPE;    
	}
	
	@RenderMapping(params = "action=createAdvanceLesson")
	public String createAdvanceLesson(RenderRequest request,RenderResponse response) { 
		
		String publishWithProfile=ParamUtil.getString(request,Constant.PUBLISH_WITH_PROFILE);
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long userGroupId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
		if(userGroupId>0l){
			
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,userGroupId);
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_PUBLISHED_PROFILE,publishWithProfile);
		}
		
		Lesson lesson = null;
		List<LessonObjectives> lessonObjectives = null;
		
		List<RequestLesson> requestedLessons;
		try {
			request.getPortletSession().removeAttribute(Constant.RESOURCE_ID_ARRAY);
			requestedLessons = RequestLessonLocalServiceUtil.getRequestLessons(themeDisplay.getCompanyId());
			List<RequestLesson> reverseReqLes=new CopyOnWriteArrayList<RequestLesson>(requestedLessons);
			Collections.reverse(reverseReqLes);
			request.setAttribute(Constant.REQUEST_LESSONS, reverseReqLes);
			if(GetterUtil.getString(request.getParameter(Constant.BASIC_LESSON),Constant.NO_BASIC_LESSON).equals(Constant.BASIC_LESSON)){
				request.setAttribute(Constant.BASIC_LESSON, Constant.BASIC_LESSON);
			}
			
		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: createAdvanceLesson() ]"+e);
		}
			
		if(request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID)!=null){
			
			long lessonId = Long.parseLong(request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID).toString());
			
	        try {
	        		lesson = LessonLocalServiceUtil.getLesson(lessonId);
	        	    request.setAttribute(Constant.LESSON, lesson );
	        	    request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lesson.getLessonId() );
	        	    request.setAttribute(Constant.FROM_PREVIEW_EDIT,ParamUtil.getString(request,Constant.FROM_PREVIEW_EDIT));
	        	    lessonObjectives = LessonObjectivesLocalServiceUtil.getLessonObjectivesList(lessonId);
	        	    request.setAttribute(Constant.LESSON_OBJECTIVES, lessonObjectives );
	        	    request.setAttribute(Constant.CATEGORY_IDS, CommonUtil.getCategoryIdsAsString(lessonId,Lesson.class.getName()));
	        	    request.setAttribute(Constant.TAG_NAMES, CommonUtil.getTagSelectedNamesAsString(lessonId,Lesson.class.getName()));
		        } catch (NumberFormatException e) {
		        	LOG.error("[NyuLessonsController: createAdvanceLesson() ]"+e);
		        } catch (SystemException e) {
		        	LOG.error("[NyuLessonsController: createAdvanceLesson() ]"+e);
		        } catch (Exception e){
		        	LOG.error("[NyuLessonsController: createAdvanceLesson() ]"+e);
		        }
		}
		
		if(request.getParameter(Constant.COLLABORATION_REQUEST_ID)!=null){
			request.setAttribute(Constant.COLLABORATION_REQUEST_ID, request.getParameter(Constant.COLLABORATION_REQUEST_ID));
		}
		
		try{
			TempFileUtil.deleteTempFile(
                    themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
                    getTempImageFileName(request), getTempImageFolderName());
			}catch(Exception e){
				LOG.error("[NyuLessonsController: createAdvanceLesson() ]"+e);
				
		}
		
		return Constant.CREATE_ADVANCE_LESSON;   
	}
	
	@ActionMapping(params = "action=createBasicLesson")
	public void createBasicLesson(ActionRequest actionRequest,ActionResponse actionResponse)throws PortalException, SystemException{
		if(actionRequest.getParameter(Constant.COLLABORATION_REQUEST_ID)!=null){
			actionResponse.setRenderParameter(Constant.COLLABORATION_REQUEST_ID, actionRequest.getParameter(Constant.COLLABORATION_REQUEST_ID));
		}
		
		actionResponse.setRenderParameter(Constant.BASIC_LESSON, Constant.BASIC_LESSON);
		actionResponse.setRenderParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.CREATE_ADVANCE_LESSON);
		String publishWithProfile=ParamUtil.getString(actionRequest,Constant.PUBLISH_WITH_PROFILE);
		long userGroupId=ParamUtil.getLong(actionRequest,Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
		if(userGroupId>0l){
			actionResponse.setRenderParameter(Constant.PUBLISH_WITH_PROFILE, publishWithProfile);
			actionResponse.setRenderParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID, String.valueOf(userGroupId));
		}
	}
	
	@RenderMapping(params = "action=viewAdvanceLesson")
	public String viewAdvanceLesson(RenderRequest request,RenderResponse response) { 
		if(GetterUtil.getString(request.getParameter(Constant.BASIC_LESSON),Constant.NO_BASIC_LESSON).equals(Constant.BASIC_LESSON)){
			request.setAttribute(Constant.BASIC_LESSON, request.getParameter(Constant.BASIC_LESSON));
		}
		CommonUtil.getViewAdvanceLesson(request, response);
		CommonUtil.voilatingSection(request); 
 		
		LOG.info("[previewAdvanceLesson]:::::");
		return Constant.VIEWLESSON_VIEWLESSON;   
	}
	
	
	
	
	@RenderMapping(params = "action=advanceLessonContent")
	public String advanceLessonContent(RenderRequest request,RenderResponse response) {  
		
		try {
			ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
			ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
			long lessonId = ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_LESSON_ID);
			if(GetterUtil.getString(request.getParameter(Constant.BASIC_LESSON),Constant.NO_BASIC_LESSON).equals(Constant.BASIC_LESSON)){
				request.setAttribute(Constant.BASIC_LESSON, request.getParameter(Constant.BASIC_LESSON));
			}
			AssetEntryLocalServiceUtil.updateEntry(serviceContext.getUserId(), serviceContext.getScopeGroupId(), 
					Lesson.class.getName(), lessonId, serviceContext.getAssetCategoryIds(), serviceContext.getAssetTagNames());
			List<LessonObjectives> lessonObjectives = LessonObjectivesLocalServiceUtil.getLessonObjectivesList(lessonId);
			JSONObject AllJsonNyuLessonObjectives=JSONFactoryUtil.createJSONObject();
			String jsonNyuLessonObjectives =CommonUtil.getJSONNyuLessonObjectives(lessonObjectives, themeDisplay);
			AllJsonNyuLessonObjectives.put(Constant.JSON_VENDOR_LESSON_OBJECTIVES,jsonNyuLessonObjectives);
			request.setAttribute(Constant.JSON_VENDOR_LESSON_OBJECTIVES, AllJsonNyuLessonObjectives);
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lessonId);
			request.setAttribute(Constant.LESSON, LessonLocalServiceUtil.getLesson(lessonId));
			CommonUtil.getDocumentsForAddMedia(request);
		} catch (PortalException e) {
			LOG.error("[NyuLessonsController: advanceLessonContent() ]"+e);
			
		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: advanceLessonContent() ]"+e);
		}
		
		return Constant.ADVANCE_LESSON_CONTENT;   
	}
	
	@ActionMapping(params = "action=saveLessonDetails")
	public void saveLessonDetails(ActionRequest actionRequest,ActionResponse actionResponse)throws PortalException, SystemException, IOException{
		UploadPortletRequest request = PortalUtil.getUploadPortletRequest(actionRequest);
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
		String lessonMode = ParamUtil.getString(request, Constant.LESSON_MODE);
		String fromPreviewEdit = ParamUtil.getString(request,Constant.FROM_PREVIEW_EDIT);
		long lessonId = ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_LESSON_ID,0);
		Lesson lesson = null;
		if(lessonId > 0){
			lesson = LessonLocalServiceUtil.getLesson(lessonId);
		}else{
			lesson = new LessonImpl();
		}
		lesson.setLessonName(request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_NAME));
		lesson.setDescription(request.getParameter(Constant.COMMON_STRING_CONSTANT_DESCRIPTION));
		lesson.setStatus(Constant.LIFERAY_VENDOR_LESSON_STATUS_DRAFT);
		if(lessonId <= 0){
			lesson.setAuthor(themeDisplay.getUserId());
			lesson.setCurrentAuthor(themeDisplay.getUserId());
			lesson.setCreateBy(themeDisplay.getUserId());
			lesson.setUploadedById(themeDisplay.getUserId());
			lesson.setUploadedByName(themeDisplay.getUser().getFullName());
		}
		lesson.setCompanyId(themeDisplay.getCompanyId());
		lesson.setGroupId(themeDisplay.getScopeGroupId());
		lesson.setUploadedTime(new Date(System.currentTimeMillis()));
		
		lesson.setCreateDate(new Date(System.currentTimeMillis()));
		lesson.setUpdatedDate(new Date(System.currentTimeMillis()));
		
		//set to publish with userGoup
		long userGroupId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
		String publishedProfile=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_PUBLISHED_PROFILE);
		if(Validator.isNotNull(userGroupId) && userGroupId>0l){
			lesson.setPublishWithProfile(userGroupId);
			lesson.setPublishedProfile(publishedProfile);
		}
		
		String courseId = StringUtils.isEmpty(request.getParameter(Constant.COURSE_ID)) ?  
				Constant.PORTLET_PROP_REQUEST_COURSE_ID_PREP + lesson.getLessonId() : (String)request.getParameter(Constant.COURSE_ID);
		lesson.setCourseId(courseId);

		if(request.getParameter(Constant.REQUEST_LESSON_CHECK)!=null && request.getParameter(Constant.REQUEST_LESSON_CHECK).toString().equals(Constant.YES)){
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
			
		}else{
			lesson.setRequestLessonId(0l);
		}
		
		
		if(request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID)==null){
			lesson = LessonLocalServiceUtil.addLesson(lesson);
		}else{
			lesson.setLessonId(lessonId);
			LessonLocalServiceUtil.updateLesson(lesson);
		}
		try{
		processCroppedLessonImg(actionRequest, request, themeDisplay,
				serviceContext, lesson);
		}catch(Exception e){
			LOG.error("[NyuLessonsController: saveLessonDetails() ]"+e);
			
		}
		processLessonObjectivies(request, lessonMode ,fromPreviewEdit ,lesson);
		
		
		
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lesson.getLessonId());
				
		LOG.info("lessonMode :"+lessonMode);
		long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true, Constant.PAGE_CREATE_LESSON).getPlid();		
		PortletURL renderCreateLessonPage = PortletURLFactoryUtil.create(actionRequest, PortalUtil.getPortletId(actionRequest),targetPlId, PortletRequest.RENDER_PHASE);
		renderCreateLessonPage.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID, String.valueOf(lesson.getLessonId()));
		if(GetterUtil.getString(request.getParameter(Constant.BASIC_LESSON),Constant.NO_BASIC_LESSON).equals(Constant.BASIC_LESSON)){
			renderCreateLessonPage.setParameter(Constant.BASIC_LESSON, request.getParameter(Constant.BASIC_LESSON));
		}
		if(fromPreviewEdit.equalsIgnoreCase(Constant.YES)){
			renderCreateLessonPage.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_STRING_CONSTANT_EDIT_LESSON);
			renderCreateLessonPage.setParameter(Constant.FROM_PREVIEW_EDIT, Constant.YES);
		}else if(lessonMode.equals(Constant.EDIT)){
			renderCreateLessonPage.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_STRING_CONSTANT_EDIT_LESSON);
			renderCreateLessonPage.setParameter(Constant.DETAIL_SAVE_SUCCESS, Constant.PUBLISH_LISTENER_DESTINATION);
		}else{
			renderCreateLessonPage.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.ADVANCE_LESSON_CONTENT);
		}
		
		if(actionRequest.getParameter(Constant.COLLABORATION_REQUEST_ID)!=null){
			addCollaborationRequestLesson(actionRequest, lesson);
		}
		
		CommonUtil.addUpadteAssetEntry(request, serviceContext, lesson.getLessonId(), Lesson.class.getName());
		actionResponse.sendRedirect(renderCreateLessonPage.toString());
	}

	private void processCroppedLessonImg(ActionRequest actionRequest,UploadPortletRequest request, ThemeDisplay themeDisplay,ServiceContext serviceContext, Lesson lesson) throws PortalException, SystemException, IOException {
		
		FileEntry croppedImage = getTempImageFileEntry(actionRequest);
		if(Validator.isNotNull(croppedImage)){
			String contentType = croppedImage.getMimeType();
			long classNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
			String thumbnailName = lesson.getLessonId()+Constant.LESSON_THUMBNAIL;
			BufferedImage originalImage = ImageIO.read(croppedImage.getContentStream());
			int type = originalImage.getType() == 0? BufferedImage.TYPE_INT_ARGB : originalImage.getType();
			BufferedImage resizeImageJpg = CommonUtil.resizeImage(originalImage, type, 
													Constant.LESSON_THUMBNAIL_IMAGE_WIDTH, Constant.LESSON_THUMBNAIL_IMAGE_HEIGHT);
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			
			String extension = croppedImage.getMimeType();
			if(extension.contains(Constant.IMAGE)){
			    ImageIO.write(resizeImageJpg, extension.substring(extension.lastIndexOf(StringPool.FORWARD_SLASH) + 1), os);
			}else{
				ImageIO.write(resizeImageJpg, Constant.JPEG, os);
			}
			
			NyuUtil.saveLessonThumbnail(themeDisplay, serviceContext, lesson.getLessonId(),
					contentType, classNameId, thumbnailName, os, Constant.LESSONS_HYPHEN_THUMBNAIL, extension);
			try{
			TempFileUtil.deleteTempFile(
                    themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
                    getTempImageFileName(actionRequest), getTempImageFolderName());
			}catch(Exception e){
				LOG.error("[NyuLessonsController: processCroppedLessonImg() ]"+e);
				
			}
			
			
		}
	}
	private void addCollaborationRequestLesson(ActionRequest actionRequest, Lesson lesson){
		try {
			long requestId = ParamUtil.getLong(actionRequest, Constant.COLLABORATION_REQUEST_ID);
			RequestLesson requestLesson = RequestLessonLocalServiceUtil.getRequestLesson(requestId);
			LessonCollaboration lessonCollaboration = new LessonCollaborationImpl();
			lessonCollaboration.setLessonId(lesson.getLessonId());
			lessonCollaboration.setUserId(requestLesson.getCreatedBy());
			lessonCollaboration.setMemberStatus(Constant.LESSON_MEMBER_STATUS_ACCEPTED);
			lessonCollaboration.setType(Constant.LESSON_ACCESS_CAN_EDIT);
			
			lessonCollaboration = LessonCollaborationLocalServiceUtil.addLessonCollaboration(lessonCollaboration);
		
			AnswerRequest answerRequest=new AnswerRequestImpl();
		    answerRequest.setRequestLessonId(requestId);
		    answerRequest.setUserId(((ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY)).getUserId());
		    answerRequest.setDescription(lesson.getLessonName());
		    answerRequest.setCollaborationLessons(lesson.getLessonId());
		    answerRequest.setCreateDate(new Date());
		    answerRequest.setCollaborationId(lessonCollaboration.getId());
			AnswerRequestLocalServiceUtil.addAnswerRequest(answerRequest);
			
			actionRequest.removeAttribute(Constant.COLLABORATION_REQUEST_ID);

		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: addCollaborationRequestLesson() ]"+e);
		} catch (PortalException e) {
			LOG.error("[NyuLessonsController: addCollaborationRequestLesson() ]"+e);
		}
	}
	
	private void processLessonObjectivies(UploadPortletRequest request,String lessonMode, String fromPreviewEdit, Lesson lesson)
			throws PortalException, SystemException {
		boolean isOldLO;
		Integer objectiveCount=1;
		LessonObjectives lessonObjective =null;
		while(request.getParameter(Constant.OBJECTIVE+objectiveCount.toString()) != null){
			isOldLO = false;
			String objectiveName = ParamUtil.getString(request,Constant.OBJECTIVE+objectiveCount.toString(),StringPool.BLANK);
			long objectiveId = ParamUtil.getLong(request,Constant.OBJECTIVE_ID+objectiveCount,0);
			if((fromPreviewEdit.equalsIgnoreCase(Constant.YES) || lessonMode.equals(Constant.EDIT)) && objectiveId > 0){
				if(objectiveName.trim().equals(StringPool.BLANK)){
					LessonObjectivesLocalServiceUtil.deleteLessonObjectives(objectiveId);
					removeLessonObjectiveEntries(lesson.getLessonId(),objectiveId);
				}else{
					isOldLO = true;
					lessonObjective = LessonObjectivesLocalServiceUtil.getLessonObjectives(objectiveId);
				}
			}else{
				lessonObjective = new LessonObjectivesImpl();
			}
			if(!objectiveName.trim().equals(StringPool.BLANK)){
			lessonObjective.setLessonId(lesson.getLessonId());
			lessonObjective.setObjective(request.getParameter(Constant.OBJECTIVE+objectiveCount.toString()));
			lessonObjective.setModifiedDate(new Date(System.currentTimeMillis()));
				if(isOldLO){
					LessonObjectivesLocalServiceUtil.updateLessonObjectives(lessonObjective);
				}else{
					LessonObjectivesLocalServiceUtil.addLessonObjectives(lessonObjective);
				}
			}
			objectiveCount++;	
		}
		
	}
	
	
	
	@RenderMapping(params="action=uploadImage")
	public String uploadImage(RenderRequest request,RenderResponse response) throws PortalException, SystemException {
		return Constant.COMMON_LESSON_THUMBNAIL;  
	}
	
	
	
	private String getFileExtension(File file) {
		String name = file.getName();
	    try {
	        return name.substring(name.lastIndexOf(StringPool.PERIOD)+1);

	    } catch (Exception e) {
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
	
	@ResourceMapping(value="deleteImageURL")
    public void deleteLessonThumbnail(ResourceRequest request, ResourceResponse response) throws IOException  {
		String clearTempOnly = ParamUtil.getString(request,Constant.CLEAR_TEMP_ONLY,Constant.COMMON_NO);
		if(clearTempOnly.equals(Constant.COMMON_NO)){
			NyuUtil.deleteDLFileEntry(Lesson.class, ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID));
		}
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		try{
			TempFileUtil.deleteTempFile(
                    themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
                    getTempImageFileName(request), getTempImageFolderName());
		}catch(Exception e){
			LOG.error("[NyuLessonsController: deleteLessonThumbnail() ]"+e);
		}
		response.getWriter().write(themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER );
	}
	
	@ResourceMapping(value = "SaveLessonSections")
    public void SaveLessonSections(ResourceRequest request, ResourceResponse response) throws IOException, PortalException, SystemException {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		String lessonSectionTitle = ParamUtil.getString(request, Constant.SECTION_TITLE);
		String sectionNote = ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_LESSON_DESCRIPTION);
		String embedUrl = ParamUtil.getString(request, Constant.EMBED_URL);
		String resourceType = ParamUtil.getString(request,Constant.RESOURCE_TYPE);
		String addOrUpdateEvent = ParamUtil.getString(request, Constant.UPDATE ,Constant.ADD);
		String existingIds = ParamUtil.getString(request, Constant.EXISTING_IDS);
		String currentSecIds = ParamUtil.getString(request, Constant.CURRENT_SEC_IDS);
		long sectionId = ParamUtil.getLong(request, Constant.SECTION_ID);
		long lessonId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		long documentId= ParamUtil.getLong(request, Constant.DOCUMENT_ID,0l);
		int sectionLength= ParamUtil.getInteger(request, Constant.SECTION_LENGTH);
		int sectionIndex= ParamUtil.getInteger(request, Constant.SECTION_INDEX);
		String lessonObjectiveIds = ParamUtil.getString(request, Constant.LEARNING_OBJ_IDS);
		boolean isAutoSave = ParamUtil.getBoolean(request, Constant.AUTO_SAVE,false);
		if(isAutoSave && lessonSectionTitle.equalsIgnoreCase(Constant.COMMON_STRING_CONSTANT_FALSE)){
			lessonSectionTitle = Constant.DEFAULT_SEC_TITLE;
		}
		Lesson lesson = LessonLocalServiceUtil.getLesson(lessonId);
		lesson.setStatus(Constant.LIFERAY_VENDOR_LESSON_STATUS_DRAFT);
		LessonLocalServiceUtil.updateLesson(lesson);
		
		if(resourceType.equals(Constant.EMBED)){
			DocumentFile document= addEmbedDocumentEntry(themeDisplay, lessonId, embedUrl,addOrUpdateEvent,documentId);
			documentId=document.getDocumentId();
		}else if(resourceType.equals(Constant.COMMON_STRING_CONSTANT_RESOURCE_SPACE)){
			DocumentFile document= addResourceDocumentEntry(themeDisplay, lessonId, request,addOrUpdateEvent,documentId);
			documentId=document.getDocumentId();
		}else if(resourceType.equals(Constant.NARRATIVE)){
			if(sectionId > 0){
				documentId = 0l;
			}
		}
		addAndUpdateDocumentSection(documentId, lessonId, lessonSectionTitle,sectionNote, addOrUpdateEvent,sectionId, lessonObjectiveIds, request);
		
		if(addOrUpdateEvent.equals(Constant.EDIT) && sectionLength == sectionIndex){
			String updatedArray = updateRemovedSection(addOrUpdateEvent, existingIds, currentSecIds,
					sectionLength, sectionIndex,lessonId);
			response.getWriter().write(updatedArray);
		}
		LOG.info("[LessonSection]::::::[lessonId]::"+lessonId+"::[documentId]::"+documentId+"::[resourceType]::"+resourceType);
	}

	private String updateRemovedSection(String addOrUpdateEvent,
			String existingIds, String currentSecIds, int sectionLength,
			int sectionIndex,long lessonId) {
			List<Long> existingSecID =new ArrayList<Long>();
			List<Long> existingDocID =new ArrayList<Long>();
			List<Long> currentSecID =new ArrayList<Long>();
			List<Long> currentDocID =new ArrayList<Long>();
			JSONArray existingSection,currentSection;
			
			try {
				existingSection = JSONFactoryUtil.createJSONArray(existingIds);
				currentSection = JSONFactoryUtil.createJSONArray(currentSecIds);
				for (int i=0 ;i < existingSection.length(); i++){
					existingSecID.add(existingSection.getJSONObject(i).getLong(Constant.SECTION_ID));
					existingDocID.add(existingSection.getJSONObject(i).getLong(Constant.DOCUMENT_ID));
				}
				for (int i=0 ;i < currentSection.length(); i++){
					currentSecID.add(currentSection.getJSONObject(i).getLong(Constant.SECTION_ID));
					currentDocID.add(currentSection.getJSONObject(i).getLong(Constant.DOCUMENT_ID));
				}
				int index=0;
				for(Long ESecID :existingSecID){
					if((ESecID>0 && !currentSecID.contains(ESecID)) ||
							( existingDocID.get(index)>0 && !currentDocID.contains(existingDocID.get(index)) )){
						if(ESecID >0 ){
							long docId=DocumentSectionLocalServiceUtil.getDocumentSection(ESecID).getDocumentId();
							if(docId > 0){
								DocumentFileLocalServiceUtil.deleteDocumentFile(docId);
							}
							DocumentSectionLocalServiceUtil.deleteDocumentSection(ESecID);
						}else if(existingDocID.get(index) > 0){
							DocumentFileLocalServiceUtil.deleteDocumentFile(existingDocID.get(index));
						}
					}
					index++;
				}
			} catch (JSONException e) {
				LOG.error("[NyuLessonsController: updateRemovedSection() ]"+e);
			} catch (PortalException e) {
				LOG.error("[NyuLessonsController: updateRemovedSection() ]"+e);
			} catch (SystemException e) {
				LOG.error("[NyuLessonsController: updateRemovedSection() ]"+e);
			}
		return StringPool.BLANK;
	}
	
	
	private void addAndUpdateDocumentSection(long documentId,long lessonId,String sectionTitle,String sectionNote,String event,long sectionId,
			String lessonObjectiveIds, ResourceRequest request){
		DocumentSection documentSection=null;
		try {
		if(event.equals(Constant.EDIT) && sectionId >0 ){
			documentSection=DocumentSectionLocalServiceUtil.getDocumentSection(sectionId);
		}else{
			documentSection=new DocumentSectionImpl();
		}
		documentSection.setSectionTitle(sectionTitle);
		documentSection.setDocumentId(documentId);
		documentSection.setLessonId(lessonId);
		documentSection.setModifiedDate(new Date());
		documentSection.setSectionNote(sectionNote);
		documentSection.setLessonObjectiveIds(lessonObjectiveIds);
		documentSection.setOrder(Integer.parseInt(request.getParameter(Constant.SECTION_ORDER)));
		if(event.equals(Constant.EDIT) && sectionId >0 ){
			DocumentSectionLocalServiceUtil.updateDocumentSection(documentSection);
		}else{
			DocumentSectionLocalServiceUtil.addDocumentSection(documentSection);
		}	
		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: addAndUpdateDocumentSection() ]"+e);
		} catch (PortalException e) {
			LOG.error("[NyuLessonsController: addAndUpdateDocumentSection() ]"+e);
		}
	}
	
	private DocumentFile addEmbedDocumentEntry(ThemeDisplay themeDispaly,long lessonID,String embedUrl,String event,long documentId){
		DocumentFile document = null;
		try {
			if(documentId >0 && event.equalsIgnoreCase(Constant.EDIT)){
				document=DocumentFileLocalServiceUtil.getDocumentFile(documentId);
			}else{
				document = new DocumentFileImpl();
			}
			document.setCompanyId(themeDispaly.getCompanyId());
			document.setGroupId(themeDispaly.getScopeGroupId());
			document.setLessonId(lessonID);
			document.setDocumentName(StringPool.BLANK);
			document.setResourceId(0l);
			document.setDocUuid(StringPool.BLANK);
			document.setDownloadUrl(StringPool.BLANK);
			document.setDocumentPath(embedUrl);
			if(document.getDocumentPath().indexOf(Constant.YOUTUBE_COM)>-1 || document.getDocumentPath().indexOf(Constant.YOUTU_BE)>-1 ){
				document.setResourceType(Constant.COMMON_YOUTUBE);
				if(document.getDocumentPath().indexOf(Constant.YOUTU_BE)>-1){
					String yurl = embedUrl;
					yurl = yurl.substring(yurl.indexOf(StringPool.DOUBLE_SLASH+Constant.YOUTU_BE+StringPool.FORWARD_SLASH)+10);
					document.setDocumentPath(Constant.YOUTUBE_URL+yurl);
				}
				
			}else
				document.setResourceType(Constant.EMBED);
			document.setCreatedDate(new Date(System.currentTimeMillis()));
			
			
			if(documentId >0 && event.equalsIgnoreCase(Constant.EDIT)){
				document = DocumentFileLocalServiceUtil.updateDocumentFile(document);
			}else{
				document = DocumentFileLocalServiceUtil.addDocumentFile(document);
			}
		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: addEmbedDocumentEntry() ]"+e);
		} catch (PortalException e) {
			LOG.error("[NyuLessonsController: addEmbedDocumentEntry() ]"+e);
		}
		return document;
	}
	
	private DocumentFile addResourceDocumentEntry(ThemeDisplay themeDispaly,long lessonID, ResourceRequest request,String event,long documentId){
		DocumentFile document = new DocumentFileImpl();
		long resourceId = ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_RESOURCE_ID,0);
		String docUuid = ParamUtil.getString(request,Constant.DOC_UUID,null);
		String resourceTitle = ParamUtil.getString(request, Constant.DOC_TITLE,StringPool.BLANK);
		
		DocumentFile existingResource = null;
		try {
			//GET RESOURCE DETAIL FROM DB IF RESOURCEID AND UUID ALREADY AVAILABLE
			if(resourceId>0 && (docUuid != null && docUuid.trim() != "")){
				existingResource = DocumentFileLocalServiceUtil.findDocumentFileByUuidAndResourceId(docUuid, resourceId);
			}
			//GET DOCUMNET IF DOCUMNET ID GREATER THAN 0
			if(documentId > 0){
				try{
				document=DocumentFileLocalServiceUtil.getDocumentFile(documentId);
				}
				catch (NoSuchDocumentFileException e){
					//IF DOCUMNET DOES NOT EXIST
					document = new DocumentFileImpl();
				}
			}
			
			if(existingResource != null){
				document.setResourceId(existingResource.getResourceId());
				document.setDocumentPath(existingResource.getDocumentPath());
				document.setDocumentName(existingResource.getDocumentName());
				document.setDocUuid(existingResource.getDocUuid());
				document.setHasAutoTranscript(existingResource.getHasAutoTranscript());
				document.setStatus(existingResource.getStatus());
				document.setDownloadUrl(existingResource.getDownloadUrl());
			}else{
				document.setResourceId(resourceId);
				document.setDocumentPath(ParamUtil.getString(request, Constant.IMAGE_URL));
				document.setDocumentName(resourceTitle);
				document.setDocUuid(docUuid);
				document.setHasAutoTranscript(ParamUtil.getString(request, Constant.DOC_AUTO_TRANSCRIPT,StringPool.BLANK));
				document.setStatus(Constant.DOCUMENT_STATUS_ARCHIVE);
				document.setDownloadUrl(StringPool.BLANK);
				
				//IF NEW RESOURCE, FORCING RS TO GENERATE PREVIEW IF ENGAGE PREVIEW NOT ENABLED
				if(!Constant.ENABLE_OFFICE_PREVIEW_IN_ENGAGE){
					generatePreview(resourceId, resourceTitle);
				}
			}
			document.setCompanyId(themeDispaly.getCompanyId());
			document.setGroupId(themeDispaly.getScopeGroupId());
			document.setLessonId(lessonID);
			document.setResourceType(Constant.COMMON_STRING_CONSTANT_RESOURCE_SPACE);
			document.setCreatedDate(new Date(System.currentTimeMillis()));
			
			//UPDATE OR ADD DOCUMNET
			if(documentId >0 && event.equalsIgnoreCase(Constant.EDIT)){
				document = DocumentFileLocalServiceUtil.updateDocumentFile(document);
			}else{
				document = DocumentFileLocalServiceUtil.addDocumentFile(document);
			}

		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: addResourceDocumentEntry() ]"+e);
		} catch (PortalException e) {
			LOG.error("[NyuLessonsController: addResourceDocumentEntry() ]"+e);
		}
		return document;
	}
	
	@ResourceMapping(value = "publishLesson")
    public void publishLesson(ResourceRequest request, ResourceResponse response) throws IOException {
		Message message = new Message();
		ServiceContext serviceContext;
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		try {
			serviceContext = ServiceContextFactory.getInstance(request);
			String siteFriendlyUrl = PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),themeDisplay.getLayout().isPrivateLayout(),themeDisplay);
			String lessonUrl=siteFriendlyUrl+Constant.PAGE_LESSON_BROWSE;
			boolean isCreateLesson = true;
			if(!(themeDisplay.getLayout().getFriendlyURL().contains(Constant.PAGE_CREATE_LESSON))){
				isCreateLesson = false;
			}
			Map<String, Object> serviceContextMap = new HashMap<String, Object>();
			serviceContextMap.put(Constant.STRING_SERVICE_CONTEXT,serviceContext);
			
			JSONObject jsonObj = new JSONFactoryUtil().createJSONObject();
			jsonObj.put( Constant.COMMON_STRING_CONSTANT_LESSON_ID,Long.parseLong(request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID)));
			jsonObj.put( Constant.SHARE,ParamUtil.getString(request,Constant.SHARE));
			jsonObj.put( Constant.COMMON_STRING_CONSTANT_PERMISSION,ParamUtil.getString(request,"permission"));
			jsonObj.put( Constant.PRIVATE_TYPE,ParamUtil.getString(request,Constant.PRIVATE_TYPE));
			jsonObj.put( Constant.PRIVATE_VALUE,ParamUtil.getString(request,Constant.PRIVATE_VALUE));
			jsonObj.put(Constant.COMMON_STRING_CONSTANT_USER_ID,PortalUtil.getUserId(request));
			jsonObj.put(Constant.LESSON_URL, lessonUrl);
			jsonObj.put(Constant.IS_CREATE_LESSON, isCreateLesson);
			message.setValues(serviceContextMap);
			message.setPayload(jsonObj);
			MessageBusUtil.sendMessage(Constant.PUBLISH_LISTENER_DESTINATION, message);
			response.getWriter().write(CommonUtil.JavaClassI18N(request, themeDisplay, "small-case-success"));
		} catch (PortalException e) {
			LOG.error("[NyuLessonsController: publishLesson() ]"+e);
		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: publishLesson() ]"+e);
		}
				
	}

	
	@ResourceMapping(value="generateDocUUID")
	public void generateUUID(ResourceRequest request, ResourceResponse response) throws IOException {
		response.getWriter().write(UUID.randomUUID().toString());  
		
	}
	
	
	@RenderMapping(params = "action=editLesson")
	public String editLesson(RenderRequest request,RenderResponse response, @RequestParam(Constant.COMMON_STRING_CONSTANT_LESSON_ID) String lessonId ) {  
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		request.removeAttribute(Constant.EDIT_LESSON_SAVED);
		String fromPreviewEdit = ParamUtil.getString(request,Constant.FROM_PREVIEW_EDIT,StringPool.BLANK);
		List<LessonObjectives> lessonObjectives = null;
		List<RequestLesson> requestedLessons;
		long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
		String lessonImg = CommonUtil.getDocumentPath(GetterUtil.getLong(lessonId),lessonClassNameId,themeDisplay);
		if(GetterUtil.getString(request.getParameter(Constant.BASIC_LESSON),Constant.NO_BASIC_LESSON).equals(Constant.BASIC_LESSON)){
			request.setAttribute(Constant.BASIC_LESSON, request.getParameter(Constant.BASIC_LESSON));
		}
		if(Validator.isNull(lessonImg)){
			lessonImg =	themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER;
		}
		try {
			 ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
			 Lesson lesson = LessonLocalServiceUtil.getLesson(Long.parseLong((String)lessonId));
			 boolean hasEditRights = CommonUtil.hasEditRights(request, themeDisplay.getUserId(),lesson);
			 if(!hasEditRights){
				 return Constant.COMMON_DONT_HAVE_PERMISSION;
			 }
			 request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lessonId);
			 request.setAttribute(Constant.LESSON, lesson);
			 
			 if(fromPreviewEdit.equalsIgnoreCase(Constant.YES)){
				 request = (RenderRequest)CommonUtil.getDocumentListAndIdsAsArray(request, lesson);
			 }
			 request.setAttribute(Constant.LESSON_IMG,lessonImg);
			 
			 if(!fromPreviewEdit.equalsIgnoreCase(Constant.YES)){
				 	request.setAttribute(Constant.IS_EDIT_MODE,true);
				 	CommonUtil.getViewAdvanceLesson(request, response);
				 	requestedLessons = RequestLessonLocalServiceUtil.getRequestLessons(themeDisplay.getCompanyId());
					List<RequestLesson> reverseReqLes=new CopyOnWriteArrayList<RequestLesson>(requestedLessons);
					Collections.reverse(reverseReqLes);

					if(request.getParameter(Constant.OPEN_CONTENT_IN_EDIT)!=null && request.getParameter(Constant.OPEN_CONTENT_IN_EDIT).equals(Constant.YES)){
						request.setAttribute(Constant.EDIT_LESSON_SAVED, Constant.CONTENT_SAVED_SUCCESS);
					}
					
					request.setAttribute(Constant.REQUEST_LESSONS, reverseReqLes);
					request.setAttribute(Constant.OPEN_CONTENT_IN_EDIT,ParamUtil.getString(request, Constant.OPEN_CONTENT_IN_EDIT, StringPool.BLANK));
					getUserListToInvite(request, Long.parseLong((String)lessonId));
			 }
			request.setAttribute(Constant.CATEGORY_IDS, CommonUtil.getCategoryIdsAsString(GetterUtil.getLong(lessonId),Lesson.class.getName()));
			request.setAttribute(Constant.TAG_NAMES, CommonUtil.getTagSelectedNamesAsString(GetterUtil.getLong(lessonId),Lesson.class.getName()));
			lessonObjectives = LessonObjectivesLocalServiceUtil.getLessonObjectivesList(Long.parseLong((String)lessonId));
			request.setAttribute(Constant.LESSON_OBJECTIVES, lessonObjectives );
			JSONObject AllJsonNyuLessonObjectives=JSONFactoryUtil.createJSONObject();
			String jsonNyuLessonObjectives =CommonUtil.getJSONNyuLessonObjectives(lessonObjectives, themeDisplay);
			AllJsonNyuLessonObjectives.put(Constant.JSON_VENDOR_LESSON_OBJECTIVES,jsonNyuLessonObjectives);
			request.setAttribute(Constant.JSON_VENDOR_LESSON_OBJECTIVES, AllJsonNyuLessonObjectives);
			
			CommonUtil.getDocumentsForAddMedia(request);
			CommonUtil.voilatingSection(request);
			
			if(!fromPreviewEdit.equalsIgnoreCase(Constant.YES)){ 
				AssetEntryLocalServiceUtil.updateEntry(serviceContext.getUserId(), serviceContext.getScopeGroupId(), 
				Lesson.class.getName(), Long.parseLong((String)lessonId), serviceContext.getAssetCategoryIds(), serviceContext.getAssetTagNames());
    		}
		} catch (NumberFormatException e) {
			LOG.error("[NyuLessonsController: editLesson() ]"+e);
		} catch (PortalException e) {
			LOG.error("[NyuLessonsController: editLesson() ]"+e);
		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: editLesson() ]"+e);
		} catch (Exception e) {
			LOG.error("[NyuLessonsController: editLesson() ]"+e);
		}
		if(!fromPreviewEdit.equalsIgnoreCase(Constant.YES)){
			if(request.getParameter(Constant.DETAIL_SAVE_SUCCESS)!=null){
				request.setAttribute(Constant.EDIT_LESSON_SAVED, Constant.DETAIL_SAVED_SUCCESS);
			}
			return Constant.EDIT_ADVANCE_LESSON;   
		}else{
			return Constant.PREVIEW_EDIT;
		}
	}

	
	@ResourceMapping(value="cancelLessonURL")
	public void cancelLesson(ResourceRequest request, ResourceResponse response) {  
	}
	@ResourceMapping(value="saveAsDraft")
	public void saveAsDraft(ResourceRequest request, ResourceResponse response) {  
		long lessonId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID,0);
		 if(lessonId > 0){
			 Lesson lesson;
			try {
				lesson = LessonLocalServiceUtil.getLesson(lessonId);
				lesson.setStatus(Constant.LIFERAY_VENDOR_LESSON_STATUS_DRAFT);
				LessonLocalServiceUtil.updateLesson(lesson);
			} catch (PortalException e) {
				LOG.error("[NyuLessonsController: saveAsDraft() ]"+e);
			} catch (SystemException e) {
				LOG.error("[NyuLessonsController: saveAsDraft() ]"+e);
			}
			 
		 }
	}
	private void getUserListToInvite(PortletRequest request,long lessonId){
		
		try{
			ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
			JSONArray userListJsonArray=JSONFactoryUtil.createJSONArray();
			JSONArray userDropDownArray=JSONFactoryUtil.createJSONArray();
			JSONArray userCommentsArray=JSONFactoryUtil.createJSONArray();
			Lesson lesson=LessonLocalServiceUtil.getLesson(lessonId);
			List<LessonCollaboration> lessonCollaborations = LessonCollaborationLocalServiceUtil.getLessonUsers(lessonId,Constant.LESSON_MEMBER_STATUS_ACCEPTED);
			List<Long> existUserIds = new ArrayList<Long>();
			List<User> existingUsers = new ArrayList<User>();
			long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
			String threadIdStr=lessonId+StringPool.BLANK+lessonClassNameId+StringPool.BLANK+lessonId;
			
			DynamicQuery lessonEditDiscussionQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
			lessonEditDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(lessonId));
			lessonEditDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(lessonClassNameId));
			lessonEditDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.THREAD_ID).eq(GetterUtil.getLong(threadIdStr)));
			lessonEditDiscussionQuery.addOrder(OrderFactoryUtil.desc(Constant.COMMON_STRING_CONSTANT_CREATE_DATE));
			List<MBMessage> lessonEditDiscussion = MBMessageLocalServiceUtil.dynamicQuery(lessonEditDiscussionQuery);
			
			for(LessonCollaboration lessonCollab:lessonCollaborations){
				existUserIds.add(lessonCollab.getUserId());	
				existUserIds.add(lesson.getCurrentAuthor());	
				existingUsers.add(UserLocalServiceUtil.getUser(lessonCollab.getUserId()));
				JSONObject jsonUserObject=JSONFactoryUtil.createJSONObject();
				jsonUserObject.put(Constant.DROP_DOWN_ID,Constant.DD_HYPHEN+lessonCollab.getUserId());
				jsonUserObject.put(Constant.DROP_DOWN_VALUE,lessonCollab.getType()); 
				userDropDownArray.put(jsonUserObject);
			}
			
			for(MBMessage comments:lessonEditDiscussion){
				User commentUser=UserLocalServiceUtil.getUser(comments.getUserId());
				JSONObject jsonCommentsObject=JSONFactoryUtil.createJSONObject();
				jsonCommentsObject.put(Constant.USER_IMG,commentUser.getPortraitURL(themeDisplay));
				jsonCommentsObject.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,commentUser.getFullName()); 
				jsonCommentsObject.put(Constant.COMMENT,comments.getBody()); 
				userCommentsArray.put(jsonCommentsObject);
			}
			 
			List<User> allUser = UserLocalServiceUtil.getUsers(-1,-1);
			  for(User user:allUser){
				 
				 if(!existUserIds.contains(user.getUserId())){
					 JSONObject jsonUserObject=JSONFactoryUtil.createJSONObject();
					 jsonUserObject.put(Constant.COMMON_STRING_CONSTANT_USER_ID,user.getUserId());
					 jsonUserObject.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,user.getFullName()); 
					 userListJsonArray.put(jsonUserObject);
				 }
			 }
			User lessonAdmin = UserLocalServiceUtil.getUser(lesson.getCurrentAuthor());  
			request.setAttribute(Constant.LESSON_ADMIN,lessonAdmin.getUserId());
			request.setAttribute(Constant.LESSON_ADMIN_NAME,PortalUtil.getUserId(request)==lesson.getCurrentAuthor()?Constant.YOU:lessonAdmin.getFullName());
			request.setAttribute(Constant.LESSON_ADMIN_EMAIL,lessonAdmin.getEmailAddress());
			request.setAttribute(Constant.MEMBER, existingUsers);
			request.setAttribute(Constant.USER_LIST_JSON, userListJsonArray.toString());
			request.setAttribute(Constant.USER_DROP_DOWN_ARRAY, userDropDownArray.toString());
			request.setAttribute(Constant.USER_COMMENTS_ARRAY, userCommentsArray.toString());
		}catch(Exception e){
			LOG.error("[NyuLessonsController: getUserListToInvite() ]"+e);
		}
	}
	
	@ResourceMapping(value="sendInvitation")
	public void sendInviataion(ResourceRequest request, ResourceResponse response) throws PortalException, SystemException, AddressException, IOException{
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long userId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_ID);
		long lessonId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		long invitationSender=themeDisplay.getUserId();
		String userName=StringPool.BLANK;
		
		try {
		 	ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
			userName=UserLocalServiceUtil.getUser(invitationSender).getFullName();
			Lesson lesson=LessonLocalServiceUtil.getLesson(lessonId);
			LessonCollaboration lessonCollaboration=null;
			
			if(LessonCollaborationLocalServiceUtil.getUserExistence(lessonId, userId) != null){
				lessonCollaboration=LessonCollaborationLocalServiceUtil.getUserExistence(lessonId, userId);
				lessonCollaboration.setLessonId(lessonId);
				lessonCollaboration.setUserId(userId);
				lessonCollaboration.setMemberStatus(Constant.LESSON_MEMBER_STATUS_PENDING);
				lessonCollaboration.setType(Constant.LESSON_ACCESS_VIEWONLY);
				LessonCollaborationLocalServiceUtil.updateLessonCollaboration(lessonCollaboration);
			}else{	
				lessonCollaboration = new LessonCollaborationImpl();
				lessonCollaboration.setLessonId(lessonId);
				lessonCollaboration.setUserId(userId);
				lessonCollaboration.setMemberStatus(Constant.LESSON_MEMBER_STATUS_PENDING);
				lessonCollaboration.setType(Constant.LESSON_ACCESS_VIEWONLY);
				LessonCollaborationLocalServiceUtil.addLessonCollaboration(lessonCollaboration);
			}
			
			JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
						payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, invitationSender);
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
			payloadJSON.put(Constant.TYPE,Constant.INVITE_TO_JOIN_LESSON);
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,
					lesson.getLessonName());
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_ID,
					lesson.getLessonId());
			payloadJSON.put(Constant.ADDITIONAL_DATA,
			CommonUtil.JavaClassI18N(request, themeDisplay, "has-invited-you-to-manage-lesson"));
			UserNotificationEventLocalServiceUtil
					.addUserNotificationEvent(
							userId,
							com.nyu.notification.NyuLessonsNotificationHandler.PORTLET_ID,
							(new Date()).getTime(), invitationSender,
							payloadJSON.toString(), false,
							serviceContext);
			String subject = CommonUtil.JavaClassI18N(request, themeDisplay, "lesson-invitation");
			String message= Constant.BOLD_OPEN_STYLE_COLOR+userName+ CommonUtil.JavaClassI18N(request, themeDisplay, "has-invited-you-to-manage-lesson") +lesson.getLessonName()+Constant.BOLD_TAG_CLOSE;
			VelocityContext velocityContext = new VelocityContext();
			velocityContext.put(Constant.COMMON_DATE, CommonUtil.dateAsPerFormat(Constant.EEEE_MMM_D_YYYY));
			velocityContext.put(Constant.FROM, userName);
			velocityContext.put(Constant.TO,UserLocalServiceUtil.getUser(userId).getFullName());
			velocityContext.put(Constant.REQUEST_LESSON_SUBJECT_JSP,subject);
			velocityContext.put(Constant.LESSON_HYPER_LINK,generateLessonUrl(lessonId, request));
			velocityContext.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,lesson.getLessonName());
			
			CommonUtil.emailNotification(invitationSender, userId, subject, message,Constant.INVITE_USER_TO_LESSON_VM,velocityContext);
				
		} catch (PortalException e) {
			LOG.error("[NyuLessonsController: sendInviataion() ]"+e);
		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: sendInviataion() ]"+e);
		}
		
	}
	
	@ResourceMapping(value="acceptLessonInvitation")
	public void acceptLessonInvitation(ResourceRequest request,ResourceResponse response) throws IOException {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long lessonId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID);		
		long userNotificationEventId=ParamUtil.getLong(request, Constant.USER_NOTIFICATION_EVENT_ID);
		long senderUserId=themeDisplay.getUserId();
		String userName=StringPool.BLANK;
		ServiceContext serviceContext =null; 
		try{
			serviceContext = ServiceContextFactory.getInstance(request);
			userName=UserLocalServiceUtil.getUser(senderUserId).getFullName();
			Lesson lesson=LessonLocalServiceUtil.getLesson(lessonId);
			long userId=lesson.getCurrentAuthor();
			
			LessonCollaboration lessonCollaboration=null;
			if(LessonCollaborationLocalServiceUtil.getUserExistence(lessonId, senderUserId) != null){
				lessonCollaboration=LessonCollaborationLocalServiceUtil.getUserExistence(lessonId, senderUserId);
				lessonCollaboration.setLessonId(lessonId);
				lessonCollaboration.setUserId(senderUserId);
				lessonCollaboration.setMemberStatus(Constant.LESSON_MEMBER_STATUS_ACCEPTED);
				lessonCollaboration.setType(Constant.LESSON_ACCESS_CAN_EDIT);
				LessonCollaborationLocalServiceUtil.updateLessonCollaboration(lessonCollaboration);
			}else{	
				lessonCollaboration = new LessonCollaborationImpl();
				lessonCollaboration.setLessonId(lessonId);
				lessonCollaboration.setUserId(senderUserId);
				lessonCollaboration.setMemberStatus(Constant.LESSON_MEMBER_STATUS_ACCEPTED);
				lessonCollaboration.setType(Constant.LESSON_ACCESS_CAN_EDIT);
				LessonCollaborationLocalServiceUtil.addLessonCollaboration(lessonCollaboration);
			}
			
			if(userNotificationEventId>0){
				UserNotificationEvent userNotiEvent= UserNotificationEventLocalServiceUtil.getUserNotificationEvent(userNotificationEventId);
				userNotiEvent.setArchived(true);
				UserNotificationEventLocalServiceUtil.updateUserNotificationEvent(userNotiEvent);
			}
		
			JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, senderUserId);
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
			payloadJSON.put(Constant.TYPE, Constant.ACCEPT_TO_MANAGE_LESSON);
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,
					lesson.getLessonName());
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_ID,
					lesson.getLessonId());
			payloadJSON.put(Constant.ADDITIONAL_DATA,
					CommonUtil.JavaClassI18N(request, themeDisplay, "has-accepted-invitation-to-manage-lesson"));
			UserNotificationEventLocalServiceUtil
					.addUserNotificationEvent(
							userId,
							com.nyu.notification.NyuLessonsNotificationHandler.PORTLET_ID,
							(new Date()).getTime(), senderUserId,
							payloadJSON.toString(), false,
							serviceContext);
			String subject = CommonUtil.JavaClassI18N(request, themeDisplay, "lesson-invitation-accepted");
			String message=Constant.BOLD_OPEN_STYLE_COLOR+userName+ CommonUtil.JavaClassI18N(request, themeDisplay, "has-accepted-invitation-to-manage-lesson") +lesson.getLessonName()+Constant.BOLD_TAG_CLOSE;
			
			VelocityContext velocityContext = new VelocityContext();
			velocityContext.put(Constant.COMMON_DATE, CommonUtil.dateAsPerFormat(Constant.EEEE_MMM_D_YYYY));
			velocityContext.put(Constant.FROM, userName);
			velocityContext.put(Constant.TO,UserLocalServiceUtil.getUser(userId).getFullName());
			velocityContext.put(Constant.REQUEST_LESSON_SUBJECT_JSP,subject);
			velocityContext.put(Constant.LESSON_HYPER_LINK,generateLessonUrl(lessonId, request));
			velocityContext.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,lesson.getLessonName());
			
			CommonUtil.emailNotification(senderUserId, userId, subject, message,Constant.CONTENT_TEMPLATES_ACCEPT_INVITATION_TO_LESSON,velocityContext);
			
		}
		catch(Exception e){
			LOG.error("[NyuLessonsController: acceptLessonInvitation() ]"+e);
			
		}
	}
		
		@ResourceMapping(value="declineLessonInvitation")
		public void declineLessonInvitation(ResourceRequest request,ResourceResponse response) throws IOException {
			ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
			long lessonId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID);		
			long userNotificationEventId=ParamUtil.getLong(request, Constant.USER_NOTIFICATION_EVENT_ID);
			long senderUserId=themeDisplay.getUserId();
			String userName=StringPool.BLANK;
			ServiceContext serviceContext =null; 
			try{
				serviceContext = ServiceContextFactory.getInstance(request);
				userName=UserLocalServiceUtil.getUser(senderUserId).getFullName();
				Lesson lesson=LessonLocalServiceUtil.getLesson(lessonId);
				long userId=lesson.getCurrentAuthor();
				
				LessonCollaboration lessonCollaboration=null;
				if(LessonCollaborationLocalServiceUtil.getUserExistence(lessonId, senderUserId) != null){
					lessonCollaboration=LessonCollaborationLocalServiceUtil.getUserExistence(lessonId, senderUserId);
					lessonCollaboration.setLessonId(lessonId);
					lessonCollaboration.setUserId(senderUserId);
					lessonCollaboration.setMemberStatus(Constant.LESSON_MEMBER_STATUS_DECLINED);
					lessonCollaboration.setType(Constant.LESSON_ACCESS_VIEWONLY);
					LessonCollaborationLocalServiceUtil.updateLessonCollaboration(lessonCollaboration);
				}else{	
					lessonCollaboration = new LessonCollaborationImpl();
					lessonCollaboration.setLessonId(lessonId);
					lessonCollaboration.setUserId(senderUserId);
					lessonCollaboration.setMemberStatus(Constant.LESSON_MEMBER_STATUS_DECLINED);
					lessonCollaboration.setType(Constant.LESSON_ACCESS_VIEWONLY);
					LessonCollaborationLocalServiceUtil.addLessonCollaboration(lessonCollaboration);
				}
				
				if(userNotificationEventId>0){
					UserNotificationEvent userNotiEvent= UserNotificationEventLocalServiceUtil.getUserNotificationEvent(userNotificationEventId);
					userNotiEvent.setArchived(true);
					UserNotificationEventLocalServiceUtil.updateUserNotificationEvent(userNotiEvent);
				}
			
				JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
				payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, senderUserId);
				payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
				payloadJSON.put(Constant.TYPE,Constant.DECLINE_TO_MANAGE_LESSON);
				payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,
						lesson.getLessonName());
				payloadJSON.put(Constant.COMMON_STRING_CONSTANT_LESSON_ID,
						lesson.getLessonId());
				payloadJSON.put(Constant.ADDITIONAL_DATA,
						CommonUtil.JavaClassI18N(request, themeDisplay, "has-decline-invitation-to-manage-lesson"));
				UserNotificationEventLocalServiceUtil
						.addUserNotificationEvent(
								userId,
								com.nyu.notification.NyuLessonsNotificationHandler.PORTLET_ID,
								(new Date()).getTime(), senderUserId,
								payloadJSON.toString(), false,
								serviceContext); 
				String subject = CommonUtil.JavaClassI18N(request, themeDisplay, "lesson-invitation-declined");
				String message= Constant.BOLD_OPEN_STYLE_COLOR+userName+CommonUtil.JavaClassI18N(request, themeDisplay, "has-accepted-invitation-to-manage-lesson")+lesson.getLessonName()+Constant.BOLD_TAG_CLOSE;
				
				VelocityContext velocityContext = new VelocityContext();
				velocityContext.put(Constant.COMMON_DATE, CommonUtil.dateAsPerFormat(Constant.EEEE_MMM_D_YYYY));
				velocityContext.put(Constant.FROM, userName);
				velocityContext.put(Constant.TO,UserLocalServiceUtil.getUser(userId).getFullName());
				velocityContext.put(Constant.REQUEST_LESSON_SUBJECT_JSP,subject);
				velocityContext.put(Constant.LESSON_HYPER_LINK,generateLessonUrl(lessonId, request));
				velocityContext.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,lesson.getLessonName());
				
				CommonUtil.emailNotification(senderUserId, userId, subject, message,Constant.DECLINE_INVITATION_TO_LESSON_VM,velocityContext);
			}
			catch(Exception e){
				LOG.error("[NyuLessonsController: declineLessonInvitation() ]"+e);
				
			}
	}

		@ResourceMapping(value="removeUserLessonAccess")
	public void removeUserLessonAccess(ResourceRequest request,ResourceResponse response){
		long lessonId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		long userId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_USER_ID);
		LessonCollaboration lessonCollaboration=null;
		lessonCollaboration=LessonCollaborationLocalServiceUtil.getUserExistence(lessonId, userId);
		lessonCollaboration.setMemberStatus(Constant.LESSON_MEMBER_STATUS_REMOVED);
		lessonCollaboration.setType(Constant.LESSON_ACCESS_VIEWONLY);
		try {
			LessonCollaborationLocalServiceUtil.updateLessonCollaboration(lessonCollaboration);
		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: removeUserLessonAccess() ]"+e);
		}
	}
	
	
	@ResourceMapping(value="assignUserLessonAccess")
	public void assignUserLessonAccess(ResourceRequest request,ResourceResponse response){
		long lessonId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		long userId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_USER_ID);
		String type = ParamUtil.getString(request, Constant.TYPE);
		LessonCollaboration lessonCollaboration=null;
		lessonCollaboration=LessonCollaborationLocalServiceUtil.getUserExistence(lessonId, userId);
		lessonCollaboration.setType(type);
		try {
			LessonCollaborationLocalServiceUtil.updateLessonCollaboration(lessonCollaboration);
		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: assignUserLessonAccess() ]"+e);
		}
	}
	
	@ResourceMapping(value="addEditComment")
	public void addEditComment(ResourceRequest request,ResourceResponse response){
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long lessonId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		long userId = PortalUtil.getUserId(request);
		long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
		long messageId = 0l;
		String threadIdStr=lessonId+StringPool.BLANK+lessonClassNameId+StringPool.BLANK+lessonId;
		
		String comment = ParamUtil.getString(request,Constant.COMMENT);
		
		try {
		User user = UserLocalServiceUtil.getUser(userId);
		messageId = CounterLocalServiceUtil.increment();
		MBMessage mbMessage = MBMessageLocalServiceUtil.createMBMessage(messageId);
		mbMessage.setGroupId(themeDisplay.getScopeGroupId());
		mbMessage.setCompanyId(themeDisplay.getCompanyId());
		mbMessage.setUserId(userId);
		mbMessage.setCreateDate(new Date());
		mbMessage.setClassNameId(lessonClassNameId);
		mbMessage.setClassPK(lessonId);
		mbMessage.setUserName(themeDisplay.getUser().getFullName());
		mbMessage.setBody(comment);
		mbMessage.setThreadId(GetterUtil.getLong(threadIdStr));
		mbMessage=MBMessageLocalServiceUtil.addMBMessage(mbMessage);
		
		JSONObject jsonUserDetailObject=JSONFactoryUtil.createJSONObject();
		jsonUserDetailObject.put(Constant.USER_IMG,user.getPortraitURL(themeDisplay));
		jsonUserDetailObject.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,user.getFullName()); 
		
		response.getWriter().write(jsonUserDetailObject.toString());
		
		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: addEditComment() ]"+e);
		} catch (PortalException e) {
			LOG.error("[NyuLessonsController: addEditComment() ]"+e);
		} catch (IOException e) {
			LOG.error("[NyuLessonsController: addEditComment() ]"+e);
		}
	}
	
	@ResourceMapping(value="lessonPrivacy")
	public void lessonPrivacy(ResourceRequest request, ResourceResponse response) throws IOException {
	String message=StringPool.BLANK;
	long nolessonId=0l;
	ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
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
			LOG.error("[NyuLessonsController: lessonPrivacy() ]"+e);
			message= CommonUtil.JavaClassI18N(request, themeDisplay, "no-lesson-exists-with-lesson-id")+ "   ("+nolessonId+")";
			
		 }
		response.getWriter().write(message);  
		
	}
	
	private void removeLessonObjectiveEntries(long lessonId,long objectiveId){
		DynamicQuery docSecQuery = DynamicQueryFactoryUtil.forClass(DocumentSection.class);
		docSecQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_LESSON_ID).eq(lessonId));
		docSecQuery.addOrder(OrderFactoryUtil.asc(Constant.COMMON_ORDER));
		try {
			List<DocumentSection> documentSections = DocumentSectionLocalServiceUtil.dynamicQuery(docSecQuery);
			for(DocumentSection documentSection:documentSections){
				String objIds = documentSection.getLessonObjectiveIds();
				List<String> items = new ArrayList<String>();
				if(!objIds.isEmpty()){
					 items.addAll(Arrays.asList(objIds.split(StringPool.COMMA)));
				}
				if(items.contains(objectiveId+StringPool.BLANK)){
					items.size();
					items.remove(objectiveId+StringPool.BLANK);
					objIds =StringPool.BLANK;
					for(String id:items){
						if(objIds.isEmpty()){
							objIds=id;
						}else{
							objIds = objIds+StringPool.COMMA+id; 
						}
					}
				}
				documentSection.setLessonObjectiveIds(objIds);
				DocumentSectionLocalServiceUtil.updateDocumentSection(documentSection);
			}
		
		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: removeLessonObjectiveEntries() ]"+e);
		}
	}
	
	private void generatePreview(long resourceId, String title){
		String getExt = title;
		getExt = getExt.substring(getExt.lastIndexOf(StringPool.PERIOD)+1);
		if(!(getExt.equalsIgnoreCase(Constant.MP_FOUR))){
			String previewGenerateUrl = Constant.PORTLET_PROP_RESOURCE_SPACE_PREVIEW_GENERATE_URL; 
			previewGenerateUrl = previewGenerateUrl+Constant.COMMON_KEY+Constant.PORTLET_PROP_RESOURCE_SPACE_PREVIEW_KEY;
			previewGenerateUrl = previewGenerateUrl+Constant.AMPERSAND_CALLBACK_RECEIVER_REF_ID+resourceId+Constant.AMPERSAND_PREFIX+getExt;
			Message message = new Message();
			JSONObject jsonObj = new JSONFactoryUtil().createJSONObject();
			jsonObj.put( Constant.TYPE,Constant.GENERATE_PREVIEW);
			jsonObj.put(Constant.GENERATE_PREVIEW_URL, previewGenerateUrl);
			message.setPayload(jsonObj);
			MessageBusUtil.sendMessage(Constant.PUBLISH_LISTENER_DESTINATION, message);
		}
	}
	
	public static String generateLessonUrl(long lessonId,PortletRequest request){
		
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

	@ResourceMapping(value="addAssetTag")
	public void addAssetTag(ResourceRequest request, ResourceResponse response) throws IOException {
		AssetTag assetTag =null;
		try {
			String[] props = {};
			String tagName = ParamUtil.getString(request, Constant.TAG_NAME);
			ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
			assetTag = AssetTagLocalServiceUtil.addTag(serviceContext.getUserId(),tagName, props, serviceContext);
		} catch (PortalException e) {
			LOG.error("[NyuLessonsController: addAssetTag() ]"+e);
		} catch (SystemException e) {
			LOG.error("[NyuLessonsController: addAssetTag() ]"+e);
		}
		response.getWriter().write(assetTag != null ?assetTag.getTagId()+StringPool.BLANK:StringPool.BLANK);  
	}
	
	
	
	@ResourceMapping(value = "getTempPic")
	public void getTempPic(ResourceRequest request, ResourceResponse response)
			throws SystemException, PortalException, IOException,
			ServletException {
		try {
			addTempImageFile(request);
			FileEntry tempFileEntry = getTempImageFileEntry(request);
			serveTempImageFile(response, tempFileEntry.getContentStream());
		} catch (NoSuchFileEntryException nsfee) {
			LOG.error("[NyuLessonsController: addAssetTag() ]"+nsfee.getMessage());
		} catch (Exception e) {
			LOG.error("[NyuLessonsController: addAssetTag() ]"+e.getMessage());
		}
	}
	
	
	 protected void addTempImageFile(PortletRequest portletRequest)
	                     throws Exception {
                 UploadPortletRequest uploadPortletRequest =
                         PortalUtil.getUploadPortletRequest(portletRequest);
 
                 ThemeDisplay themeDisplay = (ThemeDisplay)portletRequest.getAttribute(
                         WebKeys.THEME_DISPLAY);
 
                 String contentType = uploadPortletRequest.getContentType(Constant.USER_PROFILE_FILE_UPLOAD);
 
                 if (!MimeTypesUtil.isWebImage(contentType)) {
                         throw new ImageTypeException();
                 }
 
                 try {
                         TempFileUtil.deleteTempFile(
                                 themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
                                 getTempImageFileName(portletRequest), getTempImageFolderName());
                 }
                 catch (Exception e) {
                	 LOG.error("[NyuLessonsController: addTempImageFile() ]"+e);
                     }
     
                     InputStream inputStream = uploadPortletRequest.getFileAsStream(Constant.USER_PROFILE_FILE_UPLOAD);
                   
                     try {
                    	             			
                    	BufferedImage originalImage = ImageIO.read(inputStream);
                    	String ext = getFileExtension(uploadPortletRequest.getFile(Constant.USER_PROFILE_FILE_UPLOAD));
                    	int heightCalculatedPercentage = originalImage.getHeight(); 
		            	int widthCalculatedPercentage =	originalImage.getWidth();
			            if(originalImage.getHeight() > Constant.MAX_USER_IMG_FILE_HEIGTH_SIZE){
			            	while(heightCalculatedPercentage >= Constant.MAX_USER_IMG_FILE_HEIGTH_SIZE){
			            		heightCalculatedPercentage = heightCalculatedPercentage - ((originalImage.getHeight()*1)/100);
			            		widthCalculatedPercentage = widthCalculatedPercentage - ((originalImage.getWidth()*1)/100);
			            	}
			            }
			            if(widthCalculatedPercentage > Constant.MAX_USER_IMG_FILE_WIDTH_SIZE){
			            	while(widthCalculatedPercentage >= Constant.MAX_USER_IMG_FILE_WIDTH_SIZE){
			            		heightCalculatedPercentage = heightCalculatedPercentage - ((originalImage.getHeight()*1)/100);
			            		widthCalculatedPercentage = widthCalculatedPercentage - ((originalImage.getWidth()*1)/100);
			            	}
			            }
			            int imageHeight = heightCalculatedPercentage;
			            int imageWidth = widthCalculatedPercentage;
			            int type = originalImage.getType() == 0? BufferedImage.TYPE_INT_ARGB : originalImage.getType();
             			BufferedImage resizeImageJpg =CommonUtil.resizeImage(originalImage, type,imageWidth, imageHeight);
             			ByteArrayOutputStream os = new ByteArrayOutputStream();
             			ImageIO.write(resizeImageJpg,ext, os);
             			InputStream is = new ByteArrayInputStream(os.toByteArray());
             			FileEntry test =  TempFileUtil.addTempFile(
						             themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
						             	getTempImageFileName(portletRequest), getTempImageFolderName(),
						             	is, contentType);
 
                     }
                     catch(NullPointerException e){
                    	 LOG.error("[NyuLessonsController: addTempImageFile() ]"+e.getMessage());
         }
         finally {
                 StreamUtil.cleanUp(inputStream);
         }
	 }

	 
	 
	 
	protected FileEntry getTempImageFileEntry(PortletRequest portletRequest)
			throws PortalException, SystemException {
		ThemeDisplay themeDisplay = (ThemeDisplay) portletRequest
				.getAttribute(WebKeys.THEME_DISPLAY);
		return TempFileUtil.getTempFile(themeDisplay.getScopeGroupId(),
				themeDisplay.getUserId(), getTempImageFileName(portletRequest),
				getTempImageFolderName());
	}

	protected String getTempImageFileName(PortletRequest portletRequest) {
		ThemeDisplay themeDisplay = (ThemeDisplay) portletRequest
				.getAttribute(WebKeys.THEME_DISPLAY);
		return themeDisplay.getUserId()+Constant.LESSONS;
	}

	protected String getTempImageFolderName() {
		Class<?> clazz = getClass();
		return clazz.getName();
	}

	protected void serveTempImageFile(MimeResponse mimeResponse,
			InputStream tempImageStream) throws Exception {
		ImageBag imageBag = ImageToolUtil.read(tempImageStream);

		byte[] bytes = ImageToolUtil.getBytes(imageBag.getRenderedImage(),
				imageBag.getType());

		String contentType = MimeTypesUtil.getExtensionContentType(imageBag
				.getType());
		mimeResponse.setContentType(contentType);
		mimeResponse.getWriter().write(Base64.encode(bytes));
	}

	@ResourceMapping(value = "saveImage")
	public void saveImage(ResourceRequest request, ResourceResponse response)
			throws SystemException, PortalException, IOException,
			ServletException {
		FileEntry tempFileEntry = null;
		//ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		InputStream tempImageStream = null;

		try {
			tempFileEntry = getTempImageFileEntry(request);

			tempImageStream = tempFileEntry.getContentStream();

			ImageBag imageBag = ImageToolUtil.read(tempImageStream);

			RenderedImage renderedImage = imageBag.getRenderedImage();
			String cropRegionJSON = ParamUtil.getString(request,Constant.COMMON_CROP_REGION);
			if (Validator.isNotNull(cropRegionJSON)) {
				JSONObject jsonObject = JSONFactoryUtil
						.createJSONObject(cropRegionJSON);

				int height = jsonObject.getInt(Constant.HEIGHT);
				int width = jsonObject.getInt(Constant.WIDTH);
				int x = jsonObject.getInt(Constant.COMMON_X);
				int y = jsonObject.getInt(Constant.COMMON_Y);

				
				
				renderedImage = getCroppedRenderedImage(renderedImage, height,
						width, x, y);
			}

			byte[] bytes = ImageToolUtil.getBytes(renderedImage,
					imageBag.getType());

			saveTempImageFile(request,response,bytes);
		} catch (NoSuchFileEntryException nsfee) {
			throw new UploadException(nsfee);
		} catch (NoSuchRepositoryException nsre) {
			throw new UploadException(nsre);
		} catch (Exception e) {
			 LOG.error("[NyuLessonsController: addTempImageFile() ]"+e);
		} finally {
			StreamUtil.cleanUp(tempImageStream);
		}
	}

	protected RenderedImage getCroppedRenderedImage(
			RenderedImage renderedImage, int height, int width, int x, int y) {
		Rectangle rectangle = new Rectangle(width, height);

		Rectangle croppedRectangle = rectangle.intersection(new Rectangle(
				renderedImage.getWidth(), renderedImage.getHeight()));

		BufferedImage bufferedImage = ImageToolUtil
				.getBufferedImage(renderedImage);

		return bufferedImage.getSubimage(x, y, croppedRectangle.width,
				croppedRectangle.height);
	}
	
	

	protected void saveTempImageFile(PortletRequest portletRequest,ResourceResponse portletResponse, byte[] bytes)
			throws Exception {
		
		ThemeDisplay themeDisplay = (ThemeDisplay) portletRequest
				.getAttribute(WebKeys.THEME_DISPLAY);
		InputStream is = new ByteArrayInputStream(bytes);
		String contentType = StringPool.BLANK;
		try {
			contentType = getTempImageFileEntry(portletRequest).getMimeType();
            TempFileUtil.deleteTempFile(
                    themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
                    getTempImageFileName(portletRequest), getTempImageFolderName());
			}
	    catch (Exception e) {
	    	 LOG.error("[NyuLessonsController: saveTempImageFile() ]"+e);
	    }
		FileEntry tempfileEntry = TempFileUtil.addTempFile(
                themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
                getTempImageFileName(portletRequest), getTempImageFolderName(),is,contentType);
		serveTempImageFile(portletResponse, tempfileEntry.getContentStream());
		
	}
	
	
	@ResourceMapping(value="changePrimaryContributor")
    public void changePrimaryContributor(ResourceRequest resourceRequest, ResourceResponse resourceResponse){
		long lessonId=ParamUtil.getLong(resourceRequest,Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		long updatedPrimaryContriutor =ParamUtil.getLong(resourceRequest,Constant.UPDATE_PRIMARY_CONTRIUTOR);
		try {
			Lesson lesson = LessonLocalServiceUtil.getLesson(lessonId);
			long updatedCollaborator = lesson.getCurrentAuthor();
			LessonCollaboration lessonCollaboration=null;
			lessonCollaboration=LessonCollaborationLocalServiceUtil.getUserExistence(lessonId, updatedPrimaryContriutor);
			lessonCollaboration.setUserId(updatedCollaborator);
			LessonCollaborationLocalServiceUtil.updateLessonCollaboration(lessonCollaboration);
			lesson.setCurrentAuthor(updatedPrimaryContriutor);
			LessonLocalServiceUtil.updateLesson(lesson);
			} catch (PortalException e) {
			e.printStackTrace();
		} catch (SystemException e) {
			e.printStackTrace();
		}
		
	}
	
}