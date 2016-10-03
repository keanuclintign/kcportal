<%@page import="com.nyu.util.Constant"%>
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
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/groups.js?<%=new Date().getTime()%>"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/lessons.js?<%=new Date().getTime()%>"></script>

<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/requestLessons.js?<%=new Date().getTime()%>"></script>
	

<portlet:defineObjects />
<liferay-theme:defineObjects />

<%
String action = request.getParameter(Constant.COMMON_STRING_CONSTANT_ACTION);
String archivedLessonsTabActive = request.getParameter("archivedLessonstabActive");
String backToMyStuff = request.getParameter("onLoadTrigger");

%>

<portlet:resourceURL var="myfollowingURL" id="myfollowing">
</portlet:resourceURL>

<portlet:resourceURL var="mybadgesURL" id="mybadges">
</portlet:resourceURL>

<portlet:resourceURL var="mypointsURL" id="mypoints">
</portlet:resourceURL>

<portlet:resourceURL var="myfollowersURL" id="myfollowers">
</portlet:resourceURL>

<portlet:resourceURL var="userprofilegroupURL" id="myGroups">
</portlet:resourceURL>

<portlet:resourceURL var="mylessonsURL" id="mylessons">
</portlet:resourceURL>

<portlet:resourceURL var="myrequestURL" id="myrequest">
</portlet:resourceURL>

<portlet:resourceURL var="archivedLessonsURL" id="archivedLessons">
</portlet:resourceURL>


<div id="divLoading" style="display:none;">
	<div class="divLoadingclass" align="center" style="margin-top: 35%;"><img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt="" /> <label style="color:#8131AF;">
		<liferay-ui:message key="loading" />
	</label></div>
</div>

<%
	
%>

<div class="container">
	<div id="myStuff" class="clearfix">
		<div class="span3">
			<div class="left-section" style= "margin-bottom: 250px;">
				<div class="user-profile text-center">
					<img src="<%=user.getPortraitURL(themeDisplay) %>"  style="background-color: #CCCCCC;"/> 
					<p class="word-wrap"><%=user.getFullName() %></p>
				</div>
				<ul id="userMenu">
					<li> <a id="<portlet:namespace/>mypoints" href="javascript:void(0);"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyPoints.png">
						<liferay-ui:message key="my-points" />
					</a> </li>
					<c:if test="<%=Constant.IS_BADGES_REQUIRE%>">
						<li> <a id="<portlet:namespace/>mybadges" href="javascript:void(0);"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyBadges.png"> 
							<liferay-ui:message key="my-badges" />
						</a> </li>
					</c:if>
					<li> <a id="<portlet:namespace/>myGroups" href="javascript:void(0);"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyGroups.png"> 
						<liferay-ui:message key="my-groups" />
					</a> </li>
					<li> <a id="<portlet:namespace/>myfollowers" href="javascript:void(0);"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>Followers.png"> 
						<liferay-ui:message key="followers" /> 
					</a> </li>
					<li> <a id="<portlet:namespace/>myfollowing" href="javascript:void(0);"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>Followings.png"> 
						<liferay-ui:message key="following" /> 
					</a> </li>
					<li id="myStuffLesson"> <a id="<portlet:namespace/>mylessons" href="javascript:void(0);"><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyLesson.png"> 
						<liferay-ui:message key="my-lessons" />
					</a></li>
					<li> <a id="<portlet:namespace/>myfavouriteLessons" href="javascript:void(0);"><img width="34px;" src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>favorite-icon.png">
						<liferay-ui:message key="my-favorites" />
					</a></li>
					<li> <a id="<portlet:namespace/>myrequest" href="javascript:void(0);"><img width="24px;" style="margin-left: 4px; margin-right: 5px;" src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>acceptRequest.png">
						<liferay-ui:message key="my-requests" />
					</a></li>
					<%if(PortalUtil.isOmniadmin(PortalUtil.getUserId(request)) || request.isUserInRole(Constant.PORTAL_ADMIN_ROLE)){ %>
					<li> <a id="<portlet:namespace/>archive" href="javascript:void(0);"><img width="24px;" style="margin-left: 4px; margin-right: 5px;" src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>lesson-archive-icon.png">
						<liferay-ui:message key="archieve" />
					</a></li>
					<%} %>
				</ul>
			</div> <!-- end left-section -->
		</div> <!-- end span3 -->
		<div class="span9">	
			<div id='<portlet:namespace/>content'>
				<div id="<portlet:namespace/>myfollowersContent" class="makeActive" style="display:none">
					
				</div>
				<div id="<portlet:namespace/>userprofilegroupContent" class="makeActive" style="display:none">
					<jsp:include page="myGroups.jsp"></jsp:include>
				</div>
				<div id="<portlet:namespace/>myfollowingContent" class="makeActive" style="display:none">
					
				</div>
				<div id="<portlet:namespace/>mybadgesContent" class="makeActive" style="display:none">
					
				</div>
				<div id="<portlet:namespace/>myPointsContent" class="makeActive" style="display:none">
					<jsp:include page="myPoints.jsp"></jsp:include>
				</div>
				<div id="<portlet:namespace/>myLessonsContent" class="makeActive" style="display:none">
					<jsp:include page="myLessons.jsp"></jsp:include>
				</div>
				<div id="<portlet:namespace/>myFavouriteLessonsContent" class="makeActive" style="display:none">
					<jsp:include page="favouriteLessons.jsp"></jsp:include>
				</div>
				<div id="<portlet:namespace/>myRequestContent" class="makeActive" style="display:none">
					<jsp:include page="myRequest.jsp"></jsp:include>
				</div>
				<div id="<portlet:namespace/>myLessonsLoading" class="makeActive"  style="display:none;">
					<div class="divLoadingclass" align="center" style="margin-top: 35%;"><img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt="" /> 
						<label style="color:#8131AF;">
						<liferay-ui:message key="loading" />
					</label></div>
				</div>
				<div id="<portlet:namespace/>archiveLessons" class="makeActive" style="display:none;">
					<div class="divLoadingclass" ><jsp:include page="archivedLessons.jsp"></jsp:include></div>
				</div>
			</div>
		</div> <!-- end span9 -->
	</div> <!-- end row-fluid -->
</div> <!-- end container -->

<script>
var archivedLessonsTabActive='<%=archivedLessonsTabActive%>';
var Inappropriate="<%=Constant.INAPPROPRIATE%>";
var lessonDeletedFromGroup="<%=Constant.LESSON_FROM_DELETED_GROUP%>";
var lessonDeletedFromUser="<%=Constant.LESSON_DELETED_BY_USER%>";
var quarantine="<%=Constant.MARKEDAS_QUARANTINE%>";

$(document).ready(function(){
	
	var mystuffAction = '<%=action%>';
	
	var backToMyStuff = '<%=backToMyStuff%>';
	
	if(mystuffAction != 'null'){
		$("#<portlet:namespace/>content #<portlet:namespace/>userprofilegroupContent").show();	
	}else{
		$("#<portlet:namespace/>content #<portlet:namespace/>myPointsContent").show();
	}
	if(archivedLessonsTabActive!= 'null'){
		$("#<portlet:namespace/>archive").trigger('click');
	}
	if(backToMyStuff!= 'null' && backToMyStuff == '<%=Constant.MYSTUFF_MYFOLLOWERS%>'){
		$("#<portlet:namespace/>myfollowers").trigger('click');
	}
	else if(backToMyStuff!= 'null' && backToMyStuff == '<%=Constant.MYSTUFF_MYFOLLOWINGS%>'){
		$("#<portlet:namespace/>myfollowing").trigger('click');
	}

});
</script>
<aui:script>

$("#<portlet:namespace/>archive").click(function(){
	$("#<portlet:namespace/>content .makeActive ").hide();
	$("#<portlet:namespace/>content #<portlet:namespace/>archiveLessons").show();
	var e = $('#archivedLessonsController');
	var scope = angular.element(e).scope();
	
	scope.start = 0
	scope.end = 0;
	scope.categoryId=0;
    scope.tagId=0;
    scope.lessonFilter="";
	
	getArchivedLessons("archivedLessonsController",Inappropriate,'no');
});

function userAndGroupDeletedLessons(type,angularId){
	var e = $('#'+angularId);
	var scope = angular.element(e).scope();
	scope.start = 0
	scope.end = 0;
	scope.categoryId=0;
    scope.tagId=0;
    scope.lessonFilter="";
	//var id=$('#inappropriate .tab-pane.active').children().first().attr('id');
	getArchivedLessons(angularId,type,'no');
}




$("#<portlet:namespace/>myrequest").click(function(){
	$("#<portlet:namespace/>content .makeActive ").hide();
	$("#<portlet:namespace/>content #<portlet:namespace/>myRequestContent").show();
	$.ajax({
        url:'<%=myrequestURL.toString() %>',
        type: 'GET',
        data:{
        	<%-- <portlet:namespace/>count:count, --%>
        },
        success: function(data){
			var e1 = $("#requestController");
			var scope = angular.element(e1).scope();
			scope.allJsonRequests=JSON.parse(data);
			scope.items=scope.allJsonRequests;
			scope.$apply(function(){
			});
         }
    });
});


$("#<portlet:namespace/>myfollowing").click(function(){
	$("#<portlet:namespace/>content .makeActive ").hide();
	$("#<portlet:namespace/>content #<portlet:namespace/>myfollowersContent").show();
	$("#<portlet:namespace/>content #<portlet:namespace/>myfollowersContent").html($("#divLoading").html());
	$.ajax({
        url:'<%=myfollowingURL.toString() %>',
        type: 'GET',
        data:{
        	<%-- <portlet:namespace/>count:count, --%>
        },
        success: function(data){
        	$("#<portlet:namespace/>content #<portlet:namespace/>myfollowersContent .divLoadingclass").remove();
        	$("#<portlet:namespace/>content #<portlet:namespace/>myfollowersContent").html(data);
         }
        
    });
});


$("#<portlet:namespace/>mybadges").click(function(){
	$("#<portlet:namespace/>content .makeActive").hide();
	$("#<portlet:namespace/>content #<portlet:namespace/>mybadgesContent").show();
	$("#<portlet:namespace/>content #<portlet:namespace/>mybadgesContent").html($("#divLoading").html());
	$.ajax({
        url:'<%=mybadgesURL.toString() %>',
        type: 'GET',
        success: function(data){
        	$("#<portlet:namespace/>content #<portlet:namespace/>mybadgesContent .divLoadingclass").remove();
        	$("#<portlet:namespace/>content #<portlet:namespace/>mybadgesContent").html(data);
         }
        
    });
});

$("#<portlet:namespace/>mypoints").click(function(){
	$("#<portlet:namespace/>content .makeActive").hide();
	$("#<portlet:namespace/>content #<portlet:namespace/>myPointsContent").show();
	$("#<portlet:namespace/>content #<portlet:namespace/>myPointsContent").html($("#divLoading").html());
	$.ajax({
        url:'<%=mypointsURL.toString() %>',
        type: 'GET',
        data:{
        	<%-- <portlet:namespace/>count:count, --%>
        },
        success: function(data){
        	$("#<portlet:namespace/>content #<portlet:namespace/>myPointsContent .divLoadingclass").remove();
        	$("#<portlet:namespace/>content #<portlet:namespace/>myPointsContent").html(data);
         }
        
    });
});

$("#<portlet:namespace/>myfollowers").click(function(){
	$("#<portlet:namespace/>content .makeActive").hide();
	$("#<portlet:namespace/>content #<portlet:namespace/>myfollowersContent").show();
	$("#<portlet:namespace/>content #<portlet:namespace/>myfollowersContent").html($("#divLoading").html());
	$.ajax({
        url:'<%=myfollowersURL.toString() %>',
        type: 'GET',
        data:{
        	<%-- <portlet:namespace/>count:count, --%>
        },
        success: function(data){
        	$("#<portlet:namespace/>content #<portlet:namespace/>myfollowersContent .divLoadingclass").remove();
        	$("#<portlet:namespace/>content #<portlet:namespace/>myfollowersContent").html(data);
         }
        
    });
});


$("#<portlet:namespace/>mylessons").click(function(){
	 $("#<portlet:namespace/>content .makeActive").hide();
		$("#<portlet:namespace/>content #<portlet:namespace/>myLessonsLoading").show();
	    $.ajax({
	        url:'<%=mylessonsURL.toString() %>',
	        type: 'GET',
	        data:{
	        	 <portlet:namespace/>lessons:"myLessons", 
	        },
	        success: function(data){
				var AllLessonData=JSON.parse(data);	        
				var e = $('#draftAndPublishedLessonsController');
		    	scope = angular.element(e).scope();
		    	scope.$apply(function() {
			    	scope.categories=JSON.parse(AllLessonData.categories);
			    	scope.tags=JSON.parse(AllLessonData.tags);
			    	scope.lessons = JSON.parse(AllLessonData.lessons);
			    	scope.currentUserId ='<%=themeDisplay.getUserId()%>'
			    	scope.categoryId=0;
    				scope.tagId=0;
			    	scope.load();
		       	});
		    $("#<portlet:namespace/>content #<portlet:namespace/>myLessonsLoading").hide();
	     	$("#<portlet:namespace/>content #<portlet:namespace/>myLessonsContent").show();
	         }
        
    	});
});

$("#<portlet:namespace/>myfavouriteLessons").click(function(){

$("#<portlet:namespace/>content .makeActive").hide();
		$("#<portlet:namespace/>content #<portlet:namespace/>myLessonsLoading").show();
	    $.ajax({
	        url:'<%=mylessonsURL.toString() %>',
	        type: 'GET',
	        data:{
	        	 <portlet:namespace/>lessons:"myFavouriteLessons", 
	        },
	        success: function(data){
				var AllLessonData=JSON.parse(data);	        
				var e = $('#favouriteLessonsController');
		    	scope = angular.element(e).scope();
		    	scope.$apply(function() {
			    	scope.categories=JSON.parse(AllLessonData.categories);
			    	scope.tags=JSON.parse(AllLessonData.tags);
			    	scope.lessons = JSON.parse(AllLessonData.lessons);
			    	scope.categoryId=0;
    				scope.tagId=0;
			    	scope.load();
		       	});
		    $("#<portlet:namespace/>content #<portlet:namespace/>myLessonsLoading").hide();
	     	$("#<portlet:namespace/>content #<portlet:namespace/>myFavouriteLessonsContent").show();
	         }
        
    	});
	 
});


$("#<portlet:namespace/>myGroups").click(function(){

		
	  $("#<portlet:namespace/>content .makeActive").hide();
		$("#<portlet:namespace/>content #<portlet:namespace/>myLessonsLoading").show();
		$("#<portlet:namespace/>content #<portlet:namespace/>myLessonsLoading").hide();
	    $("#<portlet:namespace/>content #<portlet:namespace/>userprofilegroupContent").show();
	    var e = $('#groupsController');
	   	scope = angular.element(e).scope();
	   	scope.$apply(function() {
	   		scope.categoryId=0;
			scope.tagId=0;
	   	});
});


</aui:script>
 

<script>
	(function(){
		$('#myStuffLesson').on('click',function(){ 	
			$('#nyYouTab ul li:first-child').trigger('click');  	 
		});		
	})();
	
	
	YUI().use('aui-tabview', function(Y) {
		new Y.TabView({
			srcNode : '#myRequestTab'
		}).render();
	});
</script>
		


