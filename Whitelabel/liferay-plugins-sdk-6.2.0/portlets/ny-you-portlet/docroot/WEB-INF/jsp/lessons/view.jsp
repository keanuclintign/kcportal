<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="java.util.*" %>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portal.theme.ThemeDisplay"%>
<%@page import="com.liferay.portal.model.User"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>	<%--	added by asif	 --%>
<%@page import="com.liferay.util.portlet.PortletProps"%>

<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/lessons.js"></script>
<portlet:resourceURL var='latestLessonsURL' id='latestLessons' />
<portlet:resourceURL var='popularLessonsURL' id='popularLessons' />
<portlet:resourceURL var='featuredLessonsURL' id='featuredLessons' />

	
<%
String userGroupId =request.getParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),layout.isPrivateLayout(),themeDisplay);
String homeUrl=siteFriendlyUrl+Constant.PAGE_HOME;
boolean isBrowsePage = themeDisplay.getLayout().getNameCurrentValue().equalsIgnoreCase("browse");
if(!isBrowsePage && request.getAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID)==null){
%>
<c:set var="userGroupId" value="<%=userGroupId%>" scope="page" />
<div id="divLoading" style="display:none;">
	<div class="divLoadingclass" align="center" style="margin-top: 5%;"><img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt="" /> 
		<label style="color:#8131AF;">
			<liferay-ui:message key="loading" />
		</label></div>
</div>


<div id="lessonsController" ng-controller="LessonsController"> 
		<!-- ============== TAB COMPONENT ==================== -->
		<div id="nyYouTab">
			<!-- TAB LINKS -->
			<ul class="nav nav-tabs">
				<li class="active <portlet:namespace/>featuredLessons">
					<a href="#featured" id="<portlet:namespace/>featuredLessons">
						<liferay-ui:message key="featured" />
					</a>
				</li>
				<li class="<portlet:namespace/>latestLessons">
					<a href="#latest" id="<portlet:namespace/>latestLessons">
						<liferay-ui:message key="latest" />
					</a>
				</li>
				<li class="<portlet:namespace/>popularLessons" >
					<a href="#popular" id="<portlet:namespace/>popularLessons">
						<liferay-ui:message key="popular" />
					</a>
				</li>
				
			</ul> <!-- END TAB LINKS -->
			<!-- TAB CONTENT -->
			
			<div class="tab-content">
				<div id="featured" class="tab-pane">
					<div class="angularContent view-available">
					<%@ include file="featuredLessons.jsp" %>
					</div>
				</div>
				
				<div id="latest" class="tab-pane">
					<div class="angularContent view-unavailable">
						<jsp:include page="latestLessons.jsp"></jsp:include>
					</div>
				</div>
				
				<div id="popular" class="tab-pane" >
					<div class="angularContent view-unavailable">
						<jsp:include page="popularLessons.jsp"></jsp:include>
					</div>
				</div>
			</div>
		</div> <!-- end nyYouTab -->
</div><!-- end LessonsController -->

<script>
	$(document).ready(function(){
		//getLatestLessons();
		$('li.<portlet:namespace/>featuredLessons').trigger('click');
	});

	YUI().use('aui-tabview', function(Y) {
		new Y.TabView(
		  {
			srcNode: '#nyYouTab'
		  }
		).render();
	});
	var latestLessonAjaxInProcess = false;
	var popularLessonAjaxInProcess = false;
	var featuredLessonAjaxInProcess = false;
	
	function getLatestLessons(pagination){
		$('.tab-content .divLoadingclass').remove();
		$('#latest').append($('#divLoading').html());
		$('#latest .angularContent').hide();
		var e = $('#lessonsController');
		var scope = angular.element(e).scope();
		var showCount=60;
    	var start = 0;
    	var end = showCount;
    	
   		if(pagination == 'next'){
   			start = scope.end;
   			end = scope.end + showCount;
   		}else if(pagination == 'previous'){ //previous
   			start = scope.start - showCount;
   			end = scope.start;
   		}
    	if(!latestLessonAjaxInProcess){
    		latestLessonAjaxInProcess = true;
    	    $.ajax({
	        url:'<%=latestLessonsURL.toString() %>',
	        type: 'GET',
	        async: true,
	        data:{
	        	<portlet:namespace/>start: start,
	        	<portlet:namespace/>end: end,
	        	<portlet:namespace/>categoryId:scope.categoryId,
	        	<portlet:namespace/>tagId:scope.tagId,
	        	<portlet:namespace/>userGroupId:<%=userGroupId%>
	        },
	        success: function(data){
				var allLessonData=JSON.parse(JSON.parse(JSON.stringify(data)));      
		    	scope.lessonFilter="";
		    	if(scope.categoryId==0){
		    		scope.categories=JSON.parse(allLessonData.getCategories);
		    		scope.categoryId = 0;
		    	}
		    	if(scope.tagId==0){
		    		scope.tags=JSON.parse(allLessonData.getTags);
		    		scope.tagId = 0;
		    	}
		    	scope.lessons = JSON.parse(allLessonData.getLessons);
		    	scope.start=allLessonData.start;
		    	scope.end=allLessonData.end;
		    	scope.load();
		    	 if(scope.$root.$$phase != '$apply'){
	            	 scope.$apply(function() {});
	             }
		    	if(scope.lessons.length <= 0){
		    		$('.tab-content .divLoadingclass').remove();
					$('#latest .angularContent').show();
					scope.loadCloudTags([]);
		    	}
		    	   
		    	if(scope.start<showCount)
		    		$('#latest #previousPagination').hide();
		    	else
		    		$('#latest #previousPagination').show();

		    	if(allLessonData.endResult)
		    		$('#latest #nextPagination').hide();
		    	else
		    		$('#latest #nextPagination').show();
		    	
		    	latestLessonAjaxInProcess = false;
		    	
	     	}
	        
	    });
    	}    
	}
	
	function getPopularLessons(pagination) {
		$('.tab-content .divLoadingclass').remove();
		$('#popular').append($('#divLoading').html());
		$('#popular .angularContent').hide();
		var e = $('#lessonsController');
		var scope = angular.element(e).scope();
		var showCount=60;
	   	var start = 0;
	   	var end = showCount;
		if(pagination == 'next'){
			start = scope.end;
			end = scope.end + showCount;
		}else if(pagination == 'previous'){ //previous
			start = scope.start - showCount;
			end = scope.start;
		}
		if(!popularLessonAjaxInProcess){
			popularLessonAjaxInProcess = true;
			$.ajax({
	        url:'<%=popularLessonsURL.toString() %>',
	        type: 'GET',
	        async: true,
	        data:{
	        	<portlet:namespace/>filterType: scope.lessonFilter,
	        	<portlet:namespace/>start: start,
	        	<portlet:namespace/>end: end,
	        	<portlet:namespace/>categoryId:scope.categoryId,
	        	<portlet:namespace/>tagId:scope.tagId,
	        	<portlet:namespace/>userGroupId:<%=userGroupId%>
	        },
	        success: function(data){
				var allLessonData=JSON.parse(JSON.parse(JSON.stringify(data)));
		    	if(scope.categoryId==0){
		    		scope.categories=JSON.parse(allLessonData.getCategories);
		    		scope.categoryId = 0;
		    	}
		    	if(scope.tagId==0){
		    		scope.tags=JSON.parse(allLessonData.getTags);
		    		scope.tagId = 0;
		    	}
	    		scope.lessons = JSON.parse(allLessonData.getLessons);
	    		scope.start=allLessonData.start;
		    	scope.end=allLessonData.end;
	    		scope.load();
	    		 if(scope.$root.$$phase != '$apply'){
	            	 scope.$apply(function() {});
	             }
	    		if(scope.lessons.length<=0){
		    		$('.tab-content .divLoadingclass').remove();
					$('#popular .angularContent').show();
					scope.loadCloudTags([]);
		    	}	
	    		
		    	if(scope.start < showCount)
		    		$('#popular #previousPagination').hide();
		    	else
		    		$('#popular #previousPagination').show();

		    	if(allLessonData.endResult)
		    		$('#popular #nextPagination').hide();
		    	else
		    		$('#popular #nextPagination').show();    		
	    		
		    	popularLessonAjaxInProcess = false;
	         }
	   	});
		}
	}	
</script>

<aui:script>

$("li.<portlet:namespace/>latestLessons").click(function(){
	var e = $('#lessonsController');
	var scope = angular.element(e).scope();
	$('.tab-content .angularContent.view-available').removeClass('view-available').addClass('view-unavailable');
	$('.tab-content #latest .angularContent').addClass('view-available').removeClass('view-unavailable');
	scope.start = 0
	scope.end = 0;
	scope.categoryId=0;
    scope.tagId=0;
    scope.filterTab="latest";
    scope.lessonFilter="";
	getLatestLessons();
});

$("li.<portlet:namespace/>popularLessons").click(function(){
	var e = $('#lessonsController');
   	var scope = angular.element(e).scope();
   	$('.tab-content .angularContent.view-available').removeClass('view-available').addClass('view-unavailable');
	$('.tab-content #popular .angularContent').addClass('view-available').removeClass('view-unavailable');
   	scope.lessonFilter="viewCount";
   	scope.filterTab="popular";
   	scope.start = 0
	scope.end = 0;
	scope.categoryId=0;
    scope.tagId=0;
    getPopularLessons();
});

$("li.<portlet:namespace/>featuredLessons").click(function(){
	$('.tab-content .angularContent.view-available').removeClass('view-available').addClass('view-unavailable');
	$('.tab-content #featured .angularContent').addClass('view-available').removeClass('view-unavailable');
	var e = $('#lessonsController');
	var scope = angular.element(e).scope();
	scope.tagId=0;
	scope.categoryId=0;
	scope.filterTab="feature";
	featuredLessons();
});


function featuredLessons(){
	$('.tab-content .divLoadingclass').remove();
	$('#featured').append($('#divLoading').html());
	$('.angularContent').hide();
	var e = $('#lessonsController');
	var scope = angular.element(e).scope();
	if(!featuredLessonAjaxInProcess){
		featuredLessonAjaxInProcess = true;
		$.ajax({
		    url:'<%=featuredLessonsURL.toString() %>',
		    type: 'GET',
		    async: true,
		    data:{
		    	<portlet:namespace/>userGroupId:<%=userGroupId%>,
		    	<portlet:namespace/>tagId:scope.tagId
		    },
		    success: function(data){
				var allLessonData=JSON.parse(JSON.parse(JSON.stringify(data)));	        
				scope.$apply(function() {
			  	scope.lessonFilter="";
			  	scope.categories=JSON.parse(allLessonData.getCategories);
			  	scope.tags=JSON.parse(allLessonData.getTags);
			  	scope.lessons = JSON.parse(allLessonData.getLessons);
			  	
			  	if(scope.lessons.length<=0){
				  	$('.tab-content .divLoadingclass').remove();
					$('.angularContent').show();
					scope.loadCloudTags([]);
			  	}			    	
			  	scope.load();
			 	});
			   	featuredLessonAjaxInProcess = false;
		    }
	   	});
	}
}
</aui:script>

<%}else{%>
<script>
$(function(){
	window.location.href="<%=homeUrl%>";
});
</script>
<%}%>