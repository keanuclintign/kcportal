package com.nyu.util;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.portlet.PortletConfig;
import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.portlet.WindowStateException;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.runtime.RuntimeConstants;
import org.apache.velocity.runtime.resource.loader.ClasspathResourceLoader;
import org.joda.time.DateTime;
import org.joda.time.Duration;
import org.joda.time.Period;

import com.liferay.mail.service.MailServiceUtil;
import com.liferay.portal.kernel.dao.orm.Criterion;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.OrderFactoryUtil;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.mail.MailMessage;
import com.liferay.portal.kernel.portlet.LiferayWindowState;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.JavaConstants;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.LayoutSet;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.RoleConstants;
import com.liferay.portal.model.User;
import com.liferay.portal.model.UserGroup;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.LayoutLocalServiceUtil;
import com.liferay.portal.service.LayoutSetLocalServiceUtil;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.service.UserGroupLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.service.UserNotificationEventLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.liferay.portlet.announcements.model.AnnouncementsEntry;
import com.liferay.portlet.announcements.service.AnnouncementsEntryLocalServiceUtil;
import com.liferay.portlet.asset.model.AssetCategory;
import com.liferay.portlet.asset.model.AssetEntry;
import com.liferay.portlet.asset.model.AssetTag;
import com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetTagLocalServiceUtil;
import com.liferay.portlet.documentlibrary.model.DLFileEntry;
import com.liferay.portlet.documentlibrary.service.DLFileEntryLocalServiceUtil;
import com.liferay.portlet.messageboards.model.MBMessage;
import com.liferay.portlet.messageboards.service.MBMessageLocalServiceUtil;
import com.nyu.NoSuchNYUUserGroupException;
import com.nyu.model.AuditReport;
import com.nyu.model.DocumentFile;
import com.nyu.model.DocumentSection;
import com.nyu.model.KeywordsCollaboration;
import com.nyu.model.Lesson;
import com.nyu.model.LessonCollaboration;
import com.nyu.model.LessonObjectives;
import com.nyu.model.NYUUserGroup;
import com.nyu.model.RequestLesson;
import com.nyu.model.UserGroupRequest;
import com.nyu.model.impl.KeywordsCollaborationImpl;
import com.nyu.portlet.vo.CategoryTagsVO;
import com.nyu.portlet.vo.DocumentVO;
import com.nyu.portlet.vo.GroupsVO;
import com.nyu.portlet.vo.LessonVO;
import com.nyu.portlet.vo.MBMessageVO;
import com.nyu.portlet.vo.NyuObjectivesVO;
import com.nyu.portlet.vo.RequestLessonVO;
import com.nyu.service.AuditReportLocalServiceUtil;
import com.nyu.service.DocumentFileLocalServiceUtil;
import com.nyu.service.DocumentSectionLocalServiceUtil;
import com.nyu.service.KeywordsCollaborationLocalServiceUtil;
import com.nyu.service.LessonCollaborationLocalServiceUtil;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.LessonObjectivesLocalServiceUtil;
import com.nyu.service.Lesson_UsergroupsLocalServiceUtil;
import com.nyu.service.NYUUserGroupLocalServiceUtil;
import com.nyu.service.UserGroupRequestLocalServiceUtil;

public class CommonUtil {

	private static final String CLASS_NAME = CommonUtil.class.getName();
	private final static Logger _log = Logger.getLogger(CLASS_NAME);

	public static String getDocumentPath(long primaryKey, long classNameId,
			ThemeDisplay themeDisplay) {

		String documentPath = StringPool.BLANK;

		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil
				.forClass(DLFileEntry.class);
		dynamicQuery
				.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID, classNameId));
		dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_PK, primaryKey));

		List<DLFileEntry> dlFileEntries = null;

		try {
			dlFileEntries = DLFileEntryLocalServiceUtil
					.dynamicQuery(dynamicQuery);
		} catch (SystemException e) {
			_log.error(e);
		}

		if (Validator.isNotNull(dlFileEntries) && dlFileEntries.size() > 0) {

			documentPath = themeDisplay.getPortalURL()
					+ themeDisplay.getPathContext() + StringPool.FORWARD_SLASH + Constant.REQUEST_LESSON_DOCUMENTS + StringPool.FORWARD_SLASH +
					+ dlFileEntries.get(0).getGroupId() + StringPool.SLASH
					+ dlFileEntries.get(0).getUuid();
		}

		return documentPath;
	}

	public static User getAuthor(long userId) {

		User author = null;
		try {
			author = UserLocalServiceUtil.getUser(userId);
		} catch (Exception e) {
			_log.error(e);
		}

		return author;
	}

	public static int getAppreciatedCount(String appreciatorUserIds) {

		int appreciatedCount = 0;
		List<String> items = new ArrayList<String>();
		if (!appreciatorUserIds.isEmpty()) {
			items = Arrays.asList(appreciatorUserIds.split(StringPool.COMMA));
			appreciatedCount = items.size();
		}

		return appreciatedCount;
	}

	public static int getViewCount(String className, long entryId) {

		int viewCount = 0;
		try {
			AssetEntry assetEntry = AssetEntryLocalServiceUtil.getEntry(
					className, entryId);

			if (assetEntry != null) {
				viewCount = assetEntry.getViewCount();
			}
		} catch (Exception e) {
			_log.error(e);
		}

		return viewCount;
	}

	public static int getIncrementedViewCount(long userId, String className,
			long primaryKey) {
		int viewCount = 0;
		try {
			AssetEntry assetEntry = AssetEntryLocalServiceUtil
					.incrementViewCounter(userId, className, primaryKey);
			// AssetEntry assetEntry =
			// AssetEntryLocalServiceUtil.getEntry(className, primaryKey);
			if (assetEntry != null) {
				viewCount = assetEntry.getViewCount();
			}

		} catch (Exception e) {
			_log.error(e);
		}

		return viewCount;
	}

	public static BufferedImage resizeImage(BufferedImage originalImage,
			int type, int resizedWidth, int resizedHeight) {
		double ratio = (double) originalImage.getWidth()/originalImage.getHeight();
		  if (resizedWidth < 1) {
			  resizedWidth = (int) (resizedHeight * ratio + 0.4);
		  } else if (resizedHeight < 1) {
			  resizedHeight = (int) (resizedWidth /ratio + 0.4);
		  }

		  Image scaled = originalImage.getScaledInstance(resizedWidth, resizedHeight, Image.SCALE_AREA_AVERAGING);
		  BufferedImage bufferedScaled = new BufferedImage(scaled.getWidth(null), scaled.getHeight(null), BufferedImage.TYPE_INT_RGB);
		  Graphics2D g2d = bufferedScaled.createGraphics();
		  g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
		  g2d.drawImage(scaled, 0, 0, resizedWidth, resizedHeight, null);
		  g2d.dispose();
		return bufferedScaled;
	}

	public static BufferedImage resizeUserProfileImage(
			BufferedImage originalImage, int type, int x, int y,
			int resizedWidth, int resizedHeight) {
		BufferedImage resizedImage = new BufferedImage(resizedWidth,
				resizedHeight, type);
		Graphics2D g = resizedImage.createGraphics();
		g.drawImage(originalImage, x, y, resizedWidth, resizedHeight, null);
		g.dispose();
		return resizedImage;
	}

	public static String getDatesDuration(long fDate, long tDate) {

		String timeDuration = StringPool.BLANK;
		DateTime toDate = null;

		DateTime fromDate = new DateTime(fDate);

		if (tDate == 0)
			toDate = new DateTime();// Current datetime
		else
			toDate = new DateTime(tDate);

		Duration duration = new Duration(fromDate, toDate);

		Period period = duration.toPeriod();// To get years

		if (period.getYears() != 0) {
			timeDuration = period.getYears() + StringPool.SPACE+ Constant.YEARS_AGO;
		} else if (duration.getStandardDays() != 0) {
			timeDuration = duration.getStandardDays() + StringPool.SPACE+ Constant.DAYS_AGO;
		} else if (duration.getStandardHours() != 0) {
			timeDuration = duration.getStandardHours() +StringPool.SPACE+ Constant.HRS_AGO;
		} else if (duration.getStandardMinutes() != 0) {
			timeDuration = duration.getStandardMinutes() +StringPool.SPACE+ Constant.MINS_AGO;
		} else {
			timeDuration = duration.getStandardSeconds() + StringPool.SPACE+Constant.SECS_AGO;
		}

		return timeDuration;

	}

	public static int getAuthorAppreciateCount(long authorId) {

		List<Lesson> lessons = LessonLocalServiceUtil
				.getLessonsUploadedByAuthor(authorId);
		int appreciateCount = 0;
		for (Lesson lesson : lessons) {

			appreciateCount += getAppreciatedCount(lesson
					.getAppreciatedUserIds());
		}
		return appreciateCount;

	}

	public static int getAuthorViewCount(long authorId) {
		int totalViewCount = 0;
		List<Lesson> lessons = LessonLocalServiceUtil
				.getLessonsUploadedByAuthor(authorId);
		for (Lesson lesson : lessons) {

			try {
				totalViewCount += getViewCount(Lesson.class.getName(),
						lesson.getLessonId());
			} catch (Exception e) {
				_log.error(e);
			}

		}
		return totalViewCount;

	}
	
	public static String getJSONCategorys(List<AssetCategory> categorys)
			throws PortalException, SystemException {
		List<CategoryTagsVO> categoryVOList = new ArrayList<CategoryTagsVO>();
		if (categorys != null && categorys.size() > 0) {
			for (AssetCategory category : categorys) {
				CategoryTagsVO categoryVO = new CategoryTagsVO();
				categoryVO.setId(category.getCategoryId()+StringPool.BLANK);
				categoryVO.setName(category.getName());
				categoryVOList.add(categoryVO);
			}
		}
		String jsonCategorys = JSONFactoryUtil.looseSerialize(categoryVOList);
		return jsonCategorys;
	}
	
	public static String getJSONTags(List<AssetTag> tags)
			throws PortalException, SystemException {
		List<CategoryTagsVO> tagVOList = new ArrayList<CategoryTagsVO>();
		if (tags != null && tags.size() > 0) {
			for (AssetTag tag : tags) {
				CategoryTagsVO tagVO = new CategoryTagsVO();
				tagVO.setId(tag.getTagId()+StringPool.BLANK);
				tagVO.setName(tag.getName());
				tagVOList.add(tagVO);
			}
		}
		String jsonTags = JSONFactoryUtil.looseSerialize(tagVOList);
		return jsonTags;
	}
	
	public static String getJSONLessons(List<Lesson> lessons,
			ThemeDisplay themeDisplay) throws PortalException, SystemException { 
		List<LessonVO> lessonVOList = new ArrayList<LessonVO>();
		if (lessons != null && lessons.size() > 0) {
			for (Lesson lsn : lessons) {
					LessonVO LessonVO = new LessonVO();
					//LessonVO.setAuthorId(lsn.getAuthor());
					LessonVO.setAuthorId(lsn.getCurrentAuthor());
					User author = CommonUtil.getAuthor(LessonVO.getAuthorId());
					LessonVO.setLessonId(lsn.getLessonId());
					LessonVO.setStatus(lsn.getStatus());
					LessonVO.setLessonName(lsn.getLessonName().length()>53?
							lsn.getLessonName().substring(0, 50)+Constant.COMMON_STRING_CONSTANT_THREE_DOTS:lsn.getLessonName());
					LessonVO.setLessonFullName(lsn.getLessonName());
					
					String userName = author.getFirstName() + StringPool.SPACE+ author.getLastName();
					String userPic = author.getPortraitURL(themeDisplay);
					/*if(CommonUtil.isAnonymous(author)){
						userName = Constant.ANONYMOUS_NAME;
						userPic = Constant.ANONYMOUS_PIC;
					}*/
					LessonVO.setUserName(userName);
					LessonVO.setUserImage(userPic);
					LessonVO.setAppreciateCount(CommonUtil
							.getAppreciatedCount(lsn.getAppreciatedUserIds()));
					LessonVO.setViewCount(CommonUtil.getViewCount(
							Lesson.class.getName(), lsn.getLessonId()));
					if(lsn.getUploadedTime() != null){
					LessonVO.setUploadedTime(CommonUtil.getDatesDuration(lsn
							.getUploadedTime().getTime(), 0));
					}
					if(lsn.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC)){
						LessonVO.setPrivacyIcon(Constant.COMMON_STRING_CONSTANT_ICON_GLOBE);
					}else if(lsn.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE) || lsn.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE)){
						LessonVO.setPrivacyIcon(Constant.COMMON_STRING_CONSTANT_ICON_USER);
					}else if(lsn.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR)){
						LessonVO.setPrivacyIcon(Constant.COMMON_STRING_CONSTANT_ICON_GROUP);
					}
					List<AssetCategory> categoriesList = null;
					List<AssetTag> tagList = null;
					List<CategoryTagsVO> categoryVOList = new ArrayList<CategoryTagsVO>();
					List<CategoryTagsVO> tagsVOList = new ArrayList<CategoryTagsVO>();
					try {
						categoriesList = AssetCategoryLocalServiceUtil
								.getCategories(Lesson.class.getName(),
										lsn.getLessonId());
						tagList = AssetTagLocalServiceUtil
								.getTags(Lesson.class.getName(),lsn.getLessonId());
						for(AssetCategory category:categoriesList){
							CategoryTagsVO ctVO = new CategoryTagsVO();
							ctVO.setId(category.getCategoryId()+StringPool.BLANK);
							ctVO.setName(category.getName());
							categoryVOList.add(ctVO);
						}
						for(AssetTag tag:tagList){
							CategoryTagsVO ctVO = new CategoryTagsVO();
							ctVO.setId(tag.getTagId()+StringPool.BLANK);
							ctVO.setName(tag.getName());
							tagsVOList.add(ctVO);
						}
					}catch (Exception e) {
						_log.error(e);
					}
					
				    LessonVO.setCategories(categoryVOList);
				    LessonVO.setTags(tagsVOList);
				    LessonVO.setDescription(lsn.getDescription());

					String documentPath=CommonUtil.getDocumentPath(lsn.getLessonId(), ClassNameLocalServiceUtil.getClassNameId(Lesson.class), themeDisplay);
					if(documentPath==null || documentPath.equals(StringPool.BLANK))
						documentPath=themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER ;
					LessonVO.setDocumentPath(documentPath);
					

					String userGroupDocumentPath=StringPool.BLANK;
					String userGroupName=StringPool.BLANK;
					if(lsn.getPublishWithProfile()>0l && lsn.getPublishedProfile().equals(Constant.PUBLISH_WITH_GROUPPROFILE )){
						UserGroup userGroup=UserGroupLocalServiceUtil.getUserGroup(lsn.getPublishWithProfile());
						userGroupName=userGroup.getName();
						userGroupDocumentPath=themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.GROUP_CARD_PLACEHOLDER;
						LayoutSet publicLS=LayoutSetLocalServiceUtil.getLayoutSet(userGroup.getGroupId(), false);
						LayoutSet privateLS=LayoutSetLocalServiceUtil.getLayoutSet(userGroup.getGroupId(), true);
						
						if(publicLS.getLogo()){
							userGroupDocumentPath=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+publicLS.getLogoId();	
						}
						if(privateLS.getLogo()){
							userGroupDocumentPath=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+privateLS.getLogoId();
						}
						
					}
					
					LessonVO.setUserGroupDocumentPath(userGroupDocumentPath);
					LessonVO.setUserGroupName(userGroupName);
					lessonVOList.add(LessonVO);
			}
		}
		String jsonLessons = JSONFactoryUtil.looseSerializeDeep(lessonVOList);
		return jsonLessons;

	}
	
	
	public static String getJSONGroups(List<UserGroup> groups,
			ThemeDisplay themeDisplay) throws PortalException, SystemException { 
		List<UserGroup> usergroups=themeDisplay.getUser().getUserGroups();
		List<Long> usergroupids= new ArrayList<Long>();
		long currentTime = System.currentTimeMillis();
		for(UserGroup usergroup:usergroups){
			usergroupids.add(usergroup.getUserGroupId());
		}
		List<GroupsVO> groupsVOList = new ArrayList<GroupsVO>();
		if (groups != null && groups.size() > 0) {
			for (UserGroup grs : groups) {
					GroupsVO groupsVO = new GroupsVO();
					groupsVO.setAuthorId(grs.getUserId());
					User author = CommonUtil.getAuthor(groupsVO.getAuthorId());
					groupsVO.setGroupId(grs.getUserGroupId());
					groupsVO.setGroupName(grs.getName().length()>50?
							grs.getName().substring(0, 47)+Constant.COMMON_STRING_CONSTANT_THREE_DOTS:grs.getName());
					groupsVO.setGroupLongName(grs.getName());
					String userName = author.getFirstName() + StringPool.SPACE+ author.getLastName();
					String userPic = author.getPortraitURL(themeDisplay);
					/*if(CommonUtil.isAnonymous(author)){
						userName = Constant.ANONYMOUS_NAME;
						userPic = Constant.ANONYMOUS_PIC;
					}*/
					
					groupsVO.setUserName(userName);
					groupsVO.setUserImage(userPic);
					groupsVO.setViewCount(CommonUtil.getViewCount(
							UserGroup.class.getName(), grs.getUserGroupId()));
					groupsVO.setUploadedTime(CommonUtil.getDatesDuration(grs.getCreateDate()
							.getTime(), 0));
					groupsVO.setMemberSize(UserLocalServiceUtil.getUserGroupUsers(grs.getUserGroupId()).size());
					groupsVO.setLabel(Constant.JOIN);
					groupsVO.setClasses(Constant.BTN_BTN_WARNING);
					groupsVO.setDataSub(Constant.SUBSCRIBE);
					
					boolean groupPrivacy =false;
					try{
						NYUUserGroup nyuUG=NYUUserGroupLocalServiceUtil.getNYUUserGroup(grs.getUserGroupId());
						
						String administartors = nyuUG.getAdministrators();
						if(administartors.contains(Long.toString(groupsVO.getAuthorId())))
						{
							groupsVO.setAdministrator(true);
						}else{
							groupsVO.setAdministrator(false);
						}
						
						groupsVO.setAppreciateCount(nyuUG.getAppreciateCount());
						
						if(nyuUG.getGroupPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC)){
							groupPrivacy =false;
						}else{
							groupPrivacy = true;
						}
					}catch(NoSuchNYUUserGroupException nyuExp){
						groupPrivacy =GetterUtil.getBoolean(grs.getExpandoBridge().getAttribute(Constant.GOROUP_PRIVACY));
						groupsVO.setAppreciateCount(CommonUtil
								.getAppreciatedCount(grs.getExpandoBridge().getAttribute(Constant.APPRECIATE).toString()));
					}
					boolean isRequestedUser = false;
					UserGroupRequest userGroupRequest = null;
					if(Validator.isNotNull
							(UserGroupRequestLocalServiceUtil.getRequestStatusByUsers
									(grs.getUserGroupId(),themeDisplay.getUserId()))){
						userGroupRequest = UserGroupRequestLocalServiceUtil.getRequestStatusByUsers
													(grs.getUserGroupId(),themeDisplay.getUserId());
						if(userGroupRequest.getStatus().equals(Constant.KEYWORD_STATUS_REQUEST))
							isRequestedUser=true;
					}
															
					if(groupPrivacy && grs.getUserId()!=themeDisplay.getUserId() && !isRequestedUser)
					{
						groupsVO.setLabel(Constant.REQUEST_TO_JOIN_STRING);
						groupsVO.setClasses(Constant.BTN_BTN_INFO);
						groupsVO.setDataSub(Constant.REQUEST_JOIN);
						
					}
					else if(groupPrivacy && grs.getUserId()!=themeDisplay.getUserId() && isRequestedUser)
					{
						groupsVO.setLabel(Constant.UNREQUEST);
						groupsVO.setClasses(Constant.BTN_BTN_PRIMARY);
						groupsVO.setDataSub(Constant.UN_REQUEST);
					}
					
					if(usergroupids.contains(grs.getUserGroupId()))
					{
						groupsVO.setLabel(Constant.LEAVE);
						groupsVO.setClasses(Constant.BTN);
						groupsVO.setDataSub(Constant.UN_SUBSCRIBE);
					}
					
					groupsVO.setGroupPrivacy(groupPrivacy);
					Role NyuAdminRole = RoleLocalServiceUtil.getRole(themeDisplay.getCompanyId(), Constant.PORTAL_ADMIN_ROLE);
					if(themeDisplay.getUser().getRoles().contains(NyuAdminRole)){
						groupsVO.setUserID(grs.getUserId());
					}else{
						groupsVO.setUserID(themeDisplay.getUserId());
					}
					List<AssetCategory> categoriesList = null;
					List<AssetTag> tagList = null;
					List<CategoryTagsVO> categoryVOList = new ArrayList<CategoryTagsVO>();
					List<CategoryTagsVO> tagsVOList = new ArrayList<CategoryTagsVO>();
					try {
						categoriesList = AssetCategoryLocalServiceUtil
								.getCategories(UserGroup.class.getName(),
										grs.getUserGroupId());
						tagList = AssetTagLocalServiceUtil
								.getTags(UserGroup.class.getName(),grs.getUserGroupId());
						for(AssetCategory category:categoriesList){
							CategoryTagsVO ctVO = new CategoryTagsVO();
							ctVO.setId(category.getCategoryId()+StringPool.BLANK);
							ctVO.setName(category.getName());
							categoryVOList.add(ctVO);
						}
						for(AssetTag tag:tagList){
							CategoryTagsVO ctVO = new CategoryTagsVO();
							ctVO.setId(tag.getTagId()+StringPool.BLANK);
							ctVO.setName(tag.getName());
							tagsVOList.add(ctVO);
						}
					}catch (Exception e) {
						_log.error(e);
					}
					
					groupsVO.setCategories(categoryVOList);
					groupsVO.setTags(tagsVOList);
					groupsVO.setDescription(grs.getDescription());
					

					String documentPath=themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.GROUP_CARD_PLACEHOLDER;
					LayoutSet publicLS=LayoutSetLocalServiceUtil.getLayoutSet(grs.getGroupId(), false);
					LayoutSet privateLS=LayoutSetLocalServiceUtil.getLayoutSet(grs.getGroupId(), true);
					
					
					
					if(publicLS.getLogo()){
						documentPath=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+publicLS.getLogoId();
						documentPath = documentPath!=null? documentPath+"&t="+currentTime : documentPath;
					}
					if(privateLS.getLogo()){
						documentPath=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+privateLS.getLogoId();
						documentPath = documentPath!=null? documentPath+"&t="+currentTime : documentPath;
					}
					
					if(documentPath==null || documentPath.equals(StringPool.BLANK))
						documentPath=themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.GROUP_CARD_PLACEHOLDER;
					groupsVO.setDocumentPath(documentPath);
					groupsVOList.add(groupsVO);
					 
			}
		}
		String jsonGroups = JSONFactoryUtil.looseSerializeDeep(groupsVOList);
		return jsonGroups;

	}
	
	public static String getJSONRequestLessons(List<RequestLesson> requestLessons,
			ThemeDisplay themeDisplay) throws PortalException, SystemException { 
		List<RequestLessonVO> requestLessonVOList = new ArrayList<RequestLessonVO>();
		if (requestLessons != null && requestLessons.size() > 0) {
			for (RequestLesson reql : requestLessons) {
				RequestLessonVO requestLessonVO = new RequestLessonVO();
					requestLessonVO.setCreatedBy(reql.getCreatedBy());
					User author = CommonUtil.getAuthor(requestLessonVO.getCreatedBy());
					requestLessonVO.setRequestLessonId(reql.getRequestLessonId());
					requestLessonVO.setDescription(reql.getDescription());
					requestLessonVO.setRequestLessonName(reql.getName().length()>20?
							reql.getName().substring(0, 17)+Constant.COMMON_STRING_CONSTANT_THREE_DOTS:reql.getName());
					String userName = author.getFirstName() + StringPool.SPACE+ author.getLastName();
					String userPic = author.getPortraitURL(themeDisplay);
					/*if(CommonUtil.isAnonymous(author)){
						userName = Constant.ANONYMOUS_NAME;
						userPic = Constant.ANONYMOUS_PIC;
					}*/
					requestLessonVO.setUserName(userName);
					requestLessonVO.setUserImage(userPic);
					requestLessonVO.setAppreciateCount(CommonUtil
							.getAppreciatedCount(reql.getAppreciatedUserIds()));
					requestLessonVO.setCreatedDate(CommonUtil.getDatesDuration(reql
							.getCreatedDate().getTime(), 0));
					requestLessonVO.setUserId(themeDisplay.getUserId());
					requestLessonVO.setAcceptedBy(reql.getAcceptedBy());
					
					requestLessonVO.setAppreciatedUserIds(reql.getAppreciatedUserIds());
					requestLessonVO.setStatusValue(Constant.REQUEST_LESSON_STATUS_IN_PROGRESS);
					requestLessonVO.setStatus(reql.getStatus());
					requestLessonVO.setPublishStatusValue(Constant.CLOSED);

					List<String> items = new ArrayList<String>();
					if (requestLessonVO.getAppreciatedUserIds()!=null && !requestLessonVO.getAppreciatedUserIds().isEmpty()) {
						items = Arrays.asList(requestLessonVO.getAppreciatedUserIds().split(StringPool.COMMA));
						requestLessonVO.setHasAppreciated(items.contains(themeDisplay.getUserId()+StringPool.BLANK));
					}
					
					if(reql.getAcceptedNote() != null){
					requestLessonVO.setAcceptedNote((reql.getAcceptedNote().length()>80?
							reql.getAcceptedNote().substring(0, 80)+Constant.COMMON_STRING_CONSTANT_THREE_DOTS:reql.getAcceptedNote()));
					}
					
					List<AssetCategory> categoriesList = null;
					List<AssetTag> tagList = null;
					List<CategoryTagsVO> categoryVOList = new ArrayList<CategoryTagsVO>();
					List<CategoryTagsVO> tagsVOList = new ArrayList<CategoryTagsVO>();
					List<MBMessageVO> mbMessageVOList = new ArrayList<MBMessageVO>();
					try {
						categoriesList = AssetCategoryLocalServiceUtil
								.getCategories(RequestLesson.class.getName(),
										reql.getRequestLessonId());
						tagList = AssetTagLocalServiceUtil
								.getTags(RequestLesson.class.getName(),reql.getRequestLessonId());
						

						long requestLessonNameId = ClassNameLocalServiceUtil.getClassNameId(RequestLesson.class);
						DynamicQuery dynamicQuery2 = DynamicQueryFactoryUtil.forClass(MBMessage.class);
						dynamicQuery2.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(reql.getRequestLessonId()));
						dynamicQuery2.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(requestLessonNameId));
						
						List<MBMessage> reverseList = MBMessageLocalServiceUtil.dynamicQuery(dynamicQuery2);
						
						for(MBMessage message : reverseList){
							MBMessageVO mbmVO = new MBMessageVO();
							mbmVO.setUserName(message.getUserName());
							mbmVO.setMessageBody(message.getBody());
							mbMessageVOList.add(mbmVO);
						}
						for(AssetCategory category:categoriesList){
							CategoryTagsVO ctVO = new CategoryTagsVO();
							ctVO.setId(category.getCategoryId()+StringPool.BLANK);
							ctVO.setName(category.getName());
							categoryVOList.add(ctVO);
						}
						for(AssetTag tag:tagList){
							CategoryTagsVO ctVO = new CategoryTagsVO();
							ctVO.setId(tag.getTagId()+StringPool.BLANK);
							ctVO.setName(tag.getName());
							tagsVOList.add(ctVO);
						}
					}catch (Exception e) {
						_log.error(e);
					}
					requestLessonVO.setMbMessages(mbMessageVOList);
					requestLessonVO.setCategories(categoryVOList);
					requestLessonVO.setTags(tagsVOList);
					requestLessonVOList.add(requestLessonVO);
			}
		}
		String jsonRequestLessons = JSONFactoryUtil.looseSerializeDeep(requestLessonVOList);
		return jsonRequestLessons;

	}
	
	
	
	public static String getJSONNyuLessonObjectives(List<LessonObjectives> lessonObjectives,
			ThemeDisplay themeDisplay) throws PortalException, SystemException { 
		List<NyuObjectivesVO> nyuObjectivesVOList = new ArrayList<NyuObjectivesVO>();
		if (lessonObjectives != null && lessonObjectives.size() > 0) {
			for (LessonObjectives lsno : lessonObjectives) {
				NyuObjectivesVO nyuObjectivesVO = new NyuObjectivesVO();
				nyuObjectivesVO.setLessonId(lsno.getLessonId());
				nyuObjectivesVO.setLessonObjective(lsno.getObjective());
				nyuObjectivesVO.setObjectiveId(lsno.getId());
				nyuObjectivesVO.setModifiedDate(new Date(System.currentTimeMillis()));
				nyuObjectivesVOList.add(nyuObjectivesVO);
			}
		}
		String jsonObjectives = JSONFactoryUtil.looseSerializeDeep(nyuObjectivesVOList);
		return jsonObjectives;
	}
	
	public static void getViewAdvanceLesson(RenderRequest request,RenderResponse response) {   
		long lessonId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		Lesson lesson = null;
		boolean userPermissionToAccess = false;
		try {
			lesson = LessonLocalServiceUtil.getLesson(lessonId);
			userPermissionToAccess = (getlessonAccessPermission(request,lesson, themeDisplay.getUserId(),lesson.getCurrentAuthor()) );
		}catch (Exception e) {
		}
		request.setAttribute(Constant.USER_PERMISSION_TO_ACCESS, userPermissionToAccess);
		if(userPermissionToAccess && lesson != null){
		try {
			getUserGroupDetails(request, themeDisplay, lesson);
			getUserDetails(request, themeDisplay, lesson);
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_PRIVACY,lesson.getLessonPrivacy());
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_PERMISSION, lesson.getPermission());
			
			if(lesson.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR)){
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_PRIVACY, CommonUtil.JavaClassI18N(request, themeDisplay, "x-community-any-alumnus-faculty-staff-or-student",Constant.CURRENT_BRAND_NAME));
			}else if(lesson.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE) || lesson.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_USER)){
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_PRIVACY, CommonUtil.JavaClassI18N(request, themeDisplay, "private-list-via-group-or-by-invitation-only"));
			}else{
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_PRIVACY, CommonUtil.JavaClassI18N(request, themeDisplay, "general-public-via-social-media-etc"));
			}
			
			if(lesson.getPermission().equals(Constant.LESSON_PERMISSION_VIEW_ONLY)){
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_PERMISSION_ICON,Constant.COMMON_STRING_CONSTANT_ICON_LOCK);
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_PERMISSION_TOOL_TIP, CommonUtil.JavaClassI18N(request, themeDisplay, "view-only"));
			}else if(lesson.getPermission().equals(Constant.LESSON_PERMISSION_VIEW_REUSE)){
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_PERMISSION_ICON,Constant.COMMON_STRING_CONSTANT_ICON_UNLOCK);
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_PERMISSION_TOOL_TIP, "View and Reuse.");
			}else if(lesson.getPermission().equals(Constant.LESSON_PERMISSION_VIEW_REUSE_ATTRIBUTION)){
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_PERMISSION_ICON,Constant.COMMON_STRING_CONSTANT_ICON_SHARE_ALT);
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_PERMISSION_TOOL_TIP, CommonUtil.JavaClassI18N(request, themeDisplay, "view-and-reuse-with-attribution"));
			}
			
			User author= UserLocalServiceUtil.getUser(lesson.getCurrentAuthor());
			String userName = author.getFirstName() + StringPool.SPACE+ author.getLastName();
			String userPic = author.getPortraitURL(themeDisplay);
			String userAbout = GetterUtil.getString(author.getExpandoBridge().getAttribute(Constant.EXPANDO_FIELD_AUTHOR_INFO),StringPool.BLANK);
			String authorName = userName;
			String aboutAuthor = userAbout;
			String authorImg = userPic;
		
		
			if(lesson.getPublishWithProfile()>0l && lesson.getPublishedProfile().equals(Constant.PUBLISH_WITH_GROUPPROFILE)){
				UserGroup userGroup=UserGroupLocalServiceUtil.getUserGroup(lesson.getPublishWithProfile());
				String documentPath=themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.GROUP_CARD_PLACEHOLDER;
				LayoutSet publicLS=LayoutSetLocalServiceUtil.getLayoutSet(userGroup.getGroupId(), false);
				LayoutSet privateLS=LayoutSetLocalServiceUtil.getLayoutSet(userGroup.getGroupId(), true);
				
				if(publicLS.getLogo()){
					documentPath=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+publicLS.getLogoId();	
				}
				if(privateLS.getLogo()){
					documentPath=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+privateLS.getLogoId();
				}
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_GROUP_PATH_DOCUMENT_PATH, documentPath);
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME, userGroup.getName());
			}else if(lesson.getPublishWithProfile()>0l && lesson.getPublishedProfile().equals(Constant.PUBLISH_WITH_USERPROFILE)){
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_PUBLISHED_PROFILE, lesson.getPublishedProfile());
			}
			
			String lessonThumbnail = CommonUtil.getDocumentPath
					(lessonId,ClassNameLocalServiceUtil.getClassNameId(Lesson.class.getName()), themeDisplay);
			
			PortletURL editUrl = PortletURLFactoryUtil.create(request, Constant.PORTLET_CREATE_LESSON, themeDisplay.getPlid(), PortletRequest.RENDER_PHASE);
			editUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_STRING_CONSTANT_EDIT_LESSON);
			editUrl.setWindowState(LiferayWindowState.MAXIMIZED);
			editUrl.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lessonId+StringPool.BLANK);
			
			if(Validator.isNull(lessonThumbnail) || lessonThumbnail.equals(StringPool.BLANK)){
				lessonThumbnail=themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER;
			}
			int viewCount = CommonUtil.getViewCount(Lesson.class.getName(), lesson.getLessonId());
			boolean hasAppreciated =false;
			boolean hasAdminRights = false;
			boolean isLessonOwner = false;
			boolean isCoAuthor = false;
			Date uploadTime = lesson.getUploadedTime();
			int appreciatedCount = 0;
			if(author.getUserId() != themeDisplay.getUserId()){ 
				viewCount = CommonUtil.getIncrementedViewCount(themeDisplay.getUserId(), Lesson.class.getName(), lesson.getLessonId());
			}
			else{
				viewCount = CommonUtil.getViewCount(Lesson.class.getName(), lesson.getLessonId());
			}
			
			String appreciatedUserIds = lesson.getAppreciatedUserIds();
			List<String> items = new ArrayList<String>();
			if (!appreciatedUserIds.isEmpty()) {
				items = Arrays.asList(appreciatedUserIds.split(StringPool.COMMA));
				hasAppreciated = items.contains(themeDisplay.getUserId()+StringPool.BLANK);
				appreciatedCount = items.size();
			}
			if(author.getUserId() == themeDisplay.getUserId())
			{
				//hasAppreciated = true;
				hasAdminRights = true;
				isLessonOwner = true;
			}
			if(PortalUtil.isOmniadmin(themeDisplay.getUserId()) || PortalUtil.isCompanyAdmin(themeDisplay.getUser()) || request.isUserInRole(Constant.PORTAL_ADMIN_ROLE)){
				hasAdminRights = true;
			}
			LessonCollaboration lessonCollaboration = LessonCollaborationLocalServiceUtil.getUserExistence(lessonId, themeDisplay.getUserId());
			if(lessonCollaboration != null){
				if(lessonCollaboration.getType().equals(Constant.LESSON_ACCESS_CAN_EDIT)){
					hasAdminRights = true;
					isCoAuthor = true;
				}
			}
			request = (RenderRequest)getDocumentListAndIdsAsArray(request, lesson); 
			request.setAttribute(Constant.COMMON_LESSON_THUMBNAIL, lessonThumbnail);
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,lesson.getLessonName());
			request.setAttribute(Constant.COMMON_CITATION_LESSON_NAME,lesson.getLessonName());
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lesson.getLessonId());
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_DESCRIPTION, lesson.getDescription());
			request.setAttribute(Constant.COMMON_AUTHOR_NAME,authorName);
			request.setAttribute(Constant.COMMON_ABOUT_AUTHOR,aboutAuthor);
			request.setAttribute(Constant.COMMON_AUTHOR_IMG,authorImg);
			request.setAttribute(Constant.COMMON_VIEW_COUNT, viewCount);
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_APPRECIATED_COUNT, appreciatedCount);
			request.setAttribute(Constant.COMMON_HAS_APPRECIATED, hasAppreciated);
			request.setAttribute(Constant.COMMON_HAS_ADMIN_RIGHTS, hasAdminRights);
			request.setAttribute(Constant.COMMON_IS_LESSON_OWNER, isLessonOwner);
			request.setAttribute(Constant.COMMON_IS_CO_AUTHOR, isCoAuthor);
			request.setAttribute(Constant.COMMON_EDIT_URL, editUrl);
			if(Validator.isNotNull(lesson.getPublishWithProfile()) && lesson.getPublishWithProfile() > 0){
				request.setAttribute(Constant.COMMON_CONTRIBUTOR_URL,getUserGroupUrl(request, themeDisplay,lesson.getPublishWithProfile()));
			}else{
				request.setAttribute(Constant.COMMON_CONTRIBUTOR_URL,getContributorUrl(request, themeDisplay, lesson.getCurrentAuthor(),lesson.getLessonId()));
			}
			if(ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_ACTION,StringPool.BLANK).equals(Constant.COMMON_SHOW_DOCUMENT)){
				request.setAttribute(Constant.COMMON_SHOW_SCRIPT_VALUES,Constant.COMMON_NO);
			}
			if(uploadTime != null)
			request.setAttribute(Constant.COMMON_LESSON_DURATION,CommonUtil.getDatesDuration(uploadTime.getTime(), 0));
			
			request.setAttribute(Constant.COMMON_CITATION_DATE, dateAsPerFormatForCitation(uploadTime, Constant.E_MMM_D_Y));
			lastViewDateOfLesson(lessonId, Constant.CAPITAL_LESSON, CommonUtil.JavaClassI18N(request, themeDisplay, "view-lesson"), request);
		} catch (PortalException e) {
			_log.error(e);
		} catch (SystemException e) {
			_log.error(e);
		} catch (WindowStateException e) {
			_log.error(e);
		} catch (Exception e) {
			_log.error(e);
		}
		}
		
	}

	private static void getUserGroupDetails(RenderRequest request,
			ThemeDisplay themeDisplay, Lesson lesson) throws SystemException {
		List<UserGroup> allUserGroupList = null;
		if(request.isUserInRole(Constant.PORTAL_ADMIN_ROLE)){
			allUserGroupList = UserGroupLocalServiceUtil.getUserGroups(-1, -1);
		}else{
			allUserGroupList = UserGroupLocalServiceUtil.getUserUserGroups(themeDisplay.getUserId());
		}
		List<UserGroup> lessonMapping = Lesson_UsergroupsLocalServiceUtil.getGroupsByLessonId(lesson.getLessonId());
		List<Long> lessonMappingIds = new ArrayList<Long>();
		String userGroupIds = StringPool.BLANK;
		if(Validator.isNotNull(lesson.getPublishWithProfile()) && lesson.getPublishWithProfile() > 0 && lesson.getPublishedProfile().equals(Constant.PUBLISH_WITH_GROUPPROFILE)){
			userGroupIds = lesson.getPublishWithProfile()+StringPool.BLANK;
		}
		for(UserGroup lessonMap:lessonMapping){
			lessonMappingIds.add(lessonMap.getUserGroupId());
			if(userGroupIds.isEmpty()){
				userGroupIds = lessonMap.getUserGroupId()+StringPool.BLANK;
			}else{
				if(lesson.getPublishWithProfile() != lessonMap.getUserGroupId()){
					userGroupIds =userGroupIds+StringPool.COMMA+lessonMap.getUserGroupId()+StringPool.BLANK;
				}
			}
		}
		JSONArray userGroupArray =JSONFactoryUtil.createJSONArray();
		
		
		for(UserGroup usergroup: allUserGroupList){
			JSONObject jsonObject = JSONFactoryUtil.createJSONObject();
			jsonObject.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID, usergroup.getUserGroupId());
			jsonObject.put(Constant.COMMON_STRING_CONSTANT_NAME, usergroup.getName());
			if(lessonMappingIds.contains(usergroup.getUserGroupId())){
				jsonObject.put(Constant.COMMON_STRING_CONSTANT_IS_CHECKED_LOWER, Constant.COMMON_STRING_CONSTANT_TRUE);
			}else
			{
				jsonObject.put(Constant.COMMON_STRING_CONSTANT_IS_CHECKED_LOWER, Constant.COMMON_STRING_CONSTANT_FALSE);
			}
			if(lesson.getPublishWithProfile()==usergroup.getUserGroupId()){
				jsonObject.put(Constant.COMMON_STRING_CONSTANT_IS_CHECKED_LOWER, Constant.COMMON_STRING_CONSTANT_TRUE);
			}
			userGroupArray.put(jsonObject);
		}
		
		request.setAttribute(Constant.COMMON_HIDDEN_USER_GROUP_IDS, userGroupIds);
		request.setAttribute(Constant.COMMON_USER_GROUP_ARRAY,userGroupArray);
	}
	
	private static void getUserDetails(RenderRequest request,
			ThemeDisplay themeDisplay, Lesson lesson) throws SystemException {
		List<User> allUserList = UserLocalServiceUtil.getUsers(-1, -1);
		List<LessonCollaboration> lessonMapping = LessonCollaborationLocalServiceUtil.getallLessonAccessPermissionByLessonId(lesson.getLessonId(),Constant.COMMON_STRING_CONSTANT_TRUE);
		List<Long> lessonMappingIds = new ArrayList<Long>();
		String userIds = StringPool.BLANK;
		for(LessonCollaboration lessonMap:lessonMapping){
			lessonMappingIds.add(lessonMap.getUserId());
			if(userIds.isEmpty()){
				userIds = lessonMap.getUserId()+StringPool.BLANK;
			}else{
				userIds =userIds+StringPool.COMMA+lessonMap.getUserId()+StringPool.BLANK;
			}
		}
		JSONArray userArray =JSONFactoryUtil.createJSONArray();
		for(User user: allUserList){
			JSONObject jsonObject = JSONFactoryUtil.createJSONObject();
			jsonObject.put(Constant.COMMON_STRING_CONSTANT_USER_ID, user.getUserId());
			jsonObject.put(Constant.COMMON_STRING_CONSTANT_NAME, user.getFullName());
			if(lessonMappingIds.contains(user.getUserId())){
				jsonObject.put(Constant.COMMON_STRING_CONSTANT_IS_CHECKED_LOWER, Constant.COMMON_STRING_CONSTANT_TRUE);
			}else
			{
				jsonObject.put(Constant.COMMON_STRING_CONSTANT_IS_CHECKED_LOWER, Constant.COMMON_STRING_CONSTANT_FALSE);
			}
			if(lesson.getAuthor() != user.getUserId() && (!user.getFullName().isEmpty())){
				userArray.put(jsonObject);
			}
		}
		request.setAttribute(Constant.COMMON_HIDDEN_USER_IDS, userIds);
		request.setAttribute(Constant.COMMON_USER_ARRAY,userArray);
	}
	private static String getContributorUrl(PortletRequest request,
			ThemeDisplay themeDisplay, long userId,long classPK) throws SystemException {
		PortletURL contributorUrl = null;
		try {
			long contibutorPageLayoutId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true, Constant.PAGE_CONTRIBUTOR).getPlid();
			contributorUrl = PortletURLFactoryUtil.create(request,Constant.PORTLET_CONTRIBUTOR,contibutorPageLayoutId,PortletRequest.RENDER_PHASE);
			contributorUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION,Constant.LESSON_AND_REQUESTS);
			contributorUrl.setParameter(Constant.COMMON_STRING_CONSTANT_USER_ID,userId+StringPool.BLANK);
			if(classPK >0){
				contributorUrl.setParameter(Constant.COMMON_STRING_CONSTANT_CLASS_PK,classPK+StringPool.BLANK);
			}
			contributorUrl.setWindowState(request.getWindowState().NORMAL);
		} catch (Exception e) {
			return StringPool.POUND;
		}
		if(themeDisplay.isSignedIn() && themeDisplay.getLayout().isPrivateLayout()){
			return contributorUrl.toString();
		}else{
			return StringPool.POUND;
		}
	}
		
	public static String dateAsPerFormat(String format){
		SimpleDateFormat sdf = new SimpleDateFormat(format);
	    Date convertedCurrentDate;
		convertedCurrentDate = new Date();
	    String date=sdf.format(convertedCurrentDate );
	    return date;
	}
	
	public static String dateAsPerFormatForCitation(Date citationDate, String format){
		SimpleDateFormat sdf = new SimpleDateFormat(format);
	    Date convertedCurrentDate;
		convertedCurrentDate = citationDate;
	    String date=sdf.format(convertedCurrentDate );
	    return date;
	}
	
	public static void emailNotification(long sender,long receiver,String subject,String message,String TemplateUrl,VelocityContext velocityContext) throws AddressException, PortalException, SystemException, IOException {  
		String fromAddress=UserLocalServiceUtil.getUser(sender).getEmailAddress();
		String toAddress=UserLocalServiceUtil.getUser(receiver).getEmailAddress();
		if(sender == receiver){
			fromAddress = Constant.VENDOR_FROM_ADDRESS_MAIL;
		}
		InternetAddress from = new InternetAddress(fromAddress);
		InternetAddress[] to = new InternetAddress[1];
		to[0] = new InternetAddress(toAddress);
		String body = VelocityParse(TemplateUrl,velocityContext);
		
		MailMessage mailMessage = new MailMessage();
		mailMessage.setFrom(from);
		mailMessage.setTo(to);
		mailMessage.setBody(body);
		mailMessage.setSubject(subject);
		mailMessage.setHTMLFormat(true);
		
		MailServiceUtil.sendEmail(mailMessage);
		}
	
	public static String VelocityParse(String TemplateUrl,VelocityContext velocityContext) {
		VelocityEngine velocity = new VelocityEngine();
		velocity.setProperty(RuntimeConstants.RESOURCE_LOADER, Constant.COMMON_STRING_CONSTANT_CLASS_PATH);
		velocity.setProperty(Constant.CLASSPATH_RESOURCE_LOADER_CLASS,
				ClasspathResourceLoader.class.getName());
		try {
			velocity.init();
			Template t = velocity
					.getTemplate(TemplateUrl);
			VelocityContext ctx = velocityContext;
			Writer writer = new StringWriter();
			t.merge(ctx, writer);
			return writer.toString();
		} catch (Exception e) {
			_log.error(e);
		}
		return StringPool.BLANK;
	
	}

	public static void lastViewDateOfLesson(long classPK,String className,String EventType,PortletRequest request){
		try {
			DynamicQuery auditReportQuery = DynamicQueryFactoryUtil.forClass(AuditReport.class);
			auditReportQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(classPK+StringPool.BLANK));
			auditReportQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME).eq(className));
			auditReportQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_EVENT_TYPE).eq(EventType));
			auditReportQuery.addOrder(OrderFactoryUtil.desc(Constant.COMMON_STRING_CONSTANT_CREATE_DATE));
			List<AuditReport> auditReportList;
			auditReportList = AuditReportLocalServiceUtil.dynamicQuery(auditReportQuery);
			if(auditReportList.size() > 1){
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_LAST_VIEW_DATE, dateAsPerFormatForCitation(auditReportList.get(1).getCreateDate(), Constant.E_MMM_D_Y));
			}
		} catch (SystemException e) {
			_log.error(e);
		}
	}
	
	public static String getCategoryIdsAsString(long classPK,String className){
		long categoryIds[];
		String categoryStringIds =StringPool.BLANK;
		try {
			categoryIds = AssetCategoryLocalServiceUtil.getCategoryIds(className, classPK);
			categoryStringIds =StringPool.BLANK; 
			for (int i = 0; i < categoryIds.length; i++){
				if(categoryStringIds.equals(StringPool.BLANK)){
					categoryStringIds = categoryIds[i]+StringPool.BLANK;
				}else{
					categoryStringIds =categoryStringIds+StringPool.COMMA+categoryIds[i];
				}
			}
		} catch (SystemException e) {
			_log.error(e);
		}
		return categoryStringIds;
	}
	
	public static String getTagSelectedNamesAsString(long classPK,String className){
		String tagSelectedNames[];
		String tagSelectedStringNames =StringPool.BLANK;
		try {
			tagSelectedNames = AssetTagLocalServiceUtil.getTagNames(className, classPK);
			tagSelectedStringNames =StringPool.BLANK; 
			for (int i = 0; i < tagSelectedNames.length; i++){
				if(tagSelectedStringNames.equals(StringPool.BLANK)){
					tagSelectedStringNames = tagSelectedNames[i];
				}else{
					tagSelectedStringNames =tagSelectedStringNames+StringPool.COMMA+tagSelectedNames[i];
				}
			}
			
		} catch (SystemException e) {
			_log.error(e);
		}
		return tagSelectedStringNames;
	}
	
	public static void addUpadteAssetEntry(UploadPortletRequest request,ServiceContext serviceContext,long classPk,String className){
		
		String categoryStringIds[] = ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_CATEGORIES_SELECTED_IDS).trim().split(StringPool.COMMA);
		if(categoryStringIds.length == 1 && categoryStringIds[categoryStringIds.length-1].equals(StringPool.BLANK) ){
			categoryStringIds = new String[0];
		}
		long[] categoryIds = new long[categoryStringIds.length];
		for (int i = 0; i < categoryStringIds.length; i++){
			if(Validator.isNotNull(categoryStringIds[i].trim())){
				categoryIds[i] = Long.parseLong(categoryStringIds[i]);
			}
		}
		
		String[] tagStringNames = ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_TAGS_SELECTED_NAMES).trim().split(StringPool.COMMA);
		if(tagStringNames.length == 1 && tagStringNames[tagStringNames.length-1].equals(StringPool.BLANK) ){
			tagStringNames = new String[0];
		}
		
		try {
			AssetEntryLocalServiceUtil.updateEntry(serviceContext.getUserId(), serviceContext.getScopeGroupId(), 
					className, classPk,categoryIds, tagStringNames);
		} catch (PortalException e) {
			_log.error(e);
		} catch (SystemException e) {
			_log.error(e);
		}
	}
	
	public static List<LessonVO> getlessonVOList(Set<Lesson> lessons,ThemeDisplay themeDisplay){
		List<LessonVO> lessonsVOList =new ArrayList<LessonVO>();
		if (lessons != null && lessons.size() > 0) {
			for (Lesson lsn : lessons) {
				if(lsn.getStatus().equals(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH)){	
					LessonVO LessonVO = new LessonVO();
					LessonVO.setAuthorId(lsn.getCurrentAuthor());
					User author = CommonUtil.getAuthor(LessonVO.getAuthorId());
					LessonVO.setLessonId(lsn.getLessonId());
					LessonVO.setStatus(lsn.getStatus());
					LessonVO.setLessonName(lsn.getLessonName().length()>53?
							lsn.getLessonName().substring(0, 50)+Constant.COMMON_STRING_CONSTANT_THREE_DOTS:lsn.getLessonName());
					LessonVO.setLessonFullName(lsn.getLessonName());
					
					String userName = author.getFirstName() + StringPool.SPACE+ author.getLastName();
					String userPic = Constant.ANONYMOUS_PIC;
					try {
						userPic = author.getPortraitURL(themeDisplay);
					} catch (PortalException e1) {
						e1.printStackTrace();
					} catch (SystemException e1) {
						e1.printStackTrace();
					}
					
					LessonVO.setUserName(userName);
					LessonVO.setUserImage(userPic);
					
					LessonVO.setAppreciateCount(CommonUtil
							.getAppreciatedCount(lsn.getAppreciatedUserIds()));
					LessonVO.setViewCount(CommonUtil.getViewCount(
							Lesson.class.getName(), lsn.getLessonId()));
					if(lsn.getUploadedTime() != null){
					LessonVO.setUploadedTime(CommonUtil.getDatesDuration(lsn
							.getUploadedTime().getTime(), 0));
					}
					
					if(lsn.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC)){
						LessonVO.setPrivacyIcon(Constant.COMMON_STRING_CONSTANT_ICON_GLOBE);
					}else if(lsn.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE) || lsn.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_USER)){
						LessonVO.setPrivacyIcon(Constant.COMMON_STRING_CONSTANT_ICON_USER);
					}else if(lsn.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR)){
						LessonVO.setPrivacyIcon(Constant.COMMON_STRING_CONSTANT_ICON_GROUP);
					}
					
					List<AssetCategory> categoriesList = null;
					List<AssetTag> tagList = null;
					List<CategoryTagsVO> categoryVOList = new ArrayList<CategoryTagsVO>();
					List<CategoryTagsVO> tagsVOList = new ArrayList<CategoryTagsVO>();
					try {
						categoriesList = AssetCategoryLocalServiceUtil
								.getCategories(Lesson.class.getName(),
										lsn.getLessonId());
						tagList = AssetTagLocalServiceUtil
								.getTags(Lesson.class.getName(),lsn.getLessonId());
						for(AssetCategory category:categoriesList){
							CategoryTagsVO ctVO = new CategoryTagsVO();
							ctVO.setId(category.getCategoryId()+StringPool.BLANK);
							ctVO.setName(category.getName());
							categoryVOList.add(ctVO);
						}
						for(AssetTag tag:tagList){
							CategoryTagsVO ctVO = new CategoryTagsVO();
							ctVO.setId(tag.getTagId()+StringPool.BLANK);
							ctVO.setName(tag.getName());
							tagsVOList.add(ctVO);
						}
					}catch (Exception e) {
						_log.error(e);
					}
					
				    LessonVO.setCategories(categoryVOList);
				    LessonVO.setTags(tagsVOList);
				    LessonVO.setDescription(lsn.getDescription());

					String documentPath=CommonUtil.getDocumentPath(lsn.getLessonId(), ClassNameLocalServiceUtil.getClassNameId(Lesson.class), themeDisplay);
					if(documentPath==null || documentPath.equals(StringPool.BLANK))
						documentPath=themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER ;
					LessonVO.setDocumentPath(documentPath);
					String userGroupDocumentPath=StringPool.BLANK;
					String userGroupName=StringPool.BLANK;
					if(lsn.getPublishWithProfile()>0l && lsn.getPublishedProfile().equals(Constant.PUBLISH_WITH_GROUPPROFILE)){
						UserGroup userGroup;
						try {
							userGroup = UserGroupLocalServiceUtil.getUserGroup(lsn.getPublishWithProfile());
							userGroupName=userGroup.getName();
							userGroupDocumentPath=themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.GROUP_CARD_PLACEHOLDER;
							LayoutSet publicLS=LayoutSetLocalServiceUtil.getLayoutSet(userGroup.getGroupId(), false);
							LayoutSet privateLS=LayoutSetLocalServiceUtil.getLayoutSet(userGroup.getGroupId(), true);
							
							if(publicLS.getLogo()){
								userGroupDocumentPath=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+publicLS.getLogoId();	
							}
							if(privateLS.getLogo()){
								userGroupDocumentPath=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+privateLS.getLogoId();
							}
						} catch (PortalException e) {
							_log.error(e);
						} catch (SystemException e) {
							_log.error(e);
						}
					}
					
					LessonVO.setUserGroupDocumentPath(userGroupDocumentPath);
					LessonVO.setUserGroupName(userGroupName);
					lessonsVOList.add(LessonVO);
				}
			}
		}
		
		return lessonsVOList;
	}
	
	public static String getJSONLessons(List<Lesson> lessons,
			ThemeDisplay themeDisplay,boolean checkCollabortor) throws PortalException, SystemException { 
		List<LessonVO> lessonVOList = new ArrayList<LessonVO>();
		if (lessons != null && lessons.size() > 0) {
			for (Lesson lsn : lessons) {
					LessonVO LessonVO = new LessonVO();
					if(checkCollabortor){
						List<LessonCollaboration> collaborationList = LessonCollaborationLocalServiceUtil
								.getLessonUsersByType(lsn.getLessonId(),Constant.LESSON_ACCESS_CAN_EDIT);
						if (Validator.isNotNull(collaborationList)
								&& collaborationList.size() > 0) {
							LessonVO.setHasCollaborator(Constant.COMMON_STRING_CONSTANT_TRUE);
						} else {
							LessonVO.setHasCollaborator(Constant.COMMON_STRING_CONSTANT_FALSE);
						}
					}
					LessonVO.setAuthorId(lsn.getCurrentAuthor());
					User author = CommonUtil.getAuthor(LessonVO.getAuthorId());
					LessonVO.setLessonId(lsn.getLessonId());
					LessonVO.setStatus(lsn.getStatus());
					LessonVO.setLessonName(lsn.getLessonName().length()>53?
							lsn.getLessonName().substring(0, 50)+Constant.COMMON_STRING_CONSTANT_THREE_DOTS:lsn.getLessonName());
					LessonVO.setLessonFullName(lsn.getLessonName());
					String userName = author.getFirstName() + StringPool.SPACE+ author.getLastName();
					String userPic = author.getPortraitURL(themeDisplay);
					
					LessonVO.setUserName(userName);
					LessonVO.setUserImage(userPic);
					
					LessonVO.setUserImage(userPic);
					
					LessonVO.setAppreciateCount(CommonUtil
							.getAppreciatedCount(lsn.getAppreciatedUserIds()));
					LessonVO.setViewCount(CommonUtil.getViewCount(
							Lesson.class.getName(), lsn.getLessonId()));
					if(lsn.getUploadedTime() != null){
					LessonVO.setUploadedTime(CommonUtil.getDatesDuration(lsn
							.getUploadedTime().getTime(), 0));
					}
					if(lsn.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC)){
						LessonVO.setPrivacyIcon(Constant.COMMON_STRING_CONSTANT_ICON_GLOBE);
					}else if(lsn.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE) || lsn.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_USER)){
						LessonVO.setPrivacyIcon(Constant.COMMON_STRING_CONSTANT_ICON_USER);
					}else if(lsn.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR)){
						LessonVO.setPrivacyIcon(Constant.COMMON_STRING_CONSTANT_ICON_GROUP);
					}
					List<AssetCategory> categoriesList = null;
					List<AssetTag> tagList = null;
					List<CategoryTagsVO> categoryVOList = new ArrayList<CategoryTagsVO>();
					List<CategoryTagsVO> tagsVOList = new ArrayList<CategoryTagsVO>();
					try {
						categoriesList = AssetCategoryLocalServiceUtil
								.getCategories(Lesson.class.getName(),
										lsn.getLessonId());
						tagList = AssetTagLocalServiceUtil
								.getTags(Lesson.class.getName(),lsn.getLessonId());
						for(AssetCategory category:categoriesList){
							CategoryTagsVO ctVO = new CategoryTagsVO();
							ctVO.setId(category.getCategoryId()+StringPool.BLANK);
							ctVO.setName(category.getName());
							categoryVOList.add(ctVO);
						}
						for(AssetTag tag:tagList){
							CategoryTagsVO ctVO = new CategoryTagsVO();
							ctVO.setId(tag.getTagId()+StringPool.BLANK);
							ctVO.setName(tag.getName());
							tagsVOList.add(ctVO);
						}
					}catch (Exception e) {
						_log.error(e);
					}
					
				    LessonVO.setCategories(categoryVOList);
				    LessonVO.setTags(tagsVOList);
				    LessonVO.setDescription(lsn.getDescription());

					String documentPath=CommonUtil.getDocumentPath(lsn.getLessonId(), ClassNameLocalServiceUtil.getClassNameId(Lesson.class), themeDisplay);
					if(documentPath==null || documentPath.equals(StringPool.BLANK))
						documentPath=themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER;
					LessonVO.setDocumentPath(documentPath);
					
					
					
					lessonVOList.add(LessonVO);
			}
		}
		String jsonLessons = JSONFactoryUtil.looseSerializeDeep(lessonVOList);
		return jsonLessons;

	}
	
	public static String createLessonUrl(PortletRequest request,
			ThemeDisplay themeDisplay,long classPK) throws SystemException {
		PortletURL LessonUrl = null;
		try {
			long contibutorPageLayoutId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true, Constant.PAGE_LESSON_BROWSE).getPlid();
			LessonUrl = PortletURLFactoryUtil.create(request,Constant.PORTLET_LESSON,contibutorPageLayoutId,PortletRequest.RENDER_PHASE);
			LessonUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION,Constant.COMMON_SHOW_DOCUMENT);
			LessonUrl.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID,classPK+StringPool.BLANK);
			LessonUrl.setWindowState(LiferayWindowState.NORMAL);
		} catch (Exception e) {
			return StringPool.POUND;
		}
		return LessonUrl.toString();
	}
	
	private static boolean getlessonAccessPermission(PortletRequest request, Lesson lesson,long userId,long authorId) throws Exception{
		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY); 
		String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE, Constant.LIFERAY_VENDOR_LESSON_PRIVACY_USER};
		 Set<Long> allPrivateLessonIds = LessonLocalServiceUtil.findPrivateLessonsIds(lessonPrivacy);
		 String privacyCheckMessage = StringPool.BLANK;
		 boolean privacyCheck;
		 if(userId > 0){
			 if(PortalUtil.isOmniadmin(userId) || PortalUtil.isCompanyAdmin(UserLocalServiceUtil.getUser(userId)) || request.isUserInRole(Constant.PORTAL_ADMIN_ROLE)){
				 privacyCheck = true;
			 }else{
				 Set<Long> userPrivateLessonIds =  LessonLocalServiceUtil.findPrivateLessonsIdsBelongToUser(userId);
				 List<LessonCollaboration> collabortionList = LessonCollaborationLocalServiceUtil.getLessonUsersByType(lesson.getLessonId(), Constant.LESSON_ACCESS_CAN_EDIT);
				 privacyCheck = allPrivateLessonIds.contains(lesson.getLessonId())? userPrivateLessonIds.contains(lesson.getLessonId()) : true;
				 if(authorId == userId){
					 privacyCheck = true;
				 }else if(!privacyCheck){
					 privacyCheckMessage = CommonUtil.JavaClassI18N(request, themeDisplay, "you-don-t-have-permission-to-access-this-lesson");
					 for(LessonCollaboration collaboration:collabortionList){
						if(collaboration.getUserId() == userId){
							privacyCheck = true;
							break;
						}
					 }
				 }
				 if(lesson.getMarkedAs().equalsIgnoreCase(Constant.MARKEDAS_QUARANTINE) || lesson.getMarkedAs().equalsIgnoreCase(Constant.LESSON_DELETED_BY_USER)){
					 if(lesson.getMarkedAs().equalsIgnoreCase(Constant.MARKEDAS_QUARANTINE)){
						 privacyCheckMessage = CommonUtil.JavaClassI18N(request, themeDisplay, "this-lesson-has-been-quarantined");
					 }else{
						 privacyCheckMessage = CommonUtil.JavaClassI18N(request, themeDisplay, "this-lesson-has-been-deleted-by-the-author");
					 }
					 privacyCheck = false;
				 }
			 }
		 }else{
			 privacyCheck = allPrivateLessonIds.contains(lesson.getLessonId()) ?false:true;
			 if(lesson.getLessonPrivacy().equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR)){
				 privacyCheck = false; 
			 }
			 privacyCheckMessage = CommonUtil.JavaClassI18N(request, themeDisplay, "you-don-t-have-permission-to-access-this-lesson");
			 if(lesson.getMarkedAs().equalsIgnoreCase(Constant.MARKEDAS_QUARANTINE) || lesson.getMarkedAs().equalsIgnoreCase(Constant.LESSON_DELETED_BY_USER)){
				 if(lesson.getMarkedAs().equalsIgnoreCase(Constant.MARKEDAS_QUARANTINE)){
					 privacyCheckMessage = CommonUtil.JavaClassI18N(request, themeDisplay, "this-lesson-has-been-quarantined");
				 }else{
					 privacyCheckMessage = CommonUtil.JavaClassI18N(request, themeDisplay, "this-lesson-has-been-deleted-by-the-author");
				 }
				 privacyCheck = false; 
			 }
		 }
		 request.setAttribute(Constant.COMMON_STRING_CONSTANT_PRIVACY_CHECK_MESSAGE, privacyCheckMessage);
		 return privacyCheck;
	}
	
	public static void getDocumentsForAddMedia(PortletRequest request){
		String[] permission = {Constant.LESSON_PERMISSION_VIEW_REUSE,Constant.LESSON_PERMISSION_VIEW_REUSE_ATTRIBUTION};
		List<DocumentFile> mediafileList=DocumentFileLocalServiceUtil.findResourceDocumentsWithPermission(Constant.COMMON_STRING_CONSTANT_RESOURCE_SPACE,Constant.DOCUMENT_STATUS_COMPLETED,permission);
		JSONArray resourceDataArray=JSONFactoryUtil.createJSONArray();
		if(Validator.isNotNull(mediafileList)){
			for(DocumentFile mediaFile:mediafileList){
				JSONObject doucumet=JSONFactoryUtil.createJSONObject();
				doucumet.put(Constant.COMMON_STRING_CONSTANT_REF_ID,mediaFile.getResourceId());
				doucumet.put(Constant.COMMON_STRING_CONSTANT_DOCUMENT_NAME,mediaFile.getDocumentName());
				doucumet.put(Constant.COMMON_STRING_CONSTANT_DOCUMENT_PATH,mediaFile.getDocumentPath());
				doucumet.put("docUuid",mediaFile.getDocUuid());
				String extension[]=mediaFile.getDocumentName().split(Constant.DOUBLE_BACK_SLASH_DOT);
				if(extension.length>1){
				doucumet.put(Constant.COMMON_STRING_CONSTANT_EXTENSION,extension[1]);
				}
				resourceDataArray.put(doucumet);
			}
		}
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_RESOURCE_DATA,resourceDataArray.toString());
	}
	public static void voilatingSection(PortletRequest request){
	String[] permission = {Constant.LESSON_PERMISSION_VIEW_REUSE,Constant.LESSON_PERMISSION_VIEW_REUSE_ATTRIBUTION};
	List<String> voilatingSection = new ArrayList<String>();
	Set<Long> resourceIds = DocumentFileLocalServiceUtil.findResourceDocumentsIdsWithPermission(Constant.COMMON_STRING_CONSTANT_RESOURCE_SPACE,permission,ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID));
	try {
		List<DocumentSection> documentSection =  DocumentSectionLocalServiceUtil.getDocumentSectionList(ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID));
		for(DocumentSection ds :documentSection){
			if(resourceIds.contains(DocumentFileLocalServiceUtil.getDocumentFile(ds.getDocumentId()).getResourceId())){
				voilatingSection.add(ds.getSectionTitle());
			}
		}
	} catch (SystemException e) {
		_log.error(e);
	} catch (PortalException e) {
		_log.error(e);
	}
	request.setAttribute(Constant.COMMON_STRING_CONSTANT_VIOLATING_SECTION, voilatingSection);
	}
	
	public static boolean isAnonymous(User user){
		int length = GetterUtil.getStringValues(user.getExpandoBridge().getAttribute(Constant.EXPANDO_FIELD_ANONYMOUS_USER)).length;
		if(length == 0){
			return false;
		}else{
			return true;
		}
	}
	
	private static String getUserGroupUrl(PortletRequest request,
			ThemeDisplay themeDisplay, long classPK) throws SystemException {
		PortletURL userGroupUrl = null;
		try {
			long userGroupPageLayoutId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true, Constant.PAGE_GROUP).getPlid();
			userGroupUrl = PortletURLFactoryUtil.create(request,Constant.PORTLET_GROUP,userGroupPageLayoutId,PortletRequest.RENDER_PHASE);
			userGroupUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION,Constant.LESSON_URL);
			if(classPK >0){
				userGroupUrl.setParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,classPK+StringPool.BLANK);
			}
			userGroupUrl.setWindowState(request.getWindowState().MAXIMIZED);
		} catch (Exception e) {
			return StringPool.POUND;
		}
		if(themeDisplay.isSignedIn() && themeDisplay.getLayout().isPrivateLayout()){
			return userGroupUrl.toString();
		}else{
			return StringPool.POUND;
		}
	}
	
	
	
	
	
	
	public static  String getGroupAnnouncements(PortletRequest request){
		
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		JSONArray annoucementJsonArray=JSONFactoryUtil.createJSONArray();
		
		long classNameId=ClassNameLocalServiceUtil.getClassNameId(UserGroup.class.getName());
		long userGroupId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
		List<AnnouncementsEntry> entries=null;
		DynamicQuery announcementQuery = DynamicQueryFactoryUtil.forClass(AnnouncementsEntry.class);
		Calendar now = Calendar.getInstance();
		now.set(Calendar.HOUR_OF_DAY, 0);
		now.set(Calendar.MINUTE, 0);
		now.set(Calendar.SECOND, 0);
		SimpleDateFormat format = new SimpleDateFormat(Constant.DD_MM_YYYY);
		Date date=null;
		try {
				date=format.parse(format.format(now.getTime()));
		} catch (ParseException e1) {
			_log.error(e1);
		}
		try {

				announcementQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(classNameId));
				announcementQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(userGroupId));
				
				
				Criterion expirationDateCriterion = null;
				expirationDateCriterion = RestrictionsFactoryUtil.ge(Constant.COMMON_STRING_CONSTANT_EXPIRATION_DATE,date);
				expirationDateCriterion=RestrictionsFactoryUtil.or(expirationDateCriterion,
				RestrictionsFactoryUtil.isNull(Constant.COMMON_STRING_CONSTANT_EXPIRATION_DATE));
				announcementQuery.add(expirationDateCriterion);
				announcementQuery.addOrder(OrderFactoryUtil.desc(Constant.COMMON_STRING_CONSTANT_CREATE_DATE));

				entries=AnnouncementsEntryLocalServiceUtil.dynamicQuery(announcementQuery);
				
				if(entries.size()>0){
					for(AnnouncementsEntry entry:entries){
						JSONObject  announcement=JSONFactoryUtil.createJSONObject();
						announcement.put(Constant.COMMON_STRING_CONSTANT_ENTRY_ID,entry.getEntryId());
						announcement.put(Constant.COMMON_STRING_CONSTANT_TITLE,entry.getTitle());
						announcement.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,entry.getUserName());
						announcement.put(Constant.COMMON_STRING_CONSTANT_USER_ID,entry.getUserId());
						announcement.put(Constant.COMMON_STRING_CONSTANT_USER_GROUP_NAME,UserGroupLocalServiceUtil.getUserGroup(entry.getClassPK()).getName());
						announcement.put(Constant.COMMON_STRING_CONSTANT_CREATED_DATE,new SimpleDateFormat(Constant.COMMON_MM_DD_YYYY_DATE_FORMAT).format(entry.getCreateDate()));
						announcement.put(Constant.COMMON_STRING_CONSTANT_USER_IMAGE,UserLocalServiceUtil.getUser(entry.getUserId()).getPortraitURL(themeDisplay));
						announcement.put(Constant.COMMON_STRING_CONSTANT_CONTENT,entry.getContent());
						
						annoucementJsonArray.put(announcement);
					}
				}
			
		} catch (SystemException e) {
			return StringPool.POUND;
		} catch (PortalException e) {
			return StringPool.POUND;
		}
		return annoucementJsonArray.toString();
		}
	
	/*
	 * added by asif
	 */
	public static String JavaClassI18N(PortletRequest request, ThemeDisplay themeDisplay, String key){
		String value = StringPool.BLANK;
		PortletConfig portletConfig = (PortletConfig)request.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);
		Locale locale = themeDisplay.getLocale();
		value = LanguageUtil.get(portletConfig, locale, key);
		return value;
	}
	
	public static String JavaClassI18N(PortletRequest request, ThemeDisplay themeDisplay, String key,String arguments){
		String value = StringPool.BLANK;
		PortletConfig portletConfig = (PortletConfig)request.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);
		Locale locale = themeDisplay.getLocale();
		value = LanguageUtil.format(portletConfig, locale, key,arguments);
		return value;
	}
	
	public static boolean hasEditRights(RenderRequest request, long loginUserId,
			Lesson lesson) throws Exception, PortalException, SystemException {
		boolean privacyCheck = false;
		List<LessonCollaboration> collabortionList = LessonCollaborationLocalServiceUtil.getLessonUsersByType(lesson.getLessonId(), Constant.LESSON_ACCESS_CAN_EDIT);
		if(PortalUtil.isOmniadmin(loginUserId) || PortalUtil.isCompanyAdmin(UserLocalServiceUtil.getUser(loginUserId)) || request.isUserInRole("nyu-admin")){
			 privacyCheck = true;
		 }else if(loginUserId == lesson.getCurrentAuthor()){
			 privacyCheck = true;
		 }else{
			for(LessonCollaboration collaboration:collabortionList){
				if(collaboration.getUserId() == loginUserId){
					privacyCheck = true;
					break;
				}
			 }
		 }
		return privacyCheck;
	}	
	
	public static void processKeyWordRequest(ResourceRequest request,ResourceResponse response) throws PortalException, SystemException, IOException{
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long keywordId = ParamUtil.getLong(request, Constant.KEYWORD_ID);
		String keywordName = ParamUtil.getString(request, Constant.KEYWORD_CAPITAL_NAME);
		long userId = themeDisplay.getUserId();
		User user = UserLocalServiceUtil.getUser(userId);
		ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
		KeywordsCollaboration keywordsCollaboration;
		keywordsCollaboration = KeywordsCollaborationLocalServiceUtil.getKeyWordCollaborationStatus(keywordId,userId);
		if(keywordsCollaboration != null){
			if(keywordsCollaboration.getStatus().equals(Constant.KEYWORD_STATUS_DECLINED))
				response.getWriter().write(CommonUtil.JavaClassI18N(request, themeDisplay, "Your-request-has-been-declined"));
			else
				response.getWriter().write(CommonUtil.JavaClassI18N(request, themeDisplay, "this-is-duplicate-request"));
		}else{
			keywordsCollaboration = new KeywordsCollaborationImpl();
			
			keywordsCollaboration.setCompanyId(themeDisplay.getCompanyId());
			keywordsCollaboration.setGroupId(themeDisplay.getScopeGroupId());
			keywordsCollaboration.setKeywordId(keywordId);
			keywordsCollaboration.setKeywordName(keywordName);
			keywordsCollaboration.setUserId(userId);
			keywordsCollaboration.setUserName(themeDisplay.getUser().getFullName());
			keywordsCollaboration.setStatus(Constant.KEYWORD_STATUS_REQUEST);
			keywordsCollaboration.setCreatedDate(new Date());
			KeywordsCollaborationLocalServiceUtil.addKeywordsCollaboration(keywordsCollaboration);
			
			JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, userId);
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,user.getFullName());
			payloadJSON.put(Constant.TYPE, Constant.KEYWORDS_REQUEST);
			payloadJSON.put(Constant.ADDITIONAL_DATA, CommonUtil.JavaClassI18N(request, themeDisplay, "has-requested-to-use-reserved-group-keyword-phrase")+" \""+keywordName+"\"");

			Set<long[]> allAdminUserIds = new HashSet<long[]>();
			Role portalAdmin = RoleLocalServiceUtil.getRole(serviceContext.getCompanyId(), Constant.PORTAL_ADMIN_ROLE);
			Role portalSuperAdmin = RoleLocalServiceUtil.getRole(serviceContext.getCompanyId(), RoleConstants.ADMINISTRATOR);
			long[] adminUserIds = UserLocalServiceUtil.getRoleUserIds(portalAdmin.getRoleId());
			long[] superAdminUserIds = UserLocalServiceUtil.getRoleUserIds(portalSuperAdmin.getRoleId());
			allAdminUserIds.addAll(Arrays.asList(adminUserIds));
			allAdminUserIds.addAll(Arrays.asList(superAdminUserIds));
			for(Long adminUser:adminUserIds){
				UserNotificationEventLocalServiceUtil
					.addUserNotificationEvent(adminUser,
							com.nyu.notification.UserGroupNotificationHandler.PORTLET_ID,
							(new Date()).getTime(), userId,
							payloadJSON.toString(), false,
							serviceContext);
			}	
			response.getWriter().write(CommonUtil.JavaClassI18N(request, themeDisplay, "requested-successfully"));
		}
		
	}
	
	public static List<DocumentVO> getDocumentList(Lesson lesson,String engageLink,long authorId){
		List<DocumentVO> documentVOList = new ArrayList<DocumentVO>();
		try{
		List<DocumentFile> documentList = DocumentFileLocalServiceUtil.getDocumentFiles(lesson.getLessonId());
		List<DocumentSection> sectionList = DocumentSectionLocalServiceUtil.getDocumentSectionList(lesson.getLessonId());
		List<String> engageTypes = null;
		
		if(Constant.ENABLE_OFFICE_PREVIEW_IN_ENGAGE){
			engageTypes =Arrays.asList((Constant.COMMON_VENDOR_ENGAGE_SUPPORTED_TYPES+","+Constant.EXPLICIT_PREVIEW_FORMATS).split(StringPool.COMMA));
		}else{
			engageTypes =Arrays.asList(Constant.COMMON_VENDOR_ENGAGE_SUPPORTED_TYPES.split(StringPool.COMMA));
		}
		
		//If Lesson Contains Sections then Process from it sectionList
		if( sectionList != null && (!sectionList.isEmpty()) ){
			for(DocumentSection section:sectionList){
				DocumentFile sectionDocument = null;
				for(DocumentFile documentFile:documentList){
					if(section.getDocumentId() == documentFile.getDocumentId()){
						sectionDocument = documentFile;
						break;
					}
				}
				if(sectionDocument != null){
					DocumentVO lessonSection = createLessonSection(lesson, engageLink, authorId, engageTypes,section, sectionDocument);
					documentVOList.add(lessonSection);
				}
			}
		}else if( documentList != null && (!documentList.isEmpty()) ){ //If it contains only documnetfiles but not section
			for(DocumentFile sectionDocument:documentList){
				DocumentVO lessonSection = createLessonSection(lesson, engageLink, authorId, engageTypes, null, sectionDocument);
				documentVOList.add(lessonSection);
			}
		}
		}catch(NullPointerException e){
			_log.error("Issue in getDocumentVOList:::::\n"+e.getMessage());
			
		}
		return documentVOList;
	}
	/*
	 * provide Individual LessonSection 
	 *  
	 * */
	private static DocumentVO createLessonSection(Lesson lesson, String engageLink,
			long authorId, List<String> engageTypes, DocumentSection section, DocumentFile sectionDocument) {
		String engageUrl;
		DocumentVO lessonSection = new DocumentVO();
		String resourceExt = (!sectionDocument.getDocumentName().equals(""))?sectionDocument.getDocumentName().toLowerCase().substring(sectionDocument.getDocumentName().lastIndexOf(StringPool.PERIOD)):"";
		lessonSection.setSectionId(section != null ? section.getId() : 0l);
		lessonSection.setDocumentId(sectionDocument.getDocumentId());
		lessonSection.setResourceId(sectionDocument.getResourceId());
		lessonSection.setDocUuid(sectionDocument.getDocUuid());
		lessonSection.setType(sectionDocument.getResourceType());
		lessonSection.setTitle(StringEscapeUtils.escapeHtml(section != null ? section.getSectionTitle():sectionDocument.getDocumentName()));
		lessonSection.setResourceTitle(StringEscapeUtils.escapeHtml(sectionDocument.getDocumentName().isEmpty()?(section != null ? section.getSectionTitle():sectionDocument.getDocumentName()):sectionDocument.getDocumentName()));
		lessonSection.setResourceImgUrl(sectionDocument.getDocumentPath());
		lessonSection.setResourceDownloadUrl(sectionDocument.getDownloadUrl());
		lessonSection.setTextContent(section != null ? section.getSectionNote() : lesson.getLessonNote());
		if(section != null){
			lessonSection = getLessonObjectiveList(lesson, section, lessonSection);
		}

		//#*****Setting ResourceUrl whether to play in Engage or not*****#//
		if(sectionDocument.getStatus().equals(Constant.DOCUMENT_STATUS_COMPLETED) && lesson.getStatus().equals(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH)
		&& sectionDocument.getResourceType().contains(Constant.COMMON_RESOURCE) && sectionDocument.getResourceId() > 0 && engageTypes.contains(resourceExt)){
			engageUrl = engageLink+StringPool.FORWARD_SLASH+Constant.COMMON_STRING_CONSTANT_RESOURCE_ID+
						StringPool.FORWARD_SLASH+sectionDocument.getResourceId()+Constant.COMMON_STRING_CONSTANT_FORWARD_SLASH_LESSON_ID+lesson.getLessonId()+
						StringPool.FORWARD_SLASH+Constant.AUTHOR_ID+StringPool.FORWARD_SLASH+authorId+StringPool.FORWARD_SLASH+
						Constant.CHAPTER_ID+StringPool.FORWARD_SLASH+Constant.COMMON_STRING_ZERO;
			lessonSection.setDocumentPath(engageUrl);
		}else{
			lessonSection.setDocumentPath(sectionDocument.getDocumentPath());
			if(!(sectionDocument.getResourceType().contains(Constant.COMMON_RESOURCE))){
					lessonSection.setDocumentPath(StringPool.DOUBLE_SLASH+sectionDocument.getDocumentPath());	
					lessonSection.setResourceImgUrl(Constant.PORTLET_PROP_SITE_THEME_IMAGES+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER);
				if(sectionDocument.getResourceType().equalsIgnoreCase(Constant.COMMON_YOUTUBE)){						
					String youtubeId = sectionDocument.getDocumentPath().substring(sectionDocument.getDocumentPath().lastIndexOf(StringPool.SLASH)+1);
					String youtubeImg = Constant.COMMON_HTTP_IMG_YOUTUBE_COM_VI+youtubeId+Constant.SLASH_DEFAULT_JPG;
					lessonSection.setResourceImgUrl(youtubeImg);
				}
			}
		}
		
		return lessonSection;
	}
	
	/*
	 * provide List of Objectives to Individual LessonSection
	 *  
	 * */
	private static DocumentVO getLessonObjectiveList(Lesson lesson,
			DocumentSection documentSection,DocumentVO lessonSection){
		List<LessonObjectives> lessonObjectivesList = new ArrayList<LessonObjectives>();
		List<Long> objectiveIds =new ArrayList<Long>();
		
		try{
			String[] secObjIds =new String[0];
			if(Validator.isNotNull(documentSection.getLessonObjectiveIds()) && !documentSection.getLessonObjectiveIds().trim().equals(StringPool.BLANK)){
				secObjIds =documentSection.getLessonObjectiveIds().split(StringPool.COMMA);
				for(int i=0 ;i<secObjIds.length;i++){
					objectiveIds.add(GetterUtil.getLong(secObjIds[i]));
				}
			}
			if(secObjIds.length > 0){
				Long[] secIdsLong = new Long[secObjIds.length];
				int i = 0;
				for(String secId:secObjIds){
					secIdsLong[i] = GetterUtil.getLong(secId);
					i++;
				}
				DynamicQuery secObjQuery  = DynamicQueryFactoryUtil.forClass(LessonObjectives.class);
				Criterion criterion2 = RestrictionsFactoryUtil.in(Constant.COMMON_ID, secIdsLong);
				secObjQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_LESSON_ID).eq(lesson.getLessonId()));
				secObjQuery.add(criterion2);
				lessonObjectivesList = LessonObjectivesLocalServiceUtil.dynamicQuery(secObjQuery);
			}
		}catch(Exception e){
			_log.error("getLessonObjectiveList::::"+e.getMessage());
		}
		lessonSection.setExistingObjIds(documentSection.getLessonObjectiveIds());
		lessonSection.setObjectiveIds(objectiveIds);
		lessonSection.setLessonObjective(lessonObjectivesList);
		
		return lessonSection;
	}
	
	public static PortletRequest getDocumentListAndIdsAsArray(PortletRequest request,
			Lesson lesson) {
		String engageUrl=request.getContextPath()+Constant.COMMON_STRING_CONSTANT_ENGAGE_SLASH_LAUNCHER;
		 List<DocumentVO> documentSectionList = CommonUtil.getDocumentList(lesson,engageUrl,lesson.getCurrentAuthor());
		 JSONArray sectionAndDocIdArray = JSONFactoryUtil.createJSONArray();
		 for(DocumentVO documentVO:documentSectionList){
				 JSONObject jsonSectionAndDocObject=JSONFactoryUtil.createJSONObject();
				 jsonSectionAndDocObject.put(Constant.SECTION_ID,documentVO.getSectionId());
				 jsonSectionAndDocObject.put(Constant.DOCUMENT_ID,documentVO.getDocumentId()); 
				 sectionAndDocIdArray.put(jsonSectionAndDocObject);
		 }
		 request.setAttribute(Constant.COMMON_DOCUMENT_SECTION, documentSectionList);
		 request.setAttribute(Constant.SECTION_AND_DOC_ID_ARRAY, sectionAndDocIdArray);
		 return request;
	}
}
