<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>			<%--	added by asif 	 --%>

<%@page import="com.nyu.service.UserGroupRequestLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.nyu.model.UserGroupRequest"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@page import="com.nyu.NoSuchNYUUserGroupException"%>
<%@page import="com.nyu.service.NYUUserGroupLocalServiceUtil"%>
<%@page import="com.nyu.model.NYUUserGroup"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.liferay.portal.service.UserGroupLocalServiceUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.model.UserGroup"%>
<%@page import="com.liferay.portal.service.LayoutSetLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.LayoutSet"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.nyu.model.Lesson"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="java.util.Date"%>

<%if(LiferayWindowState.isPopUp(request)){%>
	<%@ include file="angularScriptInclude.jsp" %>
	
<%}else{
  String mystuffGroupURL= Constant.PORTLET_PROP_GROUP_SLASH_VENDOR +Constant.PAGE_MY_SUTFF;
%>
	<c:set var="mystuffRedirectUrl" value="<%=mystuffGroupURL %>" />
<% }%>

<portlet:resourceURL var='subscriberURL' id='subscriber' />
<portlet:resourceURL var='acceptGroupURL' id='acceptUsertoGroup' />
<portlet:resourceURL id="appreciate" var="appreciateURL" />
<portlet:resourceURL var='declineGroupURL' id='declineUsertoGroup' />

<portlet:renderURL var="groupHome">
<portlet:param name="action" value="groupHome" />
</portlet:renderURL>

<portlet:renderURL var="addLessonUrl" windowState="pop_up">
	<portlet:param name="action" value="addLessons" />
	<portlet:param name="userGroupId" value="${usergroup.userGroupId}" />
</portlet:renderURL>

<script>AUI().use('aui-tabview',function(Y) {new Y.TabView({srcNode: '#learnTab'}).render();});</script>
<script type="text/javascript"
		src="<%=themeDisplay.getPathThemeJavaScript()%>/jquery/libs/Stylish-Select-Box/fancySelect.js"></script>
<script type="text/javascript"
		src="<%=request.getContextPath()%>/js/angular/lessons.js"></script>

<script>	
$(document).ready(function(){ 
	$('#members').find('.thumbnail-test').each(function(i,val){	    
	    if(i%3 == 0) {  
	      $(this).addClass('no-margin clearfix');
	    }
	});
	
	$('#requestedMember').find('.thumbnail-test').each(function(i,val){	    
	    if(i%3 == 0) {  
	      $(this).addClass('no-margin clearfix');
	    }
	});
	
	$('#lessons').find('.thumbnail-content').each(function(i,val){	    
	    if(i%3 == 0) {  
	      $(this).addClass('no-margin clearfix');
	    }
	});
	
	
}); 
</script>

<%
String portletId = Constant.PORTLET_CREATE_LESSON;

List<UserGroup> usergroups=themeDisplay.getUser().getUserGroups();
List<Long> usergroupids= new ArrayList<Long>();

for(UserGroup usergroup:usergroups){
	usergroupids.add(usergroup.getUserGroupId());
}


%>

<c:set var="usergroupId" value="${usergroup.userGroupId}" scope="page" />
<c:set var="groupId" value="${usergroup.groupId}" scope="page" />

<%
			Long userGroupId = GetterUtil.getLong(pageContext.getAttribute("usergroupId"));
			Long groupId = GetterUtil.getLong(pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_GROUP_ID));
			int membersSize=UserLocalServiceUtil.getUserGroupUsers(userGroupId).size();
			UserGroup usergroup=UserGroupLocalServiceUtil.getUserGroup(userGroupId);
			List<User>members=UserLocalServiceUtil.getUserGroupUsers(userGroupId);
			request.setAttribute("members", members);
			
			long lesson_targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true, Constant.PAGE_CREATE_LESSON).getPlid();		
			PortletURL createLessonUrl=PortletURLFactoryUtil.create(renderRequest, portletId, lesson_targetPlId, PortletRequest.RENDER_PHASE);
			createLessonUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION,"createGroupLesson");
			createLessonUrl.setParameter(Constant.COMMON_STRING_CONSTANT_GROUP_ID,groupId.toString());
				
			
			int viewCountgroup =GetterUtil.getInteger(usergroup.getExpandoBridge().getAttribute("view-count").toString());
			viewCountgroup=viewCountgroup+1;
			usergroup.getExpandoBridge().setAttribute("view-count",viewCountgroup);			
			UserGroupLocalServiceUtil.updateUserGroup(usergroup);
			
			
			boolean hasAppreciated = false;
			long appreciatedCountGroup = 0;
			
			String appreciatedUserIds =StringPool.BLANK;
			String requestedId=usergroup.getExpandoBridge().getAttribute("requested-id").toString();
			String curUserId=themeDisplay.getUserId()+"";	
			boolean isRequestedUser = false;
			UserGroupRequest userGroupRequest = null;
			if(Validator.isNotNull
					(UserGroupRequestLocalServiceUtil.getRequestStatusByUsers
							(userGroupId,themeDisplay.getUserId()))){
				userGroupRequest = UserGroupRequestLocalServiceUtil.getRequestStatusByUsers
											(userGroupId,themeDisplay.getUserId());
				if(userGroupRequest.getStatus().equals(Constant.KEYWORD_STATUS_REQUEST))
					isRequestedUser=true;
			}
			boolean groupPrivacy =false;
			String groupPrivacyValue=StringPool.BLANK;
			String isAdminsStr=StringPool.BLANK;
			List<String> adminIDs = new ArrayList<String>();
			NYUUserGroup nyuUG=null;
			boolean hasAdminRights=false;
			try{
				nyuUG=NYUUserGroupLocalServiceUtil.getNYUUserGroup(usergroup.getUserGroupId());
				appreciatedUserIds=nyuUG.getAppreciatedUserIds();
				appreciatedCountGroup=nyuUG.getAppreciateCount();
				groupPrivacyValue=nyuUG.getGroupPrivacy();
				isAdminsStr=nyuUG.getAdministrators();
				if (!isAdminsStr.isEmpty()){
					adminIDs = Arrays.asList(isAdminsStr.split(","));
				}
				hasAdminRights=adminIDs.contains(themeDisplay.getUserId()+"");
				if(groupPrivacyValue.equals(Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC)){
					groupPrivacy =false;
				}else{
					groupPrivacy =true;
				}
			}catch(NoSuchNYUUserGroupException nyuExp){
				groupPrivacy =GetterUtil.getBoolean(usergroup.getExpandoBridge().getAttribute(Constant.GOROUP_PRIVACY));
				groupPrivacyValue=groupPrivacy?Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE:Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC;
				appreciatedUserIds =UserGroupLocalServiceUtil.getUserGroup(userGroupId).getExpandoBridge().getAttribute(Constant.APPRECIATE).toString();
				List<String> items = new ArrayList<String>();
				
				if (!appreciatedUserIds.isEmpty()) {
					items = Arrays.asList(appreciatedUserIds.split(","));
					hasAppreciated = items.contains(themeDisplay.getUserId()+"");
					appreciatedCountGroup = items.size();
				}
			}
			List<User> requestedUsers=new ArrayList<User>();
			if(Validator.isNotNull
					(UserGroupRequestLocalServiceUtil.getGroupRequestByStatus
													(userGroupId, Constant.KEYWORD_STATUS_REQUEST))){
				List<UserGroupRequest> RequestUserList = UserGroupRequestLocalServiceUtil.getGroupRequestByStatus
						(userGroupId, Constant.KEYWORD_STATUS_REQUEST);
				for(UserGroupRequest requestUser:RequestUserList){
					requestedUsers.add(UserLocalServiceUtil.getUser(requestUser.getRequestedBy()));
				}
			}
			
			
			String dataSub="subscribe";
			String label="Join";
			String classes=Constant.BTN_BTN_WARNING;		
			boolean accessRight=false;
			request.setAttribute("requestedMembers", requestedUsers);	
				
			if(groupPrivacy && usergroup.getUserId()!=user.getUserId() && !isRequestedUser)
			{
				label=Constant.REQUEST_TO_JOIN_STRING;
				dataSub="requestJoin";
				classes="btn btn-info";
			}
			else if(groupPrivacy && usergroup.getUserId()!=user.getUserId() && isRequestedUser)
			{
				label="Unrequest";
				dataSub="unrequest";
				classes="btn btn-primary";
			}
			
			if(usergroupids.contains(userGroupId))
			{
				label="Leave";
				dataSub=Constant.UN_SUBSCRIBE;
				classes="btn";
				accessRight=true;
			}	
			String logo=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.GROUP_CARD_PLACEHOLDER;
			LayoutSet publicLS=LayoutSetLocalServiceUtil.getLayoutSet(groupId, false);
			if(publicLS.getLogo())
			{
				logo=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+publicLS.getLogoId();	
			}
			LayoutSet privateLS=LayoutSetLocalServiceUtil.getLayoutSet(groupId, true);
			if(privateLS.getLogo())
			{
				logo=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+privateLS.getLogoId();	
			}
			if(request.isUserInRole(Constant.PORTAL_ADMIN_ROLE)){
				accessRight = true;
			}

	/* if(accessRight || usergroup.getUserId()==themeDisplay.getUserId()){ */
%>
<section <%=LiferayWindowState.isPopUp(request)?"ng-app='"+Constant.PORTLET_PROP_ONLY_VENDOR_NAME+"'":""%> >
	<div id="myStuff" class="clearfix"> 	 
			<div class="row-fluid">
				<h1><%=usergroup.getName()%>
				<%if(!LiferayWindowState.isPopUp(request)){%>
					<span class="pull-right"> 
					<a href="<%=groupHome%>" style="font-size: 16px; text-decoration: none;"> <liferay-ui:message key="groups-home" /> </a>
					<i class="icon-home"></i>
				</span>
				<%}%>
				</h1> 
			</div>
			
			<div id="nyYouTab" class="clearfix">
				<!-- TAB LINKS -->
				<ul class="nav nav-tabs">
					<li class="active">
					<a href="#group"><liferay-ui:message key="group" /></a></li>
					<li><a href="#members"><liferay-ui:message key="members" /></a></li>
					<li id="editor"><a href="#properties"><liferay-ui:message key="properties" /></a></li>
				</ul> 
				
				<!-- END TAB LINKS -->
				<div class="tab-content">
					<div id="group" class="tab-pane"> 
						<div class="row-fluid">
						<%if(usergroup.getUserId()==themeDisplay.getUserId() || hasAdminRights){%>
							<div class="ny-you-message">
								<%@include file="requestedMembers.jsp" %>
							</div> <!-- end ny-you-message -->
						<%}%>
							<%@include file="groupDiscussion.jsp" %>
							
						</div> <!-- end row -->
						<c:if test="${!empty mystuffRedirectUrl}">
						<div class="announcement">
							<h4> <liferay-ui:message key="announcements" /> </h4>
							<button style="margin-bottom: 30px;" class="btn btn-large" id="makeAnnouncement"> <liferay-ui:message key="send-an-announcement-to" /> <%=usergroup.getName()%></button>
						</div> <!-- end announcement -->
						</c:if>
						<hr/>
						<div class="row-fluid"> <h1> <liferay-ui:message key="group-stuff" /> </h1> </div> 				
							
					<%
					if(groupPrivacy){ 
						if(accessRight || usergroup.getUserId()==themeDisplay.getUserId()){%>
							<div class="text-right" style="margin-bottom: 15px;">
								<a href="javascript:void(0);" class="btn btn-primary" onclick="<portlet:namespace/>AddLessons('<%=addLessonUrl%>','Add Lessons')"><liferay-ui:message key="add-remove-lessons" /></a>
								<%-- <a class=" btn btn-primary" style="margin-left:10px;" href="<%=createLessonUrl%>">Create Lesson</a> --%>
							</div>	
							<%@ include file="groupLessonResults.jsp" %>
						<%}else{%>
							<p> <b class="text-info"><liferay-ui:message key="you-don't-have-permission-to-view-lesson" /></b> </p>
						<%}
					}else{%>
						<div class="text-right"  style="margin-bottom: 15px;">
							<a href="javascript:void(0);" class="btn btn-primary" onclick="<portlet:namespace/>AddLessons('<%=addLessonUrl%>','Add Lessons')"><liferay-ui:message key="add-remove-lessons" /></a>
							<%-- <a class=" btn btn-primary" style="margin-left:10px;" href="<%=createLessonUrl%>">Create Lesson</a> --%>
						</div>
						<%@ include file="groupLessonResults.jsp" %>
					
					<%}%>	
						 
					</div> <!-- end group -->
					<div aria-labelledby="tab_2" class="tab-pane active" id="members" role="tabpanel">
					<c:if test="${empty members}">
	 
							<p> <b class="text-info"><liferay-ui:message key="no-members-found" />.</b> </p> 
					</c:if>
					<%@ include file="invitation.jsp" %>
					<%@ include file="members.jsp" %>
					</div>
					
					
					
					
					<div id="properties" class="tab-pane"> 
					<%@ include file="editGroup.jsp" %>
					
					 </div>
					
				</div> <!-- end tab-content -->
			</div>
			
	</div> <!-- end row-fluid -->
	<%@include file="groupAnnoumcementForm.jsp"%>

</section> <!-- end section -->
<%@include file="/WEB-INF/jsp/common/categoriesSelector.jsp"%>
<%@include file="/WEB-INF/jsp/common/tagsSelector.jsp"%>

<%-- <%}else{%>
<p> <b class="text-info">You don't have Permission to View Lesson</b> </p>
<%}%> --%>



<script>

function subscriber(groupId,groupPrivacy,isOwner)
{
	var subscriberURL = "<%=subscriberURL%>";
	var subsData=$("#group-"+groupId).data('sub');
	$.ajax({
        url:subscriberURL,
        type: 'GET',
        datatype:'html',
        data:{
        	<portlet:namespace/>groupId:groupId,
        	<portlet:namespace/>subsData:subsData
        },
        success: function(data){
        	if(subsData.indexOf('requestJoin')>=0)
	        	{
        		$("#group-"+groupId).html("Unrequest");
        		$("#group-"+groupId).removeClass('btn-info');
        		$("#group-"+groupId).addClass('btn-primary');
        		$("#group-"+groupId).data('sub','unrequest');
	        	}
        	else if(subsData.indexOf('unrequest')>=0)
	        	{
        		$("#group-"+groupId).html("Request to join");
        		$("#group-"+groupId).removeClass('btn-primary');
        		$("#group-"+groupId).addClass('btn-info');
        		$("#group-"+groupId).data('sub','requestJoin');
	        	}
        	else if(subsData.indexOf('unsubscribe')>=0)
        		{
        		if(groupPrivacy.indexOf('true')>=0 && (!(isOwner.indexOf('true')>=0))){
        			$("#group-"+groupId).html('<liferay-ui:message key="request-to-join" />');
            		$("#group-"+groupId).removeClass('btn-primary');
            		$("#group-"+groupId).addClass('btn-info');
            		$("#group-"+groupId).data('sub','requestJoin');
        		}else{
	        		$("#group-"+groupId).html("Join");
					$("#group-"+groupId).addClass('btn-warning');
					$("#group-"+groupId).data('sub','subscribe');
        		}
        		}
        	else{
        		
	        		$("#group-"+groupId).html("Leave");
	        		$("#group-"+groupId).removeClass('btn-warning');
	        		$("#group-"+groupId).data('sub','unsubscribe');
	        	}
         }
        
      });
		
}
	
	$('#appreciate').click(function(event) {
		$.ajax({
		  	url: "<%=appreciateURL%>",
		  	data: { 
		  		"<portlet:namespace />userGroupId": '${usergroup.userGroupId}',
		  		 }
		})
	  	.done(function( msg ) {
	  		$('#appreciatedCount').text(msg);
	    	$("#appreciate-success-msg span").text('<liferay-ui:message key="thank-you-for-your-appreciation" />');
	    	$("#appreciate-success-msg").show().delay( 2000 ).hide(0);;
	  	});
	});	
	
	
	function acceptUsertoGroup(id,groupId,userId)
	{
		var subscriberURL = "<%=acceptGroupURL%>";
		$.ajax({
	        url:subscriberURL,
	        type: 'GET',
	        datatype:'html',
	        data:{
	        	<portlet:namespace/>groupId:groupId,
	        	<portlet:namespace/>userId:userId
	        },
	        success: function(data){
	        	$(id).parent().parent().remove();
	    	}
	        
	      });
			
	}
	
	function declineUsertoGroup(id,groupId,userId)
	{
		var declineGroupURL ="<%=declineGroupURL%>";
		$.ajax({
	        url:declineGroupURL,
	        type: 'GET',
	        datatype:'html',
	        data:{
	        	<portlet:namespace/>groupId:groupId,
	        	<portlet:namespace/>userId:userId
	        },
	        success: function(data){
	        	$(id).parent().parent().remove();
	    	}
	        
	      });
			
	}
	
	
	
	function <portlet:namespace/>AddLessons(url, windowTitle) {
		Liferay.Util.openWindow({
			dialog : {
				width : 450,
				height: 570,
				align : Liferay.Util.Window.ALIGN_CENTER,
				cache : false,
				modal : true,
				resizable: false
			},

			title : windowTitle,
			id : 'AddLessons',
			uri : url
		});

	}
	
	Liferay.provide(window,
		    '<portlet:namespace/>closeAddLessonPopup',
		        function(popupIdToClose,withSuccessMsg) {
		            var popupDialog = Liferay.Util.Window.getById(popupIdToClose);
		            if(popupDialog==null){
		            	Liferay.Util.getOpener()._group_WAR_nyyouportlet_closeAddLessonPopup('AddLessons',true);
		            }else{
		            	popupDialog.destroy();	
		            }
		            if(withSuccessMsg != null && withSuccessMsg == 'yes'){
		            	AUI().use(
		                  		'aui-modal',
		                  		function(Y) {
		                  			var modal = new Y.Modal(
		                  			{
		                  				bodyContent: '<p><b><liferay-ui:message key="group-lessons-added-removed-successfully" /></b></p>',
		                  				centered: true,
		                  				modal: true,
		                  				width: 350,
		                  				zIndex: 999,
		                  				resizable: false,
		                  				toolbars: {
		                  					footer: [
		                  					{
		                  						label: '<liferay-ui:message key="ok" />',
		                  						on: {
		                  							click: function() {
		                  								modal.hide();
		                  								window.location.href='<%=PortalUtil.getAbsoluteURL(request,PortalUtil.getCurrentURL(request))%>';
		                  							}
		                  						}
		                  					}
		                  					]
		                  				}
		                  			}
		                  		).render();
		                  }); 
		            }
		            else{
		            	window.location.href='<%=PortalUtil.getAbsoluteURL(request,PortalUtil.getCurrentURL(request))%>';
		            }
		        },
		        ['liferay-util-window']
		    );
	
	$(document).ready(function(){
		var e = $('#lessonsController');
		scope = angular.element(e).scope();
		scope.$apply(function() {
			scope.lessons=<%=request.getAttribute("jsonLessons")%>;
			scope.load();
		});
	});
	
	
</script>
<script>
	 function deleteGroup(deleteUrl){
			AUI().use(
			  		'aui-modal',
			  		function(Y) {
			  			var modal = new Y.Modal(
			  			{
			  				bodyContent: '<p> <Strong><liferay-ui:message key="are-you-sure-you-want-to-remove-this-group" /></Strong></p>', centered: true,
			  				headerContent: null, 
			  				modal: true,
			  				width: 350,
			  				zIndex: 999,
			  				resizable: false,
			  				toolbars: {
			  					footer: [
			  					{
			  						label: '<liferay-ui:message key="yes" />',
			  						on: {
			  							click: function() {
			  								$.ajax({
			  									url: deleteUrl,
			  									dataType: 'html',
			  									processData: false,
			  									contentType: false,
			  									type: 'POST',
			  									success: function(data){
			  										modal.hide();
			  										<%if(!LiferayWindowState.isPopUp(request)){%>
			  											window.location.href="<%=groupHome%>";
			  										<%}else{%>
			  										Liferay.Util.getOpener().closeManageGroupForDelete('userGroupPopupId');
			  										<%}%>
			  									}
			  								});
			  							}
			  					}
			  					},
			  					{
			  						label: '<liferay-ui:message key="cancel" />',
			  						on: {
			  							click: function() {
			  								modal.hide();
			  							}
			  						}
			  					}
			  					]
			  				}
			  			}
			  		).render();
			  	 });
		};
	 $('#editor').on('click',function(){
		 var selectedCateItems = '';
		 var selectedIds = $("#<portlet:namespace/>categoriesSelectedIds").val();
		 var categoryIds =selectedIds.split(",");
		$('#<portlet:namespace/>categoriesContent .categoryIsSelected').each(function(i){
			if(categoryIds.indexOf($(this).val()) > -1){
				selectedCateItems = selectedCateItems + "<li class='textboxlistentry'>"+$(this).attr('name')+"</li>";
			}
		});
		$("#<portlet:namespace/>categoriesItems").empty();
		$("#<portlet:namespace/>categoriesItems").html(selectedCateItems);
		
		var selectedTagItems = '';
		 var selectedNames = $("#<portlet:namespace/>tagsSelectedNames").val();
		 var tagNames =selectedNames.split(",");
		$('#<portlet:namespace/>tagsContent .tagsIsSelected').each(function(i){
			if(tagNames.indexOf($(this).attr('name')) > -1){
				selectedTagItems = selectedTagItems + "<li class='textboxlistentry'>"+$(this).attr('name')+"</li>";
			}
		});
		$("#<portlet:namespace/>tagsItems").empty();
		$("#<portlet:namespace/>tagsItems").html(selectedTagItems);
	 })
		 
</script>