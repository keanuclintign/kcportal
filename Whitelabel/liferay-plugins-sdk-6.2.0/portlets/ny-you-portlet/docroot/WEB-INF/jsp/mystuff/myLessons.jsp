
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="com.nyu.util.Constant"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<div id="draftAndPublishedLessonsController" ng-controller="LessonsController"> 
	<h1> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyLesson.png"> 
		<liferay-ui:message key="my-lessons" /> 
	</h1>
	<div id="myLessonTab" class="ny-you-tab">
				<!-- TAB LINKS -->
				<ul class="nav nav-tabs">
					<li class="active"><a href="#drafted" id="<portlet:namespace/>draftedLessons">
						<liferay-ui:message key="draft" />
					</a></li>
					<li><a href="#published" id="<portlet:namespace/>publishedLessons">
						<liferay-ui:message key="published" />
					</a></li>
				</ul> <!-- END TAB LINKS -->
				<!-- TAB CONTENT -->
				
				<div class="tab-content">
					 
					<div id="<portlet:namespace/>mydraftedLessons" class="tab-pane ">
						<div class="angularContent view-available">
							<jsp:include page="draftedLessons.jsp"></jsp:include>
						</div>
					</div>
					<div id="<portlet:namespace/>mypublishedLessons" class="tab-pane " >
						<div class="angularContent view-unavailable">
							<jsp:include page="publishedLessons.jsp"></jsp:include>
						</div>
					</div>
					 
				</div>
		</div> <!-- end nyYouTab -->
</div>


<script>
$(function(){
	 YUI().use('aui-tabview', function(Y) {
			new Y.TabView(
			  {
				srcNode: '#myLessonTab'
			  }
			).render();
		});
});


$("#myLessonTab li a").click(function(){
	 
	var e = $('#draftAndPublishedLessonsController');
	scope = angular.element(e).scope();
	scope.$apply(function() {
    	scope.categoryId=0;
		scope.tagId=0;
	});
    
});
</script>

