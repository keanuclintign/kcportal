package com.nyu.portlet.mystuff;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.portlet.PortletRequest;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanComparator;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.protocol.HTTP;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.OrderFactoryUtil;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil;
import com.liferay.portal.kernel.dao.search.ResultRow;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.util.ListUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Tuple;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.UserGroup;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.service.UserGroupLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.service.UserNotificationEventLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.announcements.model.AnnouncementsEntry;
import com.liferay.portlet.announcements.model.AnnouncementsFlag;
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
import com.liferay.portlet.social.model.SocialActivity;
import com.liferay.portlet.social.model.SocialActivityCounter;
import com.liferay.portlet.social.model.SocialActivityCounterConstants;
import com.liferay.portlet.social.model.SocialRelation;
import com.liferay.portlet.social.service.SocialActivityCounterLocalServiceUtil;
import com.liferay.portlet.social.service.SocialActivityLocalServiceUtil;
import com.liferay.portlet.social.service.SocialRelationLocalServiceUtil;
import com.nyu.model.AnswerRequest;
import com.nyu.model.Basno;
import com.nyu.model.KeywordsCollaboration;
import com.nyu.model.Lesson;
import com.nyu.model.RequestLesson;
import com.nyu.model.UserBadges;
import com.nyu.portlet.social.activities.NyuMemberActivityKeys;
import com.nyu.portlet.vo.CategoryTagsVO;
import com.nyu.service.AnswerRequestLocalServiceUtil;
import com.nyu.service.BasnoLocalServiceUtil;
import com.nyu.service.KeywordsCollaborationLocalServiceUtil;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.RequestLessonLocalServiceUtil;
import com.nyu.service.UserBadgesLocalServiceUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;
import com.nyu.util.RenderHelper;
import com.nyu.util.SortLessonUtil;
import com.nyu.util.UserGroupSortByTime;
@Controller
@RequestMapping(value = "VIEW")
public class MyStuffController {
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(MyStuffController.class);
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws PortalException 
	 * @throws SystemException 
	 */
	@RenderMapping
	public String view(RenderRequest request,RenderResponse response) throws PortalException, SystemException {
		getMyPoints(request);
		if(PortalUtil.isOmniadmin(PortalUtil.getUserId(request)) || request.isUserInRole(Constant.PORTAL_ADMIN_ROLE)){		
			List<KeywordsCollaboration> keywordsCollaborations = KeywordsCollaborationLocalServiceUtil.getPendingRequestByStatus(Constant.KEYWORD_STATUS_REQUEST);
			request.setAttribute(Constant.KEYWORDS_COLLABORATIONS,keywordsCollaborations);
		}
			List<KeywordsCollaboration> keywordsRequestStatus = KeywordsCollaborationLocalServiceUtil.getRequestStatusByUserId(PortalUtil.getUserId(request));
			request.setAttribute(Constant.KEYWORDS_REQUEST_STATUS,keywordsRequestStatus);
			request.setAttribute(Constant.ANNOUNCEMENT_ENTRIES, getGroupAnnouncements(request));
			request.setAttribute(Constant.REQUESTED_LESSON_ACCEPTED, getRequestLessonAccepted(request));
			request.setAttribute(Constant.ACTIVITIES, getSocialActivities(request));
			
			String archeivedLessonParam=ParamUtil.getString(request,Constant.ARCHIVED_LESSONS);
			if(!archeivedLessonParam.isEmpty()){
				request.setAttribute(Constant.ARCHIVED_LESSON_PARAM, archeivedLessonParam);
			}
			
			return Constant.USER_PROFILE_VIEW_JSP;  
	}
	
	@ResourceMapping(value="myfollowing")
	public void myFollowing(ResourceRequest request,ResourceResponse response) {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		//List<SocialRelation> followingUserList = SocialRelationLocalServiceUtil.getRelations(themeDisplay.getUserId(), ParamUtil.getInteger(request, Constant.TYPE), QueryUtil.ALL_POS, QueryUtil.ALL_POS);
		try {
			List<SocialRelation> myFollowingUserList = SocialRelationLocalServiceUtil.getRelations(themeDisplay.getUserId(), 8, QueryUtil.ALL_POS, QueryUtil.ALL_POS);
			BeanComparator comp = new BeanComparator(Constant.COMMON_STRING_CONSTANT_CREATE_DATE);
			List<SocialRelation> myFollowingUserListTemp = ListUtil.copy(myFollowingUserList); 
			Collections.sort(myFollowingUserListTemp, comp); 
			Collections.reverse(myFollowingUserListTemp);
			//myFollowersList = ListUtil.copy(myFollowersListTemp);
			request.setAttribute(Constant.MY_FOLLOWING_USER_LIST, myFollowingUserListTemp);
		} catch (Exception e) {
			LOG.error("[MyStuffController: myFollowing() ]"+e);
		}

		try {
			HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
			HttpServletResponse httpResponse = PortalUtil
					.getHttpServletResponse(response);
			ServletContext context = httpRequest.getSession()
					.getServletContext();
			String htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.MYSTUFF_MY_FOLLOWING_JSP);
			response.getWriter().write(htmlResult);
		} catch (IOException e) {
			LOG.error("[MyStuffController: myFollowing() ]"+e);
		} catch (ServletException e) {
			LOG.error("[MyStuffController: myFollowing() ]"+e);
		}
		
	}	
	
	@ResourceMapping(value="claimBadge")
	public void claimBadge(ResourceRequest request,ResourceResponse response) {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		try {
			UserBadges userBadge = UserBadgesLocalServiceUtil.createUserBadges(CounterLocalServiceUtil.increment(UserBadges.class.getName()));
			userBadge.setBadgeId(new Long(request.getParameter(Constant.BADGE_ID).toString()));
			userBadge.setBadgeUrl(request.getParameter(Constant.BADGE_URL).toString());
			userBadge.setUserId(themeDisplay.getUserId());
			userBadge.setCreatedDate(new Date(System.currentTimeMillis()));
			UserBadgesLocalServiceUtil.updateUserBadges(userBadge);
				
			myBadges(request, response);
			
		} catch (SystemException e) {
			LOG.error("[MyStuffController: claimBadge() ]"+e);
		} 
	}
	
	@ResourceMapping(value="mybadges")
	public void myBadges(ResourceRequest request,ResourceResponse response) {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		List<UserBadges> allUserBadges = UserBadgesLocalServiceUtil.getAllUserBadges(themeDisplay.getUserId());//Get all badges claimed by user
		String getClaimUrlEndpoint = null;
		HttpURLConnection urlConnection = null;
		URL url1=null;
		InputStream is = null;
		BufferedReader reader = null;
		String resData=null;
		
		String jsonString= null;
		List<String> basgesList = new ArrayList<String>();
		try{
		List<Basno> badges=BasnoLocalServiceUtil.getBasnos(-1,-1);
		Map<Long, String> basgesMap = new HashMap<Long, String>();
		for(Basno badge:badges){
				long id=badge.getBadgeId();
				getClaimUrlEndpoint = Constant.PORTLET_PROP_LIFERAY_SITE_BASNO_APP_URL
												+ Constant.PORTLET_PROP_LIFERAY_SITE_BASNO_APP_ID
												+ Constant.API_SLASH_ISSUE_URL;
			    url1=new URL(getClaimUrlEndpoint);
			    urlConnection=(HttpURLConnection) url1.openConnection();
			    urlConnection.setRequestMethod(Constant.POST);
			    urlConnection.setDoOutput(true);
			    urlConnection.addRequestProperty(Constant.PORTLET_PROP_LIFERAY_SITE_BASNO_APP_SECRET_KEY, Constant.PORTLET_PROP_LIFERAY_SITE_BASNO_APP_SECRET_KEY_VALUE);
			    urlConnection.addRequestProperty(HTTP.CONTENT_TYPE, Constant.APPLICATION_SLASH_JSON);
		    
		    	jsonString=Constant.OPEN_CURLY_BRACE_DOUBLE_QUOTE_PID+id+Constant.BACK_SLASH_CLOSE_CURLY_BRACE;
		    	LOG.info("jsonString >>>>>> "+jsonString);
			    urlConnection.getOutputStream().write(jsonString.getBytes());
			    urlConnection.connect();
			    is=urlConnection.getInputStream();
			    reader=new BufferedReader(new InputStreamReader(is));
			    
			    while((resData=reader.readLine())!=null){
			    	 if(resData!=null){
				    	resData=resData.replace(StringPool.OPEN_CURLY_BRACE, StringPool.BLANK).replace(StringPool.CLOSE_CURLY_BRACE, StringPool.BLANK);
				    	String str[] = resData.split(StringPool.COMMA);
				    	for(String s1 : str){
							if(s1.contains(Constant.PREVIEW_URL)){
								resData = s1.substring(s1.indexOf(Constant.HTTPS), s1.lastIndexOf(StringPool.QUOTE));
							}
						}
				    	basgesMap.put(id, resData);
				    	basgesList.add(resData);
				    }
			    }
		    }
		    
 			if(allUserBadges!=null && allUserBadges.size()>0){
				for(UserBadges ub : allUserBadges){
					for(Map.Entry<Long, String> entry : basgesMap.entrySet()){
						if(entry.getKey().equals(ub.getBadgeId()))
							basgesList.remove(entry.getValue());
					}
				}
			}

			request.setAttribute(Constant.ALL_USER_BADGES, allUserBadges);
		    
		    request.setAttribute(Constant.BASGES_LIST, basgesList);
		    
		    getMyPoints(request);
		    
		}catch (ClientProtocolException e) {
			LOG.error("[MyStuffController: myBadges() ]"+e);
		} catch (IOException e) {
			LOG.error("[MyStuffController: myBadges() ]"+e);
		} catch (SystemException e) {
			LOG.error("[MyStuffController: myBadges() ]"+e);
		}
	    		
		try {
			HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
			HttpServletResponse httpResponse = PortalUtil
					.getHttpServletResponse(response);
			ServletContext context = httpRequest.getSession()
					.getServletContext();
			String htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.MYSTUFF_MY_BADGES_JSP);
			response.getWriter().write(htmlResult);
		} catch (IOException e) {
			LOG.error("[MyStuffController: myBadges() ]"+e);
		} catch (ServletException e) {
			LOG.error("[MyStuffController: myBadges() ]"+e);
		}
		
	}	
	
	@ResourceMapping(value="mypoints")
	public void myPoints(ResourceRequest request,ResourceResponse response) {
		getMyPoints(request);
		try {
			HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
			HttpServletResponse httpResponse = PortalUtil
					.getHttpServletResponse(response);
			ServletContext context = httpRequest.getSession()
					.getServletContext();
			httpRequest.setAttribute(Constant.REQUESTED_LESSON_ACCEPTED, getRequestLessonAccepted(request));
			httpRequest.setAttribute(Constant.ANNOUNCEMENT_ENTRIES, getGroupAnnouncements(request));
			httpRequest.setAttribute(Constant.ACTIVITIES, getSocialActivities(request));
			String htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.MYSTUFF_MY_POINTS_JSP);
			response.getWriter().write(htmlResult);
		} catch (IOException e) {
			LOG.error("[MyStuffController: myPoints() ]"+e);
		} catch (ServletException e) {
			LOG.error("[MyStuffController: myPoints() ]"+e);
		}
		
	}	
	
	
	@ResourceMapping(value="myfollowers")
	public void myFollowers(ResourceRequest request,ResourceResponse response) {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		try {
			List<SocialRelation> myFollowersList = SocialRelationLocalServiceUtil.getInverseRelations(themeDisplay.getUserId(), 8, QueryUtil.ALL_POS, QueryUtil.ALL_POS);

			BeanComparator comp = new BeanComparator(Constant.COMMON_STRING_CONSTANT_CREATE_DATE);
			List<SocialRelation> myFollowersListTemp = ListUtil.copy(myFollowersList); 
			Collections.sort(myFollowersListTemp, comp); 
			Collections.reverse(myFollowersListTemp);
			//myFollowersList = ListUtil.copy(myFollowersListTemp);
			request.setAttribute(Constant.MY_FOLLOWER_LIST, myFollowersListTemp);
			
		} catch (Exception e) {
			LOG.error("[MyStuffController: myFollowers() ]"+e);
		}
		
		try {
			HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
			HttpServletResponse httpResponse = PortalUtil
					.getHttpServletResponse(response);
			ServletContext context = httpRequest.getSession()
					.getServletContext();
			String htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.MYSTUFF_MY_FOLLOWER_JSP);
			response.getWriter().write(htmlResult);
		} catch (IOException e) {
			LOG.error("[MyStuffController: myFollowers() ]"+e);
		} catch (ServletException e) {
			LOG.error("[MyStuffController: myFollowers() ]"+e);
		}
		
	}	
	
	
	@ResourceMapping(value="myGroups")
	public void myGroups(ResourceRequest request,ResourceResponse response) throws PortalException, SystemException {
		
		List<UserGroup> groups = null;
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		groups = UserGroupLocalServiceUtil.getUserUserGroups(PortalUtil.getUserId(request));
		Collections.sort(groups, new UserGroupSortByTime());
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
					
			response.getWriter().write(AllGroupData.toString());
		} catch (IOException e) {
			LOG.error("[MyStuffController: myGroups() ]"+e);
		} 
		
	}	
	
	
	@ResourceMapping(value="mylessons")
	public void myLessons(ResourceRequest request,ResourceResponse response) {
		
		String lessonType=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_LESSONS);
		List<Lesson> lessons = null;
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.MARKEDAS_QUARANTINE};
		if(lessonType.equalsIgnoreCase(Constant.REQUEST_LESSON_MY_LESSON_JSP)){
			lessons = LessonLocalServiceUtil.findMyLessonsWithCollaborations(PortalUtil.getUserId(request), Constant.USER_GROUP_UPLOAD_TIMES_VAR, markedAs, -1, -1);
		}else{
			lessons=LessonLocalServiceUtil.findMyFavouriteLessons(PortalUtil.getUserId(request), Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH, Constant.USER_GROUP_UPLOAD_TIMES_VAR, markedAs, -1, -1);
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
			String jsonLessons = CommonUtil.getJSONLessons(lessons, themeDisplay,true);
			JSONObject AllLessonData=JSONFactoryUtil.createJSONObject();
			
			AllLessonData.put(Constant.COMMON_STRING_CONSTANT_LESSONS,jsonLessons);
			AllLessonData.put(Constant.COMMON_STRING_CONSTANT_CATEGORIES,jsonCategorys);
			AllLessonData.put(Constant.COMMON_STRING_CONSTANT_TAGS,jsonTags);
			 
			response.getWriter().write(AllLessonData.toString());
			
		} catch (IOException e) {
			LOG.error("[MyStuffController: myLessons() ]"+e);
		} catch (PortalException e) {
			LOG.error("[MyStuffController: myLessons() ]"+e);
		} catch (SystemException e) {
			LOG.error("[MyStuffController: myLessons() ]"+e);
		}
		
	}	
	
	
	
	@ResourceMapping(value="scrollLoad")
    public void scrollLoad(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException  {
		List<Lesson> lessons = new ArrayList<Lesson>();
		resourceResponse.setCharacterEncoding(Constant.UTF_EIGHT);
		int count = Integer.parseInt(resourceRequest.getParameter(Constant.COUNT));
		
		long tagId = ParamUtil.getLong(resourceRequest, Constant.COMMON_STRING_CONSTANT_TAG_ID);
		long cataId = ParamUtil.getLong(resourceRequest, Constant.CATA_ID);
		HttpServletRequest httpRequest = PortalUtil
				.getHttpServletRequest(resourceRequest);
		HttpServletResponse httpResponse = PortalUtil
				.getHttpServletResponse(resourceResponse);
		ServletContext context = httpRequest.getSession()
				.getServletContext();
		int LessonCount=Integer.parseInt(Constant.PORTLET_PROP_SHOW_LESSONS_COUNT_VALUE);
		int showLessonCount=Integer.parseInt(Constant.PORTLET_PROP_SHOW_MORE_LESSONS_COUNT);
		String jspFile=StringPool.BLANK;
		try {
		
			if(tagId>0)
			{	List<Lesson> tagLessons = new ArrayList<Lesson>(); 
				AssetEntryQuery entryQuery = new AssetEntryQuery();
				entryQuery.setClassName(Lesson.class.getName());
				entryQuery.setAllTagIds(new long[] {tagId});
				
				List<AssetEntry> assetEntries = AssetEntryLocalServiceUtil.getEntries(entryQuery);
				for(AssetEntry assetEntry:assetEntries){
					try {
						tagLessons.add(LessonLocalServiceUtil.getLesson(assetEntry.getClassPK()));
					} catch (PortalException e) {
						LOG.error("[MyStuffController: scrollLoad() ]"+e);
					}
				}
				if(Validator.isNotNull(tagLessons) && !tagLessons.isEmpty()){
				for(Lesson lesson:tagLessons){
					if(lesson.getUploadedById()==PortalUtil.getUserId(resourceRequest))
					{
						lessons.add(lesson);
					}
				}
				}
			}
			else if(cataId>0)
			{	
				List<Lesson> cataLessons= new ArrayList<Lesson>(); 
				AssetEntryQuery entryQuery = new AssetEntryQuery();
				entryQuery.setClassName(Lesson.class.getName());
				entryQuery.setAllCategoryIds(new long[] {cataId});
				
				List<AssetEntry> assetEntries = AssetEntryLocalServiceUtil.getEntries(entryQuery);
				for(AssetEntry assetEntry:assetEntries){
					try {
						cataLessons.add(LessonLocalServiceUtil.getLesson(assetEntry.getClassPK()));
					} catch (PortalException e) {
						LOG.error("[MyStuffController: scrollLoad() ]"+e);
					}
				}
				if(Validator.isNotNull(cataLessons) && !cataLessons.isEmpty()){
				for(Lesson lesson:cataLessons){
					if(lesson.getUploadedById()==PortalUtil.getUserId(resourceRequest))
					{
						lessons.add(lesson);
					}
				}
				}
			}
			else
			{
				 lessons=LessonLocalServiceUtil.getLessonsUploadedByAuthor(PortalUtil.getUserId(resourceRequest));
			}
		
		if(lessons.size()>LessonCount)
		{
			
			if(lessons.size()>count+showLessonCount){
				httpRequest.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSONS, lessons.subList(count,count+showLessonCount));
			}
			else{
				if(lessons.size()>count){
					httpRequest.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSONS, lessons.subList(count,lessons.size()));
				}
					
			}
			jspFile = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.MYSTUFF_SCRLL_LOAD_JSP);
		}	
		
		resourceResponse.getWriter().write(jspFile);

		} catch (Exception e) {
			LOG.error("[MyStuffController: scrollLoad() ]"+e);
		}
	}
	
	
	@ResourceMapping(value="categoryURL")
    public void filterByCategory(ResourceRequest request, ResourceResponse response){
			
		try {
				ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
				if(request.getParameter(Constant.CAT_ID).toString().equalsIgnoreCase(Constant.COMMON_STRING_ZERO)){
					getAllCategoryLessons(request);
				}else{
					getLessonsByCategory(request);
					
				}
			
				String jsonLessons = CommonUtil.getJSONLessons((List<Lesson>)request.getAttribute(Constant.COMMON_STRING_CONSTANT_LESSONS), themeDisplay);
				response.getWriter().write(jsonLessons);
			
		} catch (IOException e) {
			LOG.error("[MyStuffController: filterByCategory() ]"+e);
		} catch (PortalException e) {
			LOG.error("[MyStuffController: filterByCategory() ]"+e);
		} catch (SystemException e) {
			LOG.error("[MyStuffController: filterByCategory() ]"+e);
		} 
	
	}
	
	@ResourceMapping(value="tagURL")
    public void filterByTag(ResourceRequest request, ResourceResponse response){
	
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		try {
			if(request.getParameter(Constant.COMMON_STRING_CONSTANT_TAG_ID).toString().equalsIgnoreCase(Constant.COMMON_STRING_ZERO))
				getAllTagLessons(request);
			else
				getLessonsByTag(request);
			 
			String jsonLessons = CommonUtil.getJSONLessons((List<Lesson>)request.getAttribute(Constant.COMMON_STRING_CONSTANT_LESSONS), themeDisplay);
			response.getWriter().write(jsonLessons);
		} catch (IOException e) {
			LOG.error("[MyStuffController: filterByTag() ]"+e);
		} catch (PortalException e) {
			LOG.error("[MyStuffController: filterByTag() ]"+e);
		} catch (SystemException e) {
			LOG.error("[MyStuffController: filterByTag() ]"+e);
		} 
		
	}
	
	@ResourceMapping(value="deleteAnnouncement")
	public void deleteAnnouncement(ResourceRequest request,ResourceResponse response) {
		
		long entryId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_ENTRY_ID);
		
		DynamicQuery announcementQuery = DynamicQueryFactoryUtil.forClass(AnnouncementsFlag.class);
		announcementQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_ENTRY_ID,entryId));
		List<AnnouncementsFlag> announcementFlags=null;
		try {
			announcementFlags = AnnouncementsFlagLocalServiceUtil.dynamicQuery(announcementQuery);
			if(Validator.isNotNull(announcementFlags) && !announcementFlags.isEmpty()){
				for(AnnouncementsFlag announcementFlag:announcementFlags){
					AnnouncementsFlagLocalServiceUtil.deleteAnnouncementsFlag(announcementFlag.getFlagId());
				}
			}
			AnnouncementsEntryLocalServiceUtil.deleteAnnouncementsEntry(entryId);
			
		} catch (SystemException e) {
			LOG.error("[MyStuffController: deleteAnnouncement() ]"+e);
		} catch (PortalException e) {
			LOG.error("[MyStuffController: deleteAnnouncement() ]"+e);
		}
		
	}
	
	
	private void getAllTagLessons(ResourceRequest request) {
		List<Lesson> lessons = new ArrayList<Lesson>();
			lessons = LessonLocalServiceUtil.getLessonsUploadedByAuthor(PortalUtil.getUserId(request));
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSONS, lessons);
	}
	
	
	private void getAllCategoryLessons(ResourceRequest request) {
		List<Lesson> lessons = new ArrayList<Lesson>();
			lessons = LessonLocalServiceUtil.getLessonsUploadedByAuthor(PortalUtil.getUserId(request));
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSONS,lessons);
	}
	
	
	private void redirectToRenderPage(ResourceRequest request,
			ResourceResponse response, String sortBy) throws IOException, ServletException {
		
		HttpServletRequest httpRequest = PortalUtil
				.getHttpServletRequest(request);
		HttpServletResponse httpResponse = PortalUtil
				.getHttpServletResponse(response);
		ServletContext context = httpRequest.getSession()
				.getServletContext();
		String jspFile = StringPool.BLANK;
			 jspFile = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.MYSTUFF_CATEGORY_TAGS_LESSONS_JSP);
		response.getWriter().write(jspFile);
	}
	
	private void getLessonsByCategory(ResourceRequest request) {
		List<Lesson> lessons = new ArrayList<Lesson>();
			lessons = getLessonsByUserAndCategory(PortalUtil.getUserId(request), Long.parseLong(request.getParameter(Constant.CAT_ID)));
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSONS, lessons);
	}
	
	private List<Lesson> getLessonsByUserAndCategory(long userId, long categoryId){
		List<AssetEntry> assetEntries=null;
		Lesson lsn = null;
		List<Lesson> lessons = new ArrayList<Lesson>();
		try {
			AssetEntryQuery entryQuery=new AssetEntryQuery();
			entryQuery.setClassName(Lesson.class.getName());
			entryQuery.setAnyCategoryIds(new long[]{categoryId});
			lessons=new ArrayList<Lesson>();
			assetEntries = AssetEntryLocalServiceUtil.getEntries(entryQuery);
			
			for(AssetEntry assetEntry:assetEntries){
				lsn = LessonLocalServiceUtil.getLessonsUploadedByAuthor(assetEntry.getClassPK(), userId);
				if(lsn!=null)
					lessons.add(lsn);
			}
			
		} catch (SystemException e) {
			LOG.error("[MyStuffController: getLessonsByUserAndCategory() ]"+e);
		}
		
		return lessons;
	}
	
	
	private List<Lesson> getLessonsByUserAndTag(long userId, long tagId){
		List<AssetEntry> assetEntries=null;
		Lesson lsn = null;
		List<Lesson> lessons = new ArrayList<Lesson>();
		try {
			AssetEntryQuery entryQuery=new AssetEntryQuery();
			entryQuery.setClassName(Lesson.class.getName());
			entryQuery.setAnyTagIds(new long[]{tagId});
			lessons=new ArrayList<Lesson>();
			assetEntries = AssetEntryLocalServiceUtil.getEntries(entryQuery);
			
			for(AssetEntry assetEntry:assetEntries){
				lsn = LessonLocalServiceUtil.getLessonsUploadedByAuthor(assetEntry.getClassPK(), userId);
				if(lsn!=null)
					lessons.add(lsn);
			}
			
		} catch (SystemException e) {
			LOG.error("[MyStuffController: getLessonsByUserAndTag() ]"+e);
		}
		
		return lessons;
	}
	
private void getLessonsByTag(ResourceRequest request) {
		
		List<Lesson> lessons = new ArrayList<Lesson>();
		lessons = getLessonsByUserAndTag(PortalUtil.getUserId(request), Long.parseLong(request.getParameter(Constant.COMMON_STRING_CONSTANT_TAG_ID)));
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSONS, lessons);
			
	}

private void getMyPoints(PortletRequest request){
		
		List<String> rankingNamesList = new ArrayList<String>();
		rankingNamesList.add(SocialActivityCounterConstants.NAME_PARTICIPATION);
		rankingNamesList.add(SocialActivityCounterConstants.NAME_CONTRIBUTION);
		String[] rankingNames = rankingNamesList.toArray(new String[rankingNamesList.size()]);
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		
		if (!rankingNamesList.isEmpty()) {
			
			int total=0;
			try {
				total= SocialActivityCounterLocalServiceUtil.getUserActivityCountersCount(themeDisplay.getScopeGroupId(), rankingNames);
			} catch (SystemException e) {
				LOG.error("[MyStuffController: getMyPoints() ]"+e);
			}
			
			List<String> selectedNamesList = new ArrayList<String>();
			selectedNamesList.add(SocialActivityCounterConstants.NAME_CONTRIBUTION);
			selectedNamesList.add(SocialActivityCounterConstants.NAME_PARTICIPATION);
			String[] selectedNames = selectedNamesList.toArray(new String[selectedNamesList.size()]);
			
			try {
				List<Tuple>	results=SocialActivityCounterLocalServiceUtil.getUserActivityCounters(themeDisplay.getScopeGroupId(), rankingNames, selectedNames, 0, total);
				Map<Long,Long[]> countributionValue=new LinkedHashMap<Long, Long[]>();
				Map<Long,Long[]>  participationValue=new LinkedHashMap<Long, Long[]>();
				
				for (int i = 0; i < results.size(); i++) {
					Long [] pointsArray = new Long[2];
					Tuple tuple = results.get(i);

					ResultRow row = new ResultRow((Map<String, SocialActivityCounter>)tuple.getObject(1), (Long)tuple.getObject(0), i);
					Map<String, SocialActivityCounter> activityCounters = (Map<String, SocialActivityCounter>)row.getObject();
					SocialActivityCounter contributionActivityCounter = activityCounters.get(SocialActivityCounterConstants.NAME_CONTRIBUTION);                
					SocialActivityCounter participationActivityCounter = activityCounters.get(SocialActivityCounterConstants.NAME_PARTICIPATION);
					LOG.info("contributionActivityCounter  : "+contributionActivityCounter);
					LOG.info("participationActivityCounter : "+participationActivityCounter );
					
					if(contributionActivityCounter!=null && participationActivityCounter!=null){
						pointsArray[0] =  new Long( contributionActivityCounter.getCurrentValue());
						pointsArray[1] =  new Long( contributionActivityCounter.getTotalValue());
						countributionValue.put(contributionActivityCounter.getClassPK(), pointsArray);
						LOG.info("c c : "+pointsArray[0] );
						LOG.info("c t : "+pointsArray[1] );
						
						pointsArray = new Long[2];
						pointsArray[0] =  new Long( participationActivityCounter.getCurrentValue());
						pointsArray[1] =  new Long( participationActivityCounter.getTotalValue());
						LOG.info("p c : "+pointsArray[0] );
						LOG.info("p t : "+pointsArray[1] );
						participationValue.put(participationActivityCounter.getClassPK(), pointsArray);
						
					}else if(contributionActivityCounter!=null){
						pointsArray[0] =  new Long( contributionActivityCounter.getCurrentValue());
						pointsArray[1] =  new Long( contributionActivityCounter.getTotalValue());
						countributionValue.put(contributionActivityCounter.getClassPK(), pointsArray);
						
						pointsArray = new Long[2];
						pointsArray[0] =  0l;
						pointsArray[1] =  0l;
						participationValue.put(contributionActivityCounter.getClassPK(), pointsArray);
				        	
					}else if(participationActivityCounter!=null){
						pointsArray[0] =  0l;
						pointsArray[1] =  0l;
						countributionValue.put(participationActivityCounter.getClassPK(), pointsArray);
						
						pointsArray = new Long[2];
						pointsArray[0] =  new Long( participationActivityCounter.getCurrentValue());
						pointsArray[1] =  new Long( participationActivityCounter.getTotalValue());
						participationValue.put(participationActivityCounter.getClassPK(), pointsArray);
						
					}
				}
	
				if(countributionValue.containsKey(PortalUtil.getUserId(request))){
					Long [] pointsArray = new Long[2];
					List keys = new ArrayList(countributionValue.keySet());
					request.setAttribute(Constant.CAPITAL_RANK, keys.indexOf(PortalUtil.getUserId(request))+1);
										
					pointsArray = (Long[])participationValue.get(PortalUtil.getUserId(request));
					request.setAttribute(Constant.PARTICIPATION_POINTS,pointsArray[0]);
					request.setAttribute(Constant.PARTICIPATION_TOTAL_POINTS,pointsArray[1]);
					
					pointsArray = new Long[2];
					pointsArray = (Long[])countributionValue.get(PortalUtil.getUserId(request));
					request.setAttribute(Constant.CONTRIBUTION_POINTS,pointsArray[0]);
					request.setAttribute(Constant.CONTRIBUTION_TOTAL_POINTS,pointsArray[1]);
					
				}
			} catch (SystemException e) {
				LOG.error("[MyStuffController: getMyPoints() ]"+e);
			}
		}	
	}
	
	@ResourceMapping(value="processKeywordRequest")
	public void processKeywordRequest(ResourceRequest request,ResourceResponse response) {
		long id= ParamUtil.getLong(request, Constant.COMMON_ID);
		String action = ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_ACTION);
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		try {
			ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
			KeywordsCollaboration keywordsCollaboration = KeywordsCollaborationLocalServiceUtil.getKeywordsCollaboration(id);
			keywordsCollaboration.setStatus(action);
			keywordsCollaboration.setModifiedDate(new Date());
			KeywordsCollaborationLocalServiceUtil.updateKeywordsCollaboration(keywordsCollaboration);
			
			JSONObject payloadJSON = JSONFactoryUtil.createJSONObject();
			payloadJSON.put(Constant.COMMON_STRING_CONSTANT_USER_ID, themeDisplay.getUserId());
			payloadJSON.put(Constant.TYPE, Constant.KEYWORDS_REQUEST_RESPONSE);
			payloadJSON.put(
					Constant.ADDITIONAL_DATA,
					CommonUtil.JavaClassI18N(request, themeDisplay,"your-request-has-been")
							+ StringPool.SPACE+ keywordsCollaboration.getStatus()+ StringPool.SPACE
							+ CommonUtil.JavaClassI18N(request, themeDisplay,"to-use-reserved-group-keyword-phrase")
							+ "\""+ keywordsCollaboration.getKeywordName()+ "\"");

			
				UserNotificationEventLocalServiceUtil
					.addUserNotificationEvent(keywordsCollaboration.getUserId(),
							com.nyu.notification.UserGroupNotificationHandler.PORTLET_ID,
							(new Date()).getTime(), themeDisplay.getUserId(),
							payloadJSON.toString(), false,
							serviceContext);
		} catch (SystemException e) {
			LOG.error("[MyStuffController: processKeywordRequest() ]"+e);
		} catch (PortalException e) {
			LOG.error("[MyStuffController: processKeywordRequest() ]"+e);
		}
	
	}
	
	@ResourceMapping(value="processKeywordRequestStatus")
	public void processKeywordRequestStatus(ResourceRequest request,ResourceResponse response) {
		long id= ParamUtil.getLong(request, Constant.COMMON_ID);
		String action = ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_ACTION);
		try {
			KeywordsCollaboration keywordsCollaboration = KeywordsCollaborationLocalServiceUtil.getKeywordsCollaboration(id);
			keywordsCollaboration.setMarkAs(action);
			keywordsCollaboration.setModifiedDate(new Date());
			KeywordsCollaborationLocalServiceUtil.updateKeywordsCollaboration(keywordsCollaboration);
		} catch (SystemException e) {
			LOG.error("[MyStuffController: processKeywordRequestStatus() ]"+e);
		} catch (PortalException e) {
			LOG.error("[MyStuffController: processKeywordRequestStatus() ]"+e);
		}
	
	}
	
	
	@ResourceMapping(value="deleteLesson")
	public void deleteLesson(ResourceRequest request,ResourceResponse response){
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		List<Lesson> lessons = null;
		long lessonId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		try {
			Lesson deleteLesson = LessonLocalServiceUtil.getLesson(lessonId);
			deleteLesson.setMarkedAs(Constant.LESSON_DELETED_BY_USER);
			LessonLocalServiceUtil.updateLesson(deleteLesson);
			String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.MARKEDAS_QUARANTINE};
			lessons =lessons = LessonLocalServiceUtil.findMyLessonsWithCollaborations(PortalUtil.getUserId(request), Constant.USER_GROUP_UPLOAD_TIMES_VAR, markedAs, -1, -1);	
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
			String jsonLessons = CommonUtil.getJSONLessons(lessons, themeDisplay,true);
			JSONObject AllLessonData=JSONFactoryUtil.createJSONObject();

			AllLessonData.put(Constant.COMMON_STRING_CONSTANT_LESSONS,jsonLessons);
			AllLessonData.put(Constant.COMMON_STRING_CONSTANT_CATEGORIES,jsonCategorys);
			AllLessonData.put(Constant.COMMON_STRING_CONSTANT_TAGS,jsonTags);

			response.getWriter().write(AllLessonData.toString());
		} 
		catch (IOException e) {
			LOG.error("[MyStuffController: deleteLesson() ]"+e);
		}catch (PortalException e) {
			LOG.error("[MyStuffController: deleteLesson() ]"+e);
		} catch (SystemException e) {
			LOG.error("[MyStuffController: deleteLesson() ]"+e);
		}


	}
	
	@ResourceMapping(value="myrequest")
	public void myrequests(ResourceRequest request,ResourceResponse response) {	
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		try {
			long userId=themeDisplay.getUserId();
			JSONObject allrequestsData=JSONFactoryUtil.createJSONObject();
			String userRequest=getAllRequestJson(request,userId).toString();
			allrequestsData.put(Constant.USER_REQUEST, userRequest);
			response.getWriter().write(userRequest.toString());
		} catch (IOException e) {
			LOG.error("[MyStuffController: myrequests() ]"+e);
		}
	}
	
	@ResourceMapping(value="archivedLessons")
	public void archivedLessons(ResourceRequest request,ResourceResponse response) {	
		
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		List<Lesson> lessons = new ArrayList<Lesson>();
		List<Lesson> lesson = new ArrayList<Lesson>();
	
		try {
			String archiveType = ParamUtil.getString(request,Constant.ARCHIVE_TYPE);
			int start=ParamUtil.getInteger(request, Constant.START, -1);
			int end=ParamUtil.getInteger(request, Constant.END, -1);
			long categoryId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_CATEGORY_ID,0l);
			long tagId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_TAG_ID,0l);
			
			lessons = SortLessonUtil.getArchivedLessonsMarkedAs(categoryId, tagId, archiveType, start, end);
			lesson = SortLessonUtil.getArchivedLessonsMarkedAs(categoryId, tagId, archiveType, -1,-1);
			LOG.info("start: "+start);
			LOG.info("end: "+end);
			
			/*if(lessons.size()<(end-start)){
				System.out.println("true");
				request.setAttribute(Constant.END_RESULT, true);
			}else{
				request.setAttribute(Constant.END_RESULT, false);
			}*/
			if(end>=lesson.size()){
				request.setAttribute(Constant.END_RESULT, false);
			}else{
				request.setAttribute(Constant.END_RESULT, true);
			}
			LOG.info("Lessons to display: "+lessons.size());
			setJsonData(request, response, lessons, start, end, themeDisplay);
		} catch (IOException e) {
			LOG.error("[MyStuffController: archivedLessons() ]"+e);
		} catch (PortalException e) {
			//LOG.error("[LessonsController: getLatestLessons() ]"+e);
		} catch (SystemException e) {
			LOG.error("[MyStuffController: archivedLessons() ]"+e);
		}
		

		
	}
	
	private JSONArray getAllRequestJson(PortletRequest portletrequest,long userId){
		
		JSONArray allRequestJson=JSONFactoryUtil.createJSONArray();
		try {
			
			DynamicQuery requestQuery = DynamicQueryFactoryUtil.forClass(RequestLesson.class);
			requestQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CREATED_BY,userId));
			requestQuery.addOrder(OrderFactoryUtil.desc(Constant.COMMON_STRING_CONSTANT_CREATED_DATE));
			
			List<RequestLesson> requestLessonList=RequestLessonLocalServiceUtil.dynamicQuery(requestQuery);
			
			if(Validator.isNotNull(requestLessonList)){
				for(RequestLesson request:requestLessonList){
			JSONObject request_lesson=JSONFactoryUtil.createJSONObject();
			
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(AnswerRequest.class);
			dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,request.getRequestLessonId()));
			List<AnswerRequest> answersList= AnswerRequestLocalServiceUtil.dynamicQuery(dynamicQuery);
			
			
			request_lesson.put(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,request.getRequestLessonId());
			request_lesson.put(Constant.COMMON_STRING_CONSTANT_NAME,request.getName());
			request_lesson.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,UserLocalServiceUtil.getUser(request.getCreatedBy()).getFullName());
			request_lesson.put(Constant.COMMON_STRING_CONSTANT_CREATE_DATE_II,CommonUtil.getDatesDuration(request.getCreatedDate().getTime(),0));	
			request_lesson.put(Constant.COMMON_STRING_CONSTANT_APPRECIATED_COUNT,CommonUtil.getAppreciatedCount(request.getAppreciatedUserIds()));
			request_lesson.put(Constant.COMMON_STRING_CONSTANT_ANSWER_TYPE,request.getAnswerType());
			request_lesson.put(Constant.COMMON_STRING_CONSTANT_ANSWER_COUNT,answersList.size());
			
			List<AssetCategory> categoriesList = null;
			List<AssetTag> tagList = null;
			List<CategoryTagsVO> categoryVOList = new ArrayList<CategoryTagsVO>();
			List<CategoryTagsVO> tagsVOList = new ArrayList<CategoryTagsVO>();
			
			categoriesList = AssetCategoryLocalServiceUtil
					.getCategories(RequestLesson.class.getName(),
							request.getRequestLessonId());
			tagList = AssetTagLocalServiceUtil
					.getTags(RequestLesson.class.getName(),request.getRequestLessonId());
			
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
			request_lesson.put(Constant.COMMON_STRING_CONSTANT_CATEGORIES,JSONFactoryUtil.createJSONArray(JSONFactoryUtil.looseSerializeDeep(categoryVOList)));
			request_lesson.put(Constant.COMMON_STRING_CONSTANT_TAGS,JSONFactoryUtil.createJSONArray(JSONFactoryUtil.looseSerializeDeep(tagsVOList)));
			
			allRequestJson.put(request_lesson);
				}
			}
			
		} catch (PortalException e)  {
			LOG.error("[MyStuffController: getAllRequestJson() ]"+e);
		} catch (SystemException e) {
			LOG.error("[MyStuffController: getAllRequestJson() ]"+e);
		}
		
		return allRequestJson;
	}
	
	private List<AnnouncementsEntry> getGroupAnnouncements(PortletRequest request){
		long classNameId=ClassNameLocalServiceUtil.getClassNameId(UserGroup.class.getName());
		long userId=PortalUtil.getUserId(request);
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
			e1.printStackTrace();
		}
		try {

			List<UserGroup> userGroups=UserGroupLocalServiceUtil.getUserUserGroups(userId);
			long[] userGroupIds=new long[userGroups.size()];
			
			if(Validator.isNotNull(userGroups) && userGroups.size()>0){
				
				for(int i=0;i<userGroups.size();i++){
					userGroupIds[i]=userGroups.get(i).getUserGroupId();
				}
				
				announcementQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(classNameId));
				announcementQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).in(userGroupIds));
				announcementQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_EXPIRATION_DATE).ge(date));
				announcementQuery.addOrder(OrderFactoryUtil.desc(Constant.COMMON_STRING_CONSTANT_CREATE_DATE));
				
				entries=AnnouncementsEntryLocalServiceUtil.dynamicQuery(announcementQuery);
			}
		} catch (SystemException e) {
			LOG.error("[MyStuffController: getGroupAnnouncements() ]"+e);
		}
		return entries;
		}
	
		private List<RequestLesson> getRequestLessonAccepted(PortletRequest request){
			DynamicQuery RequestLessonAcceptedQuery= DynamicQueryFactoryUtil.forClass(RequestLesson.class);
			RequestLessonAcceptedQuery.add(RestrictionsFactoryUtil.eq(Constant.ACCEPTED_BY, PortalUtil.getUserId(request)));
			RequestLessonAcceptedQuery.addOrder(OrderFactoryUtil.desc(Constant.LAST_ACTIVITY));
			List<RequestLesson> RequestLesonsAcepted=null;
			try {
				RequestLesonsAcepted=RequestLessonLocalServiceUtil.dynamicQuery(RequestLessonAcceptedQuery,0,3);
			} catch (SystemException e) {
				LOG.error("[MyStuffController: getRequestLessonAccepted() ]"+e);
			}
			return RequestLesonsAcepted;
		}
		
		private Map<String,Integer> getSocialActivities(PortletRequest request){
			
			//String to=new LocalDate().monthOfYear().getAsText() + StringPool.SPACE + new LocalDate().getDayOfMonth(); 
			//String from=new LocalDate().monthOfYear().getAsText() +StringPool.SPACE+ new LocalDate().minusDays(6).dayOfMonth().get();
			Calendar cal = Calendar.getInstance();
			long fromDate=cal.getTimeInMillis();
			cal.add(Calendar.DATE, -6);
			long toDate=cal.getTimeInMillis(); 
			
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(SocialActivity.class);
			dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_USER_ID,PortalUtil.getUserId(request)));
			dynamicQuery.add(RestrictionsFactoryUtil.between(Constant.COMMON_STRING_CONSTANT_CREATE_DATE,toDate,fromDate));
			List<SocialActivity> activities=null;
			try {
				activities = SocialActivityLocalServiceUtil.dynamicQuery(dynamicQuery);
			} catch (SystemException e) {
				LOG.error("[MyStuffController: getSocialActivities() ]"+e);
			}
			
			int requestAcceptedCount=0;
			int commentsAddedCount=0;
			int lessonPublishedCount=0;
			long classNameId=ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
			
			
			for(SocialActivity activity:activities){
				
				if(activity.getType()==NyuMemberActivityKeys.ACCEPT_TO_JOIN_GROUP || 
						activity.getType()==NyuMemberActivityKeys.ACCEPT_INVITATION){
					 requestAcceptedCount++;	
				}
				if(activity.getType()== NyuMemberActivityKeys.SEND_LESSON_NOTIFICATION && activity.getClassNameId()==classNameId){
					lessonPublishedCount++;	
				}
				if(activity.getType()== NyuMemberActivityKeys.ADD_COMMENT){
					commentsAddedCount++;	
				}
			}
			
			Map<String,Integer> userActivities= new HashMap<String,Integer>();
			userActivities.put(Constant.REQUEST_ACCEPTED_COUNT, requestAcceptedCount);
			userActivities.put(Constant.COMMENTS_ADDED_COUNT, commentsAddedCount);
			userActivities.put(Constant.LESSON_PUBLISHED_COUNT, lessonPublishedCount);
			
			return userActivities;
			
		}
		
		private void setJsonData(ResourceRequest request, ResourceResponse response, List<Lesson> lessons,
				int start, int end, ThemeDisplay themeDisplay) throws SystemException, PortalException,
				IOException {
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
		
		
	}


