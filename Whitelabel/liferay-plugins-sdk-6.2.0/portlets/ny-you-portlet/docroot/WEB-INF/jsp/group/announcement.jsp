<%@page import="com.itextpdf.text.log.SysoLogger"%>

<%@ include file="groupDetail.jsp" %>
<c:if test="${isUserMemberOfGroup}">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/groups.js"></script>

<c:set var="userGroupId" value="${userGroupId}" scope="page" />
<portlet:resourceURL id="deleteAnnouncement" var="deleteAnnouncementURL"/> 

<% 
  //user_userGroupId = GetterUtil.getLong(pageContext.getAttribute("usergroupId"));

String rlPortletId = Constant.PORTLET_USERGROUP;
long rlTargetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_GROUP).getPlid();
PortletURL showAnnouncementURL = PortletURLFactoryUtil.create(renderRequest, rlPortletId, rlTargetPlId, PortletRequest.RENDER_PHASE);
showAnnouncementURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, "showRequestPage");
showAnnouncementURL.setParameter("showPopOver", Constant.COMMON_STRING_CONSTANT_TRUE);
showAnnouncementURL.setParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID, String.valueOf(userGroupId));
showAnnouncementURL.setWindowState(LiferayWindowState.EXCLUSIVE);
%>
<c:set var="isTagRequired" value="false"/>
<div id="groupAnnouncement" style="padding-bottom: 100px;">
<div class="row-fluid">
	<div class="span3">
		<%@ include file="navigationLink.jsp" %>
	</div>
	<div class="span9">
	<%if(usergroup.getUserId()==themeDisplay.getUserId() || (accessRight && hasAdminRights)){%>
		<div class="announcement">
			<button style="margin-bottom: 30px;" class="btn btn-large" id="makeAnnouncement"> <liferay-ui:message key="send-an-announcement-to" /> <%=usergroup.getName()%></button>
		</div> <!-- end announcement -->
	<%}%>
		<%@ include file="announcementResults.jsp" %>
	</div>
</div>
<div id="createAnnouncement"></div>
</div>
<!-- end popOverBodyCotentRequest -->

<script>
function loadCreateRequest(){
	
	$.ajax({
        url:'<%=showAnnouncementURL.toString() %>',
        type: 'GET',
        success: function(data){
        	$("#createAnnouncement").html(data);
        	
        	 //$('#makeRequest2').trigger("click");
         }
    
	});	
}
$(document).ready(function(){
	loadCreateRequest();
	var e = $('#groupsController');
	scope = angular.element(e).scope();
	scope.$apply(function() {
		scope.groupAnnouncements=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.GROUP_ANNOUNCEMENTS)%>));
		scope.userId='<%=PortalUtil.getUser(request).getUserId()%>';
   	});
	
});
</script>
<script>
$(function(){
	$('.announcementAnchor').addClass("active");
});
</script>
</c:if>
<c:if test="${!isUserMemberOfGroup}">
	<liferay-ui:message key="you-dont-have-permission-to-see-this-group-as-this-is-a-private-group" />.
	<span class="pull-right nyu-tooltip" title='<liferay-ui:message key="click-to-go-to-group-home-page" />'><a href="<%=groupHome%>"  style="font-size: 16px; text-decoration: none;"> <liferay-ui:message key="group-home" /> </a>
					<i class="icon-home"></i></span>
</c:if>