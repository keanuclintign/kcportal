<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>		<%--	added by asif 	 --%>

<%@page import="com.liferay.portlet.asset.service.AssetTagLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@page import="com.nyu.util.Constant"%>
<%@page import="com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.model.AssetTag"%>
<%@page import="com.liferay.portlet.asset.model.AssetVocabulary"%>
<%@page import="com.liferay.portlet.asset.model.AssetCategory"%>
<%@page import="com.nyu.util.UserGroupSortByTime"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Date"%>
<%@page import="javax.portlet.ResourceURL"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.model.LayoutSet"%>
<%@page import="com.liferay.portal.service.LayoutSetLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.service.UserGroupLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.UserGroup"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/groups.js?<%=new Date().getTime()%>"></script>
<script>
	var groupPrivacy="public";
</script>
 <portlet:renderURL var="createGroupURL" windowState="pop_up">
	<portlet:param name="action" value="createGroup" />
</portlet:renderURL>

<portlet:resourceURL var="myGroupsURL" id="myGroups">
</portlet:resourceURL>
	
	<div id="groupsController" ng-controller="GroupsController"> 
	<div class="filter-form clearfix">
			<div class="span4">
					<label class="pull-left" for="Category"><liferay-ui:message key="category" /> </label>
					<select id="categoryIdMy" ng-model="categoryId" ng-change="filterByCategory();" >
						<option value="0"><liferay-ui:message key="all" /></option>
						<option ng-repeat="category in categories" value='{{category.id}}'>{{category.name}}</option>
					</select> 
			</div>
			<div class="span4">
					<label for="Tag" class="pull-left"><liferay-ui:message key="tag" /></label>  
					<select id="tagIdMy" ng-model="tagId" ng-change="filterByTag();">
						<option value="0"><liferay-ui:message key="all" /></option>
						<option ng-repeat="tag in tags" value='{{tag.id}}'>{{tag.name}}</option>
					</select>	
			</div> 	<!-- end span4 --> 
			<div class="span4 text-right clearfix"> 
				<%-- <button id=""  ng-click="createEditGroup('<%=createGroupURL%>', 'Create Group');" class="btn pull-right">Create Group</button> --%>
				<button id="myGroupPopover" class="btn btn-primary pull-right"> <liferay-ui:message key="create-group" /> </button>
			</div> 
	</div> <!-- end span12 -->
	<%-- <%@ include file="results.jsp" %> --%>
	<div id="groupResults" class="row-fluid">
		<%@ include file="groupResults.jsp"%>
	</div>
</div> <!-- MyLessonsController -->

<div id="popOverBodyCotent">
	<header class="text-center">&nbsp; <!-- <h1> Create a Group </h1>  --></header>
	<!-- ============== TAB COMPONENT ==================== -->
	<div id="nyYouCreateGroupTab" class="clearfix">
		<!-- TAB LINKS -->
		<ul class="nav nav-tabs">
			<li class="active"><a href="#groupType"><liferay-ui:message key="group-type" /></a></li>
			<li><a href="#groupDetails"><liferay-ui:message key="group-details" /></a></li> 
		</ul> <!-- END TAB LINKS --> 
				
		<!-- TAB CONTENT -->
		<div class="tab-content">
			<div id="groupType" class="tab-pane">
				<ul>
					<li class="text-center">			
						<a href="#groupDetails" onclick="javascript:groupPrivacy='public'"> 
							<div class="pull-left" style="width: 80px;">
								<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-group.png"> 
								<p>	<liferay-ui:message key="open" /> </p>
							</div>
							<div class="pull-right">
								<liferay-ui:message key="open-to-all-br-click-to-join-br-no-administration-br-just-share" /> 
							</div>
						</a>
					</li>
					<li class="text-center">
						<a href="#groupDetails" onclick="javascript:groupPrivacy='private'" class="member-only"> 
							<div class="pull-left">
								<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>lock-icon.png" width="50px">
								<p> <liferay-ui:message key="members-only" /> </p>
							</div>
							<div class="pull-right">
								<liferay-ui:message key="invitation-only-br-people-can-ask-to-join-br-collaborate-br-group-discussions" /> 
							</div>
						</a>
					</li>
					<li class="text-center">
						<a href="#" onclick="javascript:groupPrivacy='collaborator'"> 
							<div class="pull-left">
								<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>lock-icon.png" width="50px">
								<p> <liferay-ui:message key="collaboratory" /> </p>
							</div>
							<div class="pull-right"> 
								<liferay-ui:message key="invitation-only-br-content-is-private-br-your-own-private-br-x-for-br-teaching-and-learning" arguments="<%=Constant.CURRENT_BRAND_NAME%>" /> 
							</div>
						</a>
					</li>
				</ul>
				<footer class="text-center"> <a href="javascript:void(0);" class="btn group-close-popup"> <liferay-ui:message key="cancel" /> </a></footer>
			</div>
			<!-- <div id="groupDetails" class="tab-pane">
				<form class="group-details-form">
					<div class="input-prepend">
					  <label>Group Name</label>
					  <span class="add-on" style="margin-right: -5px;"><i class="icon-hand-right"></i></span>
					  <input class="input-xlarge" type="text" placeholder="Enter Group Name" id="groupName">
					</div>
					<br>
					<div>
						<label>Description</label>	
						<textarea class="input-xlarge" rows="3"></textarea>
					</div>  					
					<div class="input-append">					  
					  <label>Categories</label>	
					  <input type="text" id="Categories" placeholder="Enter Category Name">
					  <button type="button" class="btn"><i class="icon-search"></i> Search</button> 
					</div>
					<div class="input-append">					  
					  <label>Tags</label>	
					  <input type="text" id="Categories" placeholder="Enter Category Name">
					  <button type="button" class="btn"><i class="icon-plus"></i> Add</button> 
					</div>
			  </form>
			  <footer class="text-center">
				<a href="#" class="btn btn-large"> Cancel </a>
				<a href="#" class="btn btn-large back-group-type"> <i class="icon-arrow-left"> </i> Back </a>
				<a href="#" class="btn btn-large btn-primary"> Create </a>
			  </footer>
			</div> -->
			<div id="groupDetails" class="tab-pane">
			<%@ include file="/WEB-INF/jsp/userGroup/createGroup.jsp" %>
			</div>
		</div> <!-- end tab-content -->
	</div> <!-- end nyYouCreateGroupTab -->	
</div>

<script>
$(document).ready(function(){

				var AllGroupData=<%=request.getAttribute("GroupData")%>;  
				var e = $('#groupsController');
		    	scope = angular.element(e).scope();
		    	scope.$apply(function() {
			    	scope.categories=JSON.parse(AllGroupData.getCategories);
			    	scope.tags=JSON.parse(AllGroupData.getTags);
			    	scope.groups = JSON.parse(AllGroupData.getGroups);
			    	scope.load();
		       	});
	     
});

	YUI().use('aui-tabview', function(Y) {
		new Y.TabView(
		  {
			srcNode: '#nyYouTab'
		  }
		).render();
		
		var creatGroupPopover = new Y.TabView(
		  {
			srcNode: '#nyYouCreateGroupTab',
			stacked: true
		  }
		).render();  
	});
	
	// CREATE GROUP POPOVER
	YUI().use('aui-popover','widget-anim', function(Y) {
		var triggerAnim = Y.one('#myGroupPopover');
		var closePopup=Y.all('.group-close-popup');
		var popoverAnim = new Y.Popover(
		  {
			align: {
			  node: triggerAnim,
			  points:[Y.WidgetPositionAlign.TR, Y.WidgetPositionAlign.BR]
			},
			boundingBox: '#popOverBodyCotent', 
			plugins: [Y.Plugin.WidgetAnim],
			position: 'bottom',
			visible: false
		  }
		).render();

		triggerAnim.on(
		  'click',
		  function() {
			popoverAnim.set('visible', !popoverAnim.get('visible'));
		  }
		  
		);
		closePopup.on(
		  'click',
		  function() {
			popoverAnim.set('visible', false);
		  }
		  
		);
		// Intially hiding tab group detail
		Y.one('#nyYouCreateGroupTab > ul li:last-child').hide();
		
		// Click member only to show group detail
		Y.all('#groupType li ').on('click',function(event){
			Y.one('#nyYouCreateGroupTab > ul li:first-child').toggleClass('active').hide();
			Y.one('#nyYouCreateGroupTab > ul li:last-child').toggleClass('active').show();
			Y.one('#nyYouCreateGroupTab .tab-content .tab-pane:first-child').toggleClass('active');
			Y.one('#nyYouCreateGroupTab .tab-content .tab-pane:last-child').toggleClass('active'); 
			event.preventDefault();
		});
		
		
		// Click back to show group type
		$('#groupDetails .back-group-type').on('click', function(event){
			Y.one('#nyYouCreateGroupTab > ul li:first-child').toggleClass('active').show();
			Y.one('#nyYouCreateGroupTab > ul li:last-child').toggleClass('active').hide();
			Y.one('#nyYouCreateGroupTab .tab-content .tab-pane:first-child').toggleClass('active');
			Y.one('#nyYouCreateGroupTab .tab-content .tab-pane:last-child').toggleClass('active'); 	
			event.preventDefault();
		});
	});
</script>