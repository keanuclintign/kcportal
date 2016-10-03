<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui"  %>
<%@page import="com.nyu.model.RequestLesson"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

<%
RequestLesson requestLesson = null; 
String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),layout.isPrivateLayout(),themeDisplay);
String requestLandingPageUrl=siteFriendlyUrl+"/new Request";

String rlPortletId = Constant.PORTLET_REQUEST_LESSON;
long rlTargetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_REQUEST_LESSON).getPlid();
PortletURL showRequestLessonURL = PortletURLFactoryUtil.create(renderRequest, rlPortletId, rlTargetPlId, PortletRequest.RENDER_PHASE);
showRequestLessonURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, "showRequestPage");
showRequestLessonURL.setParameter("showPopOver", Constant.COMMON_STRING_CONSTANT_TRUE);
showRequestLessonURL.setWindowState(LiferayWindowState.EXCLUSIVE);
%>

<portlet:resourceURL id="createRequest" var="createRequestURL"/>
<portlet:resourceURL id="existingRequest" var="existingRequestURL"/>
<div class="span3">
	<a href="javascript:void(0)" id="makeRequest" class="box-grey">
		<nav class="box-request">	
			<p class="request-lession">
				<span class="backgroundicon-request color background-left">
					<liferay-ui:message key="request" />
				</span>
			</p>
			
			<ul>
				<li>
					<liferay-ui:message key="collaborator" />
				</li>
				<li>
					<liferay-ui:message key="information" />
				</li>
				<li>
					<liferay-ui:message key="Lesson" />
				</li>
				<li>
					<liferay-ui:message key="opinion" />
				</li>
			</ul>
		</nav>
	</a>
</div>
<div id="createRequestPortlet"></div>

<!-- end popOverBodyCotentRequest -->

<script>
function loadCreateRequest(){
	
	$.ajax({
        url:'<%=showRequestLessonURL.toString() %>',
        type: 'GET',
        success: function(data){
        	
        	$("#createRequestPortlet").html(data);
        	 //$('#makeRequest2').trigger("click");
	    	
         }
    
	});	
}
$(document).ready(function(){
	loadCreateRequest();
});
</script>
