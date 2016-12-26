package com.nyu.portlet.admin;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.Serializable;
import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletRequest;
import javax.portlet.PortletSession;
import javax.portlet.PortletURL;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.portlet.ResourceURL;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.html.simpleparser.HTMLWorker;
import com.itextpdf.text.pdf.PdfWriter;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.OrderFactoryUtil;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.dao.search.SearchContainer;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.portlet.PortletResponseUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.CharPool;
import com.liferay.portal.kernel.util.ContentTypes;
import com.liferay.portal.kernel.util.DateUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalClassLoaderUtil;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.StringBundler;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Group;
import com.liferay.portal.model.User;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.service.UserGroupLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil;
import com.liferay.portlet.asset.service.AssetTagLocalServiceUtil;
import com.nyu.model.Basno;
import com.nyu.model.DocumentFile;
import com.nyu.model.Keywords;
import com.nyu.model.Lesson;
import com.nyu.model.Lesson_Usergroups;
import com.nyu.model.UserBadges;
import com.nyu.model.impl.KeywordsImpl;
import com.nyu.service.BasnoLocalServiceUtil;
import com.nyu.service.DocumentFileLocalServiceUtil;
import com.nyu.service.KeywordsLocalServiceUtil;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.Lesson_UsergroupsLocalServiceUtil;
import com.nyu.service.UserBadgesLocalServiceUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;
import com.nyu.util.RenderHelper;
import com.nyu.util.SortLessonUtil;

@Controller
@RequestMapping(value = "VIEW")
public class Admin {
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(Admin.class);
	
	@RenderMapping
	public String view(RenderRequest request,RenderResponse response) throws SystemException, PortalException {
		
	   boolean requireBadges = GetterUtil.getBoolean(Constant.IS_BADGES_REQUIRE);
	   boolean hasPermission = (request.isUserInRole(Constant.PORTAL_ADMIN_ROLE) || PortalUtil.isOmniadmin(PortalUtil.getUserId(request)));
	   if(hasPermission){
		   if(Validator.isNull(request.getParameter(Constant.MANAGE_TYPE))){
			   request.setAttribute(Constant.MANAGE_TYPE, requireBadges? Constant.MANAGE_BADGES: Constant.MANAGE_KEYWORDS);
			   //request.setAttribute(Constant.MANAGE_TYPE, Constant.MANAGE_BADGES); 
		   }
		   else{
			   request.setAttribute(Constant.MANAGE_TYPE,request.getParameter(Constant.MANAGE_TYPE));
			   if(ParamUtil.getString(request, Constant.MANAGE_TYPE).equalsIgnoreCase(Constant.USER_ACCEPTANCE_OF_TOU)){
				   Admin.userAcceptanceProcess(request);
			   }else if(ParamUtil.getString(request, Constant.MANAGE_TYPE).equalsIgnoreCase(Constant.DOCUMENT_STATUS)){
				   Admin.documentStatusProcess(request);
			   }
		   }
	   }
	   request.setAttribute("hasPermission", hasPermission);
	   return Constant.USER_PROFILE_VIEW_JSP;
	}
	
	@RenderMapping(params="action=termsOfUse")
	public String termsOfUse(RenderRequest request,RenderResponse response) throws SystemException, PortalException {
		
	   return Constant.TERMS_OF_USE_JSP;
	}
	
	@RenderMapping(params="action=privacyStatement")
	public String privacyStatement(RenderRequest request,RenderResponse response) throws SystemException, PortalException {
		
	   return Constant.PRIVACY_STATEMENT_JSP;
	}
	
	@RenderMapping(params="action=communityGuidelines")
	public String communityGuidelines(RenderRequest request,RenderResponse response) throws SystemException, PortalException {
		
	   return Constant.COMMUNITY_GUIDELINES_JSP;
	}
	
	@ResourceMapping(value = "saveBadgeURL")
	public void saveBasnoBadge(ResourceRequest request, ResourceResponse response)
	{   
		
		PortletSession session=request.getPortletSession();
		SessionMessages.clear(session);
		SessionErrors.clear(session);
		HttpServletRequest httpRequest = PortalUtil
			.getHttpServletRequest(request);
		HttpServletResponse httpResponse = PortalUtil
			.getHttpServletResponse(response);
		ServletContext context = httpRequest.getSession()
			.getServletContext();
		
		httpRequest.setAttribute(Constant.MANAGE_TYPE, Constant.MANAGE_BADGES);
		
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		String htmlResult=StringPool.BLANK;
		
		long badgeId=ParamUtil.getLong(request,Constant.BADGE_ID);
		String badgeName=ParamUtil.getString(request, Constant.BADGE_NAME);
		String description=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_DESCRIPTION);
		long targetPoints=ParamUtil.getLong(request,Constant.TARGET_POINTS);
		Basno badge=null;
		try{
		if(request.getParameter(Constant.EDITABLE_BADGE)!=null && request.getParameter(Constant.EDITABLE_BADGE).equals(Constant.EDITABLE_BADGE)){
			badge = BasnoLocalServiceUtil.getBasno(badgeId);
		} else { //new lesson
			badge =BasnoLocalServiceUtil.createBasno(badgeId);
		}
		badge.setBadgeName(badgeName);
		badge.setTargetPoints(targetPoints);
		badge.setDescription(description);
		badge.setCreatedDate(new Date());
		badge.setCompanyId(PortalUtil.getCompanyId(request));
		badge.setGroupId(themeDisplay.getScopeGroupId());
		if(request.getParameter(Constant.EDITABLE_BADGE)!=null && request.getParameter(Constant.EDITABLE_BADGE).equals(Constant.EDITABLE_BADGE)){
			BasnoLocalServiceUtil.updateBasno(badge);
			SessionMessages.add(request, Constant.COMMON_SUCESS, CommonUtil.JavaClassI18N(request, themeDisplay, "badge-updated-sucessfully"));
			htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.ADMIN_DETAILS_JSP);
			response.getWriter().write(htmlResult);
		} else { //new lesson
			BasnoLocalServiceUtil.addBasno(badge);
			SessionMessages.add(request, Constant.COMMON_SUCESS, CommonUtil.JavaClassI18N(request, themeDisplay, "badge-created-sucessfully"));
			htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.ADMIN_DETAILS_JSP);
			response.getWriter().write(htmlResult);
		}
		}catch(Exception e){
			SessionErrors.add(request,Constant.DUPLICATE_BADGE_ID);
			try {
				htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.ADMIN_UPDATE_JSP);
				response.getWriter().write(htmlResult);
			} catch (IOException e1) {
				LOG.error("[Admin: saveBasnoBadge() ]"+e);
			} catch (ServletException e1) {
				LOG.error("[Admin: saveBasnoBadge() ]"+e);
			}
			
		}
		
	}
	
	@ActionMapping(params = "action=deleteBadge")
	public void deleteBadge(ActionRequest actionRequest,ActionResponse actionResponse)throws PortalException, SystemException
	{
		
		ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		List<UserBadges> userBadgesList=UserBadgesLocalServiceUtil.getuserBadgesByBadgeId(ParamUtil.getLong(actionRequest, Constant.BADGE_ID));
		if(Validator.isNotNull(userBadgesList) && userBadgesList.size()>0 ){
			SessionErrors.add(actionRequest,Constant.DELETE_CLAIMED_BADGES);
		} else {
			BasnoLocalServiceUtil.deleteBasno(ParamUtil.getLong(actionRequest, Constant.BADGE_ID));
			SessionMessages.add(actionRequest, Constant.COMMON_SUCESS, CommonUtil.JavaClassI18N(actionRequest, themeDisplay, "badge-deleted-sucessfully"));
		}
		
	}
	
	@ResourceMapping(value="addBadgeURL")
    public void addBadgeForm(ResourceRequest request, ResourceResponse response) throws IOException  {
		
		try {
			HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
			HttpServletResponse httpResponse = PortalUtil
					.getHttpServletResponse(response);
			ServletContext context = httpRequest.getSession()
					.getServletContext();
			String htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.ADMIN_UPDATE_JSP);
			response.getWriter().write(htmlResult);
		} catch (IOException e) {
			LOG.error("[Admin: addBadgeForm() ]"+e);
		} catch (ServletException e) {
			LOG.error("[Admin: addBadgeForm() ]"+e);
		}
	}
	
	@ResourceMapping(value="manageBadgeURL")
    public void badgeDetails(ResourceRequest request, ResourceResponse response) throws IOException  {
		
		try {
			HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
			HttpServletResponse httpResponse = PortalUtil
					.getHttpServletResponse(response);
			ServletContext context = httpRequest.getSession()
					.getServletContext();
			httpRequest.setAttribute(Constant.MANAGE_TYPE, Constant.MANAGE_BADGES);
			String htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.ADMIN_DETAILS_JSP);
			response.getWriter().write(htmlResult);
		} catch (IOException e) {
			LOG.error("[Admin: badgeDetails() ]"+e);
		} catch (ServletException e) {
			LOG.error("[Admin: badgeDetails() ]"+e);
		}
	}
	
	@ActionMapping(params="action=TOUFilter")
	public void searchTOUFilter(ActionRequest request,ActionResponse response){	
		String eventType=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_EVENT_TYPE); 
		String fromDatestr=ParamUtil.getString(request,Constant.FROM_DATE);
		String toDatestr=ParamUtil.getString(request,Constant.TO_DATE); 
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_EVENT_TYPE,eventType);
		request.setAttribute(Constant.FROM_DATE,fromDatestr);
		request.setAttribute(Constant.TO_DATE,toDatestr);
		
		response.setRenderParameter(Constant.FROM_DATE,fromDatestr);
		response.setRenderParameter(Constant.TO_DATE,toDatestr);
		response.setRenderParameter(Constant.COMMON_STRING_CONSTANT_EVENT_TYPE,eventType);
		response.setRenderParameter(Constant.MANAGE_TYPE,Constant.USER_ACCEPTANCE_OF_TOU);
		
	}
	
	@ActionMapping(params="action=DocumentStatusFilter")
	public void searchDocumentStatusFilter(ActionRequest request,ActionResponse response){	
		String eventType=ParamUtil.getString(request,Constant.STATUS); 
		String fromDatestr=ParamUtil.getString(request,Constant.FROM_DATE);
		String toDatestr=ParamUtil.getString(request,Constant.TO_DATE); 
		request.setAttribute(Constant.STATUS,eventType);
		request.setAttribute(Constant.FROM_DATE,fromDatestr);
		request.setAttribute(Constant.TO_DATE,toDatestr);
		
		response.setRenderParameter(Constant.FROM_DATE,fromDatestr);
		response.setRenderParameter(Constant.TO_DATE,toDatestr);
		response.setRenderParameter(Constant.STATUS,eventType);
		response.setRenderParameter(Constant.MANAGE_TYPE,Constant.DOCUMENT_STATUS);
	}
	
	@ResourceMapping(value=Constant.USER_ACCEPTANCE_OF_TOU)
    public String userAcceptanceOfTOU(ResourceRequest request, ResourceResponse response) throws IOException  {
		
		request.setAttribute(Constant.MANAGE_TYPE, Constant.USER_ACCEPTANCE_OF_TOU);
		request.setAttribute("clearData", true);
		Admin.userAcceptanceProcess(request);
		return Constant.DETAILS_JSP;
	}
	
	@ResourceMapping(value=Constant.DOCUMENT_STATUS)
    public String documentStatus(ResourceRequest request, ResourceResponse response) throws IOException  {
		
		request.setAttribute(Constant.MANAGE_TYPE, Constant.DOCUMENT_STATUS);
		request.setAttribute("clearData",true);
		Admin.documentStatusProcess(request);
		return Constant.DETAILS_JSP;
	}
	
	
	@ResourceMapping(value="manageCategoriesURL")
    public void categoryDetails(ResourceRequest request, ResourceResponse response) throws IOException  {
		
		try {
			HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
			HttpServletResponse httpResponse = PortalUtil
					.getHttpServletResponse(response);
			ServletContext context = httpRequest.getSession()
					.getServletContext();
			String htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.ADMIN_CATEGORIES_JSP);
			response.getWriter().write(htmlResult);
		} catch (IOException e) {
			LOG.error("[Admin: categoryDetails() ]"+e);
		} catch (ServletException e) {
			LOG.error("[Admin: categoryDetails() ]"+e);
		}
	}
	
	@ResourceMapping(value="manageTagsURL")
    public void tagDetails(ResourceRequest request, ResourceResponse response) throws IOException  {
		
		try {
			HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
			HttpServletResponse httpResponse = PortalUtil
					.getHttpServletResponse(response);
			ServletContext context = httpRequest.getSession()
					.getServletContext();
			String htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.ADMIN_TAGS_JSP);
			response.getWriter().write(htmlResult);
		} catch (IOException e) {
			LOG.error("[Admin: tagDetails() ]"+e);
		} catch (ServletException e) {
			LOG.error("[Admin: tagDetails() ]"+e);
		}
	}
	
	
	@ResourceMapping(value="manageKeywords")
    public void keywordsDetails(ResourceRequest request, ResourceResponse response) throws IOException  {
		
		try {
			HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
			HttpServletResponse httpResponse = PortalUtil
					.getHttpServletResponse(response);
			ServletContext context = httpRequest.getSession()
					.getServletContext();
			httpRequest.setAttribute(Constant.MANAGE_TYPE, Constant.MANAGE_KEYWORDS);
			String htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.ADMIN_DETAILS_JSP);
			response.getWriter().write(htmlResult);
		} catch (IOException e) {
			LOG.error("[Admin: keywordsDetails() ]"+e);
		} catch (ServletException e) {
			LOG.error("[Admin: keywordsDetails() ]"+e);
		}
	}
	
	@ResourceMapping(value="addKeyword")
    public void addKeyword(ResourceRequest request, ResourceResponse response) throws IOException  {
		
		try {
			HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
			HttpServletResponse httpResponse = PortalUtil
					.getHttpServletResponse(response);
			ServletContext context = httpRequest.getSession()
					.getServletContext();
			String htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.ADMIN_ADD_DPATE_KEYWORDS_JSP);
			response.getWriter().write(htmlResult);
		} catch (IOException e) {
			LOG.error("[Admin: addKeyword() ]"+e);
		} catch (ServletException e) {
			LOG.error("[Admin: addKeyword() ]"+e);
		}
	}
	
	@ResourceMapping(value="deleteKeyword")
	public void deleteKeyword(ResourceRequest request, ResourceResponse response)throws PortalException, SystemException
	{
		
			ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
			try {
				PortletSession session=request.getPortletSession();
				SessionMessages.clear(session);
				SessionErrors.clear(session);
				HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
				HttpServletResponse httpResponse = PortalUtil
					.getHttpServletResponse(response);
				ServletContext context = httpRequest.getSession()
					.getServletContext();
				String htmlResult=StringPool.BLANK;
							
				KeywordsLocalServiceUtil.deleteKeywords(Long.parseLong(request.getParameter(Constant.KEYWORD_ID)));
				SessionMessages.add(request, Constant.COMMON_SUCESS, CommonUtil.JavaClassI18N(request, themeDisplay, "keyword-deleted-sucessfully"));
			
				httpRequest.setAttribute(Constant.MANAGE_TYPE, Constant.MANAGE_KEYWORDS);
				htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.ADMIN_DETAILS_JSP);
				response.getWriter().write(htmlResult);
				
			} catch (IOException e) {
				LOG.error("[Admin: deleteKeyword() ]"+e);
			} catch (ServletException e) {
				LOG.error("[Admin: deleteKeyword() ]"+e);
			}
			
	}
	
	@ResourceMapping(value = "saveKeyword")
	public void saveKeyword(ResourceRequest request, ResourceResponse response)
	{   
		
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		PortletSession session=request.getPortletSession();
		SessionMessages.clear(session);
		SessionErrors.clear(session);
		HttpServletRequest httpRequest = PortalUtil
			.getHttpServletRequest(request);
		HttpServletResponse httpResponse = PortalUtil
			.getHttpServletResponse(response);
		ServletContext context = httpRequest.getSession()
			.getServletContext();

		List<Keywords> allKeywords = null;
		String htmlResult=StringPool.BLANK;
		long keywordId = request.getParameter(Constant.KEYWORD_ID)!=null ? Long.parseLong(request.getParameter(Constant.KEYWORD_ID).toString()) : 0 ;
		Keywords keyword=new KeywordsImpl();
		boolean keywordExists = false;
		
		try {
			
			allKeywords = KeywordsLocalServiceUtil.getKeywordses(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
			
			if(allKeywords!=null && allKeywords.size()>0){
				for(Keywords kword : allKeywords){
					if(kword.getId() != keywordId && ParamUtil.getString(request, Constant.KEYWORD,StringPool.BLANK).toLowerCase().contains(kword.getKeyword().toLowerCase())){
						keywordExists = true;
						SessionMessages.add(request, Constant.ERROR, CommonUtil.JavaClassI18N(request, themeDisplay, "keyword-has-already-exists-keyword-phrase"));
						htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.ADMIN_ADD_DPATE_KEYWORDS_JSP);
						break;
					}
				}
			}
			
			if(!keywordExists){
				
				keyword.setCompanyId(PortalUtil.getCompanyId(request));
				keyword.setGroupId(themeDisplay.getScopeGroupId());
				keyword.setKeyword(ParamUtil.getString(request, Constant.KEYWORD));
				keyword.setDescription(ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_DESCRIPTION));
				keyword.setUpdatedDate(new Date(System.currentTimeMillis()));
				
				if(keywordId>0){
					keyword.setId(keywordId);
					keyword.setUpdatedBy(themeDisplay.getUserId());
					keyword = KeywordsLocalServiceUtil.updateKeywords(keyword);
					SessionMessages.add(request, Constant.COMMON_SUCESS, CommonUtil.JavaClassI18N(request, themeDisplay, "keyword-updated-sucessfully"));
				}else{
					keyword.setCreatedDate(new Date(System.currentTimeMillis()));
					keyword.setCreatedBy(themeDisplay.getUserId());
					keyword = KeywordsLocalServiceUtil.addKeywords(keyword);
					SessionMessages.add(request, Constant.COMMON_SUCESS, CommonUtil.JavaClassI18N(request, themeDisplay, "keyword-added-successfully"));
				}
				
				httpRequest.setAttribute(Constant.MANAGE_TYPE, Constant.MANAGE_KEYWORDS);
				htmlResult = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.ADMIN_DETAILS_JSP);
			}
			
			response.getWriter().write(htmlResult);
			
		} catch (SystemException e) {
			LOG.error("[Admin: saveKeyword() ]"+e);
		} catch (IOException e) {
			LOG.error("[Admin: saveKeyword() ]"+e);
		} catch (ServletException e) {
			LOG.error("[Admin: saveKeyword() ]"+e);
		}
		
	}
	
	@ResourceMapping(value="generateReport")
	private void generateReport(ResourceRequest request,
			ResourceResponse response) {
		
		try {                
			String msg = Constant.PORTLET_PROP_SITE_MESSAGE_REPORT;

			Document document = new Document();

			ByteArrayOutputStream baos = new ByteArrayOutputStream();

			PdfWriter.getInstance(document, baos);
			
			
			List<Lesson> lessons = new ArrayList<Lesson>();
			//List<User> authors = new ArrayList<User>();
			List<Lesson> lessonsList = null;

				lessonsList=SortLessonUtil.getLessonsByItem(0l,PortalUtil.getUserId(request),0l ,Constant.MOST_RECENT, -1,-1);
				if(lessonsList!=null && lessonsList.size()>0){
					for(Lesson lsn : lessonsList){
						//if(lsn!=null && lsn.getLessonPrivacy().equalsIgnoreCase(PortletProps.get("liferay.nyu.lesson.privacy.nyu")))
							lessons.add(lsn);
					}
				}
				//authors = UserLocalServiceUtil.getu
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSONS,lessons);
			

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
			LOG.error("[Admin: generateReport() ]"+e2);
		}

	}
	
	protected String getSelectedValue(Serializable obj) throws IOException{
		String[] genderValues = GetterUtil.getStringValues(obj);
		if(genderValues.length > 0){
			return genderValues[0];
		}
		else{
			return "";
		}
	}
	
	@ResourceMapping(value="exportReport")
	private void exportReport(ResourceRequest request, ResourceResponse response) throws SystemException, PortalException, IOException {
		
		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
		StringBundler sb = new StringBundler();
		sb.append(Constant.PORTLET_PROP_SITE_MESSAGE_REPORT);
		sb.append(CharPool.NEW_LINE);
		sb.append(CharPool.NEW_LINE);
		List<Lesson> lessons = null;

		lessons = SortLessonUtil.getLessonsByItem(0l,themeDisplay.getUserId(),0l ,Constant.MOST_RECENT, -1,-1);
		
		for(Lesson lesson : lessons){
			long authorId = lesson.getAuthor();
			User user = UserLocalServiceUtil.getUser(authorId);
			sb.append("Contributor :");
			sb.append(CSV_SEPARATOR);
			sb.append(getCSVFormattedValue(user.getFirstName()+" "+user.getLastName()));
			sb.append(CharPool.NEW_LINE);
			sb.append("Email Address :");
			sb.append(CSV_SEPARATOR);
			sb.append(getCSVFormattedValue(user.getEmailAddress()));
			sb.append(CharPool.NEW_LINE);
			sb.append("Gender :");
			sb.append(CSV_SEPARATOR);
			sb.append(getCSVFormattedValue(user.getExpandoBridge().getAttribute(Constant.EXPANDO_FIELD_CUSTOM_GENDER).toString()));
			sb.append(CharPool.NEW_LINE);
			sb.append("Marital Status :");
			sb.append(CSV_SEPARATOR);
			sb.append(getCSVFormattedValue(getSelectedValue(user.getExpandoBridge().getAttribute(Constant.EXPANDO_FIELD_MARITAL_STATUS))));
			sb.append(CharPool.NEW_LINE);
			sb.append(CharPool.NEW_LINE);
			
			for (String columnName : columnNames) {
				sb.append(getCSVFormattedValue(columnName));
				sb.append(CSV_SEPARATOR);
			}
			sb.setIndex(sb.index() - 1);
			sb.append(CharPool.NEW_LINE);
			
			List<Lesson> authorLessonsList = LessonLocalServiceUtil.getLessonsUploadedByAuthor(authorId);
			int count = 0;
			for(Lesson authorLesson : authorLessonsList){
				List<Lesson_Usergroups> lesson_groupsList = Lesson_UsergroupsLocalServiceUtil.
						getLesson_UserGroupLessonId(authorLesson.getLessonId());
				
				sb.append(getCSVFormattedValue(String.valueOf(++count)));
				sb.append(CSV_SEPARATOR);
				sb.append(getCSVFormattedValue(authorLesson.getLessonName()));
				sb.append(CSV_SEPARATOR);
				sb.append(getCSVFormattedValue(authorLesson.getDescription()));
				sb.append(CSV_SEPARATOR);
				
				StringBuilder sb1 = new StringBuilder();
				String[] categoriesList = AssetCategoryLocalServiceUtil
						.getCategoryNames(Lesson.class.getName(), authorLesson.getLessonId());
			    if(categoriesList.length > 0){
			    	for (String st : categoriesList) { 
			    		sb1.append(st).append(',').append(' ');
			   	 	}
			    	if (categoriesList.length != 0) 
			    		sb1.deleteCharAt(sb1.length()-2);
			    	
			    	sb.append(getCSVFormattedValue(StringUtil.shorten(sb1.toString(), 50,"...")));
			    }
			    else{
			    	sb.append(getCSVFormattedValue(""));
			    }
			    sb.append(CSV_SEPARATOR);
			    
			    StringBuilder sb2 = new StringBuilder();
				String[] tagsList = AssetTagLocalServiceUtil
						.getTagNames(Lesson.class.getName(), authorLesson.getLessonId());
			    if(tagsList.length > 0){
			    	for (String st : tagsList) { 
			    		sb2.append(st).append(',').append(' ');
			   	 	}
			    	if (tagsList.length != 0) 
			    		sb2.deleteCharAt(sb2.length()-2);
			    	
			    	sb.append(getCSVFormattedValue(StringUtil.shorten(sb2.toString(), 50,"...")));
			    }
			    else{
			    	sb.append(getCSVFormattedValue(""));
			    }
			    sb.append(CSV_SEPARATOR);
			    
			    StringBuilder sb3 = new StringBuilder();
				if (lesson_groupsList.size() > 0) {
					for (Lesson_Usergroups st : lesson_groupsList) {
						try{
							sb3.append( UserGroupLocalServiceUtil.getUserGroup(st.getGroupId()).getName()).append(',').append(' ');
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					
					sb.append(getCSVFormattedValue(sb3.toString()));
				} else {
					sb.append(getCSVFormattedValue(""));
				}
				sb.append(CSV_SEPARATOR);
			    
				sb.append(getCSVFormattedValue(String.valueOf(authorLesson.getUploadedTime())));
				sb.append(CSV_SEPARATOR);
				sb.setIndex(sb.index() - 1);
				sb.append(CharPool.NEW_LINE);
			}
			sb.append(CharPool.NEW_LINE);
			sb.append(CharPool.NEW_LINE);
			sb.append(CharPool.NEW_LINE);
		}
		
		String fileName = "contentReport_"+DateUtil.getCurrentDate("dd_MMM_yyyy_h_mm_ss_a", themeDisplay.getLocale())+".csv";;
		byte[] bytes = sb.toString().getBytes();
		String contentType = ContentTypes.APPLICATION_TEXT;
		try {
			PortletResponseUtil.sendFile(request, response, fileName, bytes, contentType);
		} catch (IOException e) {
			LOG.error("Error occured while downloading content report -- "+e);
		}
	}
	
	protected String getCSVFormattedValue(String value) {
		StringBundler sb = new StringBundler(3);
		sb.append(CharPool.QUOTE);
		sb.append(StringUtil.replace(value, CharPool.QUOTE, StringPool.DOUBLE_QUOTE));
		sb.append(CharPool.QUOTE);
		return sb.toString();
	}
	
	private static void userAcceptanceProcess(PortletRequest request){
		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);	
		
		int delta = ParamUtil.getInteger(request,Constant.DELTA,10);
		int cur = ParamUtil.getInteger(request,Constant.CUR,1);
		String eventType = ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_EVENT_TYPE,Constant.MINUS_ONE);
		String fromDate = ParamUtil.getString(request,Constant.FROM_DATE,StringPool.BLANK);
		String toDate = ParamUtil.getString(request,Constant.TO_DATE,StringPool.BLANK);
		boolean canClearData = GetterUtil.getBoolean(request.getAttribute("clearData"),false);	
	    if(canClearData){
	    	eventType = Constant.MINUS_ONE;
	    	fromDate = StringPool.BLANK;
	    	toDate = StringPool.BLANK;
	    	delta = 10;
	    	cur = 1;
	    }	
	    PortletURL portletURL = PortletURLFactoryUtil.create(request,PortalUtil.getPortletId(request), themeDisplay.getPlid(), PortletRequest.RENDER_PHASE);
	    portletURL.setParameter(Constant.COMMON_STRING_CONSTANT_EVENT_TYPE, eventType);
	    portletURL.setParameter(Constant.MANAGE_TYPE, Constant.USER_ACCEPTANCE_OF_TOU);
	    portletURL.setParameter(Constant.FROM_DATE, fromDate);
	    portletURL.setParameter(Constant.TO_DATE, toDate);
	    
	    ResourceURL userAcceptanceURL=PortletURLFactoryUtil.create(request,PortalUtil.getPortletId(request), themeDisplay.getPlid(), PortletRequest.RESOURCE_PHASE);
	    userAcceptanceURL.setResourceID(Constant.TOU_REPORT);
	    userAcceptanceURL.setParameter(Constant.REPORT_TYPE, Constant.PDF);
	    userAcceptanceURL.setParameter(Constant.COMMON_STRING_CONSTANT_EVENT_TYPE, eventType);
	    userAcceptanceURL.setParameter(Constant.FROM_DATE, fromDate);
	    userAcceptanceURL.setParameter(Constant.TO_DATE, toDate);
	    
	    SearchContainer<User> searchContainer = new SearchContainer<User>(request, null, null, Constant.CUR, cur, delta, portletURL, null, null);
	    searchContainer.setEmptyResultsMessage(CommonUtil.JavaClassI18N(request, themeDisplay, "sorry-there-are-no-items-to-display"));
	    try {
	    if(!eventType.equals(Constant.MINUS_ONE) && fromDate.equals(StringPool.BLANK) && toDate.equals(StringPool.BLANK)){
			searchContainer.setResults(getuserAcceptanceData(eventType,null,null,searchContainer.getStart(),searchContainer.getEnd()));
			searchContainer.setTotal(countByuserAcceptanceData(eventType,null,null));
		    fromDate = StringPool.BLANK;
		    toDate = StringPool.BLANK;
		}else if(!fromDate.equals(StringPool.BLANK) && !toDate.equals(StringPool.BLANK)){
			searchContainer.setResults(getuserAcceptanceData(eventType,fromDate,toDate,searchContainer.getStart(),searchContainer.getEnd()));
			searchContainer.setTotal(countByuserAcceptanceData(eventType,fromDate,toDate));
		}else if(!fromDate.equals(StringPool.BLANK) && toDate.equals(StringPool.BLANK)){
			searchContainer.setResults(getuserAcceptanceData(eventType,fromDate,null,searchContainer.getStart(),searchContainer.getEnd()));
			searchContainer.setTotal(countByuserAcceptanceData(eventType,fromDate,null));
			toDate = StringPool.BLANK;
		}else{
			searchContainer.setResults(getuserAcceptanceData(Constant.MINUS_ONE,null,null,searchContainer.getStart(),searchContainer.getEnd()));
			searchContainer.setTotal(countByuserAcceptanceData(Constant.MINUS_ONE,null,null));
		    fromDate = StringPool.BLANK;
		    toDate = StringPool.BLANK;
		}
		} catch (Exception e) {
			e.printStackTrace();
		}
	    request.setAttribute(Constant.USER_ACCEPTANCE_CONTAINER, searchContainer);
	    request.setAttribute(Constant.COMMON_STRING_CONSTANT_EVENT_TYPE, eventType);
	    request.setAttribute(Constant.FROM_DATE, fromDate);
	    request.setAttribute(Constant.TO_DATE, toDate);
	    request.setAttribute(Constant.USER_ACCEPTANCE_URL, userAcceptanceURL);
	}
	
	private static void documentStatusProcess(PortletRequest request){
		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);	
		
		int delta = ParamUtil.getInteger(request,Constant.DELTA,10);
		int cur = ParamUtil.getInteger(request,Constant.CUR,1);
		String eventType = ParamUtil.getString(request,Constant.STATUS,Constant.MINUS_ONE);
		String fromDate = ParamUtil.getString(request,Constant.FROM_DATE,StringPool.BLANK);
		String toDate = ParamUtil.getString(request,Constant.TO_DATE,StringPool.BLANK);
		boolean canClearData = GetterUtil.getBoolean(request.getAttribute("clearData"),false);	
	    if(canClearData){
	    	eventType = Constant.MINUS_ONE;
	    	fromDate = StringPool.BLANK;
	    	toDate = StringPool.BLANK;
	    	delta = 10;
	    	cur = 1;
	    }
		PortletURL portletURL = PortletURLFactoryUtil.create(request,PortalUtil.getPortletId(request), themeDisplay.getPlid(), PortletRequest.RENDER_PHASE);
	    portletURL.setParameter(Constant.STATUS, eventType);
	    portletURL.setParameter(Constant.MANAGE_TYPE, Constant.DOCUMENT_STATUS);
	    portletURL.setParameter(Constant.FROM_DATE, fromDate);
	    portletURL.setParameter(Constant.TO_DATE, toDate);
	    
	    SearchContainer<DocumentFile> searchContainer = new SearchContainer<DocumentFile>(request, null, null, Constant.CUR, cur, delta, portletURL, null, null);
	    searchContainer.setEmptyResultsMessage(CommonUtil.JavaClassI18N(request, themeDisplay, "sorry-there-are-no-items-to-display"));
	    try {
	    if(!eventType.equals(Constant.MINUS_ONE) && fromDate.equals(StringPool.BLANK) && toDate.equals(StringPool.BLANK)){
			searchContainer.setResults(getDocumentStatusData(eventType,null,null,searchContainer.getStart(),searchContainer.getEnd()));
			searchContainer.setTotal(countByDocumentStatusData(eventType,null,null));
		    fromDate = StringPool.BLANK;
		    toDate = StringPool.BLANK;
		}else if(!fromDate.equals(StringPool.BLANK) && !toDate.equals(StringPool.BLANK)){
			searchContainer.setResults(getDocumentStatusData(eventType,fromDate,toDate,searchContainer.getStart(),searchContainer.getEnd()));
			searchContainer.setTotal(countByDocumentStatusData(eventType,fromDate,toDate));
		}else if(!fromDate.equals(StringPool.BLANK) && toDate.equals(StringPool.BLANK)){
			searchContainer.setResults(getDocumentStatusData(eventType,fromDate,null,searchContainer.getStart(),searchContainer.getEnd()));
			searchContainer.setTotal(countByDocumentStatusData(eventType,fromDate,null));
			toDate = StringPool.BLANK;
		}else{
			searchContainer.setResults(getDocumentStatusData(Constant.MINUS_ONE,null,null,searchContainer.getStart(),searchContainer.getEnd()));
			searchContainer.setTotal(countByDocumentStatusData(Constant.MINUS_ONE,null,null));
		    fromDate = StringPool.BLANK;
		    toDate = StringPool.BLANK;
		}
		} catch (Exception e) {
			e.printStackTrace();
		}
	    request.setAttribute(Constant.DOCUMENT_STATUS_CONTAINER, searchContainer);
	    request.setAttribute(Constant.STATUS, eventType);
	    request.setAttribute(Constant.FROM_DATE, fromDate);
	    request.setAttribute(Constant.TO_DATE, toDate);
	    
	}
	
	private static List<User> getuserAcceptanceData(String eventType,String fromDatestr,String toDatestr,int start,int end){
		
		try {
			Date fromDate = null;
			Date toDate = null;
			DynamicQuery userSearchQuery = DynamicQueryFactoryUtil.forClass(User.class,PortalClassLoaderUtil.getClassLoader());
			userSearchQuery.addOrder(OrderFactoryUtil.desc(Constant.LAST_LOGIN_DATE));
			if(!eventType.equals(Constant.MINUS_ONE)){
				userSearchQuery.add(PropertyFactoryUtil.forName(Constant.AGREES_TO_TERMS_OF_USE).eq(GetterUtil.getBoolean(eventType)));
			}
			if(Validator.isNotNull(fromDatestr)){
				SimpleDateFormat formatter = new SimpleDateFormat(Constant.MM_DD_YYYY_HH_mm_SS);
				fromDate = formatter.parse(fromDatestr+StringPool.SPACE+Constant.BEGINING_TIME);
				if(Validator.isNotNull(toDatestr)){
					toDate = formatter.parse(toDatestr+StringPool.SPACE+Constant.MID_NIGHT_TIME);
					userSearchQuery.add(PropertyFactoryUtil.forName(Constant.LAST_LOGIN_DATE).between(fromDate, toDate));
				}else{
					userSearchQuery.add(PropertyFactoryUtil.forName(Constant.LAST_LOGIN_DATE).ge(fromDate));
				}
			}
			List<User> userSearchFilter = UserLocalServiceUtil.dynamicQuery(userSearchQuery,start,end);
			return userSearchFilter;
		} catch (Exception e) {
			LOG.info("Error in " + Admin.class.getName() + "\n" + e);
			return new ArrayList<User>();
		}
	}
	
	private static int countByuserAcceptanceData(String eventType,String fromDatestr,String toDatestr){
		
		try {
			Date fromDate = null;
			Date toDate = null;
			DynamicQuery userSearchQuery = DynamicQueryFactoryUtil.forClass(User.class,PortalClassLoaderUtil.getClassLoader());
			userSearchQuery.addOrder(OrderFactoryUtil.desc(Constant.LAST_LOGIN_DATE));
			if(!eventType.equals(Constant.MINUS_ONE)){
				userSearchQuery.add(PropertyFactoryUtil.forName(Constant.AGREES_TO_TERMS_OF_USE).eq(GetterUtil.getBoolean(eventType)));
			}
			if(Validator.isNotNull(fromDatestr)){
				SimpleDateFormat formatter = new SimpleDateFormat(Constant.MM_DD_YYYY_HH_mm_SS);
				fromDate = formatter.parse(fromDatestr+StringPool.SPACE+Constant.BEGINING_TIME);
				if(Validator.isNotNull(toDatestr)){
					toDate = formatter.parse(toDatestr+StringPool.SPACE+Constant.MID_NIGHT_TIME);
					userSearchQuery.add(PropertyFactoryUtil.forName(Constant.LAST_LOGIN_DATE).between(fromDate, toDate));
				}else{
					userSearchQuery.add(PropertyFactoryUtil.forName(Constant.LAST_LOGIN_DATE).ge(fromDate));
				}
			}
			long userSearchFilterCount = UserLocalServiceUtil.dynamicQueryCount(userSearchQuery);
			return GetterUtil.getInteger(userSearchFilterCount);
		} catch (Exception e) {
			LOG.info("Error in " + Admin.class.getName() + "\n" + e);
			return 0;
		}
	}
	
private static List<DocumentFile> getDocumentStatusData(String eventType,String fromDatestr,String toDatestr,int start,int end){
		
		try {
			Date fromDate = null;
			Date toDate = null;
			DynamicQuery documentFileSearchQuery = DynamicQueryFactoryUtil.forClass(DocumentFile.class);
			documentFileSearchQuery.addOrder(OrderFactoryUtil.desc(Constant.COMMON_STRING_CONSTANT_CREATED_DATE));
			documentFileSearchQuery.add(PropertyFactoryUtil.forName(Constant.RESOURCE_TYPE).eq(Constant.COMMON_STRING_CONSTANT_RESOURCE_SPACE));
			if(!eventType.equals(Constant.MINUS_ONE)){
				documentFileSearchQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(GetterUtil.getString(eventType)));
			}
			if(Validator.isNotNull(fromDatestr)){
				SimpleDateFormat formatter = new SimpleDateFormat(Constant.MM_DD_YYYY_HH_mm_SS);
				fromDate = formatter.parse(fromDatestr+StringPool.SPACE+Constant.BEGINING_TIME);
				if(Validator.isNotNull(toDatestr)){
					toDate = formatter.parse(toDatestr+StringPool.SPACE+Constant.MID_NIGHT_TIME);
					documentFileSearchQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CREATED_DATE).between(fromDate, toDate));
				}else{
					documentFileSearchQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CREATED_DATE).ge(fromDate));
				}
			}
			List<DocumentFile> userSearchFilter = DocumentFileLocalServiceUtil.dynamicQuery(documentFileSearchQuery,start,end);
			return userSearchFilter;
		} catch (Exception e) {
			LOG.info("Error in " + Admin.class.getName() + "\n" + e);
			return new ArrayList<DocumentFile>();
		}
	}
	
	private static int countByDocumentStatusData(String eventType,String fromDatestr,String toDatestr){
		
		try {
			Date fromDate = null;
			Date toDate = null;
			DynamicQuery documentFileSearchQuery = DynamicQueryFactoryUtil.forClass(DocumentFile.class);
			documentFileSearchQuery.addOrder(OrderFactoryUtil.desc(Constant.COMMON_STRING_CONSTANT_CREATED_DATE));
			documentFileSearchQuery.add(PropertyFactoryUtil.forName(Constant.RESOURCE_TYPE).eq(Constant.COMMON_STRING_CONSTANT_RESOURCE_SPACE));
			if(!eventType.equals(Constant.MINUS_ONE)){
				documentFileSearchQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(GetterUtil.getString(eventType)));
			}
			if(Validator.isNotNull(fromDatestr)){
				SimpleDateFormat formatter = new SimpleDateFormat(Constant.MM_DD_YYYY_HH_mm_SS);
				fromDate = formatter.parse(fromDatestr+StringPool.SPACE+Constant.BEGINING_TIME);
				if(Validator.isNotNull(toDatestr)){
					toDate = formatter.parse(toDatestr+StringPool.SPACE+Constant.MID_NIGHT_TIME);
					documentFileSearchQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CREATED_DATE).between(fromDate, toDate));
				}else{
					documentFileSearchQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CREATED_DATE).ge(fromDate));
				}
			}
			long count = DocumentFileLocalServiceUtil.dynamicQueryCount(documentFileSearchQuery);
			return GetterUtil.getInteger(count);
		} catch (Exception e) {
			LOG.info("Error in " + Admin.class.getName() + "\n" + e);
			return 0;
		}
	}
	
	
	@ResourceMapping(value="TOUReport")
	private void TOUReport(ResourceRequest request,
			ResourceResponse response) {
		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
		try {                
			String msg = CommonUtil.JavaClassI18N(request, themeDisplay, "user-acceptance-of-tou-report");
			Document document = new Document();
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			PdfWriter.getInstance(document, baos);

			document.open();
			document.add(new Paragraph(msg));
			document.add(Chunk.NEWLINE);
			//document.add(new Paragraph("Lesson Details."));
			HTMLWorker htmlWorker = new HTMLWorker(document);

			String eventType=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_EVENT_TYPE); 
			String fromDatestr=ParamUtil.getString(request,Constant.FROM_DATE);
			String toDatestr=ParamUtil.getString(request,Constant.TO_DATE); 
			
			if(!eventType.equals(Constant.MINUS_ONE) && (fromDatestr.equals(StringPool.BLANK) || toDatestr.equals(StringPool.BLANK))){
			   request.setAttribute(Constant.TOU_REPORTS,getuserAcceptanceData(eventType,null,null,-1,-1));
			}else if(!fromDatestr.equals(StringPool.BLANK) && !toDatestr.equals(StringPool.BLANK)){
				request.setAttribute(Constant.TOU_REPORTS,getuserAcceptanceData(eventType,fromDatestr,toDatestr,-1,-1));
			}else{
				request.setAttribute(Constant.TOU_REPORTS,getuserAcceptanceData(Constant.MINUS_ONE,null,null,-1,-1));
			}
			
			HttpServletRequest httpRequest = PortalUtil
					.getHttpServletRequest(request);
			//HttpSession session=PortalUtil.getHttpServletRequest(request).getSession();
			HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
			ServletContext context = httpRequest.getSession()
					.getServletContext();
			String jspFile = StringPool.BLANK;
		
			jspFile = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.ADMIN_TOU_REPORT_JSP);
				
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

	}
	
	@ResourceMapping(value=Constant.EMAILDIGEST)
    public String emailDigest(ResourceRequest request, ResourceResponse response) throws IOException, PortalException, SystemException  {
		Group group = GroupLocalServiceUtil.getGroup(PortalUtil.getScopeGroupId(request));		
		boolean isEnabled = GetterUtil.getBoolean(group.getExpandoBridge().getAttribute(Constant.EMAIL_DIGEST_ATTRIBUTE),false);
		request.setAttribute("isEnable", isEnabled);
		return Constant.EMAIL_DIGEST_JSP;
	}
	
	@ResourceMapping(value=Constant.EMAILDIGESTPROCESS)
    public void emailDigestProcess(ResourceRequest request, ResourceResponse response) throws IOException, PortalException, SystemException  {
		Group group = GroupLocalServiceUtil.getGroup(PortalUtil.getScopeGroupId(request));		
		boolean isEnabled = ParamUtil.getBoolean(request,"isEnable",false);
		group.getExpandoBridge().setAttribute(Constant.EMAIL_DIGEST_ATTRIBUTE, isEnabled);
		GroupLocalServiceUtil.updateGroup(group);
	}
	
	public static String[] columnNames = { "S.No.", "Lesson Name", "Description","Categories","Tags","Groups","Create Date"};
	public static final String CSV_SEPARATOR = ",";
}
