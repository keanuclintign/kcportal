package com.nyu.portlet.trending;

import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;

import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.User;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.LayoutLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.liferay.portlet.asset.model.AssetCategory;
import com.liferay.portlet.asset.model.AssetEntry;
import com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil;
import com.liferay.portlet.asset.service.persistence.AssetEntryQuery;
import com.liferay.portlet.messageboards.model.MBMessage;
import com.liferay.portlet.messageboards.service.MBMessageLocalServiceUtil;
import com.nyu.model.Lesson;
import com.nyu.model.RequestLesson;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.RequestLessonLocalServiceUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;
import com.nyu.util.SortLessonUtil;

@Controller
@RequestMapping(value = "VIEW")
public class TrendingController {

	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws SystemException 
	 */
	@RenderMapping
	public String view(RenderRequest request,RenderResponse response)throws SystemException, Exception  {
		trendingData(request,response);
		return Constant.TRENDING_JSP;  
	}

	public void trendingData(RenderRequest renderRequest,RenderResponse renderResponse) throws SystemException, Exception{

		ThemeDisplay themeDisplay = (ThemeDisplay) renderRequest.getAttribute(WebKeys.THEME_DISPLAY);
		JSONArray trendingArr=JSONFactoryUtil.createJSONArray();
		List<Lesson> lessons=SortLessonUtil.getLessonsByItem(0l,themeDisplay.getUserId() ,0l, Constant.COMMON_VIEW_COUNT, -1, -1);
		List<RequestLesson> requestLessons=SortLessonUtil.getRequestLessonsByItem(0l, Constant.COMMON_STRING_CONSTANT_APPRECIATED_COUNT, renderRequest, null);
		if(lessons.size()>20)
		{
			lessons=lessons.subList(0,20);
		}

		if(requestLessons.size()>20)
		{
			requestLessons=requestLessons.subList(0,20);
		}

		List<User> users=new ArrayList<User>();
		Set<Long> userids=new HashSet<Long>();
		Set<String> uniqCata=new HashSet<String>();
		long[] categoriesIds ={};
		int id=0;

		String request_portlet_Id = Constant.PORTLET_REQUEST_LESSON;
		long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true,Constant.PAGE_REQUEST_LESSON).getPlid();
		PortletURL requestDetailURL=PortletURLFactoryUtil.create(renderRequest, request_portlet_Id, targetPlId, PortletRequest.RENDER_PHASE);
		requestDetailURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.REQUEST_DETAILS);
		
		String portletId = Constant.PORTLET_LESSON;
		targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true, Constant.PAGE_LESSON_BROWSE).getPlid();		
		PortletURL showDocumentURL=PortletURLFactoryUtil.create(renderRequest, portletId, targetPlId, PortletRequest.RENDER_PHASE);
		showDocumentURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);	
		
		portletId=Constant.PORTLET_CONTRIBUTOR;
		targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true,Constant.PAGE_CONTRIBUTOR).getPlid();
		PortletURL userDetailsUrl=PortletURLFactoryUtil.create(renderRequest, portletId, targetPlId, PortletRequest.RENDER_PHASE);
		userDetailsUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.LESSON_AND_REQUESTS);
		userDetailsUrl.setParameter(Constant.FROM,Constant.TRENDING_JSP);

		for(Lesson lesson:lessons){
			long userId=lesson.getUploadedById();
			User user = UserLocalServiceUtil.getUser(userId);

			if(Validator.isNotNull(userId) && !CommonUtil.isAnonymous(user)){
				
				categoriesIds = AssetCategoryLocalServiceUtil.getCategoryIds(Lesson.class.getName(),lesson.getLessonId());
				
				
				for(long categoryId:categoriesIds)
				{					
					uniqCata.add(GetterUtil.getString(AssetCategoryLocalServiceUtil.getCategory(categoryId).getName(),StringPool.BLANK));
				}
				userids.add(lesson.getUploadedById());		

				showDocumentURL.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lesson.getLessonId()+StringPool.BLANK);	
				int viewCount = CommonUtil.getViewCount(Lesson.class.getName(),lesson.getLessonId());
				int appreciatedCount = CommonUtil.getAppreciatedCount(lesson.getAppreciatedUserIds());
				id++;
				JSONArray relationArray=JSONFactoryUtil.createJSONArray();
				long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
				DynamicQuery dynamicQuery2 = DynamicQueryFactoryUtil.forClass(MBMessage.class);
				dynamicQuery2.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(lesson.getLessonId()));
				dynamicQuery2.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(lessonClassNameId));

				int commentsCount = MBMessageLocalServiceUtil.dynamicQuery(dynamicQuery2).size();


				for(long categoryId:categoriesIds)			
					relationArray.put(GetterUtil.getString(AssetCategoryLocalServiceUtil.getCategory(categoryId).getName(),StringPool.BLANK).replaceAll(Constant.TRENDING_REG_EX, StringPool.UNDERLINE));

				relationArray.put(UserLocalServiceUtil.getUser(lesson.getUploadedById()).getFullName().toUpperCase().replaceAll(Constant.TRENDING_REG_EX, StringPool.UNDERLINE));

				JSONObject trendingObj=JSONFactoryUtil.createJSONObject();
				StringBuilder info = new StringBuilder();

				/*int anonymousUser = GetterUtil.getStringValues(user.getExpandoBridge().getAttribute("anonymous-user")).length;

			if(anonymousUser == 0){
				info.append("This Lesson is created by<span class='highlight'> "+ user.getFullName().toUpperCase() +Constant.TAG_SPAN_DOT_BREAK_LINE);
			}
			else{
				info.append("This Lesson is created by<span class='highlight'> "+ "anonymous User".toUpperCase() +Constant.TAG_SPAN_DOT_BREAK_LINE);
			}*/

				info.append(CommonUtil.JavaClassI18N(renderRequest, themeDisplay, "this-Lesson-is-created-by")+Constant.TAG_SPACE_SPAN_CLASS_HIGHLIGHT+ user.getFullName().toUpperCase() +Constant.TAG_SPAN_DOT_BREAK_LINE);
				info.append(Constant.TAG_SPACE_SPAN_ARIA_HIDDEN_CLASS_ICON_THUBS_UP+appreciatedCount);
				info.append(Constant.TAG_NON_BREAK_EMPTY_SPACE_SPAN_ARIA_HIDDEN_CLASS_ICON_EYE_OPEN+viewCount);
				info.append(Constant.TAG_NON_BREAK_EMPTY_SPACE_SPAN_ARIA_HIDDEN_CLASS_ICON_COMMENT+commentsCount+Constant.TAG_LINE_BREAK);

				trendingObj.put(Constant.INFO, info.toString());
				trendingObj.put(Constant.COUNTER,id);
				trendingObj.put(Constant.ROLE,Constant.CAPITAL_LESSON);
				trendingObj.put(Constant.DISPLAY_NAME,lesson.getLessonName().toUpperCase());
				trendingObj.put(Constant.COMMON_ID,Constant.D_F_ONE+id);
				trendingObj.put(Constant.HREF,showDocumentURL.toString());
				trendingObj.put(Constant.COMMON_STRING_CONSTANT_NAME,lesson.getLessonName().replaceAll(Constant.TRENDING_REG_EX, StringPool.UNDERLINE));
				trendingObj.put(Constant.STYLE_COLOR,Constant.STRING_COSNTANT_FOUR);
				trendingObj.put(Constant.USER_NAME,user.getScreenName());
				trendingObj.put(Constant.RELATED_ID,relationArray);

				trendingArr.put(trendingObj);
			}
		}

		for(RequestLesson requestLesson:requestLessons){
			long userId=requestLesson.getCreatedBy();
			User user = UserLocalServiceUtil.getUser(userId);
			String AcceptedUser=Constant.TRANSCRIBE_NONE;
			requestDetailURL.setParameter(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,requestLesson.getRequestLessonId()+StringPool.BLANK);	
			if(requestLesson.getAcceptedBy()>0)
			{
				User Accuser = UserLocalServiceUtil.getUser(requestLesson.getAcceptedBy());
				int anonymousUser = GetterUtil.getStringValues(Accuser.getExpandoBridge().getAttribute(Constant.EXPANDO_FIELD_ANONYMOUS_USER)).length;
				if(anonymousUser == 0){
					AcceptedUser=Accuser.getFullName();
				}
				else{
					AcceptedUser = Constant.TRENDING_ANONYMOUS_USER;
				}

			}

			if(Validator.isNotNull(userId) && !CommonUtil.isAnonymous(user) && AcceptedUser!=Constant.TRENDING_ANONYMOUS_USER){
				
				categoriesIds = AssetCategoryLocalServiceUtil.getCategoryIds(RequestLesson.class.getName(),requestLesson.getRequestLessonId());
				for(long categoryId:categoriesIds)
				{					
					uniqCata.add(GetterUtil.getString(AssetCategoryLocalServiceUtil.getCategory(categoryId).getName(),StringPool.BLANK));
				}

				userids.add(requestLesson.getCreatedBy());
				if(requestLesson.getAcceptedBy()>0){
					userids.add(requestLesson.getAcceptedBy());
				}

				int appreciatedCount = CommonUtil.getAppreciatedCount(requestLesson.getAppreciatedUserIds());
				id++;

				JSONArray relationArray=JSONFactoryUtil.createJSONArray();
				if(requestLesson.getAcceptedBy()>0)
				{
					relationArray.put(UserLocalServiceUtil.getUser(requestLesson.getAcceptedBy()).getFullName().toUpperCase().replaceAll(Constant.TRENDING_REG_EX, StringPool.UNDERLINE));
				}
				long reqlessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(RequestLesson.class);
				DynamicQuery dynamicQuery2 = DynamicQueryFactoryUtil.forClass(MBMessage.class);
				dynamicQuery2.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(requestLesson.getRequestLessonId()));
				dynamicQuery2.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(reqlessonClassNameId));

				int commentsCount = MBMessageLocalServiceUtil.dynamicQuery(dynamicQuery2).size();

				for(long categoryId:categoriesIds)			
					relationArray.put(GetterUtil.getString(AssetCategoryLocalServiceUtil.getCategory(categoryId).getName(),StringPool.BLANK).replaceAll(Constant.TRENDING_REG_EX, StringPool.UNDERLINE));

				StringBuilder info = new StringBuilder();
				/*int anonymousUser = GetterUtil.getStringValues(user.getExpandoBridge().getAttribute("anonymous-user")).length;

			if(anonymousUser == 0){
				info.append("Requested by<span class='highlight'> "+ user.getFullName().toUpperCase() +Constant.TAG_SPAN_DOT_BREAK_LINE);
			}
			else{
				info.append("Requested by<span class='highlight'> "+ "anonymous User".toUpperCase() +Constant.TAG_SPAN_DOT_BREAK_LINE);
			}*/

				info.append(CommonUtil.JavaClassI18N(renderRequest, themeDisplay, "requested-by")+Constant.TAG_SPACE_SPAN_CLASS_HIGHLIGHT+ user.getFullName().toUpperCase() +Constant.TAG_SPAN_DOT_BREAK_LINE);
				info.append(CommonUtil.JavaClassI18N(renderRequest, themeDisplay, "accepted-by")+Constant.TAG_SPACE_SPAN_CLASS_HIGHLIGHT+AcceptedUser.toUpperCase() +Constant.TAG_SPAN_DOT_BREAK_LINE);
				info.append(Constant.TAG_SPACE_SPAN_ARIA_HIDDEN_CLASS_ICON_THUBS_UP+appreciatedCount);
				info.append(Constant.TAG_NON_BREAK_EMPTY_SPACE_SPAN_ARIA_HIDDEN_CLASS_ICON_COMMENT+commentsCount+Constant.TAG_LINE_BREAK);

				relationArray.put(UserLocalServiceUtil.getUser(requestLesson.getCreatedBy()).getFullName().toUpperCase().replaceAll(Constant.TRENDING_REG_EX, StringPool.UNDERLINE));

				JSONObject trendingObj=JSONFactoryUtil.createJSONObject();

				trendingObj.put(Constant.INFO,info.toString());
				trendingObj.put(Constant.COUNTER,id);
				trendingObj.put(Constant.ROLE, CommonUtil.JavaClassI18N(renderRequest, themeDisplay, "request-lesson"));
				trendingObj.put(Constant.DISPLAY_NAME,requestLesson.getName().toUpperCase());
				trendingObj.put(Constant.COMMON_ID,Constant.D_F_ONE+id);
				trendingObj.put(Constant.HREF,requestDetailURL.toString());
				trendingObj.put(Constant.COMMON_STRING_CONSTANT_NAME,requestLesson.getName().replaceAll(Constant.TRENDING_REG_EX, StringPool.UNDERLINE));
				trendingObj.put(Constant.STYLE_COLOR, Constant.STRING_COSNTANT_SIXTEEN);
				trendingObj.put(Constant.USER_NAME,UserLocalServiceUtil.getUser(requestLesson.getCreatedBy()).getScreenName());
				trendingObj.put(Constant.RELATED_ID,relationArray);

				trendingArr.put(trendingObj);
			}
		}

		for(Long userid:userids)
		{
			users.add(UserLocalServiceUtil.getUser(userid));
		}

		for(User user:users){


			long lessonsCounts=LessonLocalServiceUtil.getLessonsUploadedByAuthorAndStatus(user.getUserId(),Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH).size();
			/*int anonymousUser = GetterUtil.getStringValues(user.getExpandoBridge().getAttribute("anonymous-user")).length;*/
			DynamicQuery dynamicQuery2 = DynamicQueryFactoryUtil.forClass(RequestLesson.class);
			dynamicQuery2.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CREATED_BY).eq(user.getUserId()));

			DynamicQuery dynamicQuery3 = DynamicQueryFactoryUtil.forClass(RequestLesson.class);
			dynamicQuery3.add(PropertyFactoryUtil.forName(Constant.ACCEPTED_BY).eq(user.getUserId()));

			int RequestCounts=RequestLessonLocalServiceUtil.dynamicQuery(dynamicQuery2).size();
			int AcceptCounts=RequestLessonLocalServiceUtil.dynamicQuery(dynamicQuery3).size();

			StringBuilder info = new StringBuilder();

			info.append(CommonUtil.JavaClassI18N(renderRequest, themeDisplay, "this-user-has-created")+Constant.SPAN_CLASS_HIGHLIGHT+lessonsCounts+StringPool.SPACE+CommonUtil.JavaClassI18N(renderRequest, themeDisplay, "Lesson-s")+ StringPool.SPACE+Constant.TAG_SPAN_CLOSE+StringPool.SPACE+ CommonUtil.JavaClassI18N(renderRequest, themeDisplay, "and")+StringPool.SPACE);
			info.append(CommonUtil.JavaClassI18N(renderRequest, themeDisplay, Constant.KEYWORD_STATUS_REQUEST)+Constant.SPAN_CLASS_HIGHLIGHT+RequestCounts +StringPool.SPACE+CommonUtil.JavaClassI18N(renderRequest, themeDisplay, "Lesson-s")+StringPool.SPACE+Constant.TAG_SPAN_CLOSE+StringPool.SPACE+ CommonUtil.JavaClassI18N(renderRequest, themeDisplay, "and")+StringPool.SPACE);
			info.append(CommonUtil.JavaClassI18N(renderRequest, themeDisplay, Constant.LESSON_MEMBER_STATUS_ACCEPTED)+Constant.SPAN_CLASS_HIGHLIGHT+AcceptCounts +StringPool.SPACE+CommonUtil.JavaClassI18N(renderRequest, themeDisplay, "Request-s")+StringPool.SPACE+Constant.TAG_SPAN_CLOSE);

			id++;
			JSONArray relationArray=JSONFactoryUtil.createJSONArray();

			JSONObject trendingObj=JSONFactoryUtil.createJSONObject();
			trendingObj.put(Constant.INFO,info.toString());
			trendingObj.put(Constant.COUNTER,id);
			trendingObj.put(Constant.ROLE,Constant.USER);
			trendingObj.put(Constant.COMMON_ID,Constant.D_F_ONE+id);
			userDetailsUrl.setParameter(Constant.COMMON_STRING_CONSTANT_USER_ID,String.valueOf(user.getUserId()));
			trendingObj.put(Constant.HREF,userDetailsUrl.toString());
			/*if(anonymousUser == 0){
				trendingObj.put(Constant.DISPLAY_NAME,user.getFullName().toUpperCase());
			}
			else{
				trendingObj.put(Constant.DISPLAY_NAME,"anonymous User".toUpperCase());
			}*/
			trendingObj.put(Constant.DISPLAY_NAME,user.getFullName().toUpperCase());
			trendingObj.put(Constant.COMMON_STRING_CONSTANT_NAME,user.getFullName().toUpperCase().replaceAll(Constant.TRENDING_REG_EX, StringPool.UNDERLINE));
			trendingObj.put(Constant.STYLE_COLOR, Constant.STRING_COSNTANT_TEN);
			trendingObj.put(Constant.USER_NAME,user.getScreenName());
			trendingObj.put(Constant.RELATED_ID,relationArray);

			trendingArr.put(trendingObj);
		}


		for(String category:uniqCata)
		{
			id++;
			JSONArray relationArray=JSONFactoryUtil.createJSONArray();

			JSONObject trendingObj=JSONFactoryUtil.createJSONObject();
			int cataLessonAssetSize=0;
			int cataRequestLessonAssetSize=0;

			DynamicQuery dynamicQuery2 = DynamicQueryFactoryUtil.forClass(AssetCategory.class);
			dynamicQuery2.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_NAME).eq(category));
			List<AssetCategory> Assetcategories=AssetCategoryLocalServiceUtil.dynamicQuery(dynamicQuery2);

			for(AssetCategory assetcata:Assetcategories){
				AssetEntryQuery entryQuery = new AssetEntryQuery();
				entryQuery.setAllCategoryIds(new long[] {assetcata.getCategoryId()});
				entryQuery.setClassName(Lesson.class.getName());
				List<AssetEntry> assetEntries = AssetEntryLocalServiceUtil.getEntries(entryQuery);
				cataLessonAssetSize=assetEntries.size();
				break;
			}

			for(AssetCategory assetcata:Assetcategories){
				AssetEntryQuery entryQuery = new AssetEntryQuery();
				entryQuery.setAllCategoryIds(new long[] {assetcata.getCategoryId()});
				entryQuery.setClassName(RequestLesson.class.getName());
				List<AssetEntry> assetEntries1 = AssetEntryLocalServiceUtil.getEntries(entryQuery);
				cataRequestLessonAssetSize=assetEntries1.size();
				break;
			}


			trendingObj.put(Constant.INFO,CommonUtil.JavaClassI18N(renderRequest, themeDisplay, "This category has")+Constant.SPAN_CLASS_HIGHLIGHT+cataLessonAssetSize+ "</span> "+CommonUtil.JavaClassI18N(renderRequest, themeDisplay, "Lesson-s")+" and "+Constant.SPAN_CLASS_HIGHLIGHT+cataRequestLessonAssetSize+"</span> "+CommonUtil.JavaClassI18N(renderRequest, themeDisplay, "request-lesson-s"));	
			trendingObj.put(Constant.COUNTER,id);
			trendingObj.put(Constant.ROLE, Constant.CAPITAL_CATEGORY);
			trendingObj.put(Constant.COMMON_ID,Constant.D_F_ONE+id);
			trendingObj.put(Constant.HREF,StringPool.BLANK);
			trendingObj.put(Constant.DISPLAY_NAME,category.toUpperCase());
			trendingObj.put(Constant.COMMON_STRING_CONSTANT_NAME,category.replaceAll(Constant.TRENDING_REG_EX, StringPool.UNDERLINE));
			trendingObj.put(Constant.STYLE_COLOR,Constant.STRING_COSNTANT_SEVEN);
			trendingObj.put(Constant.USER_NAME,StringPool.BLANK);
			trendingObj.put(Constant.RELATED_ID,relationArray);

			trendingArr.put(trendingObj);

		}

		File newTextFile = new File(renderRequest.getPortletSession().getPortletContext().getRealPath(StringPool.SLASH)+ Constant.TRENDING_DATA_FILE_ONE_JSON);
		FileWriter fw = new FileWriter(newTextFile);
		fw.write(trendingArr.toString());
		fw.close();

	}



}
