package com.nyu.portlet.requestlesson;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.portlet.PortletRequest;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.liferay.counter.service.CounterLocalServiceUtil;
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
import com.liferay.portal.kernel.mail.MailMessage;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.liferay.portal.model.User;
import com.liferay.portal.model.UserGroup;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.service.UserGroupLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.asset.model.AssetCategory;
import com.liferay.portlet.asset.model.AssetTag;
import com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetTagLocalServiceUtil;
import com.liferay.portlet.documentlibrary.model.DLFileEntry;
import com.liferay.portlet.documentlibrary.service.DLFileEntryLocalServiceUtil;
import com.liferay.portlet.messageboards.model.MBMessage;
import com.liferay.portlet.messageboards.service.MBMessageLocalServiceUtil;
import com.nyu.model.AnswerRequest;
import com.nyu.model.AuditReport;
import com.nyu.model.Lesson;
import com.nyu.model.LessonCollaboration;
import com.nyu.model.RequestLesson;
import com.nyu.model.impl.AnswerRequestImpl;
import com.nyu.model.impl.LessonCollaborationImpl;
import com.nyu.portlet.social.activities.NyuMemberActivityKeys;
import com.nyu.portlet.vo.CategoryTagsVO;
import com.nyu.service.AnswerRequestLocalServiceUtil;
import com.nyu.service.AuditReportLocalServiceUtil;
import com.nyu.service.LessonCollaborationLocalServiceUtil;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.RequestLessonLocalServiceUtil;
import com.nyu.util.AuditNyuUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;
import com.nyu.util.UserGroupSortByName;


/**
 * Portlet implementation class NyuWelcome
 */
@Controller
@RequestMapping(value = "VIEW")
public class RequestLessonController  {
	private static org.apache.log4j.Logger LOG= Logger.getLogger(RequestLessonController.class);
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws SystemException 
	 */
	@RenderMapping
	public String view(RenderRequest request,RenderResponse response) throws SystemException {
		
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_ALL_REQUEST_JSON,getAllRequestJson(request));
		getUserGroup(request);
		return Constant.LESSON_PERMISSION_VIEW_ONLY;    
	}
	
	@RenderMapping(params = "action=createGroupRequest")  
	public String createRequest(RenderRequest request,RenderResponse response){
		String groupId=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_GROUP_ID);
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_ALL_REQUEST_JSON,getAllRequestJson(request));
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,groupId);
		getUserGroup(request);
		
		return Constant.LESSON_PERMISSION_VIEW_ONLY;        
	}
	
	@RenderMapping(params = "action=createMyRequest")  
	public String createMyRequest(RenderRequest request,RenderResponse response){
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_ALL_REQUEST_JSON,getAllRequestJson(request));
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_MY_REQUEST,Constant.COMMON_STRING_CONSTANT_MY_REQUEST);
		getUserGroup(request);
		return Constant.LESSON_PERMISSION_VIEW_ONLY;    
	}
	
	@RenderMapping(params = "action=showRequestPage")  
    public String showRequestPage(RenderRequest request,RenderResponse response) {	
		getUserGroup(request);
		return Constant.REQUEST_LESSON_CREATE_REQUEST_JSP;
	}
	
	
	@RenderMapping(params ="action=subjectPage")
	public String  subjectPage(RenderRequest request,RenderResponse response){
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_SUBJECT_JSON,RequestLessonLocalServiceUtil.getAllRequestCategories());
		return Constant.REQUEST_LESSON_SUBJECT_JSP;
		
	}

	@RenderMapping(params ="action=requestDetails")
	public String requestDetails(RenderRequest request,RenderResponse response) {
		long requestLessonId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID);
		RequestLesson requestLesson=null;
		getUserGroup(request);
		try {
			requestLesson=RequestLessonLocalServiceUtil.getRequestLesson(requestLessonId);
			 if(requestLesson.getAnswerType().equalsIgnoreCase(Constant.REQUEST_INFORMATION)){
				 	request.setAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,String.valueOf(requestLessonId));
					request.setAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_JSON,getrequestLessonJson(requestLessonId,request));
					request.setAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_JSON, answerJson(requestLessonId,request,requestLesson.getAnswerType()));
					request.setAttribute(Constant.COMMON_STRING_CONSTANT_COMMENTS_JSON,getRequestComments(requestLessonId,request));
					request.setAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_COMMENTS_JSON,getanswerComments(request));
					return Constant.REQUEST_LESSON_REQUEST_FOR_INFO;
				 
			 }else  if(requestLesson.getAnswerType().equalsIgnoreCase(Constant.REQUEST_OPINION)){
				 request.setAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,String.valueOf(requestLessonId));
				 request.setAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_JSON,getrequestLessonJson(requestLessonId,request));
				 request.setAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_JSON, answerJson(requestLessonId,request,requestLesson.getAnswerType()));
				 request.setAttribute(Constant.COMMON_STRING_CONSTANT_COMMENTS_JSON,getRequestComments(requestLessonId,request));
				 request.setAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_COMMENTS_JSON,getanswerComments(request));
				 return Constant.REQUEST_OPINION;
				 
			 }else  if(requestLesson.getAnswerType().equalsIgnoreCase(Constant.REQUEST_LESSON)){
				 request.setAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,String.valueOf(requestLessonId));
				 request.setAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_JSON,getrequestLessonJson(requestLessonId,request));
				 request.setAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_JSON, answerJson(requestLessonId,request,requestLesson.getAnswerType()));
				 request.setAttribute(Constant.COMMON_STRING_CONSTANT_COMMENTS_JSON,getRequestComments(requestLessonId,request));
				 request.setAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_COMMENTS_JSON,getanswerComments(request));
				 
				 return Constant.REQUEST_LESSON;
			 
			 }else{
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,String.valueOf(requestLessonId));
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_JSON,getrequestLessonJson(requestLessonId,request));
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_JSON, collobrationAnswerJson(requestLessonId));
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_COMMENTS_JSON,getRequestComments(requestLessonId,request));
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_COMMENTS_JSON,getanswerComments(request));
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSONS,LessonLocalServiceUtil.getLessonsUploadedByAuthorAndStatus(PortalUtil.getUserId(request),Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_COLLABORATION_LESSON_JSON, userLessonJson(request));
				return Constant.REQUEST_LESSON_REQ_COLLABORATION;
				 
			 }//end-of if-else
	
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: requestDetails() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: requestDetails() ]"+e);
		}
		return null;
		
	}
	
	@ResourceMapping(value="saveAnswer")
	public void saveAnswer(ResourceRequest request,ResourceResponse response)
	{
	   long requestLessonId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID);	
	   String description=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_ANSWER);
	   String answerType=ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_ANSWER_TYPE);
	   String myLessonIds = ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_MY_LESSON_IDS);
	   String myFavLessonIds = ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_MY_FAV_LESSON_IDS);
	   AnswerRequest answerRequest=new AnswerRequestImpl();
	   answerRequest.setRequestLessonId(requestLessonId);
	   answerRequest.setUserId(PortalUtil.getUserId(request));
	   answerRequest.setDescription(description);
	   answerRequest.setCreateDate(new Date());
	   answerRequest.setMyLessons(myLessonIds);
	   answerRequest.setMyFavouriteLessons(myFavLessonIds);
	   
	   if(Validator.isNotNull(answerType) && answerType.equalsIgnoreCase(Constant.REQUEST_OPINION)){
			String opinionSurvey=ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_OPINION_SURVEY);
			answerRequest.setOpinionSurvey(opinionSurvey);
		}
	   
		try {
			AnswerRequestLocalServiceUtil.addAnswerRequest(answerRequest);
			response.getWriter().write(answerJson(requestLessonId,request,RequestLessonLocalServiceUtil.getRequestLesson(requestLessonId).getAnswerType()));
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: saveAnswer() ]"+e);
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: saveAnswer() ]"+e);
		} catch (IOException e) {
			LOG.error("[RequestLessonController: saveAnswer() ]"+e);
		}
	  
	}
	
	@ResourceMapping(value="addComment")
	public void addComment(ResourceRequest request,ResourceResponse response)
	{
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long requestLessonId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID);	
		long requestLessonNameId = ClassNameLocalServiceUtil.getClassNameId(RequestLesson.class);
		String body=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_BODY);

		try {
			long messageId = 0l;
			messageId = CounterLocalServiceUtil.increment();
			MBMessage mbMessage = MBMessageLocalServiceUtil.createMBMessage(messageId);
			mbMessage.setGroupId(themeDisplay.getScopeGroupId());
			mbMessage.setCompanyId(themeDisplay.getCompanyId());
			mbMessage.setUserId(themeDisplay.getUserId());
			mbMessage.setCreateDate(new Date());
			mbMessage.setClassNameId(requestLessonNameId);
			mbMessage.setClassPK(requestLessonId);
			mbMessage.setUserName(themeDisplay.getUser().getFullName());
			mbMessage.setBody(body);
			MBMessageLocalServiceUtil.addMBMessage(mbMessage);
			RequestLesson requestLesson=RequestLessonLocalServiceUtil.getRequestLesson(requestLessonId);
			requestLesson.setLastActivity(new Date());
			RequestLessonLocalServiceUtil.updateRequestLesson(requestLesson);
			LessonLocalServiceUtil.performCleanUp(requestLessonId,Constant.LESSON_PERFORM_CLEAN_UP_DELETE_COMMENT,themeDisplay.getUserId(),NyuMemberActivityKeys.ADD_COMMENT, null);
			LessonLocalServiceUtil.addSocialActivity(themeDisplay.getUserId(), themeDisplay.getScopeGroupId(), RequestLesson.class.getName(), requestLessonId, NyuMemberActivityKeys.ADD_COMMENT);
			
			response.getWriter().write(getRequestComments(ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID),request));
		} catch (Exception e) {
			LOG.error("[RequestLessonController: addComment() ]"+e);
		}
	}
	
	@ResourceMapping(value="addAnswerComment")
	public void addAnswerComment(ResourceRequest request,ResourceResponse response)
	{
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long answerId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_ANSWER_ID);	
		long answerRequestNameId = ClassNameLocalServiceUtil.getClassNameId(AnswerRequest.class);
		String body=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_BODY);

		try {
			long messageId = 0l;
			messageId = CounterLocalServiceUtil.increment();
			MBMessage mbMessage = MBMessageLocalServiceUtil.createMBMessage(messageId);
			mbMessage.setGroupId(themeDisplay.getScopeGroupId());
			mbMessage.setCompanyId(themeDisplay.getCompanyId());
			mbMessage.setUserId(themeDisplay.getUserId());
			mbMessage.setCreateDate(new Date());
			mbMessage.setClassNameId(answerRequestNameId);
			mbMessage.setClassPK(answerId);
			mbMessage.setUserName(themeDisplay.getUser().getFullName());
			mbMessage.setBody(body);
			MBMessageLocalServiceUtil.addMBMessage(mbMessage);
			LessonLocalServiceUtil.performCleanUp(answerId,Constant.LESSON_PERFORM_CLEAN_UP_DELETE_COMMENT,themeDisplay.getUserId(),NyuMemberActivityKeys.ADD_COMMENT, null);
			LessonLocalServiceUtil.addSocialActivity(themeDisplay.getUserId(), themeDisplay.getScopeGroupId(), AnswerRequest.class.getName(), answerId, NyuMemberActivityKeys.ADD_COMMENT);
			
			response.getWriter().write(getanswerComments(request));
		} catch (Exception e) {
			LOG.error("[RequestLessonController: addAnswerComment() ]"+e);
		}
	}
	
	@ResourceMapping(value = "appreciateAnswer")
	public void appreciateAnswer(ResourceRequest request,ResourceResponse response) {
		
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long userId = themeDisplay.getUserId();
		long answerId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_ANSWER_ID);
		long requestLessonId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID);	
		int appreciatedCount = 0;
		
		try {
			AnswerRequest answerRequest = AnswerRequestLocalServiceUtil.getAnswerRequest(answerId);
			String appreciatedUserIds = answerRequest.getAppreciateUserIds();
			List<String> items = new ArrayList<String>();
			
			if(!appreciatedUserIds.isEmpty()){
				items = Arrays.asList(appreciatedUserIds.split(StringPool.COMMA));
			}
			
			if(!items.contains(userId)){
				if(appreciatedUserIds.isEmpty()){
					appreciatedUserIds = userId+StringPool.BLANK;
				} else {
					appreciatedUserIds = appreciatedUserIds+StringPool.COMMA+userId;
				}
				
				answerRequest.setAppreciateUserIds(appreciatedUserIds);
				appreciatedCount = items.size()+1;
				answerRequest.setAppreciateCount(appreciatedCount);
				AnswerRequestLocalServiceUtil.updateAnswerRequest(answerRequest);
				response.getWriter().write(answerJson(requestLessonId,request,RequestLessonLocalServiceUtil.getRequestLesson(answerRequest.getRequestLessonId()).getAnswerType()));
			}
			
		} catch (NumberFormatException e) {
			LOG.error("[RequestLessonController: appreciateAnswer() ]"+e);
		} catch (IOException e) {
			LOG.error("[RequestLessonController: appreciateAnswer() ]"+e);
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: appreciateAnswer() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: appreciateAnswer() ]"+e);
		}
		
		
	}
	
	@ResourceMapping(value = "unAppreciateAnswer")
	public void unAppreciateAnswer(ResourceRequest request,ResourceResponse response) {
		long userId = PortalUtil.getUserId(request);
		long answerId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_ANSWER_ID);
		
		List<String> items = new ArrayList<String>();
		int appreciatedCount = 0;
		
		try {
			AnswerRequest answerRequest = AnswerRequestLocalServiceUtil.getAnswerRequest(answerId);
			String appreciatedUserIds = answerRequest.getAppreciateUserIds();
			long requestId=answerRequest.getRequestLessonId();	
			appreciatedUserIds=removeAppreciateUserIds(appreciatedUserIds,userId);
			
			answerRequest.setAppreciateUserIds(appreciatedUserIds);
			
			if(!appreciatedUserIds.isEmpty()){
				items = Arrays.asList(appreciatedUserIds.split(StringPool.COMMA));
			}
			appreciatedCount = items.size();
			answerRequest.setAppreciateCount(appreciatedCount);
			AnswerRequestLocalServiceUtil.updateAnswerRequest(answerRequest);
			
			response.getWriter().write(answerJson(requestId,request,RequestLessonLocalServiceUtil.getRequestLesson(requestId).getAnswerType()));
			
		} catch (NumberFormatException e) {
			LOG.error("[RequestLessonController: unAppreciateAnswer() ]"+e);
		} catch (IOException e) {
			LOG.error("[RequestLessonController: unAppreciateAnswer() ]"+e);
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: unAppreciateAnswer() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: unAppreciateAnswer() ]"+e);
		}
	}
	
	@ResourceMapping(value = "createRequest")
	public void createRequest(ResourceRequest request,ResourceResponse response) {
		
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		String name = ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_NAME);
		String answerType = ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_ANSWER_TYPE);
		String surveyOptions=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_OPINION_SURVEY_LINK);
		if(surveyOptions.isEmpty()){
			surveyOptions= Constant.YES_NO_MAYBE;
		}
		long sendTo = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_SEND_TO);
		long groupId=0l;
		if(sendTo==1){
			groupId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_USER_GROUPS);	
		}
		long requestLessonId;
		try {
			requestLessonId = CounterLocalServiceUtil.increment(RequestLesson.class.getName());
		RequestLesson requestLesson = RequestLessonLocalServiceUtil.createRequestLesson(requestLessonId);
		
		requestLesson.setCompanyId(themeDisplay.getCompanyId());
		requestLesson.setGroupId(themeDisplay.getScopeGroupId());
		requestLesson.setName(name);
		requestLesson.setAnswerType(answerType);
		
		requestLesson.setCreatedBy(themeDisplay.getUserId());
		requestLesson.setCreatedDate(new Date());
		requestLesson.setSendTo(groupId);
		requestLesson.setSurveyOptions(surveyOptions);
		requestLesson.setStatus(Constant.REQUEST_LESSON_STATUS_OPEN);
		requestLesson.setLastActivity(new Date());
		
		requestLesson = RequestLessonLocalServiceUtil.addRequestLesson(requestLesson);
		
		ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
		
		CommonUtil.addUpadteAssetEntry(PortalUtil.getUploadPortletRequest(request), serviceContext, requestLesson.getPrimaryKey(), RequestLesson.class.getName());
		
		AuditReport auditReport=AuditNyuUtil.createReport(PortalUtil.getHttpServletRequest(request), CommonUtil.JavaClassI18N(request, themeDisplay, "create-request"),requestLesson.getRequestLessonId()+StringPool.BLANK, Constant.REQUEST_LESSON_CLASS_NAME,requestLesson.getName());
		AuditReportLocalServiceUtil.addAuditReport(auditReport);
		
		response.getWriter().write(String.valueOf(requestLesson.getRequestLessonId()));
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: createRequest() ]"+e);
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: createRequest() ]"+e);
		} catch (IOException e) {
			LOG.error("[RequestLessonController: createRequest() ]"+e);
		}
		
	}
	
	
	@ResourceMapping(value = "existingRequest")
	public void existingRequest(ResourceRequest request,ResourceResponse response) {
		
		String[] requestName = ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_NAME).trim().replaceAll(Constant.BRACKET_OPEN_BACK_SLASH_W_SLASH_S_SLASH_HYPHEN_CLOSE, StringPool.BLANK).split(StringPool.SPACE);
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(RequestLesson.class);
		Criterion criterion = null;
		String[] restrictedWords=Constant.PORTLET_PROP_LIFERAY_SITE_EXISTING_REQUEST_SEARCH_WORD.trim().toLowerCase().split(StringPool.COMMA);
		List<String>  restrictedWordsList=new ArrayList<String>();
		JSONArray matchedRequest=JSONFactoryUtil.createJSONArray();
		int i=0;
		for(String word : restrictedWords){
			restrictedWordsList.add(word);
		}
		
		for (;i<requestName.length; i++ ){
			if(requestName[i].length()>2 && !restrictedWordsList.contains(requestName[i].toLowerCase()) ){
				criterion = RestrictionsFactoryUtil.like(Constant.COMMON_STRING_CONSTANT_NAME, StringPool.PERCENT + requestName[i] + StringPool.PERCENT);
				break;
			}
		}
		if(requestName.length>1){
			for (i=i+1;i<requestName.length; i++ ){
				if(requestName[i].length()>2 && !restrictedWordsList.contains(requestName[i].toLowerCase())  ){
					criterion = RestrictionsFactoryUtil.or(criterion , RestrictionsFactoryUtil.like(Constant.COMMON_STRING_CONSTANT_NAME, StringPool.PERCENT + requestName[i] + StringPool.PERCENT));
				}
			}
		}
		try {	
				if(Validator.isNotNull(criterion)){
					dynamicQuery.add(criterion);
					List<RequestLesson> requestLessonList= RequestLessonLocalServiceUtil.dynamicQuery(dynamicQuery);
					
					if(Validator.isNotNull(requestLessonList) && requestLessonList.size()>0){
						
						for(RequestLesson request_lesson:requestLessonList){
						JSONObject requestLesson=JSONFactoryUtil.createJSONObject();
						requestLesson.put(Constant.COMMON_STRING_CONSTANT_REQUEST_ID,String.valueOf(request_lesson.getRequestLessonId()));
						requestLesson.put(Constant.COMMON_STRING_CONSTANT_NAME,request_lesson.getName());
						requestLesson.put(Constant.COMMON_STRING_CONSTANT_REQUEST_TYPE,request_lesson.getAnswerType());
						User user = UserLocalServiceUtil.getUser(request_lesson.getCreatedBy());
						String userName = user.getFullName();
						/*if(CommonUtil.isAnonymous(user)){
						   userName = Constant.ANONYMOUS_NAME;
						}*/
						requestLesson.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
						requestLesson.put(Constant.COMMON_STRING_CONSTANT_USER_ID,UserLocalServiceUtil.getUser(request_lesson.getCreatedBy()).getUserId());
						requestLesson.put(Constant.COMMON_STRING_CONSTANT_CREATE_DATE,CommonUtil.getDatesDuration(request_lesson.getCreatedDate().getTime(),0));
						requestLesson.put(Constant.COMMON_STRING_CONSTANT_APPRECIATED_COUNT,CommonUtil.getAppreciatedCount(request_lesson.getAppreciatedUserIds()));
						DynamicQuery answerRequest = DynamicQueryFactoryUtil.forClass(AnswerRequest.class);
						answerRequest.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,request_lesson.getRequestLessonId()));
						List<AnswerRequest> answersList= AnswerRequestLocalServiceUtil.dynamicQuery(answerRequest);
						requestLesson.put(Constant.COMMON_STRING_CONSTANT_ANSWER_COUNT,answersList.size());
						requestLesson.put(Constant.COMMON_STRING_CONSTANT_ANSWER_TYPE,request_lesson.getAnswerType());
						
						matchedRequest.put(requestLesson);
						}
						response.getWriter().write(matchedRequest.toString());
					}else{
						response.getWriter().write(matchedRequest.toString());
					}
					
				}else{
					response.getWriter().write(matchedRequest.toString());
				}
			
			} catch (SystemException e) {
				LOG.error("[RequestLessonController: existingRequest() ]"+e);
			} catch (IOException e) {
				LOG.error("[RequestLessonController: existingRequest() ]"+e);
			} catch (PortalException e) {
				LOG.error("[RequestLessonController: existingRequest() ]"+e);
			}
	
	}
	
	@ResourceMapping(value = "checkAnswer")
	public void checkAnswer(ResourceRequest request,ResourceResponse response) {
		long answerId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_ANSWER_ID);
		long requestId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_REQUEST_ID);
		
		boolean checkedAnswer=ParamUtil.getBoolean(request,Constant.COMMON_STRING_CONSTANT_IS_CHECKED);
		try {
			AnswerRequest answerRequest=AnswerRequestLocalServiceUtil.getAnswerRequest(answerId);
			answerRequest.setCheckedAnswer(checkedAnswer);
			AnswerRequestLocalServiceUtil.updateAnswerRequest(answerRequest);
			String answerType=RequestLessonLocalServiceUtil.getRequestLesson(requestId).getAnswerType();
			response.getWriter().write(answerJson(requestId, request, answerType));
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: checkAnswer() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: checkAnswer() ]"+e);
		} catch (IOException e) {
			LOG.error("[RequestLessonController: checkAnswer() ]"+e);
		}
	
	}
	
	@ResourceMapping(value="deleteRequest")
	public void deleteRequest(ResourceRequest request,ResourceResponse response){
		
		long requestId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_REQUEST_ID);
		try {
			RequestLesson requestLesson=RequestLessonLocalServiceUtil.getRequestLesson(requestId);
			performCleanUp(requestId);
			AuditReport auditReport=AuditNyuUtil.createReport(PortalUtil.getHttpServletRequest(request), "Delete Request",requestLesson.getRequestLessonId()+StringPool.BLANK,Constant.REQUEST_LESSON_CLASS_NAME,requestLesson.getName());
			AuditReportLocalServiceUtil.addAuditReport(auditReport);
			response.getWriter().write(getAllRequestJson(request).toString());
		} catch (IOException e) {
			LOG.error("[RequestLessonController: deleteRequest() ]"+e);
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: deleteRequest() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: deleteRequest() ]"+e);
		}
		
	}
	
	@ResourceMapping(value="deleteAnswer")
	public void deleteAnswer(ResourceRequest request,ResourceResponse response){
		
		long answerId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_ANSWER_ID);
		long requestLessonId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_REQUEST_ID);
		long answerRequestLessonNameId=ClassNameLocalServiceUtil.getClassNameId(AnswerRequest.class);
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(answerId));
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(answerRequestLessonNameId));
		try {
			AnswerRequestLocalServiceUtil.deleteAnswerRequest(answerId);
			List<MBMessage> answerComments = MBMessageLocalServiceUtil.dynamicQuery(dynamicQuery);
			for(MBMessage comment:answerComments){
				MBMessageLocalServiceUtil.deleteMBMessage(comment.getMessageId());
			}
			response.getWriter().write(answerJson(requestLessonId,request,RequestLessonLocalServiceUtil.getRequestLesson(requestLessonId).getAnswerType()));
		} catch (IOException e) {
			LOG.error("[RequestLessonController: deleteAnswer() ]"+e);
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: deleteAnswer() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: deleteAnswer() ]"+e);
		}
	
		
	}
	
	@ResourceMapping(value="deleteCollaborationAnswer")
	public void deleteCollaboratonRequestAnswer(ResourceRequest request,ResourceResponse response){
		
		long requestId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_REQUEST_ID);
		long answerId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_ANSWER_ID);
		long colloborationId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_COLLOBORATION_ID);
		
		try {
			AnswerRequestLocalServiceUtil.deleteAnswerRequest(answerId);
			LessonCollaborationLocalServiceUtil.deleteLessonCollaboration(colloborationId);
			response.getWriter().write(collobrationAnswerJson(requestId));
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: deleteCollaborationAnswer() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: deleteCollaborationAnswer() ]"+e);
		} catch (IOException e) {
			LOG.error("[RequestLessonController: deleteCollaborationAnswer() ]"+e);
		}
	}
	
	@ResourceMapping(value="deleteComments")
	public void deleteComments(ResourceRequest request,ResourceResponse response){
		
		long answerCommentId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_ANSWER_COMMENT_ID);
		long requestCommentId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_REQUEST_COMMENT_ID);
		long requestId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_REQUEST_ID);
		
		try{
			if(answerCommentId==0){
				MBMessageLocalServiceUtil.deleteMBMessage(requestCommentId);
				response.getWriter().write(getRequestComments(requestId,request));
			} else{
				MBMessageLocalServiceUtil.deleteMBMessage(answerCommentId);
				response.getWriter().write(getanswerComments(request));
			}
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: deleteCollaborationAnswer() ]"+e);
		} catch (PortalException e) {
				LOG.error("[RequestLessonController: deleteCollaborationAnswer() ]"+e);
		} catch (IOException e) {
				LOG.error("[RequestLessonController: deleteCollaborationAnswer() ]"+e);
		}
	}
	
	@ResourceMapping(value="appreciateRequest")
	public void appreciateRequest(ResourceRequest request,ResourceResponse response){
		
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long userId = themeDisplay.getUserId();
		long requestId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_REQUEST_ID);
		
		try {
			RequestLesson userRequest = RequestLessonLocalServiceUtil.getRequestLesson(requestId);
			String appreciatedUserIds = userRequest.getAppreciatedUserIds();
			List<String> items = new ArrayList<String>();
			
			if(!appreciatedUserIds.isEmpty()){
				items = Arrays.asList(appreciatedUserIds.split(StringPool.COMMA));
			}
			if(!items.contains(userId)){
				if(appreciatedUserIds.isEmpty()){
					appreciatedUserIds = userId+StringPool.BLANK;
				} else {
					appreciatedUserIds = appreciatedUserIds+StringPool.COMMA+userId;
				}
				userRequest.setAppreciatedUserIds(appreciatedUserIds);
				RequestLessonLocalServiceUtil.updateRequestLesson(userRequest);
				response.getWriter().write(getrequestLessonJson(requestId,request));
			}
			
		} catch (NumberFormatException e) {
			LOG.error("[RequestLessonController: appreciateRequest() ]"+e);
		} catch (IOException e) {
			LOG.error("[RequestLessonController: appreciateRequest() ]"+e);
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: appreciateRequest() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: appreciateRequest() ]"+e);
		}
		
	}
	
	@ResourceMapping(value="unAppreciateRequest")
	public void unAppreciateRequest(ResourceRequest request,ResourceResponse response){
		
		long requestId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_REQUEST_ID);
		RequestLesson userRequest=null;
		try {
			userRequest = RequestLessonLocalServiceUtil.getRequestLesson(requestId);
			String appreciatedUserIds = userRequest.getAppreciatedUserIds();
		
			appreciatedUserIds=removeAppreciateUserIds(appreciatedUserIds, PortalUtil.getUserId(request));
			userRequest.setAppreciatedUserIds(appreciatedUserIds);
			RequestLessonLocalServiceUtil.updateRequestLesson(userRequest);
			response.getWriter().write(getrequestLessonJson(requestId,request));
			
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: unAppreciateRequest() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: unAppreciateRequest() ]"+e);
		} catch (IOException e) {
			LOG.error("[RequestLessonController: unAppreciateRequest() ]"+e);
		}
	}
	
	private String removeAppreciateUserIds(String appreciatedUserIds,long userId ){
		
		List<String> items = new ArrayList<String>();
		if(!appreciatedUserIds.isEmpty()){
			items = Arrays.asList(appreciatedUserIds.split(StringPool.COMMA));
		}
		if(items.contains(String.valueOf(userId))){
			String appreciateUserId=String.valueOf(userId);
			appreciatedUserIds=StringPool.BLANK;
			if(items.size()>0){
				for(String item:items){
					if(!item.equals(appreciateUserId)){
						if(appreciatedUserIds.isEmpty()){
							appreciatedUserIds = item+StringPool.BLANK;
						} else {
							appreciatedUserIds = appreciatedUserIds+StringPool.COMMA+item;
						}
					}
				}//end-of for
			}
		}//end-of-if
		return appreciatedUserIds;
	}
	
	private String answerJson(long requestLessonId,PortletRequest request,String answerType){
		 
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		JSONArray answerJson=JSONFactoryUtil.createJSONArray();
		
		try {
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(AnswerRequest.class);
			dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,requestLessonId));
			dynamicQuery.addOrder(OrderFactoryUtil.desc(Constant.COMMON_STRING_CONSTANT_CREATE_DATE));
			List<AnswerRequest> answersList= AnswerRequestLocalServiceUtil.dynamicQuery(dynamicQuery);
			
			if(Validator.isNotNull(answersList) && !answersList.isEmpty()){
				 for(AnswerRequest answerRequest:answersList){
					 	JSONObject answer=JSONFactoryUtil.createJSONObject();
					 	
					 	boolean hasAppreciated = false;
						String appreciatedUserIds = answerRequest.getAppreciateUserIds();
						List<String> items = new ArrayList<String>();
						if (!appreciatedUserIds.isEmpty()) {
							items = Arrays.asList(appreciatedUserIds.split(StringPool.COMMA));
							hasAppreciated = items.contains(themeDisplay.getUserId()+StringPool.BLANK);
						}
						answer.put(Constant.COMMON_STRING_CONSTANT_ANSWER_ID,String.valueOf(answerRequest.getAnswerId())); 
						answer.put(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,String.valueOf(answerRequest.getRequestLessonId()));
						answer.put(Constant.COMMON_STRING_CONSTANT_DESCRIPTION,String.valueOf(answerRequest.getDescription()));
						answer.put(Constant.COMMON_STRING_CONSTANT_USER_ID,answerRequest.getUserId());
						User user = UserLocalServiceUtil.getUser(answerRequest.getUserId());
						String userName = user.getFullName();
						/*if(CommonUtil.isAnonymous(user)){
						   userName = Constant.ANONYMOUS_NAME;
						}*/
						answer.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
						answer.put(Constant.COMMON_STRING_CONSTANT_HAS_APPRECIATED, hasAppreciated);
						answer.put(Constant.COMMON_STRING_CONSTANT_APPRECIATED_COUNT, answerRequest.getAppreciateCount());
						String duration=CommonUtil.getDatesDuration(answerRequest.getCreateDate().getTime(),0);
						answer.put(Constant.COMMON_STRING_CONSTANT_CREATE_DATE, duration);
						answer.put(Constant.COMMON_STRING_CONSTANT_CHECKED,answerRequest.getCheckedAnswer());
						
						if(Validator.isNotNull(answerType) && answerType.equalsIgnoreCase(Constant.REQUEST_LESSON)){
							if(Validator.isNotNull(answerRequest.getMyLessons())){
								String lessonId=answerRequest.getMyLessons();
								boolean found=false;
								 Lesson lesson=null;
								try{
									lesson=LessonLocalServiceUtil.getLesson(GetterUtil.getLong(lessonId));
								}catch(Exception e){
									found=true;
								}
							    if(!found){
							    	answer.put(Constant.COMMON_STRING_CONSTANT_LESSON_ID,lessonId);
							    	answer.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,lesson.getLessonName());
							    	answerJson.put(answer);
							    }else{
									AnswerRequestLocalServiceUtil.deleteAnswerRequest(answerRequest.getAnswerId());
								}
							}else{
								answerJson.put(answer);
							}
				 		}else{
				 			answerJson.put(answer);	
				 		}
				 }//end-of-for
				
			}//end-of-if
			if(Validator.isNotNull(answerType) && answerType.equalsIgnoreCase(Constant.REQUEST_OPINION)){
				JSONObject AllAnswerData=JSONFactoryUtil.createJSONObject();
				AllAnswerData.put(Constant.COMMON_STRING_CONSTANT_GET_ANSWER_JSON,answerJson);
				AllAnswerData.put(Constant.COMMON_STRING_CONSTANT_GET_OPINION_SURVEY,opinionSurvey(requestLessonId));
				return AllAnswerData.toString();	
			} else{
				return answerJson.toString();	
			}
			
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: answerJson() ]"+e);
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: answerJson() ]"+e);
		}
		
		return answerJson.toString();
	}
	
	private String getRequestComments(long requestLessonId,PortletRequest request){
		
		long requestLessonNameId = ClassNameLocalServiceUtil.getClassNameId(RequestLesson.class);
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		JSONArray commentsJson=JSONFactoryUtil.createJSONArray();
		
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(requestLessonId));
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(requestLessonNameId));
		dynamicQuery.addOrder(OrderFactoryUtil.desc(Constant.COMMON_STRING_CONSTANT_CREATE_DATE));
		
		try {
			List<MBMessage> comments = MBMessageLocalServiceUtil.dynamicQuery(dynamicQuery);
			if(Validator.isNotNull(comments) && !comments.isEmpty()){
				for(MBMessage  comment:comments){
					JSONObject request_comments=JSONFactoryUtil.createJSONObject();
					request_comments.put(Constant.COMMON_STRING_CONSTANT_COMMENT_ID,comment.getMessageId());
					request_comments.put(Constant.COMMON_STRING_CONSTANT_DESCRIPTION,comment.getBody());
					User user = UserLocalServiceUtil.getUser(comment.getUserId());
					String userName = user.getFullName();
					String userPic = user.getPortraitURL(themeDisplay);
					/*if (CommonUtil.isAnonymous(user)) {
						userName = Constant.ANONYMOUS_NAME;
						userPic = Constant.ANONYMOUS_PIC;
					}*/
					request_comments.put(Constant.COMMON_STRING_CONSTANT_USER_NAME, userName);
					request_comments.put(Constant.COMMON_STRING_CONSTANT_DOCUMENT_PATH,userPic);
					request_comments.put(Constant.COMMON_STRING_CONSTANT_CREATE_DATE,CommonUtil.getDatesDuration(comment.getCreateDate().getTime(),0));					
					commentsJson.put(request_comments);
				}
			}
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: getRequestComments() ]"+e);
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: getRequestComments() ]"+e);
		}
		return commentsJson.toString();
	}
	
	private String getanswerComments(PortletRequest request){
		
		long AnswerRequestNameId = ClassNameLocalServiceUtil.getClassNameId(AnswerRequest.class);
		
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(AnswerRequestNameId));
		dynamicQuery.addOrder(OrderFactoryUtil.desc(Constant.COMMON_STRING_CONSTANT_CREATE_DATE));
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		JSONArray answerCommentsJson=JSONFactoryUtil.createJSONArray();
		
		try {
			
			List<MBMessage> comments = MBMessageLocalServiceUtil.dynamicQuery(dynamicQuery);
			if(Validator.isNotNull(comments) && !comments.isEmpty()){
				for(MBMessage  comment:comments){
					JSONObject request_comments=JSONFactoryUtil.createJSONObject();
					request_comments.put(Constant.COMMON_STRING_CONSTANT_ANSWER_ID, comment.getClassPK());
					request_comments.put(Constant.COMMON_STRING_CONSTANT_COMMENT_ID,comment.getMessageId());
					request_comments.put(Constant.COMMON_STRING_CONSTANT_DESCRIPTION,comment.getBody());
					User user = UserLocalServiceUtil.getUser(comment.getUserId());
					String userName = user.getFullName();
					String userPic = user.getPortraitURL(themeDisplay);
					/*if (CommonUtil.isAnonymous(user)) {
						userName = Constant.ANONYMOUS_NAME;
						userPic = Constant.ANONYMOUS_PIC;
					}*/
					request_comments.put(Constant.COMMON_STRING_CONSTANT_USER_NAME, userName);
					request_comments.put(Constant.COMMON_STRING_CONSTANT_DOCUMENT_PATH,userPic);
					request_comments.put(Constant.COMMON_STRING_CONSTANT_CREATE_DATE,CommonUtil.getDatesDuration(comment.getCreateDate().getTime(),0));					
					answerCommentsJson.put(request_comments);
				}
			}
			
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: getanswerComments() ]"+e);
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: getanswerComments() ]"+e);
		}
		
		return answerCommentsJson.toString();
	}
	
	private String getrequestLessonJson(long requestLessonId,PortletRequest request){
		
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		try {
			RequestLesson requestLesson=RequestLessonLocalServiceUtil.getRequestLesson(requestLessonId);
			ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
			//CommonUtil.addUpadteAssetEntry(PortalUtil.getUploadPortletRequest(request), serviceContext, requestLesson.getPrimaryKey(), RequestLesson.class.getName());
			
			AuditReport auditReport=AuditNyuUtil.createReport(PortalUtil.getHttpServletRequest(request), CommonUtil.JavaClassI18N(request, themeDisplay, "view-request"),requestLesson.getRequestLessonId()+StringPool.BLANK, Constant.REQUEST_LESSON_CLASS_NAME,requestLesson.getName());
			AuditReportLocalServiceUtil.addAuditReport(auditReport);
			JSONObject requestLessonJson=JSONFactoryUtil.createJSONObject();
			boolean hasAppreciated = false;
			List<String> items = new ArrayList<String>();
			List<AssetCategory> categoriesList = null;
			List<AssetTag> tagList = null;
			
			requestLessonJson.put(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,requestLesson.getRequestLessonId());
			requestLessonJson.put(Constant.COMMON_STRING_CONSTANT_NAME,requestLesson.getName());
			requestLessonJson.put(Constant.COMMON_STRING_CONSTANT_CREATED_BY,requestLesson.getCreatedBy());
			User user = UserLocalServiceUtil.getUser(requestLesson.getCreatedBy());
			String userName = user.getFullName();
			String userPic = user.getPortraitURL(themeDisplay);
			/*if (CommonUtil.isAnonymous(user)) {
				userName = Constant.ANONYMOUS_NAME;
				userPic = Constant.ANONYMOUS_PIC;
			}*/
			requestLessonJson.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
			requestLessonJson.put(Constant.COMMON_STRING_CONSTANT_USER_ID,UserLocalServiceUtil.getUser(requestLesson.getCreatedBy()).getUserId());
			requestLessonJson.put(Constant.COMMON_STRING_CONSTANT_CREATE_DATE,CommonUtil.getDatesDuration(requestLesson.getCreatedDate().getTime(),0));
			requestLessonJson.put(Constant.COMMON_STRING_CONSTANT_APPRECIATED_COUNT,CommonUtil.getAppreciatedCount(requestLesson.getAppreciatedUserIds()));
			requestLessonJson.put(Constant.COMMON_STRING_CONSTANT_OPINION_SURVEY_LINK_II, requestLesson.getOpnionSurveyLink());
			if(requestLesson.getOpnionSurveyLink().indexOf(Constant.QUALTRICS_URLPATTERN)>-1){
				requestLessonJson.put(Constant.COMMON_STRING_CONSTANT_SURVEY_RESULT_LINK, Constant.QUALTRICS_URL);
			}else if(requestLesson.getOpnionSurveyLink().indexOf(Constant.SURVEYMONKEY_URLPATTERN)>-1){
				requestLessonJson.put(Constant.COMMON_STRING_CONSTANT_SURVEY_RESULT_LINK,Constant.SURVEYMONKEY_URLPATTERN);
			}
			
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_OPINION_SURVEY_LINK_II,requestLesson.getOpnionSurveyLink());
			
			String appreciatedUserIds = requestLesson.getAppreciatedUserIds();
			if (!appreciatedUserIds.isEmpty()) {
				items = Arrays.asList(appreciatedUserIds.split(StringPool.COMMA));
				hasAppreciated = items.contains(themeDisplay.getUserId()+StringPool.BLANK);
			}
			requestLessonJson.put(Constant.COMMON_STRING_CONSTANT_HAS_APPRECIATED,hasAppreciated);
			
			List<CategoryTagsVO> categoryVOList = new ArrayList<CategoryTagsVO>();
			List<CategoryTagsVO> tagsVOList = new ArrayList<CategoryTagsVO>();
			categoriesList = AssetCategoryLocalServiceUtil
					.getCategories(RequestLesson.class.getName(),
							requestLesson.getRequestLessonId());
			tagList = AssetTagLocalServiceUtil
					.getTags(RequestLesson.class.getName(),requestLesson.getRequestLessonId());
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
			requestLessonJson.put(Constant.COMMON_STRING_CONSTANT_CATEGORIES,JSONFactoryUtil.createJSONArray(JSONFactoryUtil.looseSerializeDeep(categoryVOList)));
			requestLessonJson.put(Constant.COMMON_STRING_CONSTANT_TAGS,JSONFactoryUtil.createJSONArray(JSONFactoryUtil.looseSerializeDeep(tagsVOList)));
			
			return requestLessonJson.toString();
			
		} catch (PortalException e)  {
			LOG.error("[RequestLessonController: getrequestLessonJson() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: getrequestLessonJson() ]"+e);
		}
		return null;
		
	}
	
	private JSONArray getAllRequestJson(PortletRequest portletrequest){
		
		JSONArray allRequestJson=JSONFactoryUtil.createJSONArray();
		long userGroupId=ParamUtil.getLong(portletrequest,Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
		long userId=ParamUtil.getLong(portletrequest,Constant.COMMON_STRING_CONSTANT_USER_ID);
		try {
			List<RequestLesson> requestLessonList=null;
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(RequestLesson.class);
			if(Validator.isNotNull(userGroupId)){
				dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_SEND_TO,userGroupId));
			}else if(Validator.isNotNull(userId)){
				dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CREATED_BY,userId));
			}else{
				dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_SEND_TO,0l));
			}
			
			dynamicQuery.addOrder(OrderFactoryUtil.desc(Constant.COMMON_STRING_CONSTANT_CREATED_DATE));
			requestLessonList=RequestLessonLocalServiceUtil.dynamicQuery(dynamicQuery);
			
			long categoryId=ParamUtil.getLong(portletrequest, Constant.COMMON_STRING_CONSTANT_CATEGORY_ID);
			if(Validator.isNotNull(categoryId)){
				requestLessonList=RequestLessonLocalServiceUtil.getAllRequestByCategory(categoryId, -1, -1);
			}
			if(Validator.isNotNull(requestLessonList) && !requestLessonList.isEmpty()){
				for(RequestLesson request:requestLessonList){
					JSONObject request_lesson=JSONFactoryUtil.createJSONObject();
			
					dynamicQuery = DynamicQueryFactoryUtil.forClass(AnswerRequest.class);
					dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,request.getRequestLessonId()));
					List<AnswerRequest> answersList= AnswerRequestLocalServiceUtil.dynamicQuery(dynamicQuery);
			
			
					request_lesson.put(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,request.getRequestLessonId());
					request_lesson.put(Constant.COMMON_STRING_CONSTANT_NAME,request.getName());
					User user = UserLocalServiceUtil.getUser(request.getCreatedBy());
					String userName = user.getFullName();
					/*if (CommonUtil.isAnonymous(user)) {
						userName = Constant.ANONYMOUS_NAME;
					}*/
					request_lesson.put(Constant.COMMON_STRING_CONSTANT_USER_NAME,userName);
					request_lesson.put(Constant.COMMON_STRING_CONSTANT_CREATE_DATE_II,CommonUtil.getDatesDuration(request.getCreatedDate().getTime(),0));	
					request_lesson.put(Constant.COMMON_STRING_CONSTANT_APPRECIATED_COUNT,CommonUtil.getAppreciatedCount(request.getAppreciatedUserIds()));
					request_lesson.put(Constant.COMMON_STRING_CONSTANT_ANSWER_TYPE,request.getAnswerType());
					request_lesson.put(Constant.COMMON_STRING_CONSTANT_ANSWER_COUNT,answersList.size());
					request_lesson.put(Constant.COMMON_STRING_CONSTANT_SEND_TO,request.getSendTo());
			
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
				}//end-of-for
			}//end-of-if
			
		} catch (PortalException e)  {
			LOG.error("[RequestLessonController: getAllRequestJson() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: getAllRequestJson() ]"+e);
		}
		
		return allRequestJson;
	}
	
	private void performCleanUp(long requestId){
		
		DynamicQuery answer_request = DynamicQueryFactoryUtil.forClass(AnswerRequest.class);
		answer_request.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,requestId));
		
		long requestLessonNameId=ClassNameLocalServiceUtil.getClassNameId(RequestLesson.class);
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(MBMessage.class);
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(requestId));
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(requestLessonNameId));
		
		try {
			RequestLessonLocalServiceUtil.deleteRequestLesson(requestId);
			List<MBMessage> requestComments = MBMessageLocalServiceUtil.dynamicQuery(dynamicQuery);
			List<AnswerRequest>  answerRequest=AnswerRequestLocalServiceUtil.dynamicQuery(answer_request);
			
			if(Validator.isNotNull(answerRequest) && !answerRequest.isEmpty()){
				for(AnswerRequest answer:answerRequest){
					AnswerRequestLocalServiceUtil.deleteAnswerRequest(answer.getAnswerId());
				}	
			}
			if(Validator.isNotNull(requestComments) && !requestComments.isEmpty()){
				for(MBMessage  comment:requestComments){
					MBMessageLocalServiceUtil.deleteMBMessage(comment.getMessageId());
				}
			}
			
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: performCleanUp() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: performCleanUp() ]"+e);
		}
	}
	
	private String opinionSurvey(long requestId){
		JSONArray allOpinionSurvey=JSONFactoryUtil.createJSONArray();
		try {
		RequestLesson requestf_Opinoin=RequestLessonLocalServiceUtil.getRequestLesson(requestId);
		String[] options=requestf_Opinoin.getSurveyOptions().split(StringPool.COMMA);
		
		DynamicQuery answerCount = DynamicQueryFactoryUtil.forClass(AnswerRequest.class);
		answerCount.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,requestId));
		List<AnswerRequest> answersCountList= AnswerRequestLocalServiceUtil.dynamicQuery(answerCount);
		
		for(String option:options){
			
			JSONObject optionPercentage=JSONFactoryUtil.createJSONObject();
			
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(AnswerRequest.class);
			dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,requestId));
			dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_OPINION_SURVEY,option.trim()));
			List<AnswerRequest> answersList= AnswerRequestLocalServiceUtil.dynamicQuery(dynamicQuery);
			
			if(answersList.size()>0){
				int percentage=(answersList.size()*100)/answersCountList.size();	
				
				optionPercentage.put(Constant.COMMON_STRING_CONSTANT_OPTION_NAME,option);
				optionPercentage.put(Constant.COMMON_STRING_CONSTANT_PERCENTAGE,percentage);
				optionPercentage.put(Constant.COMMON_STRING_CONSTANT_PARTICIPATION_SIZE,answersCountList.size());
			}else{
				optionPercentage.put(Constant.COMMON_STRING_CONSTANT_OPTION_NAME,option);
				optionPercentage.put(Constant.COMMON_STRING_CONSTANT_PERCENTAGE,0);
				optionPercentage.put(Constant.COMMON_STRING_CONSTANT_PARTICIPATION_SIZE,answersCountList.size());
			}
			allOpinionSurvey.put(optionPercentage);
		}
		
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: opinionSurvey() ]"+e);
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: opinionSurvey() ]"+e);
		}
		return allOpinionSurvey.toString();
	}
	
	@RenderMapping(params ="action=addmyLessons")
	public String addmyLessons(RenderRequest request,RenderResponse response){  
			
		List<Lesson> lessons = null;
		//List<Lesson> lessons = LessonLocalServiceUtil.getLessonsUploadedByAuthorAndStatus(PortalUtil.getUserId(request),Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH);
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.CURRENT_AUTHOR).eq(PortalUtil.getUserId(request)));
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
		//workflow status
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.LESSON_STATUS).eq(WorkflowConstants.STATUS_APPROVED));
		// end
		try {
			lessons = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: addMyLessons() ]"+e);
		}
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_ALL_LESSONS,lessons);
		return Constant.REQUEST_LESSON_MY_LESSON_JSP;   
	}
	
	
	@RenderMapping(params ="action=addmyFavouriteLessons")
	public String addmyFavouriteLessons(RenderRequest request,RenderResponse response){  
		
		List<Lesson> lessons = null;
		//List<Lesson> lessons = LessonLocalServiceUtil.getLessonsUploadedByAuthorAndStatus(PortalUtil.getUserId(request),Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH);
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.CURRENT_AUTHOR).eq(PortalUtil.getUserId(request)));
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
		//workflow status
		dynamicQuery.add(PropertyFactoryUtil.forName(Constant.LESSON_STATUS).eq(WorkflowConstants.STATUS_APPROVED));
		// end
		try {
			lessons = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: addmyFavouriteLessons() ]"+e);
		}
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_ALL_LESSONS,lessons);
		return Constant.REQUEST_LESSON_MY_FAVOURITE_LESSONS_JSP;  
	}
	
	@RenderMapping(params ="action=categoryAddMyLessons")
    public String filterByMyLessonCategory(RenderRequest request, RenderResponse response) throws IOException  {
		
		long categoryId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_CATEGORY_ID);
		long userId = PortalUtil.getUserId(request);
		List<Lesson> lessons=null;
		String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
		String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
		String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.LESSON_FROM_DELETED_GROUP,Constant.MARKEDAS_QUARANTINE};
		if(categoryId>0){
			lessons =LessonLocalServiceUtil.findAssetLessonsByCategoryAndFeatured(categoryId, true, status, lessonPrivacy, Constant.USER_GROUP_UPLOAD_TIMES_VAR,markedAs,-1, -1);
		}else{
			//lessons = LessonLocalServiceUtil.getLessonsUploadedByAuthorAndStatus(userId,Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH);
			
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.CURRENT_AUTHOR).eq(userId));
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
			//workflow status
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.LESSON_STATUS).eq(WorkflowConstants.STATUS_APPROVED));
			// end
			try {
				lessons = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
			} catch (SystemException e) {
				LOG.error("[RequestLessonController: filterByMyLessonCategory() ]"+e);
			}
		}
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_ALL_LESSONS,lessons);
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_CATEGORY_ID,categoryId+StringPool.BLANK);
		
		return Constant.REQUEST_LESSON_MY_LESSON_JSP;
	}
	
	@RenderMapping(params ="action=tagAddMyLessons")
    public String filterByMyLessonTag(RenderRequest request, RenderResponse response) throws IOException  {
		
		long tagId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_TAG_ID);
		long userId=PortalUtil.getUserId(request);
		List<Lesson> lessons=null;
		String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
		String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
		String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.LESSON_FROM_DELETED_GROUP,Constant.MARKEDAS_QUARANTINE};
		if(tagId>0){
			lessons =LessonLocalServiceUtil.findAssetLessonsByTagAndFeatured(tagId, true, status, lessonPrivacy,Constant.USER_GROUP_UPLOAD_TIMES_VAR,markedAs, -1, -1);
		}else{
			//lessons = LessonLocalServiceUtil.getLessonsUploadedByAuthorAndStatus(userId,Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH);
			
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.CURRENT_AUTHOR).eq(userId));
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
			//workflow status
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.LESSON_STATUS).eq(WorkflowConstants.STATUS_APPROVED));
			// end
			try {
				lessons = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
			} catch (SystemException e) {
				LOG.error("[RequestLessonController: filterByMyLessonTag() ]"+e);
			}
		}
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_ALL_LESSONS,lessons);
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_TAG_ID,tagId+StringPool.BLANK);
		
		return Constant.REQUEST_LESSON_MY_LESSON_JSP;
	}
	
	@RenderMapping(params ="action=categoryAddMyFavLessons")
    public String filterByMyFavLessonCategory(RenderRequest request, RenderResponse response) throws IOException  {
		
		long categoryId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_CATEGORY_ID);
		long userId = PortalUtil.getUserId(request);
		List<Lesson> lessons=null;
		String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
		String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
		String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.LESSON_FROM_DELETED_GROUP,Constant.MARKEDAS_QUARANTINE};
		if(categoryId>0){
			lessons =LessonLocalServiceUtil.findAssetLessonsByCategoryAndFeatured(categoryId, true, status, lessonPrivacy, Constant.USER_GROUP_UPLOAD_TIMES_VAR,markedAs, -1, -1);
		}else{
			//lessons = LessonLocalServiceUtil.getLessonsUploadedByAuthorAndStatus(userId,Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH);
			
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.CURRENT_AUTHOR).eq(userId));
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
			//workflow status
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.LESSON_STATUS).eq(WorkflowConstants.STATUS_APPROVED));
			// end
			try {
				lessons = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
			} catch (SystemException e) {
				LOG.error("[RequestLessonController: filterByMyFavLessonCategory() ]"+e);
			}
		}
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_ALL_LESSONS,lessons);
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_CATEGORY_ID,categoryId+StringPool.BLANK);
		
		return Constant.REQUEST_LESSON_MY_FAVOURITE_LESSONS_JSP;
	}
	
	@RenderMapping(params ="action=tagAddMyFavLessons")
    public String filterByMyFavLessonTag(RenderRequest request, RenderResponse response) throws IOException  {
		
		long tagId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_TAG_ID);
		long userId=PortalUtil.getUserId(request);
		List<Lesson> lessons=null;
		String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
		String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
		String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.LESSON_FROM_DELETED_GROUP,Constant.MARKEDAS_QUARANTINE};
		if(tagId>0){
			lessons =LessonLocalServiceUtil.findAssetLessonsByTagAndFeatured(tagId, true, status, lessonPrivacy,Constant.USER_GROUP_UPLOAD_TIMES_VAR,markedAs, -1, -1);
		}else{
			//lessons = LessonLocalServiceUtil.getLessonsUploadedByAuthorAndStatus(userId,Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH);
			
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.CURRENT_AUTHOR).eq(userId));
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
			//workflow status
			dynamicQuery.add(PropertyFactoryUtil.forName(Constant.LESSON_STATUS).eq(WorkflowConstants.STATUS_APPROVED));
			// end
			try {
				lessons = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
			} catch (SystemException e) {
				LOG.error("[RequestLessonController: filterByMyFavLessonTag() ]"+e);
			}
		}
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_ALL_LESSONS,lessons);
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_TAG_ID,tagId+StringPool.BLANK);
		return Constant.REQUEST_LESSON_MY_FAVOURITE_LESSONS_JSP;
	}
	
	@RenderMapping(params ="action=allRequest")
    public String allRequest(RenderRequest request, RenderResponse response) throws IOException  {
		
		long categoryId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_CATEGORY_ID);
		try {
			request.setAttribute(Constant.CATEGORY_NAME,AssetCategoryLocalServiceUtil.getAssetCategory(categoryId).getName());
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_ALL_REQUEST_JSON,getAllRequestJson(request));
		} catch (PortalException e ) {
			LOG.error("[RequestLessonController: allRequest() ]"+e);
		} catch ( SystemException e) {
			LOG.error("[RequestLessonController: allRequest() ]"+e);
		}
		
		return Constant.LESSON_PERMISSION_VIEW_ONLY;
	}
	
	
	@ResourceMapping(value="collaborateLinkToLesson")
	public void collaborateLinkToLesson(ResourceRequest request, ResourceResponse response) throws PortalException, SystemException, AddressException, IOException{
		
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long lessonId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		String lessonName = LessonLocalServiceUtil.getLesson(lessonId).getLessonName();
		long requestId = ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_REQUEST_ID);
		boolean lessonLinked = false;
		
		List<AnswerRequest> collaborationAnswers = AnswerRequestLocalServiceUtil.getAnsweredCollaborationLessons(requestId, themeDisplay.getUserId());
		if(collaborationAnswers!=null && collaborationAnswers.size()>0){
			for(AnswerRequest aq : collaborationAnswers){
				if(aq.getCollaborationLessons() == lessonId){
					response.getWriter().write(Constant.TAG_BOLD_OPEN+lessonName+ CommonUtil.JavaClassI18N(request, themeDisplay, "is-already-linked-to-the-request"));
					lessonLinked = true;
					break;
				}
			}
		}
			
		if(!lessonLinked){
			RequestLesson requestLesson = RequestLessonLocalServiceUtil.getRequestLesson(requestId);
			LessonCollaboration lessonCollaboration = new LessonCollaborationImpl();
			lessonCollaboration.setLessonId(lessonId);
			lessonCollaboration.setUserId(requestLesson.getCreatedBy());
			lessonCollaboration.setMemberStatus(Constant.LESSON_MEMBER_STATUS_ACCEPTED);
			lessonCollaboration.setType(Constant.LESSON_ACCESS_CAN_EDIT);
			lessonCollaboration = LessonCollaborationLocalServiceUtil.addLessonCollaboration(lessonCollaboration);
			
			AnswerRequest answerRequest=new AnswerRequestImpl();
		    answerRequest.setRequestLessonId(requestId);
		    answerRequest.setUserId(themeDisplay.getUserId());
		    answerRequest.setDescription(lessonName);
		    answerRequest.setCollaborationLessons(lessonId);
		    answerRequest.setCreateDate(new Date());
		    answerRequest.setCollaborationId(lessonCollaboration.getId());
			AnswerRequestLocalServiceUtil.addAnswerRequest(answerRequest);
			response.getWriter().write(collobrationAnswerJson(requestId));
		}
		
	}

	private String collobrationAnswerJson(long requestId){
		List<AnswerRequest> answeredRequestList = null;
		List<AnswerRequest> answeredRequests = null;
		JSONObject requestAnswered = null;
		User user = null;
		String duration = null;;
		JSONArray allData=JSONFactoryUtil.createJSONArray();
		try {
			answeredRequests = AnswerRequestLocalServiceUtil.getCollaborationLessonList(requestId);
			
			answeredRequestList = new ArrayList<AnswerRequest>();
			answeredRequestList.addAll(answeredRequests);
			Collections.sort( answeredRequestList, new Comparator<AnswerRequest>()
			        {
			            public int compare( AnswerRequest o1, AnswerRequest o2 )
			            {
			                return (o2.getCreateDate()).compareTo( o1.getCreateDate());
			            }
			        } 
			);
			
			if(answeredRequestList!=null && answeredRequestList.size()>0){
				for(AnswerRequest aq : answeredRequestList){
					requestAnswered=JSONFactoryUtil.createJSONObject();
					user = UserLocalServiceUtil.getUser(aq.getUserId());
					duration=CommonUtil.getDatesDuration(aq.getCreateDate().getTime(),0);
					requestAnswered.put(Constant.COMMON_STRING_CONSTANT_ANSWER_ID, aq.getAnswerId());
					requestAnswered.put(Constant.COMMON_STRING_CONSTANT_COLLABORATION_ID, aq.getPrimaryKey());
					requestAnswered.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME, aq.getDescription());
					requestAnswered.put(Constant.COMMON_STRING_CONSTANT_ANSWERED_BY, user.getFullName());
					requestAnswered.put(Constant.COMMON_STRING_CONSTANT_LESSON_ID, aq.getCollaborationLessons());
					requestAnswered.put(Constant.COMMON_STRING_CONSTANT_COLLABORATION_ID, aq.getCollaborationId());
					requestAnswered.put(Constant.COMMON_STRING_CONSTANT_ANSWERED_REQUEST_ID, aq.getAnswerId());
					requestAnswered.put(Constant.COMMON_STRING_CONSTANT_DURATION, duration);
					requestAnswered.put(Constant.COMMON_STRING_CONSTANT_LESSON_STATUS, LessonLocalServiceUtil.getLesson(aq.getCollaborationLessons()).getStatus());
					
					allData.put(requestAnswered);
				}
			}
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: collobrationAnswerJson() ]"+e);
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: collobrationAnswerJson() ]"+e);
		}
		
		return allData.toString();
	}
	
	@RenderMapping(params ="action=email")
	public String showEmail(RenderRequest request,RenderResponse response)throws IOException, Exception {  
		 ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
	     
		 JSONArray jsonResult = com.liferay.portal.kernel.json.JSONFactoryUtil.createJSONArray();
	     List<User> userEmailList=UserLocalServiceUtil.getCompanyUsers(themeDisplay.getCompanyId(),-1, -1);
		 for(User user:userEmailList){
			jsonResult.put(user.getEmailAddress());
		 }
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID, ParamUtil.getShort(request, Constant.COMMON_STRING_CONSTANT_EMAIL_REQ_LESSON_ID));
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_EMAIL_ADDRESS,jsonResult.toString());
		return Constant.REQUEST_LESSON_EMAIL_JSP;   
	}
	
	@ResourceMapping(value="sendEmailAction")  
	public void sendEmail(ResourceRequest request, ResourceResponse response) throws AddressException, PortalException, SystemException, IOException {  
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		String fromAddress=UserLocalServiceUtil.getUser(themeDisplay.getUserId()).getEmailAddress();
		String[] toAddress=ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_TO_ADDRESS).split(StringPool.SEMICOLON);
		String message=ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_MESSAGE);
		String subject=ParamUtil.getString(request, Constant.REQUEST_LESSON_SUBJECT_JSP);
		String url=ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_URL);
		
		message=message+StringPool.DOUBLE_SPACE+ Constant.COMMON_STRING_CONSTANT_DOUBLE_NEW_LINE+url;
		InternetAddress from = new InternetAddress(fromAddress);
		InternetAddress[] to = new InternetAddress[toAddress.length];
		for(int i=0;i<to.length;i++){
			to[i] = new InternetAddress(toAddress[i]);
		}
		
		MailMessage mailMessage = new MailMessage();
		mailMessage.setFrom(from);
		mailMessage.setTo(to);
		mailMessage.setBody(message);
		mailMessage.setSubject(subject);
		MailServiceUtil.sendEmail(mailMessage);
		response.getWriter().write(CommonUtil.JavaClassI18N(request, themeDisplay, "send-email-successfully")+ toAddress);
		 
	}
	
	@ResourceMapping(value="deleteLinkedLesson")
	public void deleteLinkedLesson(ResourceRequest request,ResourceResponse response){
		
		long answerRequestId=ParamUtil.getLong(request, Constant.COMMON_STRING_CONSTANT_ANSWERED_REQUEST_ID);
		long collaborationId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_COLLABORATION_ID);
		long requestId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_REQUEST_ID);
		
		try {
			LessonCollaboration lessonCollaboration = LessonCollaborationLocalServiceUtil.deleteLessonCollaboration(collaborationId);
			AnswerRequest answerRequest = AnswerRequestLocalServiceUtil.deleteAnswerRequest(answerRequestId);
			
			response.getWriter().write(collobrationAnswerJson(requestId));
		} catch (IOException e) {
			LOG.error("[RequestLessonController: deleteLinkedLesson() ]"+e);
		} catch (PortalException e) {
			LOG.error("[RequestLessonController: deleteLinkedLesson() ]"+e);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: deleteLinkedLesson() ]"+e);
		}
	}
	
	
	@ResourceMapping(value="addExternalSurvey")
	public void addExternalSurvey(ResourceRequest request,ResourceResponse response){
		
		
		long requestId=ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_REQUEST_ID);
		String opnionSurveyLink=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_SURVEY_URL);
		try {
			RequestLesson requestforOpinion=RequestLessonLocalServiceUtil.getRequestLesson(requestId);
			requestforOpinion.setOpnionSurveyLink(opnionSurveyLink);
			RequestLessonLocalServiceUtil.updateRequestLesson(requestforOpinion);
			response.getWriter().write(getrequestLessonJson(requestId,request));
			
		} catch (PortalException e) {
			LOG.error(e);
		} catch (SystemException e) {
			LOG.error(e);
		} catch (IOException e) {
			LOG.error(e);
		}
		
	}
	
	
	private void getUserGroup(PortletRequest request){
		List<UserGroup> userGroups=null;
		try {
			userGroups = UserGroupLocalServiceUtil.getUserUserGroups(PortalUtil.getUserId(request));
			Collections.sort(userGroups, new UserGroupSortByName());
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_GROUPS, userGroups);
		} catch (SystemException e) {
			LOG.error("[RequestLessonController: getUserGroup() ]"+e);
		}
		
	}
	private String userLessonJson(PortletRequest request){
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		List<Lesson> lessons=LessonLocalServiceUtil.getLessonsUploadedByAuthorAndStatus(PortalUtil.getUserId(request),Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH);
		JSONArray colloborationLessonArray=JSONFactoryUtil.createJSONArray();
		try {
			for(Lesson lesson:lessons){
				
				JSONObject colloboartionLesson=JSONFactoryUtil.createJSONObject();
				String thumbnailPath = null;
				List<DLFileEntry> dlFileEntries=null;
				
				DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(DLFileEntry.class);
				dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID,ClassNameLocalServiceUtil.getClassNameId(Lesson.class)));
				dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_PK, lesson.getLessonId()));
				dlFileEntries = DLFileEntryLocalServiceUtil.dynamicQuery(dynamicQuery);
				
				if(dlFileEntries!=null && dlFileEntries.size()>0){
						thumbnailPath = themeDisplay.getPortalURL() + themeDisplay.getPathContext() + StringPool.SLASH+ Constant.REQUEST_LESSON_DOCUMENTS+StringPool.SLASH + dlFileEntries.get(0).getGroupId() + StringPool.SLASH + dlFileEntries.get(0).getUuid();
				}else{
						thumbnailPath = themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER;
				}
				
				StringBuilder sb = new StringBuilder();
				String[] categoriesList = AssetCategoryLocalServiceUtil.getCategoryNames(Lesson.class.getName(), lesson.getLessonId());
				String categories=StringPool.BLANK;
				
				if(categoriesList.length > 0){
			    	for (String st : categoriesList) { 
			    		sb.append(st).append(Constant.CHAR_COMMA).append(Constant.CHAR_SPACE);
			   	 }
			    	if (categoriesList.length != 0) sb.deleteCharAt(sb.length()-2);{
			    		if(sb.toString().length()>30)
			    			categories=sb.toString().substring(0,30)+Constant.COMMON_STRING_CONSTANT_THREE_DOTS;
			    		else
			    			categories=sb.toString();
			    	}
			    }
				
				colloboartionLesson.put(Constant.COMMON_STRING_CONSTANT_LESSON_ID,lesson.getLessonId());
				colloboartionLesson.put(Constant.COMMON_STRING_CONSTANT_LESSON_NAME,lesson.getLessonName());
				colloboartionLesson.put(Constant.COMMON_STRING_CONSTANT_THUMBNAIL_PATH, thumbnailPath);
				colloboartionLesson.put(Constant.COMMON_STRING_CONSTANT_CATEGORIES,categories);
				colloboartionLesson.put(Constant.COMMON_STRING_CONSTANT_LESSON_DESCRIPTION,lesson.getDescription());
				colloboartionLesson.put(Constant.COMMON_STRING_CONSTANT_LESSON_AUTHOR, lesson.getUploadedByName());
				colloboartionLesson.put(Constant.COMMON_STRING_CONSTANT_LESSON_AUTHOR_ID, lesson.getCurrentAuthor());
				colloborationLessonArray.put(colloboartionLesson);
				
			}
		} catch (SystemException e) {
			LOG.error(e);
		}
		return colloborationLessonArray.toString();
		
	}
	
}
