<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %> 		<%--	added by asif 	 --%>

<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="javax.portlet.PortletURL"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/lessons.js"></script>
	<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/requestLessons.js"></script>
	<%-- <portlet:renderURL var="redirectURL" />   --%>
 <%
	String portletID = Constant.PORTLET_MY_SUTFF;
	long targetPlID = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_MY_SUTFF).getPlid();
	PortletURL myStuffUrl=PortletURLFactoryUtil.create(request, portletID, targetPlID, PortletRequest.RENDER_PHASE);
	
	if(request.getAttribute(Constant.TYPE).toString().equalsIgnoreCase("myFollowers")){
		myStuffUrl.setParameter("onLoadTrigger", "myfollowersUrl");
	}else if(request.getAttribute(Constant.TYPE).toString().equalsIgnoreCase("myFollowing")){
		myStuffUrl.setParameter("onLoadTrigger", "myFollowingUrl");
	}else if(request.getAttribute(Constant.TYPE).toString().equalsIgnoreCase("trending")){
		portletID = Constant.PORTLET_TRENDING;
	 	targetPlID = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_TRENDING).getPlid();
	 	myStuffUrl=PortletURLFactoryUtil.create(request, portletID, targetPlID, PortletRequest.RENDER_PHASE);
	}
	%> 
	
	<div id="lessonsController" ng-controller="LessonsController"> 
		<div id="nyYouTab" class="clearfix" style="padding: 0;">
				<!-- TAB LINKS -->
				<c:if test="${type eq 'contributor'}">
				<a href="${redirectUrl}" class="btn btn-default" style="position: absolute; right: 0px;"><i class="icon-hand-left icon-white"></i> <liferay-ui:message key="back" /> </a>
				</c:if>
				<c:if test="${type eq 'myFollowers'}">
				<a href="<%=myStuffUrl%>" class="btn btn-default" style="position: absolute; right: 0px;"><i class="icon-hand-left icon-white"></i> <liferay-ui:message key="back" /> </a>
				</c:if>
				<c:if test="${type eq 'myFollowing'}">
				<a href="<%=myStuffUrl%>" class="btn btn-default" style="position: absolute; right: 0px;"><i class="icon-hand-left icon-white"></i> <liferay-ui:message key="back" /> </a>
				</c:if>
				<c:if test="${type eq 'trending'}">
				<a href="<%=myStuffUrl%>" class="btn btn-default" style="position: absolute; right: 0px;"><i class="icon-hand-left icon-white"></i> <liferay-ui:message key="back" /> </a>
				</c:if>
				<h4 style="position: absolute; left: 370px;" ng-cloak> <i class="icon-user"></i> ${userName} </h4>
				<ul class="nav nav-tabs">
					<li class="active"><a href="lessons"><liferay-ui:message key="lessons" /></a></li>
					<li><a href="#request"><liferay-ui:message key="requests" /></a></li> 					
				</ul> <!-- END TAB LINKS --> 
				<!-- TAB CONTENT -->
				<div class="tab-content" >
				
					<div id="lessons" class="tab-pane">
						
						 <%@include file="lesson.jsp" %> 
					</div>
					<div id="request" class="tab-pane">
					<div id="requestController" ng-controller="requestLessonsController">
						<%@include file="request.jsp" %> 
					</div>
					</div>
				</div>	
		</div>
	</div> <!--  END lessonsController -->
				
<script>	   
YUI().use('aui-tabview', function(Y) {
		new Y.TabView(
		  {
			srcNode: '#nyYouTab'
		  }
		).render();
	});
$(document).ready(function(){
	var str=JSON.stringify(<%=request.getAttribute(Constant.USER_CONTRIBUTION_DATA)%>);
	var data=JSON.parse(str);
	var allLessonData=JSON.parse(data.userLessons);
	var e = $('#lessonsController');
	var scope = angular.element(e).scope();
	scope.$apply(function() {
    	scope.lessonFilter="";
    	scope.categories=JSON.parse(allLessonData.getCategories);
    	scope.tags=JSON.parse(allLessonData.getTags);
    	scope.lesson = JSON.parse(allLessonData.getLessons);
    	scope.userName = '';
    	scope.load();
   	});
	var e = $('#requestController');
	var scope = angular.element(e).scope();
	scope.$apply(function() {
	scope.allJsonRequests=JSON.parse(data.userRequest);
	scope.items=scope.allJsonRequests;
	});
	
});	
	
</script>
