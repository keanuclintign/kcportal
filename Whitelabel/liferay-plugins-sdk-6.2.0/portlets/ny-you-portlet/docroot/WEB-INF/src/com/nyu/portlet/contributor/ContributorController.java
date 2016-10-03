package com.nyu.portlet.contributor;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.portlet.PortletRequest;
import javax.portlet.PortletResponse;
import javax.portlet.PortletURL;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.joda.time.LocalDate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;

import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.OrderFactoryUtil;
import com.liferay.portal.kernel.dao.orm.ProjectionFactoryUtil;
import com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.User;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portlet.asset.model.AssetCategory;
import com.liferay.portlet.asset.model.AssetTag;
import com.liferay.portlet.asset.model.AssetVocabulary;
import com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetTagLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil;
import com.liferay.portlet.social.model.SocialActivityCounter;
import com.liferay.portlet.social.model.SocialActivityCounterConstants;
import com.liferay.portlet.social.service.SocialActivityCounterLocalServiceUtil;
import com.liferay.portlet.social.util.SocialCounterPeriodUtil;
import com.nyu.model.AnswerRequest;
import com.nyu.model.Lesson;
import com.nyu.model.RequestLesson;
import com.nyu.portlet.vo.CategoryTagsVO;
import com.nyu.service.AnswerRequestLocalServiceUtil;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.RequestLessonLocalServiceUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;
/**
 * Portlet implementation class ContributorController
 */
@Controller
@RequestMapping(value = "VIEW")
public class ContributorController {
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(ContributorController.class);
	
@SuppressWarnings("deprecation")
@RenderMapping
public String view(RenderRequest request,RenderResponse response) throws SystemException, PortalException {
	
		int startPeriod = SocialCounterPeriodUtil.getStartPeriod(new LocalDate().minusMonths(0).dayOfMonth().withMinimumValue().toDateMidnight().getMillis());
			
		List<Long>  currentMonthStats=RequestLessonLocalServiceUtil.getUserContribution(startPeriod, -1,-1);
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		request.setAttribute(Constant.CURRENT_MONTH_STATE,userStats(currentMonthStats,startPeriod,themeDisplay));
			
		startPeriod = SocialCounterPeriodUtil.getStartPeriod(new LocalDate().minusMonths(1).dayOfMonth().withMinimumValue().toDateMidnight().getMillis());
		List<Long> lastMonthStats=RequestLessonLocalServiceUtil.getUserContribution(startPeriod, -1, -1);
		
		request.setAttribute(Constant.LAST_MONTH_STATE, userStats(lastMonthStats,startPeriod,themeDisplay));
			
		return Constant.USER_PROFILE_VIEW_JSP;
}

@RenderMapping(params="action=lessonAndRequests")
public String userContribution(RenderRequest request,RenderResponse response){
	
		String from=ParamUtil.getString(request,Constant.FROM);
		long userId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_ID);
		long classPK = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_CLASS_PK,0l);
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		List<Lesson> lessons=LessonLocalServiceUtil.getLessonsUploadedByAuthorAndStatus(userId,Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH,themeDisplay.getUserId());
		JSONObject userContributionData=JSONFactoryUtil.createJSONObject();
		try {
			String userLessons=setLessonJsonData(request, response, lessons, -1, -1, themeDisplay);
			String userRequest=getAllRequestJson(request,userId).toString();
			User user = UserLocalServiceUtil.getUser(userId);
			   String userName = user.getFullName();
			  /* if(CommonUtil.isAnonymous(user)){
				   userName = Constant.ANONYMOUS_NAME;
			   }*/
			request.setAttribute(Constant.TYPE,from);
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
			request.setAttribute(Constant.CONTRIBUTOR_USER_ID,userId);
			userContributionData.put(Constant.USER_LESSONS, userLessons);
			userContributionData.put(Constant.USER_REQUEST, userRequest);
			request.setAttribute(Constant.USER_CONTRIBUTION_DATA, userContributionData);
			if(classPK > 0){
				request.setAttribute(Constant.TYPE,Constant.CONTRIBUTOR);
				request.setAttribute(Constant.REDIRECT_URL, CommonUtil.createLessonUrl(request, themeDisplay, classPK));	
			}else{
				PortletURL redirectUrl = response.createRenderURL();
				request.setAttribute(Constant.REDIRECT_URL,redirectUrl);
			}
		} catch (SystemException e) {
			LOG.error("[ContributorController: userContribution() ]"+e);
		} catch (PortalException e) {
			LOG.error("[ContributorController: userContribution() ]"+e);
		} catch (IOException e) {
			LOG.error("[ContributorController: userContribution() ]"+e);
		}
		return Constant.USER_LESSON_REQUEST;
}

private String setLessonJsonData(PortletRequest request, PortletResponse response, List<Lesson> lessons,
		int start, int end, ThemeDisplay themeDisplay) throws SystemException, PortalException,	IOException {
	
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
		return AllLessonData.toString();
}	

private JSONArray getAllRequestJson(PortletRequest portletrequest,long userId){
	
	JSONArray allRequestJson=JSONFactoryUtil.createJSONArray();
	List<AssetCategory> categoriesList = null;
	List<AssetTag> tagList = null;
	try {
		
		DynamicQuery requestQuery = DynamicQueryFactoryUtil.forClass(RequestLesson.class);
		requestQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CREATED_BY,userId));
		requestQuery.addOrder(OrderFactoryUtil.desc(Constant.COMMON_STRING_CONSTANT_CREATED_DATE));
		
		List<RequestLesson> requestLessonList=RequestLessonLocalServiceUtil.dynamicQuery(requestQuery);
		
		if(Validator.isNotNull(requestLessonList) && !requestLessonList.isEmpty()){
			for(RequestLesson request:requestLessonList){
				
				JSONObject request_lesson=JSONFactoryUtil.createJSONObject();
				
				DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(AnswerRequest.class);
				dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,request.getRequestLessonId()));
				List<AnswerRequest> answersList= AnswerRequestLocalServiceUtil.dynamicQuery(dynamicQuery);
				
				request_lesson.put(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,request.getRequestLessonId());
				request_lesson.put(Constant.COMMON_STRING_CONSTANT_NAME,request.getName());
				User user = UserLocalServiceUtil.getUser(request.getCreatedBy());
				String userName = user.getFullName();
				/*if(CommonUtil.isAnonymous(user)){
					userName = Constant.ANONYMOUS_NAME;
				}*/
				request_lesson.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
				request_lesson.put(Constant.COMMON_STRING_CONSTANT_CREATE_DATE_II,CommonUtil.getDatesDuration(request.getCreatedDate().getTime(),0));	
				request_lesson.put(Constant.COMMON_STRING_CONSTANT_APPRECIATED_COUNT,CommonUtil.getAppreciatedCount(request.getAppreciatedUserIds()));
				request_lesson.put(Constant.COMMON_STRING_CONSTANT_ANSWER_TYPE,request.getAnswerType());
				request_lesson.put(Constant.COMMON_STRING_CONSTANT_ANSWER_COUNT,answersList.size());
				
				categoriesList = AssetCategoryLocalServiceUtil
						.getCategories(RequestLesson.class.getName(),
								request.getRequestLessonId());
				tagList = AssetTagLocalServiceUtil
						.getTags(RequestLesson.class.getName(),request.getRequestLessonId());
				List<CategoryTagsVO> categoryVOList=new ArrayList<CategoryTagsVO>();
				List<CategoryTagsVO> tagsVOList = new ArrayList<CategoryTagsVO>();
				categoryVOList=new ArrayList<CategoryTagsVO>();
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
			}//end-of-for
		}//end-of-if
		
	} catch (PortalException e)  {
		LOG.error("[ContributorController: getAllRequestJson() ]"+e);
	} catch (SystemException e) {
		LOG.error("[ContributorController: getAllRequestJson() ]"+e);
	}
	
	return allRequestJson;
}

private String userStats(List<Long> userContribution,int startPeriod,ThemeDisplay themeDisplay){
	
   JSONArray userStatJson=JSONFactoryUtil.createJSONArray();
   long userId=0l;
   int rank=1;
   try { 
	   	for (long key : userContribution) {
		   	 int contributionCurrentValue=0;
		     int particpationCurrentValue=0;
		     int contributionTotalValue=0;
		     int particpationTotalValue=0;
	   		
	   		if(!CommonUtil.isAnonymous(UserLocalServiceUtil.getUser(key))){
	   			   long classNameId=ClassNameLocalServiceUtil.getClassNameId(User.class);
				   DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(SocialActivityCounter.class);
				   dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID,classNameId));
				   dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.START_PERIOD,startPeriod));
				   List<String> activitiNames=new ArrayList<String>();
				   activitiNames.add(SocialActivityCounterConstants.NAME_CONTRIBUTION);
				   activitiNames.add(SocialActivityCounterConstants.NAME_PARTICIPATION);
				   dynamicQuery.add(RestrictionsFactoryUtil.in(Constant.COMMON_STRING_CONSTANT_NAME, activitiNames));
				   //dynamicQuery.add(RestrictionsFactoryUtil.eq("name", SocialActivityCounterConstants.NAME_CONTRIBUTION));
				   dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_PK,key));
				   List<SocialActivityCounter> socailActivitiyCounterList = SocialActivityCounterLocalServiceUtil.dynamicQuery(dynamicQuery);
				   
				   if(Validator.isNotNull(socailActivitiyCounterList) && !socailActivitiyCounterList.isEmpty() ){
						
					   for(SocialActivityCounter activity:socailActivitiyCounterList){
						  
						   userId=activity.getClassPK();
						   if(activity.getName().equalsIgnoreCase(SocialActivityCounterConstants.NAME_PARTICIPATION)){
							   particpationCurrentValue=activity.getCurrentValue();
							   particpationTotalValue=activity.getTotalValue();
						   }
						   if(activity.getName().equalsIgnoreCase(SocialActivityCounterConstants.NAME_CONTRIBUTION)){
							   contributionCurrentValue=activity.getCurrentValue();
							   contributionTotalValue=activity.getTotalValue();
							   
						   }
						}//end-of-for
					   
					   if(contributionCurrentValue == 0){
						   DynamicQuery dynamicQuery1= DynamicQueryFactoryUtil.forClass(SocialActivityCounter.class);
						   dynamicQuery1.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_PK,key));
						   dynamicQuery1.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_NAME,SocialActivityCounterConstants.NAME_CONTRIBUTION));
						   dynamicQuery1.setProjection(ProjectionFactoryUtil.max(Constant.TOTAL_VALUE));
						   List<Integer> result= SocialActivityCounterLocalServiceUtil.dynamicQuery(dynamicQuery1);
						   Integer maxTotalValue=result.get(0);
					       contributionTotalValue=maxTotalValue ;
						           
					   }
					   
					   if(particpationCurrentValue == 0){
						   DynamicQuery dynamicQuery1= DynamicQueryFactoryUtil.forClass(SocialActivityCounter.class);
						   dynamicQuery1.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_PK,key));
						   dynamicQuery1.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_NAME, SocialActivityCounterConstants.NAME_PARTICIPATION));
						   dynamicQuery1.setProjection(ProjectionFactoryUtil.max(Constant.TOTAL_VALUE));
						   socailActivitiyCounterList = SocialActivityCounterLocalServiceUtil.dynamicQuery(dynamicQuery1);
						   List<Integer> result= SocialActivityCounterLocalServiceUtil.dynamicQuery(dynamicQuery1);
						   Integer maxTotalValue=result.get(0);
					       particpationTotalValue=maxTotalValue ;
						   
					   }
					   
					   
					   JSONObject userStatObject=JSONFactoryUtil.createJSONObject ();
					   userStatObject.put(Constant.RANK,rank++);
					   userStatObject.put(Constant.CONTRIBUTION_CURRENT_VALUE,contributionCurrentValue);
					   userStatObject.put(Constant.PARTICIPATION_CURRENT_VALUE,particpationCurrentValue);
					   userStatObject.put(Constant.CONTRIBUTION_TOTAL_VALUE,contributionTotalValue);
					   userStatObject.put(Constant.PARTICIPATION_TOTAL_VALUE,particpationTotalValue);
					   userStatObject.put(Constant.COMMON_STRING_CONSTANT_USER_ID,userId);
					   
					   User user = UserLocalServiceUtil.getUser(userId);
					   String userName = user.getFullName();
					   String userPic = user.getPortraitURL(themeDisplay);
					   
					   userStatObject.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
					   userStatObject.put(Constant.COMMON_STRING_CONSTANT_DOCUMENT_PATH,userPic);
					   userStatJson.put(userStatObject);
				   }//end-of-if
	   		}
	   }//end-of-for
	   return userStatJson.toString();
   } catch (SystemException e) {
	   LOG.error("[ContributorController: getAllRequestJson() ]"+e);
   } catch (PortalException e) {
	   LOG.error("[ContributorController: getAllRequestJson() ]"+e);
   }
   return userStatJson.toString();

}

}