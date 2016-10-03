<%@page import="com.liferay.portal.kernel.dao.orm.OrderFactoryUtil"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="com.nyu.model.RequestLesson"%>
<%@page import="com.nyu.service.RequestLessonLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.Criterion"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.nyu.portlet.social.activities.NyuMemberActivityKeys"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portlet.social.service.SocialActivityLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil"%>
<%@page import="com.liferay.portlet.social.model.SocialActivity"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="java.util.Calendar"%>
<%@page import="org.joda.time.LocalDate"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

	<% 
	
	String to=new LocalDate().monthOfYear().getAsText() + StringPool.SPACE + new LocalDate().getDayOfMonth(); 
	String from=new LocalDate().monthOfYear().getAsText() +StringPool.SPACE+ new LocalDate().minusDays(6).dayOfMonth().get();
	Calendar cal = Calendar.getInstance();
	
	String portlet_Id = Constant.PORTLET_CREATE_LESSON;
	long lesson_targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true, Constant.PAGE_CREATE_LESSON).getPlid();		
	PortletURL createLessonUrl=PortletURLFactoryUtil.create(request,portlet_Id , lesson_targetPlId, PortletRequest.RENDER_PHASE);
	createLessonUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION,"createGroupLesson"); 
	

	String request_portlet_Id = Constant.PORTLET_REQUEST_LESSON;
	long request_targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true, Constant.PAGE_REQUEST_LESSON).getPlid();		
	PortletURL createRequestUrl=PortletURLFactoryUtil.create(request,request_portlet_Id , request_targetPlId, PortletRequest.RENDER_PHASE);
	createRequestUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION,"createMyRequest"); 
	
	%>

	<div>
		<h1>
			<liferay-ui:message key="my-stuff" />
			<div class="pull-right">
				<select id="createNew">
					<option value=""><liferay-ui:message key="create-new" /></option>
					<option value="lesson"><liferay-ui:message key="lesson" /></option>
					<option value="request"><liferay-ui:message key="request" /></option>
					<option value="group"><liferay-ui:message key="group" /></option>
				</select>
			</div>
		</h1> 
	</div>
	
	<div class="ny-you-message">
		<h4 class="message-heading"></h4>
		<div class="message-body shadow"> 
		<c:if test="${!empty requestLessonAccepted}">
			<c:forEach items="${requestLessonAccepted}" var="requestAccepted" varStatus="i">
				<p>You have accepted Lesson Request:<a href="javascript:void(0)">${requestAccepted.name}</a></p>
			</c:forEach>
		</c:if>
		<c:if test="${empty requestLessonAccepted}">
			<p>
				<liferay-ui:message key="you-have-not-accepted-any-lesson-request" />
			</p>
			</c:if>
		</div>
	</div>
	
	 
	<div>
		<h3> <liferay-ui:message key="this-week" />: <%=from%>  -  <%=to%></h3>
		<ul class="unstyled">
			<li> <i class="icon-file"></i> <span>${activities.lessonPublishedCount} &nbsp;
				<liferay-ui:message key="lesson-published" /> 
			</span> </li>
			<li> <i class="icon-comment"></i>&nbsp;<span>${activities.commentsAddedCount}&nbsp;
				<liferay-ui:message key="comment-added" /> </span> </li>
			<li> <i class="icon-check"></i> <span>${activities.requestAcceptedCount}&nbsp;
				<liferay-ui:message key="new-request-accepted" /> </span> </li>
		</ul> 
	</div>
	
	<script type="text/javascript"src="<%=themeDisplay.getPathThemeJavaScript()%>/jquery/libs/Stylish-Select-Box/fancySelect.js"></script>
	
	<Script>
	$(document).ready(function() {
		
	        $('#createNew').fancySelect().on('change', function() { 
	                 if($(this).val().indexOf('lesson')>=0){
	                	 window.location.href='<%=createLessonUrl%>'; 
	                 }if($(this).val().indexOf('request')>=0){
	                	 window.location.href='<%=createRequestUrl%>'; 
	                 }
	                 else if($(this).val().indexOf('group')>=0){
	                	$("#<portlet:namespace/>content .makeActive").hide();
	              		$("#<portlet:namespace/>content #<portlet:namespace/>myLessonsLoading").show();
	              		$("#<portlet:namespace/>content #<portlet:namespace/>myLessonsLoading").hide();
	              	    $("#<portlet:namespace/>content #<portlet:namespace/>userprofilegroupContent").show(); 
	              		  $('#myGroupPopover').trigger("click");
	                 }
	        });
		});
	
	 </Script>