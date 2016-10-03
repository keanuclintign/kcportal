<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>		<%--		added asif			 --%>

<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portlet.PortletURLFactory"%>
<%@page import="com.nyu.service.KeywordsLocalServiceUtil"%>
<%@page import="com.nyu.model.Keywords"%>
<%@page import="com.nyu.model.impl.BasnoImpl"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.nyu.service.BasnoLocalServiceUtil"%>
<%@page import="com.nyu.model.Basno"%>
<%@page import="com.liferay.portal.kernel.util.ListUtil"%>
<%@page import="com.liferay.portal.kernel.servlet.SessionMessages"%>
<%@page import="com.liferay.portal.kernel.servlet.SessionErrors"%>
<%@taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

<portlet:actionURL var="TOUFilterUrl">
	<portlet:param name="action" value="TOUFilter"/>
</portlet:actionURL>

<portlet:actionURL var="DocumentStatusFilterUrl">
	<portlet:param name="action" value="DocumentStatusFilter"/>
</portlet:actionURL>

<%String message=(String)SessionMessages.get(portletSession,Constant.COMMON_SUCESS);
String manageType = null;
if(request.getAttribute(Constant.MANAGE_TYPE)!=null){
	manageType = (String)request.getAttribute(Constant.MANAGE_TYPE);
}
String rlPortletId = Constant.PORTLET_ADMIN;
long rlTargetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_CONFIGURATION).getPlid();
long lessonPageId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_LESSON_BROWSE).getPlid();
PortletURL iteratorURL = PortletURLFactoryUtil.create(request, rlPortletId, rlTargetPlId, PortletRequest.RENDER_PHASE);

%>

<%if(manageType!=null && manageType.equals(Constant.MANAGE_BADGES) && Constant.IS_BADGES_REQUIRE) {
	
	iteratorURL.setParameter(Constant.MANAGE_TYPE, Constant.MANAGE_BADGES);
%>
       
		<liferay-ui:success key="sucess" message="<%=message %>"/>
		<liferay-ui:error key="DeleteClaimedBadges" message="you-cannot-delete-claimed-badge"/>
		<%List<Basno> badges=BasnoLocalServiceUtil.getBasnos(-1,-1);%>
		<portlet:renderURL var="addBadgeURL">
		 	<portlet:param name="jspPage" value="<%= Constant.ADMIN_UPDATE_JSP %>"/>
		</portlet:renderURL>
		
		<div class="text-right" >
		<aui:button onclick="addBadge()" value="create-new-badge" cssClass="btn-primary"/>
		</div>
		<br/>
		<div>
		<liferay-ui:search-container delta="10" curParam="badges" emptyResultsMessage="sorry-there-are-no-badges-to-display" iteratorURL="<%=iteratorURL %>" > 
		<liferay-ui:search-container-results total="<%= badges.size() %>" 	results="<%= ListUtil.subList(badges, searchContainer.getStart(), searchContainer.getEnd()) %>"/> 
				<liferay-ui:search-container-row modelVar="badge" className="Basno"> 
					<liferay-ui:search-container-column-text name="badge-id" property="badgeId" /> 
					<liferay-ui:search-container-column-text name="badge-name" property="badgeName" /> 
					<liferay-ui:search-container-column-text name="target-points" property="targetPoints" /> 
					<liferay-ui:search-container-column-text name="description" property="description" /> 
					<liferay-ui:search-container-column-jsp name="actions" path="/WEB-INF/jsp/admin/action.jsp"/>
				</liferay-ui:search-container-row> 
		<liferay-ui:search-iterator /> 
		</liferay-ui:search-container> 
		 </div> 
<%} %>

<%if(manageType!=null && manageType.equals("manageKeywords")) {
	iteratorURL.setParameter(Constant.MANAGE_TYPE, "manageKeywords");
%>
	<liferay-ui:success key="sucess" message="<%=message %>"/>
	<%List<Keywords> keywords=KeywordsLocalServiceUtil.getKeywordses(-1,-1);%>
	<portlet:renderURL var="addKeywordURL">
	 	<portlet:param name="jspPage" value="<%= Constant.ADMIN_ADD_DPATE_KEYWORDS_JSP %>"/>
	</portlet:renderURL>
	
	<div class="text-right" >
	<aui:button onclick="addKeyword()" value="create-new-keyword" cssClass="btn-primary"/>
	</div>
	<br/>
	<div>
	<liferay-ui:search-container delta="10" curParam="keywords" emptyResultsMessage="sorry-there-are-no-keywords-to-display" iteratorURL="<%=iteratorURL %>"> 
	<liferay-ui:search-container-results total="<%= keywords.size() %>" 	results="<%= ListUtil.subList(keywords, searchContainer.getStart(), searchContainer.getEnd()) %>"/> 
			<liferay-ui:search-container-row modelVar="keyword" className="Keywords"> 
				<liferay-ui:search-container-column-text name="reserved-keyword-phrase" property="keyword" /> 
				<liferay-ui:search-container-column-text name="description" property="description" /> 
				<liferay-ui:search-container-column-jsp name="actions" path="/WEB-INF/jsp/admin/action.jsp"/>
			</liferay-ui:search-container-row> 
	<liferay-ui:search-iterator /> 
	</liferay-ui:search-container> 
	 </div> 
	 
<%} %>
<%if(manageType!=null && manageType.equals(Constant.USER_ACCEPTANCE_OF_TOU)) {
%>
	<div class="clearfix">
		<form name='<portlet:namespace/>search' action="<%=TOUFilterUrl%>" method="post" onsubmit="event.preventDefault();<portlet:namespace/>ValidateOnSubmit(this)">
			<span class="span4">
			<label>
			<b><liferay-ui:message key="agreed-to-tou" />:&nbsp;</b></label><select id="<portlet:namespace/>eventType" name="<portlet:namespace/>eventType">
					<option value="-1"><liferay-ui:message key="any" /></option>
					<option value="true"><liferay-ui:message key="yes" /></option>
					<option value="false"><liferay-ui:message key="no" /></option>
					</select>
			</span>
			<span class="span5">
			 	<span class="span6"><label><b><liferay-ui:message key="from" />:&nbsp;</b></label><input style="width:115px;cursor:pointer"  readonly="readonly" placeholder='<liferay-ui:message key="click-here" />' id="<portlet:namespace/>fromDate" class="datepicker" value="${fromDate}"  name="<portlet:namespace/>fromDate"/><span class='btn icon-remove' onclick='javascript:$("#<portlet:namespace/>fromDate").val("")'></span></span>
				<span class="span6"><label><b><liferay-ui:message key="to" />:&nbsp;</b></label><input style="width:115px;cursor:pointer" readonly="readonly" placeholder='<liferay-ui:message key="click-here" />' id="<portlet:namespace/>toDate" class="datepicker" value="${toDate}" name="<portlet:namespace/>toDate"/><span class='btn icon-remove' onclick='javascript:$("#<portlet:namespace/>toDate").val("")'></span></span>
			</span>
			<span class="span3">
				<label>&nbsp;</label>
				<input type="submit" class="btn btn-primary" value='<liferay-ui:message key="small-search" />'>
				<button class="btn btn-primary  generate-report" onClick="event.preventDefault();<portlet:namespace/>TOUReportWindow('${userAcceptanceURL}');"><liferay-ui:message key="report" /></button>
			</span>
		</form>
	</div>
	<div>
		<div class="row-fluid"><span class="alert alert-danger hide fromGtToIssue">From date is greater than To date.</span></div>
		<div class="row-fluid"><span class="alert alert-danger hide fromDateReqIssue">From date is required.</span></div>
	</div>
	<liferay-ui:search-container searchContainer="${userAcceptanceContainer}"> 
			<liferay-ui:search-container-row modelVar="user" keyProperty="userId" className="com.liferay.portal.model.User"> 
				<liferay-ui:search-container-column-text name="user-name" >
					 <%=user.getFullName()%>
				</liferay-ui:search-container-column-text>
				<liferay-ui:search-container-column-text name="agreed-to-tou" href="javascript:void(0);">
					<span> <%= user.getAgreedToTermsOfUse()? LanguageUtil.get(pageContext,Constant.YES): LanguageUtil.get(pageContext, Constant.COMMON_NO) %></span>
				</liferay-ui:search-container-column-text> 
				<liferay-ui:search-container-column-text name="date-of-agreement" href="javascript:void(0);">
					<%if(user.getLastLoginDate()!=null){%>	
						<span> <%= user.getLastLoginDate()!=null ?CommonUtil.dateAsPerFormatForCitation(GetterUtil.getDate(user.getExpandoBridge().getAttribute("agree-date"),null),Constant.EEEE_MMM_D_YYYY ): LanguageUtil.get(pageContext, "never-login") %></span>
					<%}else{%>
						<span><liferay-ui:message key="not-applicable" /></span>
					<%}%>
				</liferay-ui:search-container-column-text>
				<liferay-ui:search-container-column-text name="last-login-date" href="javascript:void(0);">
					<span <%if(user.getLastLoginDate()!=null){%> class="nyu-tooltip" title="<%=user.getLastLoginDate()%> <%}%> "> <%= user.getLastLoginDate()!=null ?CommonUtil.getDatesDuration(user.getLastLoginDate().getTime(),0): LanguageUtil.get(pageContext, "never-login") %></span>
				</liferay-ui:search-container-column-text>
			</liferay-ui:search-container-row> 
	<liferay-ui:search-iterator /> 
	</liferay-ui:search-container> 
<%} %>
<%if(manageType!=null && manageType.equals(Constant.DOCUMENT_STATUS)) {
%>
	<div class="clearfix">
		<form name='<portlet:namespace/>search' action="<%=DocumentStatusFilterUrl%>" method="post" onsubmit="event.preventDefault();<portlet:namespace/>ValidateOnSubmit(this)">
			<span class="span4">
			<label>
			<b><liferay-ui:message key="uploaded-content-status" />:&nbsp;</b></label><select id="<portlet:namespace/>status" name="<portlet:namespace/>status">
					<option value="-1"><liferay-ui:message key="any" /></option>
					<option value="<%=Constant.DOCUMENT_STATUS_ARCHIVE%>"><liferay-ui:message key="Archive"/></option>
					<option value="<%=Constant.DOCUMENT_STATUS_S3%>"><liferay-ui:message key="S3"/></option>
					<option value="<%=Constant.DOCUMENT_STATUS_CDN%>"><liferay-ui:message key="CDN"/></option>
					<option value="<%=Constant.DOCUMENT_STATUS_COMPLETED%>"><liferay-ui:message key="Success"/></option>
				</select>
			</span>
			<span class="span5">
			 	<span class="span6"><label><b><liferay-ui:message key="from" />:&nbsp;</b></label><input style="width:115px;cursor:pointer"  readonly="readonly" placeholder='<liferay-ui:message key="click-here" />' id="<portlet:namespace/>fromDate" class="datepicker" value="${fromDate}"  name="<portlet:namespace/>fromDate"/><span class='btn icon-remove' onclick='javascript:$("#<portlet:namespace/>fromDate").val("")'></span></span>
				<span class="span6"><label><b><liferay-ui:message key="to" />:&nbsp;</b></label><input style="width:115px;cursor:pointer" readonly="readonly" placeholder='<liferay-ui:message key="click-here" />' id="<portlet:namespace/>toDate" class="datepicker" value="${toDate}" name="<portlet:namespace/>toDate"/><span class='btn icon-remove' onclick='javascript:$("#<portlet:namespace/>toDate").val("")'></span></span>
			</span>
			<span class="span3">
				<label>&nbsp;</label>
				<input type="submit" class="btn btn-primary" value='<liferay-ui:message key="small-search" />'>
			</span>
		</form>
	</div>
	<div>
		<div class="row-fluid"><span class="alert alert-danger hide fromGtToIssue">From date is greater than To date.</span></div>
		<div class="row-fluid"><span class="alert alert-danger hide fromDateReqIssue">From date is required.</span></div>
	</div>
	<liferay-ui:search-container searchContainer="${documentStatusContainer}"> 
			<liferay-ui:search-container-row modelVar="document" keyProperty="documentId" className="com.nyu.model.DocumentFile"> 
				<liferay-ui:search-container-column-text name="document-id" >
					 <%=document.getDocumentId()%>
				</liferay-ui:search-container-column-text>
				<liferay-ui:search-container-column-text name="document-name" >
					 <%if((URLDecoder.decode(document.getDocumentName(),"UTF-8")).length() > 30){%>
					 	<span class="nyu-tooltip" title="<%=URLDecoder.decode(document.getDocumentName())%>"><%=(URLDecoder.decode(document.getDocumentName(),"UTF-8")).substring(0,27)+"..."%></span>
					<%}else{%>
						<span><%=URLDecoder.decode(document.getDocumentName(),"UTF-8")%></span>
					<%}%> 
				</liferay-ui:search-container-column-text>
				<liferay-ui:search-container-column-text name="document-status" >
					 <%=document.getStatus()%>
				</liferay-ui:search-container-column-text>
				<liferay-portlet:renderURL var="lessonUrl" plid="<%=lessonPageId%>" portletName="<%=Constant.PORTLET_LESSON%>" >
					<liferay-portlet:param name="action" value="<%=Constant.COMMON_SHOW_DOCUMENT%>"/>
					<liferay-portlet:param name="lessonId" value="<%=document.getLessonId()+\"\"%>"/>
				</liferay-portlet:renderURL>
				
				<liferay-ui:search-container-column-text name="document-lesson" >
					<a href="<%=lessonUrl%>" target ="_blank" class="nyu-tooltip" title="Click Here to View Lesson (or) Edit Lesson" >View Lesson</a>
				</liferay-ui:search-container-column-text>
			</liferay-ui:search-container-row> 
	<liferay-ui:search-iterator /> 
	</liferay-ui:search-container> 
<%} %>


<%SessionMessages.clear(portletSession);
SessionErrors.clear(portletSession); %>