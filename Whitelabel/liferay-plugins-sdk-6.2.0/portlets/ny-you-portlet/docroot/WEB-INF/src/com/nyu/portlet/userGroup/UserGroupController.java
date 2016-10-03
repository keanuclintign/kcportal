package com.nyu.portlet.userGroup;

import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.awt.image.RenderedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import javax.imageio.ImageIO;
import javax.mail.internet.AddressException;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.MimeResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.portlet.WindowStateException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.velocity.VelocityContext;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.portal.DuplicateUserGroupException;
import com.liferay.portal.ImageTypeException;
import com.liferay.portal.NoSuchRepositoryException;
import com.liferay.portal.kernel.dao.orm.Criterion;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.image.ImageBag;
import com.liferay.portal.kernel.image.ImageToolUtil;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.portlet.LiferayWindowState;
import com.liferay.portal.kernel.repository.model.FileEntry;
import com.liferay.portal.kernel.upload.UploadException;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.Base64;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.JavaConstants;
import com.liferay.portal.kernel.util.MimeTypesUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StreamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.TempFileUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.LayoutSet;
import com.liferay.portal.model.User;
import com.liferay.portal.model.UserGroup;
import com.liferay.portal.model.UserNotificationEvent;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.LayoutLocalServiceUtil;
import com.liferay.portal.service.LayoutSetLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.service.UserGroupLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.service.UserNotificationEventLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.liferay.portlet.announcements.model.AnnouncementsEntry;
import com.liferay.portlet.announcements.model.AnnouncementsFlagConstants;
import com.liferay.portlet.announcements.service.AnnouncementsEntryLocalServiceUtil;
import com.liferay.portlet.announcements.service.AnnouncementsFlagLocalServiceUtil;
import com.liferay.portlet.asset.model.AssetCategory;
import com.liferay.portlet.asset.model.AssetEntry;
import com.liferay.portlet.asset.model.AssetTag;
import com.liferay.portlet.asset.model.AssetVocabulary;
import com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetTagLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil;
import com.liferay.portlet.asset.service.persistence.AssetEntryQuery;
import com.liferay.portlet.documentlibrary.NoSuchFileEntryException;
import com.liferay.portlet.messageboards.model.MBMessage;
import com.liferay.portlet.messageboards.service.MBMessageLocalServiceUtil;
import com.liferay.portlet.social.service.SocialActivityLocalServiceUtil;
import com.nyu.NoSuchNYUUserGroupException;
import com.nyu.model.AuditReport;
import com.nyu.model.Keywords;
import com.nyu.model.KeywordsCollaboration;
import com.nyu.model.Lesson;
import com.nyu.model.Lesson_Usergroups;
import com.nyu.model.NYUUserGroup;
import com.nyu.model.UserGroupRequest;
import com.nyu.model.impl.KeywordsCollaborationImpl;
import com.nyu.model.impl.Lesson_UsergroupsImpl;
import com.nyu.portlet.social.activities.NyuMemberActivityKeys;
import com.nyu.service.AuditReportLocalServiceUtil;
import com.nyu.service.KeywordsCollaborationLocalServiceUtil;
import com.nyu.service.KeywordsLocalServiceUtil;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.Lesson_UsergroupsLocalServiceUtil;
import com.nyu.service.NYUUserGroupLocalServiceUtil;
import com.nyu.service.UserGroupRequestLocalServiceUtil;
import com.nyu.util.AuditNyuUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;
import com.nyu.util.RenderHelper;
import com.nyu.util.UserGroupSortByTime;


@Controller
@RequestMapping(value = "VIEW")
public class UserGroupController {
	
private static Logger _log = Logger.getLogger(UserGroupController.class);
	
@RenderMapping
public String view(RenderRequest request,RenderResponse response) throws SystemException, PortalException {
	myGroups(request, response);
   return Constant.USER_GROUP_GROUPS_JSP;
}
@RenderMapping(params="action=uploadImage")
public String uploadImage(RenderRequest request,RenderResponse response) throws PortalException, SystemException {
	return Constant.USER_GROUP_GROUP_THUMBNAIL_JSP;
}
@RenderMapping(params="action=groupHome")
public String groupHome(RenderRequest request,RenderResponse response) throws SystemException, PortalException {
	myGroups(request, response);
	return Constant.USER_GROUP_GROUPS_JSP;
}

@RenderMapping(params = "action=showRequestPage")  
public String showRequestPage(RenderRequest request,RenderResponse response) {	
	UserGroup userGroup;
	try {
		userGroup = UserGroupLocalServiceUtil.getUserGroup(Long.parseLong(request.getParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID)));
		request.setAttribute(Constant.USER_GROUP,userGroup);
	} catch (NumberFormatException e) {
		e.printStackTrace();
	} catch (PortalException e) {
		e.printStackTrace();
	} catch (SystemException e) {
		e.printStackTrace();
	}
	
	return Constant.USER_GROUP_GROUP_ANNOUNCEMENT_FORM_JSP;
}

@RenderMapping(params="action=groupUrl")
public String groupPage(RenderRequest request,RenderResponse response) throws SystemException, Exception {
	ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
	long userGroupId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
	UserGroup userGroup=UserGroupLocalServiceUtil.getUserGroup(userGroupId);

	List<Lesson> lessons = LessonLocalServiceUtil.findGroupAliveLessons(userGroup.getUserGroupId());
	String jsonLessons =CommonUtil.getJSONLessons(lessons, themeDisplay);
	long userGroupClassNameId = ClassNameLocalServiceUtil.getClassNameId(UserGroup.class);
	DynamicQuery groupDiscussionQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
	groupDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(userGroupId));
	groupDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(userGroupClassNameId));
	groupDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.THREAD_ID).eq(userGroupId));
	groupDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.PARENT_MESSAGE_ID).eq(0l));
	
	List<MBMessage> groupDiscussionList = MBMessageLocalServiceUtil.dynamicQuery(groupDiscussionQuery);
	List<List<MBMessage>> groupSubDiscussionList=new ArrayList<List<MBMessage>>();
	for(MBMessage groupDiscussion:groupDiscussionList){
		DynamicQuery groupSubDiscussionQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
		groupSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(userGroupId));
		groupSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(userGroupClassNameId));
		groupSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.THREAD_ID).eq(userGroupId));
		groupSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.ROOT_MESSAGE_ID).eq(groupDiscussion.getRootMessageId()));
		List<MBMessage> lessonSubDiscussion = MBMessageLocalServiceUtil.dynamicQuery(groupSubDiscussionQuery);
		groupSubDiscussionList.add(lessonSubDiscussion);
	}
	//List<User> users=UserLocalServiceUtil.getUsers(-1, -1);
	JSONArray userGroupJsonArray=JSONFactoryUtil.createJSONArray();
	List<User> userList=UserLocalServiceUtil.getUserGroupUsers(userGroupId);
	List<Long> existUserIds=new ArrayList<Long>();
	
	for(User user:userList){
	existUserIds.add(user.getUserId());	
	}
		
	 List<User> allUser=UserLocalServiceUtil.getUsers(-1,-1);
	  for(User user:allUser){
		 
		 if(!existUserIds.contains(user.getUserId())){
			 JSONObject jsonUserObject=JSONFactoryUtil.createJSONObject();
			 jsonUserObject.put(Constant.COMMON_STRING_CONSTANT_USER_ID,user.getUserId());
			 jsonUserObject.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,user.getFullName()); 
			 userGroupJsonArray.put(jsonUserObject);
		 }
	 }
	 // _log.info(userGroupJsonArray);
	
	request.setAttribute(Constant.USER_GROUP_JSON, userGroupJsonArray.toString());
	request.setAttribute(Constant.GROUP_SUB_DISCUSSION_LIST, groupSubDiscussionList );
	request.setAttribute(Constant.USER_GROUP,userGroup);
	request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSONS,lessons);
	request.setAttribute(Constant.JSON_LESSONS,jsonLessons);
	request.setAttribute(Constant.CATEGORY_IDS, CommonUtil.getCategoryIdsAsString(userGroupId,UserGroup.class.getName()));
    request.setAttribute(Constant.TAG_NAMES, CommonUtil.getTagSelectedNamesAsString(userGroupId,UserGroup.class.getName()));
    return Constant.USER_GROUP_GROUP_DETAIL_JSP;
}

@RenderMapping(params ="action=createGroup")
public String createGroup(RenderRequest request,RenderResponse response)throws IOException, Exception {  
	 
	return Constant.USER_GROUP_CREATE_GROUP__JSP;
}

@RenderMapping(params ="action=renderGroup")
public String renderGroup(RenderRequest request,RenderResponse response)throws IOException, Exception {  
	
	return Constant.USER_GROUP_GROUPS_JSP;
}

@RenderMapping(params ="action=editGroup")
public String editGroup(RenderRequest request,RenderResponse response)throws IOException, Exception {  
	UserGroup userGroup = UserGroupLocalServiceUtil.getUserGroup(Long.parseLong(request.getParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID)));
	request.setAttribute(Constant.USER_CAPITAL_GROUP, userGroup);
	return Constant.USER_GROUP_EDIT_GROUP_JSP;
}

@ResourceMapping(value="addUpdateGroup")  
public void addUpdateGroup(ResourceRequest request, ResourceResponse response) throws IOException {  
	ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
	UploadPortletRequest uploadPortletRequest = PortalUtil.getUploadPortletRequest(request);
	long userId=themeDisplay.getUserId();
	long companyId=themeDisplay.getCompanyId();
	String isImageDeleted=ParamUtil.getString(uploadPortletRequest, Constant.IS_IMAGE_DELETED);
	//String isImageChanged=ParamUtil.getString(uploadPortletRequest, Constant.IS_IMAGE_CHANGED);
	String groupName=ParamUtil.getString(uploadPortletRequest, Constant.COMMON_STRING_CONSTANT_NAME);
	String groupDescription=ParamUtil.getString(uploadPortletRequest, Constant.GROUP_DESCRIPTION);
	String groupPrivacy=ParamUtil.getString(uploadPortletRequest, Constant.GROUP_PRIVACY);
	UserGroup userGroup = null;	
	NYUUserGroup userGroupReferences = null;
		
	//File file = uploadPortletRequest.getFile(Constant.GROUP_CAPITAL_LOGO);
	
	try {
		ServiceContext serviceContext = ServiceContextFactory.getInstance(uploadPortletRequest);
		
		List<Keywords> keywords = new ArrayList<Keywords>();
		keywords = KeywordsLocalServiceUtil.getKeywordses(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
		KeywordsCollaboration keywordsCollaboration;
		if(keywords!=null && keywords.size()>0){
			for(Keywords kword : keywords){
				if(groupName.toLowerCase().contains(kword.getKeyword().toLowerCase())){
					keywordsCollaboration = KeywordsCollaborationLocalServiceUtil.getKeyWordCollaborationStatus(kword.getPrimaryKey(),userId);
					if(keywordsCollaboration == null || (keywordsCollaboration != null && !keywordsCollaboration.getStatus().equals(Constant.KEYWORD_STATUS_ACCEPTED))){
						JSONObject keywordObj = JSONFactoryUtil.createJSONObject();
						keywordObj.put(Constant.KEYWORD_ID,kword.getPrimaryKey());
						keywordObj.put(Constant.KEYWORD_CAPITAL_NAME,kword.getKeyword());
						keywordObj.put(Constant.COMMON_STRING_CONSTANT_MESSAGE, CommonUtil.JavaClassI18N(request, themeDisplay, "group-name-contains-reserved-keyword-phrase")+StringPool.BLANK+kword.getKeyword()+Constant.QUOTE_DOT+CommonUtil.JavaClassI18N(request, themeDisplay, "please-enter-different-name"));
						response.getWriter().write(keywordObj.toString());
						return;//prevent further code from being executed
					}else{
						KeywordsLocalServiceUtil.deleteKeywords(kword);
					}
					break;
				}
			}
		}
		if(request.getParameter(Constant.GROUP_ACTION_TYPE)!=null && request.getParameter(Constant.GROUP_ACTION_TYPE).toString().equals(Constant.UPDATE_GROUP)){
			
			/** Update Group **/
			
			userGroup = UserGroupLocalServiceUtil.updateUserGroup(companyId, Long.parseLong(request.getParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID).toString()),
												groupName, groupDescription, serviceContext);
			String groupAbout=ParamUtil.getString(uploadPortletRequest, Constant.GROUP_ABOUT);
			//_log.info("groupAbout :"+groupAbout);
			processImage(request, userGroup);
			if(Validator.isNotNull(isImageDeleted) && isImageDeleted.equals(Constant.YES)){
				try{
				LayoutSet publicLS = LayoutSetLocalServiceUtil.getLayoutSet(userGroup.getGroupId(),false);
				LayoutSet privateLS = LayoutSetLocalServiceUtil.getLayoutSet(userGroup.getGroupId(),true);
				publicLS.setLogo(false);
				privateLS.setLogo(false);
				LayoutSetLocalServiceUtil.updateLayoutSet(privateLS);
				LayoutSetLocalServiceUtil.updateLayoutSet(publicLS);
				}catch(Exception e){
					
				}
			}
			userGroupReferences=NYUUserGroupLocalServiceUtil.getNYUUserGroup(userGroup.getUserGroupId());
			userGroupReferences.setAbout(groupAbout);
			userGroupReferences.setUpdatedBy(PortalUtil.getUserId(request));
			userGroupReferences.setUpdatedDate(new Date());
			NYUUserGroupLocalServiceUtil.updateNYUUserGroup(userGroupReferences);
			
			AuditReport auditReport=AuditNyuUtil.createReport(PortalUtil.getHttpServletRequest(request), CommonUtil.JavaClassI18N(request, themeDisplay, "update-group"),userGroup.getUserGroupId()+StringPool.BLANK,Constant.USER_GROUP_GROUPS_VAR, userGroup.getName());
			AuditReportLocalServiceUtil.addAuditReport(auditReport);
			String userGroupId = Long.toString(userGroup.getUserGroupId());
			response.getWriter().write(userGroupId);
			PortalUtil.getHttpServletResponse(response).getWriter().write(CommonUtil.JavaClassI18N(request, themeDisplay, "group-updated-successfully"));
			
		}else{
			/** Create Group **/
			userGroup = UserGroupLocalServiceUtil.addUserGroup(userId, companyId, groupName, groupDescription,serviceContext);
			UserGroupLocalServiceUtil.addUserUserGroup(themeDisplay.getUserId(),userGroup.getUserGroupId());
			AuditReport auditReport=AuditNyuUtil.createReport(PortalUtil.getHttpServletRequest(request), CommonUtil.JavaClassI18N(request, themeDisplay, "create-group"), userGroup.getUserGroupId()+StringPool.BLANK ,Constant.USER_GROUP_GROUPS_VAR, userGroup.getName());
			AuditReportLocalServiceUtil.addAuditReport(auditReport);
		
			userGroupReferences=NYUUserGroupLocalServiceUtil.createNYUUserGroup(userGroup.getUserGroupId());
			userGroupReferences.setCompanyId(companyId);
			userGroupReferences.setCreatedBy(userId);
			userGroupReferences.setGroupId(themeDisplay.getScopeGroupId());
			userGroupReferences.setGroupPrivacy(groupPrivacy);
			userGroupReferences.setCreatedBy(PortalUtil.getUserId(request));
			userGroupReferences.setCreatedDate(new Date());
			NYUUserGroupLocalServiceUtil.addNYUUserGroup(userGroupReferences);	
			String userGroupId = Long.toString(userGroup.getUserGroupId());
			response.getWriter().write(userGroupId);
			PortalUtil.getHttpServletResponse(response).getWriter().write(CommonUtil.JavaClassI18N(request, themeDisplay, "group-created-successfully"));
		}
					
		//userGroup.getExpandoBridge().setAttribute("group-privacy",groupPrivacy);
	
		CommonUtil.addUpadteAssetEntry(uploadPortletRequest, serviceContext, userGroup.getPrimaryKey(), UserGroup.class.getName());		
	}catch (DuplicateUserGroupException e) {
		response.getWriter().write(CommonUtil.JavaClassI18N(request, themeDisplay, "duplicate-group-name-please-change"));
		e.printStackTrace();
	} catch (PortalException e) {
		response.getWriter().write(CommonUtil.JavaClassI18N(request, themeDisplay, "group-creation-failed"));
		e.printStackTrace();
	} catch (SystemException e) {
		PortalUtil.getHttpServletResponse(response).getWriter().write(CommonUtil.JavaClassI18N(request, themeDisplay, "group-creation-failed"));
		e.printStackTrace();
	}
	
}

@RenderMapping(params ="action=deleteGroup")
public String deleteGroup(RenderRequest request,RenderResponse response)throws IOException, Exception {  
	
	ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
	try {
		_log.info("[ NyuHomeController > DELETE GROUP ]");
		long userGroupId = Long.parseLong(request.getParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID).toString());

		List<User> groupUsers = UserLocalServiceUtil.getUserGroupUsers(userGroupId); //Get all users belonging to group
		
		for(User usr : groupUsers){
			UserGroupLocalServiceUtil.deleteUserUserGroup(usr.getUserId(), userGroupId);//Empty the group by deleting users belonging to group
		}
		try{
			NYUUserGroupLocalServiceUtil.deleteNYUUserGroup(userGroupId);
		}catch(NoSuchNYUUserGroupException e){
			_log.info("[ NoSuchNYUUserGroupException > DELETE GROUP:"+userGroupId+" ]");
		}
		List<Lesson> groupLessons = Lesson_UsergroupsLocalServiceUtil.getLessonsByGroupId(userGroupId);
		Lesson_Usergroups lUserGroup = null;
		if(groupLessons!=null && groupLessons.size()>0){  // Delete all lessons mapped to group
			for(Lesson lesson : groupLessons){
				lUserGroup = new Lesson_UsergroupsImpl();
				lUserGroup.setGroupId(userGroupId);
				lUserGroup.setLessonId(lesson.getLessonId());
				Lesson_UsergroupsLocalServiceUtil.deleteLesson_Usergroups(lUserGroup);
				List<Lesson_Usergroups> isStillPrivateLesson = Lesson_UsergroupsLocalServiceUtil.getLesson_UserGroupLessonId(lesson.getLessonId());
				if(isStillPrivateLesson == null || isStillPrivateLesson.size()<=0){
					//lesson.setLessonPrivacy(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR);
					lesson.setMarkedAs(Constant.LESSON_FROM_DELETED_GROUP);
					LessonLocalServiceUtil.updateLesson(lesson);
				}
			}
		}
		UserGroup userGroup=UserGroupLocalServiceUtil.getUserGroup(userGroupId);
		AuditReport auditReport=AuditNyuUtil.createReport(PortalUtil.getHttpServletRequest(request), Constant.USER_GROUP_DELETE_GROUP_VAR, userGroup.getUserGroupId()+StringPool.BLANK,Constant.USER_GROUP_GROUPS_VAR, userGroup.getName());
		AuditReportLocalServiceUtil.addAuditReport(auditReport);
		
		UserGroupLocalServiceUtil.deleteUserGroup(userGroupId); // Delete empty group
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(AssetEntry.class);
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(ClassNameLocalServiceUtil.getClassNameId(UserGroup.class.getName())));
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(userGroupId));
		List<AssetEntry> entries = AssetEntryLocalServiceUtil.dynamicQuery(dynamicQuery);
		if(entries!=null){
			for(AssetEntry entry:entries){
				try {
					AssetEntryLocalServiceUtil.deleteAssetEntry(entry.getEntryId());
				} catch (PortalException e) {
				} catch (SystemException e) {
				}
			}
		}
		request.setAttribute(Constant.GROUP_DELETED_SUCCESS, CommonUtil.JavaClassI18N(request, themeDisplay, "group-deleted-successfully"));
					
	} catch (NumberFormatException e) {
		_log.error("[ NyuHomeController > DELETE GROUP > NumberFormatException ] " + e);
	} catch (Exception e) {
		_log.error("[ NyuHomeController > DELETE GROUP > Exception ] " + e);
	}
	
	return Constant.USER_GROUP_GROUPS_JSP;
	
}

@ResourceMapping(value = "appreciate")
public @ResponseBody String appreciateGroup(ResourceRequest request,
		ResourceResponse response) {
	long appreciatedCount = 0;
	try {
		
		NYUUserGroup userGroup = NYUUserGroupLocalServiceUtil.getNYUUserGroup(Long.parseLong(request.getParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID)));
		String appreciatedUserIds=userGroup.getAppreciatedUserIds();
		String userId=PortalUtil.getUserId(request)+StringPool.BLANK;
		List<String> items = new ArrayList<String>();
		if(!appreciatedUserIds.isEmpty()){
			items = Arrays.asList(appreciatedUserIds.split(StringPool.COMMA));
			appreciatedCount = items.size();
		}
		if(!items.contains(userId)){
			if(Validator.isNull(appreciatedUserIds) || appreciatedUserIds.isEmpty()){
				appreciatedUserIds =userId;
			} else {
				appreciatedUserIds = appreciatedUserIds+StringPool.COMMA+userId;
			}
			appreciatedCount = CommonUtil.getAppreciatedCount(appreciatedUserIds);
			userGroup.setAppreciateCount(appreciatedCount);
			userGroup.setAppreciatedUserIds(appreciatedUserIds);
			NYUUserGroupLocalServiceUtil.updateNYUUserGroup(userGroup);
		}
		response.getWriter().write(appreciatedCount+StringPool.BLANK);
	} catch (NumberFormatException e) {
		e.printStackTrace();
	} catch (IOException e) {
		e.printStackTrace();
	} catch (PortalException e) {
		e.printStackTrace();
	} catch (SystemException e) {
		e.printStackTrace();
	}
	return null;
}


@ResourceMapping(value="subscriber")
public void subscribeNunsubscribe(ResourceRequest request,ResourceResponse response) throws IOException, PortalException, SystemException { 
	ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
	long usergroupId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_GROUP_ID);
	ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
	String subsData=ParamUtil.getString(request, Constant.SUBS_DATA);
	try {
	long userId=PortalUtil.getUserId(request);
	long toUserId=0l;
	String subscribeMessage=StringPool.BLANK;
	UserGroupRequest userGroupRequest = null;
	if(subsData.equalsIgnoreCase(Constant.REQUEST_JOIN))
	{
		UserGroup userGroup = UserGroupLocalServiceUtil.getUserGroup(usergroupId);
		toUserId=userGroup.getUserId();
		
		
		if(Validator.isNotNull
				(UserGroupRequestLocalServiceUtil.getRequestStatusByUsers(usergroupId, userId))){
			userGroupRequest=UserGroupRequestLocalServiceUtil.getRequestStatusByUsers(usergroupId, userId);
			userGroupRequest.setCompanyId(themeDisplay.getCompanyId());
			userGroupRequest.setGroupId(themeDisplay.getScopeGroupId());
			userGroupRequest.setUserGroupId(usergroupId);
			userGroupRequest.setUserGroupOwner(userGroup.getUserId());
			userGroupRequest.setRequestedBy(PortalUtil.getUserId(request));
			userGroupRequest.setRequestDate(new Date());
			userGroupRequest.setStatus(Constant.KEYWORD_STATUS_REQUEST);
			UserGroupRequestLocalServiceUtil.updateUserGroupRequest(userGroupRequest);
		}
		else{
			userGroupRequest = UserGroupRequestLocalServiceUtil.createUserGroupRequest(CounterLocalServiceUtil.increment(UserGroupRequest.class.getName()));
			userGroupRequest.setCompanyId(themeDisplay.getCompanyId());
			userGroupRequest.setGroupId(themeDisplay.getScopeGroupId());
			userGroupRequest.setUserGroupId(usergroupId);
			userGroupRequest.setRequestedBy(PortalUtil.getUserId(request));
			userGroupRequest.setUserGroupOwner(userGroup.getUserId());
			userGroupRequest.setRequestDate(new Date());
			userGroupRequest.setStatus(Constant.KEYWORD_STATUS_REQUEST);
			UserGroupRequestLocalServiceUtil.addUserGroupRequest(userGroupRequest);
		}
			SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(request),PortalUtil.getScopeGroupId(request),UserGroup.class.getName(),usergroupId, NyuMemberActivityKeys.REQUEST_TO_JOIN_GROUP,"Requested to join",0l);
			
			JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, userId);
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,PortalUtil.getUserName(userId, StringPool.BLANK));
			payloadJSON.put(Constant.TYPE,Constant.REQUEST_TO_JOIN);
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME,
					userGroup.getName());
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,
					userGroup.getUserGroupId());
			payloadJSON.put(Constant.ADDITIONAL_DATA, CommonUtil.JavaClassI18N(request, themeDisplay, "has-Request-to-join"));
			UserNotificationEventLocalServiceUtil
					.addUserNotificationEvent(
							toUserId,
							com.nyu.notification.UserGroupNotificationHandler.PORTLET_ID,
							(new Date()).getTime(), userId,
							payloadJSON.toString(), false,
							serviceContext);
			//String subject ="Group Request";
			String subject = CommonUtil.JavaClassI18N(request, themeDisplay, "group-request");
			//String message=Constant.BOLD_OPEN_STYLE_COLOR+PortalUtil.getUserName(userId, StringPool.BLANK)+Constant.BOLD_TAG_CLOSE+" has Request to Join "+Constant.BOLD_OPEN_STYLE_COLOR_ROYAL_BLUE+"+userGroup.getName()+Constant.BOLD_TAG_CLOSE;
			String message=Constant.BOLD_OPEN_STYLE_COLOR+PortalUtil.getUserName(userId, StringPool.BLANK)+Constant.BOLD_TAG_CLOSE+" "+ CommonUtil.JavaClassI18N(request, themeDisplay, "has-Request-to-join")+StringPool.SPACE +Constant.BOLD_OPEN_STYLE_COLOR_ROYAL_BLUE + userGroup.getName()+Constant.BOLD_TAG_CLOSE;
			VelocityContext velocityContext = new VelocityContext();
			velocityContext.put(Constant.COMMON_DATE, CommonUtil.dateAsPerFormat(Constant.EEEE_MMM_D_YYYY));
			velocityContext.put(Constant.FROM, PortalUtil.getUserName(userId, StringPool.BLANK));
			velocityContext.put(Constant.TO,UserLocalServiceUtil.getUser(toUserId).getFullName());
			velocityContext.put(Constant.REQUEST_LESSON_SUBJECT_JSP,subject);
			velocityContext.put(Constant.USER_GROUP_HYPER_LINK,generateGroupUrl(usergroupId, request));
			velocityContext.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME,userGroup.getName());
			
			CommonUtil.emailNotification(userId, toUserId, subject, message, Constant.USER_GROUP_REQUEST_TO_JOIN_GROUP, velocityContext);
			
	}
	else if(subsData.equalsIgnoreCase(Constant.UN_REQUEST))
	{
		userGroupRequest=UserGroupRequestLocalServiceUtil.getRequestStatusByUsers(usergroupId, userId);
		userGroupRequest.setCompanyId(themeDisplay.getCompanyId());
		userGroupRequest.setGroupId(themeDisplay.getScopeGroupId());
		userGroupRequest.setUserGroupId(usergroupId);
		userGroupRequest.setRequestedBy(PortalUtil.getUserId(request));
		userGroupRequest.setRequestDate(new Date());
		userGroupRequest.setStatus(Constant.UN_REQUESTED);
		UserGroupRequestLocalServiceUtil.updateUserGroupRequest(userGroupRequest);
				
		//SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(request),PortalUtil.getScopeGroupId(request),UserGroup.class.getName(),usergroupId, NyuMemberActivityKeys.UNREQUEST_TO_JOIN_GROUP,"UnRequested to join",0l);
		SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(request),PortalUtil.getScopeGroupId(request),UserGroup.class.getName(),usergroupId, NyuMemberActivityKeys.UNREQUEST_TO_JOIN_GROUP ,CommonUtil.JavaClassI18N(request, themeDisplay, "un-requested-to-join"),0l);
	}
	
	
	else if(subsData.equalsIgnoreCase(Constant.SUBSCRIBE))
	{
		UserGroupLocalServiceUtil.addUserUserGroup(userId, usergroupId);
		//subscribeMessage="Subscribe successfull";
		subscribeMessage = CommonUtil.JavaClassI18N(request, themeDisplay, "subscribe-successfull");
		SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(request),PortalUtil.getScopeGroupId(request),UserGroup.class.getName(),usergroupId, NyuMemberActivityKeys.JOIN_GROUP, CommonUtil.JavaClassI18N(request, themeDisplay, "small-case-join"), 0l);
	}
	else
	{
		UserGroupLocalServiceUtil.deleteUserUserGroup(userId, usergroupId);
		//subscribeMessage="Unsubscribe successfull";
		subscribeMessage = CommonUtil.JavaClassI18N(request, themeDisplay, "unsubscribe-successfull");
		SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(request),PortalUtil.getScopeGroupId(request),UserGroup.class.getName(),usergroupId, NyuMemberActivityKeys.QUIT_GROUP, CommonUtil.JavaClassI18N(request, themeDisplay, "quit"),0l);
	}
		
	response.getWriter().write(subscribeMessage);
	} catch (Exception e) {
		e.printStackTrace();
	}
}	


@ResourceMapping(value="declineUsertoGroup")
public void declineUsertoGroup(ResourceRequest request,ResourceResponse response) throws IOException, PortalException, SystemException, AddressException {
	ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
	long usergroupId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_GROUP_ID);
	long userId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_ID);
	long requestAcceptor=themeDisplay.getUserId();
	String userName=StringPool.BLANK;
	
	long userNotificationEventId=ParamUtil.getLong(request, Constant.USER_NOTIFICATION_EVENT_ID);
	if(userNotificationEventId>0){
		UserNotificationEvent userNotiEvent= UserNotificationEventLocalServiceUtil.getUserNotificationEvent(userNotificationEventId);
		userNotiEvent.setArchived(true);
		UserNotificationEventLocalServiceUtil.updateUserNotificationEvent(userNotiEvent);
		_log.info(userNotificationEventId+"Marked as Read");
	}
	ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
	UserGroup userGroup=UserGroupLocalServiceUtil.getUserGroup(usergroupId);
	userName=UserLocalServiceUtil.getUser(requestAcceptor).getFullName();
	
	UserGroupRequest userGroupRequest=null;
	userGroupRequest=UserGroupRequestLocalServiceUtil.getRequestStatusByUsers(usergroupId, userId);
	userGroupRequest.setRequestedBy(userId);
	userGroupRequest.setRequestDate(new Date());
	userGroupRequest.setStatus(Constant.LESSON_MEMBER_STATUS_DECLINED);
	UserGroupRequestLocalServiceUtil.updateUserGroupRequest(userGroupRequest);
	
		JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, requestAcceptor);
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
		payloadJSON.put(Constant.TYPE,Constant.REQUEST_DECLINED);
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME,
				userGroup.getName());
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,
				userGroup.getUserGroupId());
		//payloadJSON.put(Constant.ADDITIONAL_DATA, "has declined you to join");
		payloadJSON.put(Constant.ADDITIONAL_DATA, CommonUtil.JavaClassI18N(request, themeDisplay, "has-declined-you-to-join"));
		UserNotificationEventLocalServiceUtil
				.addUserNotificationEvent(
						userId,
						com.nyu.notification.UserGroupNotificationHandler.PORTLET_ID,
						(new Date()).getTime(), requestAcceptor,
						payloadJSON.toString(), false,
						serviceContext);
		
		//String subject ="Group Request Declined";
		String subject = CommonUtil.JavaClassI18N(request, themeDisplay, "group-request-declined");
		
		String message=Constant.BOLD_OPEN_STYLE_COLOR+userName+Constant.BOLD_TAG_CLOSE+" "+CommonUtil.JavaClassI18N(request, themeDisplay, "has-declined-you-to-join")+Constant.BOLD_OPEN_STYLE_COLOR_ROYAL_BLUE+userGroup.getName()+Constant.BOLD_TAG_CLOSE;
		VelocityContext velocityContext = new VelocityContext();
		velocityContext.put(Constant.COMMON_DATE, CommonUtil.dateAsPerFormat(Constant.EEEE_MMM_D_YYYY));
		velocityContext.put(Constant.FROM, userName);
		velocityContext.put(Constant.TO,UserLocalServiceUtil.getUser(userId).getFullName());
		velocityContext.put(Constant.REQUEST_LESSON_SUBJECT_JSP,subject);
		velocityContext.put(Constant.USER_GROUP_HYPER_LINK,generateGroupUrl(usergroupId, request));
		velocityContext.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME,userGroup.getName());
		
		//CommonUtil.emailNotification(requestAcceptor, userId, subject, message,"content/templates/requestDeclinedToJoinGroup.vm",velocityContext);
		CommonUtil.emailNotification(requestAcceptor, userId, subject, message, Constant.USER_GROUP_REQUEST_DECLINED_TO_JOIN_GROUP, velocityContext);
}

@ResourceMapping(value="acceptUsertoGroup")
public void acceptUsertoGroup(ResourceRequest request,ResourceResponse response) throws IOException, PortalException, SystemException {
	ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
	long usergroupId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_GROUP_ID);
	long userId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_ID);
	long requestAcceptor=themeDisplay.getUserId();
	String userName=StringPool.BLANK;
	
	long userNotificationEventId=ParamUtil.getLong(request, Constant.USER_NOTIFICATION_EVENT_ID);
	if(userNotificationEventId>0){
		UserNotificationEvent userNotiEvent= UserNotificationEventLocalServiceUtil.getUserNotificationEvent(userNotificationEventId);
		userNotiEvent.setArchived(true);
		UserNotificationEventLocalServiceUtil.updateUserNotificationEvent(userNotiEvent);
		_log.info(userNotificationEventId+"Marked as Read");
	}
	ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
	
	try {
	UserGroupLocalServiceUtil.addUserUserGroup(userId, usergroupId);
	userName=UserLocalServiceUtil.getUser(requestAcceptor).getFullName();
	UserGroupRequest userGroupRequest=null;
	userGroupRequest=UserGroupRequestLocalServiceUtil.getRequestStatusByUsers(usergroupId, userId);
	userGroupRequest.setRequestedBy(userId);
	userGroupRequest.setRequestDate(new Date());
	userGroupRequest.setStatus(Constant.LESSON_MEMBER_STATUS_ACCEPTED);
	UserGroupRequestLocalServiceUtil.updateUserGroupRequest(userGroupRequest);
	
	UserGroup userGroup=UserGroupLocalServiceUtil.getUserGroup(usergroupId);
	
	SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(request),PortalUtil.getScopeGroupId(request),UserGroup.class.getName(),usergroupId, NyuMemberActivityKeys.ACCEPT_TO_JOIN_GROUP, LanguageUtil.get((PortletConfig)request.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG), themeDisplay.getLocale(), Constant.LESSON_MEMBER_STATUS_ACCEPTED)+" <b>"+UserLocalServiceUtil.getUser(userId).getFullName()+Constant.BOLD_TAG_CLOSE+" "+LanguageUtil.get((PortletConfig)request.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG), themeDisplay.getLocale(), "to-join"), 0l);
		JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, requestAcceptor);
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
		payloadJSON.put(Constant.TYPE,Constant.REQUESTED_ACCEPTED);
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME,
				userGroup.getName());
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,
				userGroup.getUserGroupId());
		//payloadJSON.put(Constant.ADDITIONAL_DATA,"has accepted you to join");
		payloadJSON.put(Constant.ADDITIONAL_DATA, CommonUtil.JavaClassI18N(request, themeDisplay, "has-accepted-you-to-join"));
		UserNotificationEventLocalServiceUtil
				.addUserNotificationEvent(
						userId,
						com.nyu.notification.UserGroupNotificationHandler.PORTLET_ID,
						(new Date()).getTime(), requestAcceptor,
						payloadJSON.toString(), false,
						serviceContext);
		String subject = CommonUtil.JavaClassI18N(request, themeDisplay, "group-request-accepted");
		String message=Constant.BOLD_OPEN_STYLE_COLOR+userName+Constant.BOLD_TAG_CLOSE+" "+CommonUtil.JavaClassI18N(request, themeDisplay, "has-accepted-you-to-join")+Constant.BOLD_OPEN_STYLE_COLOR_ROYAL_BLUE+userGroup.getName()+Constant.BOLD_TAG_CLOSE;
		
		VelocityContext velocityContext = new VelocityContext();
		velocityContext.put(Constant.COMMON_DATE, CommonUtil.dateAsPerFormat(Constant.EEEE_MMM_D_YYYY));
		velocityContext.put(Constant.FROM, userName);
		velocityContext.put(Constant.TO,UserLocalServiceUtil.getUser(userId).getFullName());
		velocityContext.put(Constant.REQUEST_LESSON_SUBJECT_JSP,subject);
		velocityContext.put(Constant.USER_GROUP_HYPER_LINK,generateGroupUrl(usergroupId, request));
		velocityContext.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME,userGroup.getName());
		
		CommonUtil.emailNotification(requestAcceptor, userId, subject, message, Constant.USER_GROUP_REQUEST_TO_ACCEPRTED_TO_JOIN_GROUP,velocityContext);
		
	}
	catch(Exception e)
	{
		_log.info(e.getMessage());
	}
}



@ResourceMapping(value="groupsFilter")
public void groupFilter(ResourceRequest request, ResourceResponse response) throws IOException  {
	ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
	List<AssetEntry> assetEntries=null;
	UserGroup userGroup = null;
	List<UserGroup> userGroups = new ArrayList<UserGroup>();
	long categoryId=ParamUtil.getLong(request, Constant.CATA_ID);
	long tagId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_TAG_ID);
	try {
			if(categoryId>0){
				
					AssetEntryQuery entryQuery=new AssetEntryQuery();
					entryQuery.setClassName(UserGroup.class.getName());
					entryQuery.setAnyCategoryIds(new long[]{categoryId});
					userGroups=new ArrayList<UserGroup>();
					assetEntries = AssetEntryLocalServiceUtil.getEntries(entryQuery);
					
					for(AssetEntry assetEntry:assetEntries){
						userGroup =UserGroupLocalServiceUtil.getUserGroup(assetEntry.getClassPK());
						
						userGroups.add(userGroup);
					}
				
			}else if(tagId>0) {
				
					AssetEntryQuery entryQuery=new AssetEntryQuery();
					entryQuery.setClassName(UserGroup.class.getName());
					entryQuery.setAnyTagIds(new long[]{tagId});
					userGroups=new ArrayList<UserGroup>();
					assetEntries = AssetEntryLocalServiceUtil.getEntries(entryQuery);
					for(AssetEntry assetEntry:assetEntries){
						userGroup =UserGroupLocalServiceUtil.getUserGroup(assetEntry.getClassPK());
						userGroups.add(userGroup);
					}
			}else
			{
				userGroups=new ArrayList<UserGroup>();
				userGroups.addAll(UserGroupLocalServiceUtil.getUserGroups(-1, -1));	
			}
			
			if(userGroups.size()>0)
			{
				Collections.sort(userGroups, new UserGroupSortByTime());
			}
			HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
			HttpServletResponse httpResponse = PortalUtil
					.getHttpServletResponse(response);
			ServletContext context = httpRequest.getSession()
					.getServletContext();
			
			request.setAttribute(Constant.USER_GROUP_GROUPS_JSP,userGroups);
			// start
			String jsonGroups = CommonUtil.getJSONGroups((List<UserGroup>)request.getAttribute(Constant.USER_GROUP_GROUPS_JSP), themeDisplay);
			response.getWriter().write(jsonGroups);
			// end
			String jspFile;
			
				jspFile = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.USER_GROUP_GROUP_RESULTS_JSP);
				response.getWriter().write(jspFile);
				
				
				
			
	} catch (SystemException e) {
		e.printStackTrace();
	}
	catch (PortalException e) {
		e.printStackTrace();
	}
	catch (ServletException e) {
		e.printStackTrace();
	}
}



@RenderMapping(params ="action=addLessons")
public String viewAddLessons(RenderRequest request,RenderResponse response){  
	List<Lesson> authorLessons=LessonLocalServiceUtil.findUserAliveLessons(PortalUtil.getUserId(request));
	List<Lesson> userGroupLessons=Lesson_UsergroupsLocalServiceUtil.getLessonsByGroupId(ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID));
	Set<Long> userGroupLessonsIds=new HashSet<Long>();
	for(Lesson lesson:userGroupLessons){
		userGroupLessonsIds.add(lesson.getLessonId());
	}
	String closePopup = ParamUtil.getString(request, Constant.CLOSE_POPUP,Constant.COMMON_STRING_CONSTANT_FALSE);
	request.setAttribute(Constant.CLOSE_POPUP, closePopup);
	request.setAttribute(Constant.USER_GROUP_LESSONS_IDS,userGroupLessonsIds);
	request.setAttribute(Constant.AUTHOR_LESSONS,authorLessons);
	request.setAttribute(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID));
	return Constant.USER_GROUP_ADD_LESSON_TO_GROUP;   
}

@ActionMapping(params = "action=processAddLessonToGroup")
public void processAddLessonToGroup(ActionRequest actionRequest,ActionResponse actionResponse)
{
	try {
		
		long[] CheckedlessonIds = ParamUtil.getLongValues(actionRequest,Constant.LESSON_IDS_CHECKBOX);
		long categoryId = ParamUtil.getLong(actionRequest,Constant.COMMON_STRING_CONSTANT_CATEGORY_ID);
		long tagId = ParamUtil.getLong(actionRequest,Constant.COMMON_STRING_CONSTANT_TAG_ID);
		long userGroupId=ParamUtil.getLong(actionRequest,Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
		long userId = PortalUtil.getUserId(actionRequest);
		List<Lesson> authorLessons = null;
		List<Long> lessonIds = new ArrayList<Long>();
		List<Lesson_Usergroups> Lesson_UsergroupsList = null;
		Lesson lessons = null;
		String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
		String status = Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
		String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.LESSON_FROM_DELETED_GROUP,Constant.MARKEDAS_QUARANTINE};
	
		if(categoryId>0){
			authorLessons =LessonLocalServiceUtil.findAssetLessonsByCategoryAndUser(categoryId, userId, status, lessonPrivacy,Constant.USER_GROUP_UPLOAD_TIMES_VAR,markedAs, -1, -1);
			for(Lesson lesson:authorLessons){
				lessonIds.add(lesson.getLessonId());
			}
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson_Usergroups.class);
			Criterion criterion = RestrictionsFactoryUtil.eq(Constant.PRIMARY_KEY_GROUP_ID, userGroupId);
			Criterion criterion2 = RestrictionsFactoryUtil.in(Constant.PRIMARY_KEY_LESSON_ID, lessonIds);
			dynamicQuery.add(criterion);
			dynamicQuery.add(criterion2);
			Lesson_UsergroupsList =Lesson_UsergroupsLocalServiceUtil.dynamicQuery(dynamicQuery);
			actionResponse.setRenderParameter(Constant.COMMON_STRING_CONSTANT_CATEGORY_ID,categoryId+StringPool.BLANK);
			actionResponse.setRenderParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.CATEGORY_ADD_LESSONS);
		}else if(tagId>0){
			authorLessons =LessonLocalServiceUtil.findAssetLessonsByTagAndUser(tagId, userId, status, lessonPrivacy, Constant.USER_GROUP_UPLOAD_TIMES_VAR,markedAs,-1, -1);
			for(Lesson lesson:authorLessons){
				lessonIds.add(lesson.getLessonId());
			}
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson_Usergroups.class);
			Criterion criterion = RestrictionsFactoryUtil.eq(Constant.PRIMARY_KEY_GROUP_ID, userGroupId);
			Criterion criterion2 = RestrictionsFactoryUtil.in(Constant.PRIMARY_KEY_LESSON_ID, lessonIds);
			dynamicQuery.add(criterion);
			dynamicQuery.add(criterion2);
			Lesson_UsergroupsList = Lesson_UsergroupsLocalServiceUtil.dynamicQuery(dynamicQuery);
			actionResponse.setRenderParameter(Constant.COMMON_STRING_CONSTANT_TAG_ID,tagId+StringPool.BLANK);
			actionResponse.setRenderParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.TAG_ADD_LESSONS);
		}else{
			authorLessons = LessonLocalServiceUtil.getLessonsUploadedByAuthorAndStatus(PortalUtil.getUserId(actionRequest),Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH);
			Lesson_UsergroupsList=Lesson_UsergroupsLocalServiceUtil.getLesson_UserGroupId(userGroupId);
			for(Lesson lesson:authorLessons){
				lessonIds.add(lesson.getLessonId());
			}
			actionResponse.setRenderParameter(Constant.COMMON_STRING_CONSTANT_ACTION,Constant.ADD_LESSONS);
		}
		
		for(Lesson_Usergroups lesson_Usergroup:Lesson_UsergroupsList){
			try{
				if(lessonIds.contains(lesson_Usergroup.getLessonId())){
					if(!(Lesson_UsergroupsLocalServiceUtil.getLesson_UserGroupLessonId(lesson_Usergroup.getLessonId()).size()>1))
					{
						lessons=LessonLocalServiceUtil.getLesson(lesson_Usergroup.getLessonId());
						lessons.setLessonPrivacy(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR);
						
						LessonLocalServiceUtil.updateLesson(lessons);
					}
					Lesson_UsergroupsLocalServiceUtil.deleteLesson_Usergroups(lesson_Usergroup);
				}
			}
			catch(Exception e){
				
			}
		}	
		for(long lessonId:CheckedlessonIds){
			Lesson_Usergroups lesson_group=new Lesson_UsergroupsImpl();
			lesson_group.setGroupId(userGroupId);
			lesson_group.setLessonId(lessonId);
			lessons=LessonLocalServiceUtil.getLesson(lessonId);
			lessons.setLessonPrivacy(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE);
			LessonLocalServiceUtil.updateLesson(lessons);
			Lesson_UsergroupsLocalServiceUtil.addLesson_Usergroups(lesson_group);
			SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(actionRequest),PortalUtil.getScopeGroupId(actionRequest),UserGroup.class.getName(),userGroupId, NyuMemberActivityKeys.ADD_LESSON_TO_GROUP,"Added <code>"+lessons.getLessonName()+"</code> to",0l);
		}
		actionResponse.setRenderParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,userGroupId+StringPool.BLANK);
		actionResponse.setRenderParameter(Constant.CLOSE_POPUP, Constant.COMMON_STRING_CONSTANT_TRUE);
		
	} catch (Exception e) {
		e.printStackTrace();
	}

}


private void processImage(PortletRequest actionRequest,UserGroup userGroup){
	ThemeDisplay themeDisplay =(ThemeDisplay)
			actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
	try{
		FileEntry croppedImage = getTempImageFileEntry(actionRequest);
		ImageBag imageBag = ImageToolUtil.read(croppedImage.getContentStream());
		if(Validator.isNotNull(croppedImage)){
			BufferedImage originalImage = ImageIO.read(croppedImage.getContentStream());
			int type = originalImage.getType() == 0? BufferedImage.TYPE_INT_ARGB : originalImage.getType();
			BufferedImage resizeImageJpg = CommonUtil.resizeImage(originalImage, type, 
													Constant.LESSON_THUMBNAIL_IMAGE_WIDTH, Constant.LESSON_THUMBNAIL_IMAGE_HEIGHT);
			byte[] bytes = ImageToolUtil.getBytes(resizeImageJpg,imageBag.getType());
			LayoutSetLocalServiceUtil.updateLogo(userGroup.getGroupId(), true, true, bytes);
			
			TempFileUtil.deleteTempFile(
	                themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
	                getTempImageFileName(actionRequest), getTempImageFolderName());
		}
		
	}catch(Exception e){
		
	}
}
private String getFileExtension(File file) {
    String name = file.getName();
    try {
        return name.substring(name.lastIndexOf(StringPool.PERIOD)+1);

    } catch (Exception e) {
        return StringPool.BLANK;
    }
}

@ResourceMapping(value="myGroups")
public void myGroups(RenderRequest request,RenderResponse response) throws PortalException, SystemException {
	ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
	boolean fromMyStuff=ParamUtil.getBoolean(request, Constant.FROM_MY_STUFF, false);
	List<UserGroup> groups=null;
	if(fromMyStuff){
		groups=UserGroupLocalServiceUtil.getUserUserGroups(PortalUtil.getUserId(request));
		List<UserGroup> myGroups=new ArrayList<UserGroup>();
		List<UserGroup> otherGroups=new ArrayList<UserGroup>();
		for(UserGroup temp : groups)
		{
			if(temp.getUserId() == themeDisplay.getUserId()){
				myGroups.add(temp);
				Collections.sort(myGroups, new UserGroupSortByTime());
			}else{
				otherGroups.add(temp);
			}
		}
		myGroups.addAll(otherGroups);
		Collections.copy(groups,myGroups);
	}else{
		groups = NYUUserGroupLocalServiceUtil.findUserGroupByType(-1, -1);	
	}
		
	try {
		List<AssetCategory> categories = null;
		List<AssetVocabulary> vocabularies = null;
		List<AssetTag> tags=null;
		vocabularies = AssetVocabularyLocalServiceUtil.getGroupVocabularies(themeDisplay.getScopeGroupId(), Constant.SITE_NAME, 0, 1, null);
		if(vocabularies!=null && vocabularies.size()>0){
			categories = AssetCategoryLocalServiceUtil.getVocabularyRootCategories(vocabularies.get(0).getVocabularyId(), 0, vocabularies.get(0).getCategories().size(), null);
			tags=AssetTagLocalServiceUtil.getGroupTags(themeDisplay.getScopeGroupId());
		}
		String jsonCategorys=CommonUtil.getJSONCategorys(categories);
		String jsonTags=CommonUtil.getJSONTags(tags);
		String jsonGroups = CommonUtil.getJSONGroups (groups, themeDisplay);
		
		JSONObject AllGroupData=JSONFactoryUtil.createJSONObject();
		
		AllGroupData.put(Constant.GET_GROUPS,jsonGroups);
		AllGroupData.put(Constant.GET_CATEGORIES,jsonCategorys);
		AllGroupData.put(Constant.GET_TAGS,jsonTags);
		
		request.setAttribute(Constant.GROUP_DATA, AllGroupData);
		
	} catch (PortalException e) {
		e.printStackTrace();
	} catch (SystemException e) {
		e.printStackTrace();
	}
	
}		

@ResourceMapping(value="groupDiscussion")
public void groupDiscussion(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException, PortalException, SystemException, ServletException  {

	ThemeDisplay themeDisplay = (ThemeDisplay) resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
	long userGroupClassNameId = ClassNameLocalServiceUtil.getClassNameId(UserGroup.class);
	long userGroupId = Long.parseLong(resourceRequest.getParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID));
	long parentMessageId =Long.parseLong(resourceRequest.getParameter(Constant.MESSAGE_ID));
	String body=resourceRequest.getParameter(Constant.USER_NOTE);
	String title=resourceRequest.getParameter(Constant.COMMON_STRING_CONSTANT_TITLE);
	try {
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
		mbMessage.setClassNameId(userGroupClassNameId);
		mbMessage.setClassPK(userGroupId);
		mbMessage.setUserName(themeDisplay.getUser().getFullName());
		mbMessage.setBody(body);
		mbMessage.setSubject(title);
		mbMessage.setParentMessageId(parentMessageId);
		mbMessage.setThreadId(userGroupId);
		
		if(Validator.isNotNull(mbParentMessage) && mbParentMessage.getMessageId()>0)
			mbMessage.setRootMessageId(mbParentMessage.getRootMessageId());
		else
			mbMessage.setRootMessageId(mbMessage.getMessageId());
		
		mbMessage=MBMessageLocalServiceUtil.addMBMessage(mbMessage);
		
		DynamicQuery groupDiscussionQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
		groupDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(userGroupId));
		groupDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(userGroupClassNameId));
		groupDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.THREAD_ID).eq(userGroupId));
		groupDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.PARENT_MESSAGE_ID).eq(0l));
		List<MBMessage> groupDiscussionList = MBMessageLocalServiceUtil.dynamicQuery(groupDiscussionQuery);
		List<List<MBMessage>> groupSubDiscussionList=new ArrayList<List<MBMessage>>();
		for(MBMessage groupDiscussion:groupDiscussionList){
			DynamicQuery groupSubDiscussionQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
			groupSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(userGroupId));
			groupSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(userGroupClassNameId));
			groupSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.THREAD_ID).eq(userGroupId));
			groupSubDiscussionQuery.add(PropertyFactoryUtil.forName(Constant.ROOT_MESSAGE_ID).eq(groupDiscussion.getRootMessageId()));
			List<MBMessage> lessonSubDiscussion = MBMessageLocalServiceUtil.dynamicQuery(groupSubDiscussionQuery);
			groupSubDiscussionList.add(lessonSubDiscussion);
		}
		HttpServletRequest httpRequest = PortalUtil
				.getHttpServletRequest(resourceRequest);
		HttpServletResponse httpResponse = PortalUtil
				.getHttpServletResponse(resourceResponse);
		ServletContext context = httpRequest.getSession()
				.getServletContext();
		httpRequest.setAttribute(Constant.GROUP_SUB_DISCUSSION_LIST, groupSubDiscussionList );
		String jspFile = StringPool.BLANK;
		jspFile = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.USER_GROUP_DISCUSSION_RESULTS_JSP);
		
		resourceResponse.getWriter().write(jspFile);

	} catch (Exception e) {
		e.printStackTrace();
	}
}
private String renderRequestedMembers(ResourceRequest request,ResourceResponse response)
{
	ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
	HttpServletRequest  httpRequest = PortalUtil.getHttpServletRequest(request);
	HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
	//long userId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_ID);
	long usergroupId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_GROUP_ID);
	//String userIdS=userId+StringPool.BLANK;
	List<User> requestedUsers=null;;
	List<String> items =null;
	String jspFile=StringPool.BLANK;
	try{
	UserGroup userGroup=UserGroupLocalServiceUtil.getUserGroup(usergroupId);
	//UserGroup req_userGroup=UserGroupLocalServiceUtil.getUserGroup(usergroupId);
	String requestedIds=userGroup.getExpandoBridge().getAttribute(Constant.REQUESTED_ID).toString();
	
	if(!requestedIds.isEmpty()){
		requestedUsers=new ArrayList<User>();
		items =new ArrayList<String>(Arrays.asList(requestedIds.split(StringPool.COMMA)));
		for(String requestedUserId:items)
			requestedUsers.add(UserLocalServiceUtil.getUser(GetterUtil.getLong(requestedUserId)));	
		
			 //_log.info(requestedUsers.size());
			 httpRequest.setAttribute(Constant.REQUESTED_MEMBERS, requestedUsers);	
			 httpRequest.setAttribute(Constant.USER_GROUP_ID,usergroupId);
	 
			 ServletContext context = httpRequest.getSession().getServletContext();
			 jspFile = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.USERGROUP_REQUEST_MEMBERS_JSP);
			 //_log.info("jspFile"+jspFile.isEmpty());
			
	
	}else{
		 jspFile=Constant.TAG_HEADER_CLASS_MESSAGE_HEADING+CommonUtil.JavaClassI18N(request, themeDisplay, "member-requests")+ StringPool.SPACE+Constant.TAG_HEADER_DIV_CLASS_MESSAGE_BODY+CommonUtil.JavaClassI18N(request, themeDisplay, "no-member-requests")+StringPool.PERIOD+Constant.TAG_DIV_CLOSE;
	 }	
	}
	catch(Exception e)
	{
		
	}
	 return jspFile;
}


@ResourceMapping(value="memberDeleteURL")
public void memberDeleteURL(ResourceRequest request, ResourceResponse response){
		long usergroupId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_GROUP_ID);
		long userId=ParamUtil.getLong(request, Constant.MEMBER_ID);
		NYUUserGroup userGroup;	
				try {
					userGroup =NYUUserGroupLocalServiceUtil.getNYUUserGroup(usergroupId);
					UserGroupLocalServiceUtil.deleteUserUserGroup(userId, usergroupId);
					String memberId = userId + StringPool.BLANK;
					String administratorIds = userGroup.getAdministrators();
					String modifiedAdminId=StringPool.BLANK;
					List<String> items = new ArrayList<String>();
					if (!administratorIds.isEmpty()) {
						items =new LinkedList<String>(Arrays.asList(administratorIds.split(StringPool.COMMA)));
					}
					if (items.contains(memberId)) {
						items.remove(memberId);
						for(String item:items)
						{
							if(modifiedAdminId.isEmpty()){
								modifiedAdminId =item;
							} else {
								modifiedAdminId = modifiedAdminId+StringPool.COMMA+item;
							}
						}
					}
					userGroup.setAdministrators(modifiedAdminId);
					NYUUserGroupLocalServiceUtil.updateNYUUserGroup(userGroup);
					
				} catch (PortalException e) {
					e.printStackTrace();
				}
				catch (SystemException e) {
					e.printStackTrace();
				}
		
}

@ResourceMapping(value="sendInvitation")
public void sendInviataion(ResourceRequest request, ResourceResponse response) throws PortalException, SystemException, AddressException, IOException{
	ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
	long userId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_ID);
	long userGroupId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
	long invitationSender=themeDisplay.getUserId();
	String userName=StringPool.BLANK;
	
	try {
	 	ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
		userName=UserLocalServiceUtil.getUser(invitationSender).getFullName();
		UserGroup userGroup=UserGroupLocalServiceUtil.getUserGroup(userGroupId);

		JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
					payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, invitationSender);
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
		payloadJSON.put(Constant.TYPE, Constant.INVITE_TO_JOIN_GROUP);
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME,
				userGroup.getName());
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,
				userGroup.getUserGroupId());
		payloadJSON.put(Constant.ADDITIONAL_DATA, CommonUtil.JavaClassI18N(request, themeDisplay, "has-invited-you-to-join"));
		UserNotificationEventLocalServiceUtil
				.addUserNotificationEvent(
						userId,
						com.nyu.notification.UserGroupNotificationHandler.PORTLET_ID,
						(new Date()).getTime(), invitationSender,
						payloadJSON.toString(), false,
						serviceContext);
		String subject = CommonUtil.JavaClassI18N(request, themeDisplay, "group-invitation");
		String message=Constant.BOLD_OPEN_STYLE_COLOR+userName+Constant.BOLD_TAG_CLOSE+" "+CommonUtil.JavaClassI18N(request, themeDisplay, "has-invited-you-to-join")+Constant.BOLD_OPEN_STYLE_COLOR_ROYAL_BLUE+userGroup.getName()+Constant.BOLD_TAG_CLOSE;
		
		VelocityContext velocityContext = new VelocityContext();
		velocityContext.put(Constant.COMMON_DATE, CommonUtil.dateAsPerFormat(Constant.EEEE_MMM_D_YYYY));
		velocityContext.put(Constant.FROM, userName);
		velocityContext.put(Constant.TO,UserLocalServiceUtil.getUser(userId).getFullName());
		velocityContext.put(Constant.REQUEST_LESSON_SUBJECT_JSP,subject);
		velocityContext.put(Constant.USER_GROUP_HYPER_LINK,generateGroupUrl(userGroupId, request));
		velocityContext.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME,userGroup.getName());
		
		CommonUtil.emailNotification(invitationSender, userId, subject, message,Constant.USER_GROUP_INVITE_USER_TO_GROUP,velocityContext);
		
	} catch (PortalException e) {
		e.printStackTrace();
	} catch (SystemException e) {
		e.printStackTrace();
	}

}
@ResourceMapping(value="authenticationURL")
public void authenticateMember(ResourceRequest request,
		ResourceResponse response) throws IOException {
	_log.info("authenticateMember:::::");
	String selectedValue = ParamUtil.getString(request, Constant.SELECTED_VALUE);
	long usergroupId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_GROUP_ID);
	long member = ParamUtil.getLong(request, Constant.MEMBER_ID);
	//String strSeparator = StringPool.COMMA;
	// long userId=ParamUtil.getLong(request, Constant.MEMBER_ID);
	NYUUserGroup userGroup;
	try {
		userGroup = NYUUserGroupLocalServiceUtil
				.getNYUUserGroup(usergroupId);
		if (selectedValue.equalsIgnoreCase(Constant.ADMINISTRATOR)) {
			String administratorsIds = userGroup.getAdministrators();
			String userId = member + StringPool.BLANK;
			List<String> items = new ArrayList<String>();
			if (!administratorsIds.isEmpty()) {
				items = Arrays.asList(administratorsIds.split(StringPool.COMMA));
			}
			if (!items.contains(userId)) {
				if (administratorsIds.isEmpty()) {
					administratorsIds = userId;
				} else {
					administratorsIds = administratorsIds + StringPool.COMMA + userId;
				}
				userGroup.setAdministrators(administratorsIds);
				NYUUserGroupLocalServiceUtil.updateNYUUserGroup(userGroup);
			}

		} else {
			String memberId = member + StringPool.BLANK;
			String administratorIds = userGroup.getAdministrators();
			String modifiedAdminId=StringPool.BLANK;
			List<String> items = new ArrayList<String>();
			if (!administratorIds.isEmpty()) {
				items =new LinkedList<String>(Arrays.asList(administratorIds.split(StringPool.COMMA)));
			}
			if (items.contains(memberId)) {
				items.remove(memberId);
				for(String item:items)
				{
					if(modifiedAdminId.isEmpty()){
						modifiedAdminId =item;
					} else {
						modifiedAdminId = modifiedAdminId+StringPool.COMMA+item;
					}
				}
			}
			userGroup.setAdministrators(modifiedAdminId);
			NYUUserGroupLocalServiceUtil.updateNYUUserGroup(userGroup);
		}
	} catch (PortalException e) {
		e.printStackTrace();
	} catch (SystemException e) {
		e.printStackTrace();
	}

}
@ResourceMapping(value="acceptUserInvitation")
public void acceptUserInvitation(ResourceRequest request,ResourceResponse response) throws IOException {
	ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
	long userGroupId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_GROUP_ID);
	long userId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_ID);
	long userNotificationEventId=ParamUtil.getLong(request, Constant.USER_NOTIFICATION_EVENT_ID);
	long senderUserId=themeDisplay.getUserId();
	String userName=StringPool.BLANK;
	ServiceContext serviceContext =null; 
	try{
		serviceContext = ServiceContextFactory.getInstance(request);
		userName=UserLocalServiceUtil.getUser(senderUserId).getFullName();
		
		UserGroup userGroup=UserGroupLocalServiceUtil.getUserGroup(userGroupId);
		UserGroupLocalServiceUtil.addUserUserGroup(senderUserId,userGroupId);
		
		
		if(userNotificationEventId>0){
			UserNotificationEvent userNotiEvent= UserNotificationEventLocalServiceUtil.getUserNotificationEvent(userNotificationEventId);
			userNotiEvent.setArchived(true);
			UserNotificationEventLocalServiceUtil.updateUserNotificationEvent(userNotiEvent);
		}
	
		SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(request),
				PortalUtil.getScopeGroupId(request),UserGroup.class.getName(),
				userGroupId, NyuMemberActivityKeys.ACCEPT_INVITATION,Constant.TAG_BOLD_OPEN+UserLocalServiceUtil.getUser(senderUserId).getFullName()+Constant.BOLD_TAG_CLOSE+CommonUtil.JavaClassI18N(request, themeDisplay, "accepted-invitation-to-join"),0l);
	
		JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, senderUserId);
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
		payloadJSON.put(Constant.TYPE, Constant.ACCEPT_TO_GROUP_JOIN);
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME,
				userGroup.getName());
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,
				userGroup.getUserGroupId());
		payloadJSON.put(Constant.ADDITIONAL_DATA, CommonUtil.JavaClassI18N(request, themeDisplay, "has-accepted-invitation"));
		UserNotificationEventLocalServiceUtil
				.addUserNotificationEvent(
						userId,
						com.nyu.notification.UserGroupNotificationHandler.PORTLET_ID,
						(new Date()).getTime(), senderUserId,
						payloadJSON.toString(), false,
						serviceContext);
		String subject = CommonUtil.JavaClassI18N(request, themeDisplay, "group-invitation-accepted");
		String message=Constant.BOLD_OPEN_STYLE_COLOR+userName+Constant.BOLD_TAG_CLOSE+" "+CommonUtil.JavaClassI18N(request, themeDisplay, "has-accepted--invitation-to-join")+Constant.BOLD_OPEN_STYLE_COLOR_ROYAL_BLUE+userGroup.getName()+Constant.BOLD_TAG_CLOSE;
		
		VelocityContext velocityContext = new VelocityContext();
		velocityContext.put(Constant.COMMON_DATE, CommonUtil.dateAsPerFormat(Constant.EEEE_MMM_D_YYYY));
		velocityContext.put(Constant.FROM, userName);
		velocityContext.put(Constant.TO,UserLocalServiceUtil.getUser(userId).getFullName());
		velocityContext.put(Constant.REQUEST_LESSON_SUBJECT_JSP,subject);
		velocityContext.put(Constant.USER_GROUP_HYPER_LINK,generateGroupUrl(userGroupId, request));
		velocityContext.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME,userGroup.getName());
		
		CommonUtil.emailNotification(senderUserId, userId, subject, message, Constant.USER_GROUP_ACCEPT_INVITATION_TO_GROUP,velocityContext);
	}
	catch(Exception e){
		e.printStackTrace();
		
	}
}
	
	@ResourceMapping(value="declinetUserInvitation")
	public void declineUserInvitation(ResourceRequest request,ResourceResponse response) throws IOException {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long userGroupId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_GROUP_ID);
		long userId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_ID);
		long userNotificationEventId=ParamUtil.getLong(request, Constant.USER_NOTIFICATION_EVENT_ID);
		long senderUserId=themeDisplay.getUserId();
		String userName=StringPool.BLANK;
		ServiceContext serviceContext =null; 
		try{
			serviceContext = ServiceContextFactory.getInstance(request);
			userName=UserLocalServiceUtil.getUser(senderUserId).getFullName();
			
			UserGroup userGroup=UserGroupLocalServiceUtil.getUserGroup(userGroupId);
			
			
			if(userNotificationEventId>0){
				UserNotificationEvent userNotiEvent= UserNotificationEventLocalServiceUtil.getUserNotificationEvent(userNotificationEventId);
				userNotiEvent.setArchived(true);
				UserNotificationEventLocalServiceUtil.updateUserNotificationEvent(userNotiEvent);
			}
		SocialActivityLocalServiceUtil.addActivity(PortalUtil.getUserId(request),
				PortalUtil.getScopeGroupId(request),UserGroup.class.getName(),
				userGroupId, NyuMemberActivityKeys.DECLINE_INVITATION,Constant.TAG_BOLD_OPEN+UserLocalServiceUtil.getUser(userId).getFullName()+Constant.BOLD_TAG_CLOSE+CommonUtil.JavaClassI18N(request, themeDisplay, "decline-invitation-to-join"),0l);

	
		JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, senderUserId);
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
		payloadJSON.put(Constant.TYPE, Constant.DECLINE_TO_GROUP_JOIN);
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME,
				userGroup.getName());
		payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,
				userGroup.getUserGroupId());
		payloadJSON.put(Constant.ADDITIONAL_DATA, CommonUtil.JavaClassI18N(request, themeDisplay, "has-declined-invitation"));
		UserNotificationEventLocalServiceUtil
				.addUserNotificationEvent(
						userId,
						com.nyu.notification.UserGroupNotificationHandler.PORTLET_ID,
						(new Date()).getTime(), senderUserId,
						payloadJSON.toString(), false,
						serviceContext);
		String subject = CommonUtil.JavaClassI18N(request, themeDisplay, "group-invitation-declined");
		
		String message=Constant.BOLD_OPEN_STYLE_COLOR+userName+Constant.BOLD_TAG_CLOSE+" "+CommonUtil.JavaClassI18N(request, themeDisplay, "has-declined-invitation-to-join")+Constant.BOLD_OPEN_STYLE_COLOR_ROYAL_BLUE+userGroup.getName()+Constant.BOLD_TAG_CLOSE;
		
		VelocityContext velocityContext = new VelocityContext();
		velocityContext.put(Constant.COMMON_DATE, CommonUtil.dateAsPerFormat(Constant.EEEE_MMM_D_YYYY));
		velocityContext.put(Constant.FROM, userName);
		velocityContext.put(Constant.TO,UserLocalServiceUtil.getUser(userId).getFullName());
		velocityContext.put(Constant.REQUEST_LESSON_SUBJECT_JSP,subject);
		velocityContext.put(Constant.USER_GROUP_HYPER_LINK,generateGroupUrl(userGroupId, request));
		velocityContext.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME,userGroup.getName());
		
		CommonUtil.emailNotification(senderUserId, userId, subject, message, Constant.USER_GROUP_DECLINE_INVITATION_TO_GROUP,velocityContext);
		}
		catch(Exception e){
			e.printStackTrace();
			
		}
}
	
	
		@RenderMapping(params ="action=categoryAddLessons")
	    public String filterByCategory(RenderRequest request, RenderResponse response) throws IOException  {
			
				long categoryId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_CATEGORY_ID);
				long userGroupid = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
				long userId = PortalUtil.getUserId(request);
				List<Lesson> lessons=null;
				String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
				String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
				String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.LESSON_FROM_DELETED_GROUP,Constant.MARKEDAS_QUARANTINE};
				String closePopup = ParamUtil.getString(request, Constant.CLOSE_POPUP,Constant.COMMON_STRING_CONSTANT_FALSE);
				request.setAttribute(Constant.CLOSE_POPUP, closePopup);
				if(categoryId>0){
					lessons =LessonLocalServiceUtil.findAssetLessonsByCategoryAndUser(categoryId, userId, status, lessonPrivacy, Constant.USER_GROUP_UPLOAD_TIMES_VAR,markedAs, -1, -1);
				}else{
					lessons=LessonLocalServiceUtil.getLessonsUploadedByAuthorAndStatus(userId,Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH);
				}
				List<Lesson> userGroupLessons=Lesson_UsergroupsLocalServiceUtil.getLessonsByGroupId(ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID));
				Set<Long> userGroupLessonsIds=new HashSet<Long>();
				for(Lesson lesson:userGroupLessons){
					userGroupLessonsIds.add(lesson.getLessonId());
				}

				request.setAttribute(Constant.USER_GROUP_LESSONS_IDS,userGroupLessonsIds);
				request.setAttribute(Constant.AUTHOR_LESSONS,lessons);
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,userGroupid);
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_CATEGORY_ID,categoryId+StringPool.BLANK);
				return Constant.USER_GROUP_ADD_LESSON_TO_GROUP;
		}
		
		@RenderMapping(params ="action=tagAddLessons")
	    public String filterByTag(RenderRequest request, RenderResponse response) throws IOException  {
			long tagId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_TAG_ID);
			long userId=PortalUtil.getUserId(request);
			long userGroupid = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);

			List<Lesson> lessons=null;
			String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
			String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
			String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.LESSON_FROM_DELETED_GROUP,Constant.MARKEDAS_QUARANTINE};
			if(tagId>0){
				lessons =LessonLocalServiceUtil.findAssetLessonsByTagAndUser(tagId, userId, status, lessonPrivacy,Constant.USER_GROUP_UPLOAD_TIMES_VAR,markedAs,-1, -1);
			}else{
				lessons=LessonLocalServiceUtil.getLessonsUploadedByAuthorAndStatus(userId,Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH);
			}
			List<Lesson> userGroupLessons=Lesson_UsergroupsLocalServiceUtil.getLessonsByGroupId(ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID));
			Set<Long> userGroupLessonsIds=new HashSet<Long>();
			for(Lesson lesson:userGroupLessons){
				userGroupLessonsIds.add(lesson.getLessonId());
			}
			String closePopup = ParamUtil.getString(request, Constant.CLOSE_POPUP,Constant.COMMON_STRING_CONSTANT_FALSE);
			request.setAttribute(Constant.CLOSE_POPUP, closePopup);			
			request.setAttribute(Constant.USER_GROUP_LESSONS_IDS,userGroupLessonsIds);
			request.setAttribute(Constant.AUTHOR_LESSONS,lessons);
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,userGroupid);
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_TAG_ID,tagId+StringPool.BLANK);
			return Constant.USER_GROUP_ADD_LESSON_TO_GROUP;
		}
		
		
	
	public String generateGroupUrl(long userGroupId,PortletRequest request){
		try {
			ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
			String portletId = Constant.PORTLET_GROUP;
			long targetPlId;
			targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true, Constant.PAGE_GROUP).getPlid();
			PortletURL showGroupURL=PortletURLFactoryUtil.create(request, portletId, targetPlId, PortletRequest.RENDER_PHASE);
			showGroupURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.LESSON_URL);
			showGroupURL.setParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,userGroupId+StringPool.BLANK);
			showGroupURL.setWindowState(LiferayWindowState.MAXIMIZED);
			return showGroupURL.toString();
		} catch (PortalException e) {
			e.printStackTrace();
		} catch (SystemException e) {
			e.printStackTrace();
		} catch (WindowStateException e) {
			e.printStackTrace();
		}	
		return StringPool.POUND;
	}
	
	@ResourceMapping(value="sendAnnouncement")
	public void sendAnnouncement(ResourceRequest request,ResourceResponse response) throws IOException {
		String title=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_TITLE);
		String description=ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_DESCRIPTION);
		long userGroupId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long classNameId=ClassNameLocalServiceUtil.getClassNameId(UserGroup.class.getName());
		String[] dateAndTime=ParamUtil.getString(request, Constant.DATE_AND_TIME).split(StringPool.SLASH);
		Date date=null;
		Calendar now = Calendar.getInstance();
		now.set(Calendar.HOUR_OF_DAY, 0);
		now.set(Calendar.MINUTE, 0);
		now.set(Calendar.SECOND, 0);
		SimpleDateFormat format = new SimpleDateFormat(Constant.DD_MM_YYYY);
		try {
			if(Validator.isNotNull(dateAndTime) && dateAndTime.length > 1)	
			now.set(Integer.parseInt(dateAndTime[0].toString()), Integer.parseInt(dateAndTime[1].toString())-1,Integer.parseInt( dateAndTime[2].toString()));
			date = format.parse(format.format(now.getTime()));
		} catch (ParseException e1) {
			e1.printStackTrace();
		}
		long entryId=0l;
		try {
			entryId = CounterLocalServiceUtil.increment(UserGroupRequest.class.getName());
		
		 	AnnouncementsEntry  announcementsEntry=AnnouncementsEntryLocalServiceUtil.createAnnouncementsEntry(entryId);
		 	announcementsEntry.setTitle(title);
		 	announcementsEntry.setContent(description);
		 	announcementsEntry.setExpirationDate(date);
		 	now = Calendar.getInstance();
			now.set(Calendar.HOUR_OF_DAY, 0);
			now.set(Calendar.MINUTE, 0);
			now.set(Calendar.SECOND, 0);
			date = format.parse(format.format(now.getTime()));
		 	announcementsEntry.setCreateDate(new Date());	
		 	announcementsEntry.setDisplayDate(date);
		 	announcementsEntry.setType(Constant.GENERAL);
		 	announcementsEntry.setModifiedDate(new Date());
		 	announcementsEntry.setClassNameId(classNameId);
		 	announcementsEntry.setClassPK(userGroupId);
		 	announcementsEntry.setCompanyId(themeDisplay.getCompanyId());
		 	announcementsEntry.setUserId(themeDisplay.getUserId());
		 	announcementsEntry.setUserName(themeDisplay.getUser().getFullName());
			AnnouncementsEntryLocalServiceUtil.addAnnouncementsEntry(announcementsEntry);
			
			List<User> users=UserLocalServiceUtil.getUserGroupUsers(userGroupId);
			
			for(User user:users){
				AnnouncementsFlagLocalServiceUtil.addFlag(user.getUserId(), entryId, AnnouncementsFlagConstants.READ);
			}
			response.getWriter().write(CommonUtil.getGroupAnnouncements(request));
		} catch (SystemException e) {
			e.printStackTrace();
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
	@ResourceMapping(value="keywordRequest")
	public void keywordRequest(ResourceRequest request, ResourceResponse response) throws IOException, SystemException, PortalException{
		CommonUtil.processKeyWordRequest(request, response);
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
			System.out.println("nsfee" + nsfee.getMessage());
		} catch (Exception e) {
			System.out.println("e" + e.getMessage());
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
	                    	 System.out.println(e.getMessage());
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
		return themeDisplay.getUserId()+ Constant.CAPITAL_USER_GROUP;
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
			e.printStackTrace();
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
	    }
		FileEntry tempfileEntry = TempFileUtil.addTempFile(
	            themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
	            getTempImageFileName(portletRequest), getTempImageFolderName(),is,contentType);
		serveTempImageFile(portletResponse, tempfileEntry.getContentStream());
		
	}

	@ResourceMapping(value="deleteImageURL")
	public void deleteLessonThumbnail(ResourceRequest request, ResourceResponse response) throws IOException  {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		try{
			TempFileUtil.deleteTempFile(
	                themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
	                getTempImageFileName(request), getTempImageFolderName());
		}catch(Exception e){
				
		}
		response.getWriter().write(themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.GROUP_CARD_PLACEHOLDER);
	}
 
	
	
	@RenderMapping(params="action=lessonUrl")
	public String lessonPage(RenderRequest request,RenderResponse response) throws SystemException, Exception {
		long userGroupId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
		UserGroup userGroup = null;
		try{
			if(userGroupId > 0){
				userGroup=UserGroupLocalServiceUtil.getUserGroup(userGroupId);
				request.setAttribute(Constant.USER_GROUP,userGroup);
				request.setAttribute(Constant.AFTER_CREATE,ParamUtil.getString(request, Constant.AFTER_CREATE,StringPool.BLANK));
				return Constant.USER_GROUP_GROUP_DETAIL_JSP;
			}
		}catch(Exception e){}
		return Constant.USER_GROUP_GROUPS_JSP;  
	}

	
}