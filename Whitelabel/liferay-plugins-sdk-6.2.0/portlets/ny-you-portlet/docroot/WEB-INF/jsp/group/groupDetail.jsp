<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="javax.portlet.PortletMode"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="com.nyu.NoSuchNYUUserGroupException"%>
<%@page import="com.nyu.service.NYUUserGroupLocalServiceUtil"%>
<%@page import="com.nyu.model.NYUUserGroup"%>
<%@page import="com.nyu.service.UserGroupRequestLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.nyu.model.UserGroupRequest"%>
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
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>			<%--	added by asif 	 --%>

<script type="text/javascript"
	src="<%=themeDisplay.getPathThemeJavaScript()%>/jquery/libs/Stylish-Select-Box/fancySelect.js"></script>

<portlet:resourceURL var='subscriberURL' id='subscriber' />
<portlet:resourceURL var='acceptGroupURL' id='acceptUsertoGroup' />
<portlet:resourceURL id="appreciate" var="appreciateURL" />

<portlet:renderURL var="addLessonUrl" windowState="pop_up">
	<portlet:param name="action" value="addLessons" />
	<portlet:param name="userGroupId" value="${usergroup.userGroupId}" />
</portlet:renderURL>

<portlet:renderURL var="groupHome" windowState="normal"/>

<script>AUI().use('aui-tabview',function(Y) {new Y.TabView({srcNode: '#learnTab'}).render();});</script>


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
<c:set var="userGroupId" value="${usergroup.userGroupId}" scope="page" />
<c:set var="groupId" value="${usergroup.groupId}" scope="page" />

<%

String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),
		layout.isPrivateLayout(),themeDisplay);

String groupsUrl=siteFriendlyUrl+Constant.PAGE_GROUP;
String portletId = Constant.PORTLET_CREATE_LESSON;
Long userGroupId = GetterUtil.getLong(pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID));
List<UserGroup> usergroups=themeDisplay.getUser().getUserGroups();
List<Long> usergroupids= new ArrayList<Long>();

for(UserGroup usergroup:usergroups){
	usergroupids.add(usergroup.getUserGroupId());
}

PortletURL  userGrouoURL = PortletURLFactoryUtil.create(request, Constant.PORTLET_USERGROUP, layout.getPlid(), "RENDER_PHASE");
userGrouoURL.setWindowState(LiferayWindowState.POP_UP);
userGrouoURL.setPortletMode(PortletMode.VIEW);
userGrouoURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, "groupUrl");
userGrouoURL.setParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,userGroupId+"");
%>
<portlet:renderURL var="discussion" windowState="maximized">
	<portlet:param name="action" value="discussionUrl" />
	<portlet:param name="userGroupId" value="${userGroupId}"/>
</portlet:renderURL>

<%


Long groupId = GetterUtil.getLong(pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_GROUP_ID));
int membersSize=UserLocalServiceUtil.getUserGroupUsers(userGroupId).size();
UserGroup usergroup=UserGroupLocalServiceUtil.getUserGroup(userGroupId);
List<User>members=UserLocalServiceUtil.getUserGroupUsers(userGroupId);
request.setAttribute("members", members);

User author = CommonUtil.getAuthor(usergroup.getUserId());

long lesson_targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true, Constant.PAGE_CREATE_LESSON).getPlid();		
PortletURL createLessonUrl=PortletURLFactoryUtil.create(renderRequest, portletId, lesson_targetPlId, PortletRequest.RENDER_PHASE);
/* createLessonUrl.setParameter("action","createGroupLesson"); */
createLessonUrl.setParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,userGroupId.toString());

String request_portlet_Id = Constant.PORTLET_REQUEST_LESSON;
long request_targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), true, Constant.PAGE_REQUEST_LESSON).getPlid();		
PortletURL createRequestUrl=PortletURLFactoryUtil.create(request,request_portlet_Id , request_targetPlId, PortletRequest.RENDER_PHASE);
createRequestUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION,"createGroupRequest"); 
createRequestUrl.setParameter(Constant.COMMON_STRING_CONSTANT_GROUP_ID,userGroupId.toString());
	

int viewCountgroup =GetterUtil.getInteger(usergroup.getExpandoBridge().getAttribute("view-count").toString());
viewCountgroup=viewCountgroup+1;
usergroup.getExpandoBridge().setAttribute("view-count",viewCountgroup);			
UserGroupLocalServiceUtil.updateUserGroup(usergroup);


boolean hasAppreciated = false;
long appreciatedCountGroup = 0;

String appreciatedUserIds =StringPool.BLANK;
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
String groupAbout=StringPool.BLANK;
List<String> adminIDs = new ArrayList<String>();
boolean hasAdminRights=false;
try{
	NYUUserGroup nyuUG=NYUUserGroupLocalServiceUtil.getNYUUserGroup(usergroup.getUserGroupId());
	groupAbout=nyuUG.getAbout();
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
	
}

List<String> items = new ArrayList<String>();

if (!appreciatedUserIds.isEmpty()) {
	items = Arrays.asList(appreciatedUserIds.split(","));
	hasAppreciated = items.contains(themeDisplay.getUserId()+"");
	appreciatedCountGroup = items.size();
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
String label = LanguageUtil.get(pageContext, "join");						//"<liferay-ui:message key='join' />";
String classes=Constant.BTN_BTN_WARNING;		
boolean accessRight=false;
boolean isNyuAdmin=false;
long currentTime = System.currentTimeMillis();
request.setAttribute("requestedMembers", requestedUsers);	
if(groupPrivacy && usergroup.getUserId()!=user.getUserId() && !isRequestedUser)
{
	label = LanguageUtil.get(pageContext, "request-to-join");				//"<liferay-ui:message key='request-to-join' />";
	dataSub="requestJoin";
	classes="btn btn-info";
}
else if(groupPrivacy && usergroup.getUserId()!=user.getUserId() && isRequestedUser)
{
	label = LanguageUtil.get(pageContext, "unrequest");				//"<liferay-ui:message key='unrequest' />";
	dataSub="unrequest";
	classes="btn btn-primary";
}

if(usergroupids.contains(userGroupId))
{
	label = LanguageUtil.get(pageContext, "leave");				//"<liferay-ui:message key='leave' />";
	dataSub=Constant.UN_SUBSCRIBE;
	classes="btn";
	accessRight=true;
}	
String logo=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.GROUP_CARD_PLACEHOLDER;
LayoutSet publicLS=LayoutSetLocalServiceUtil.getLayoutSet(groupId, false);
if(publicLS.getLogo())
{
	logo=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+publicLS.getLogoId();
	logo=logo+"&t="+currentTime;
}
LayoutSet privateLS=LayoutSetLocalServiceUtil.getLayoutSet(groupId, true);
if(privateLS.getLogo())
{
	logo=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+privateLS.getLogoId();
	logo=logo+"&t="+currentTime;
}
if(request.isUserInRole(Constant.PORTAL_ADMIN_ROLE)){
	isNyuAdmin = true;
	accessRight = true;
}
request.setAttribute("isUserMemberOfGroup", accessRight);
%>
<c:set var="isDiscussionAdmin" value="<%=usergroup.getUserId()==themeDisplay.getUserId() || (accessRight && hasAdminRights) || isNyuAdmin%>" />
<section >
	<div class="row-fluid">
		<div class="well clearfix group-banner">
			<div class="span3">
				<img src="<%=logo%>" style="width: 100%; height: 173px"/>
			</div>
			
			<div class="span6 group-content">
			    
				<h1> ${usergroup.name} 
					<%if(groupAbout != null && groupAbout.trim().length() > 0){%>
						<a href="javascript:void(0)" style="text-decoration: none;font-size: 15px">
							<span class="nyu-tooltip" title="<%=groupAbout%>">
								<liferay-ui:message key="about" />
							</span>
						</a>
					<%}%>
					<span class="pull-right" >
					<%if(groupPrivacyValue.equals(Constant.GROUP_PRIVACY_PRIVATE)){%>
					<img width="22px" src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>lock-icon.png"
								style="width: 28px; margin: 0px 32%;">
					<p style="font-size: 12px;width:100px;text-align: center;"><liferay-ui:message key="member-only" /></p>
					<%}else if(groupPrivacyValue.equals(Constant.GROUP_PRIVACY_COLLABORATOR)){%>
						<img width="22px" src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>lock-icon.png"
								style="width: 28px; margin: 0px 32%;">
					<p style="font-size: 12px;width:100px;text-align: center;"><liferay-ui:message  key="collaboratory" /></p>
					<%}else{%>
						<img width="22px" src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-group.png"
								style="width: 31px; margin: 0px 34%;">
					<p style="font-size: 12px;width:100px;text-align: center;"><liferay-ui:message key="open" /></p>
					<%}%>
					</span>
				</h1>
				<p> ${usergroup.description}</p>
				<footer>
					<div style="display:none;" id="appreciate-success-msg" class="span12">
						<span class="pull-right alert alert-success pull-rigth"></span>
					</div>
					<div class="infos clearfix">
						<div class="pull-left">
						<%
							String userName = author.getFirstName() + StringPool.SPACE+ author.getLastName();
							String userPic = author.getPortraitURL(themeDisplay);
							if(CommonUtil.isAnonymous(author)){
								userName = Constant.ANONYMOUS_NAME;
								userPic = Constant.ANONYMOUS_PIC;
							}
						%>
							<img class="img-circle small-img" style="width:38px;height:44px" src="<%=userPic%>"> 
							<span> <%=usergroup.getUserId()==themeDisplay.getUserId()?"<liferay-ui:message key='you-are-the-owner' />":userName%></span>
							<%if(usergroup.getUserId()==themeDisplay.getUserId() || (accessRight && hasAdminRights) || isNyuAdmin){%>
								<span> <a href="javascript:void(0)" class="btn" onclick="userGroupPopup('<%=userGrouoURL%>')"> <liferay-ui:message key="manage-group" /> </a> </span>
							<%}%>
							 &nbsp; &nbsp;
						</div>
						<div class="likes pull-left" style="line-height: 44px;"><span class="icon-thumbs-up" aria-hidden='true'></span>&nbsp;<span id="appreciatedCount"><%=appreciatedCountGroup%></span><span class='sr-only'><liferay-ui:message key="likes" /></span></div>
						<%-- <div class="views pull-left"><span class="icon-eye-open" aria-hidden='true'></span>&nbsp;<%=viewCountgroup%><span class='sr-only'>views</span></div> --%>
						<div class="group"
							style="display: inline-block; margin-left: 25px;line-height: 44px;">
							<img width="22px" src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyGroups.png"
								style="width: 22px;"> &nbsp;<%=membersSize%><span
								class="sr-only"><liferay-ui:message key="members" /></span>
						</div>
						
						<%-- <%if(usergroup.getUserId() == themeDisplay.getUserId()){%>	
							
								
								
							<div class="pull-right">
									<%
										PortletURL deleteGroupURL = renderResponse.createRenderURL();
										deleteGroupURL.setParameter("action","deleteGroup");
										deleteGroupURL.setParameter("userGroupId", userGroupId.toString());	
										deleteGroupURL.setWindowState(LiferayWindowState.EXCLUSIVE);
										
										PortletURL editGroupURL = renderResponse.createRenderURL();
										editGroupURL.setParameter("action", Constant.USER_GROUP_EDIT_GROUP_JSP);
										editGroupURL.setParameter("userGroupId", userGroupId.toString());
										editGroupURL.setWindowState(LiferayWindowState.POP_UP);
									
									
									%>
										<button style="margin-right:10px;" type="button" title='Edit' 
												class="btn btn-default white"
												onclick="createEditGroup('<%=editGroupURL%>', 'Edit Group');">
											<span class="icon-pen white vertical-align"></span>
										</button>
										
										<button type="button" title="Delete"
											class="btn btn-default white"
											onclick="deleteGroup('<%=deleteGroupURL%>');">
											<span class="icon-pen trash vertical-align "></span>
										</button>
											
							</div>
						<%} %> --%> 
					</div>	
				</footer> <!-- end footer  -->
			</div>  <!-- end span6 --> 
			<div class="span2 offset1 custom-fancy-select">
				<%if(usergroup.getUserId()==themeDisplay.getUserId() || (accessRight && hasAdminRights) ||  isNyuAdmin){%>
				<div class="group-btn-controll">
					<select id="createNew">
						<option value=""><liferay-ui:message key="Create New" /></option>
						<option value="lesson"><liferay-ui:message key="lesson" /></option>
						<option value="request"><liferay-ui:message key="request" /></option>
						<option value="discussion"><liferay-ui:message key="discussion" /></option>
					</select>
				</div>
				<%}else{ %>  
				<div class="group-btn-controll">
					<button id="group-${usergroup.userGroupId}" onclick="subscriber('${usergroup.userGroupId}','<%=groupPrivacy%>','<%=usergroup.getUserId()==user.getUserId()%>')" class="<%=classes%>  btn-block btn-large" data-sub="<%=dataSub%>"><%=label%></button>
					<button id="appreciate" type="button"  class="btn btn-default btn-block btn-large" <%= hasAppreciated ? "disabled":""  %> onclick='document.getElementById("appreciate").disabled="disabled"'> <span class="icon-thumbs-up" aria-hidden='true'></span>&nbsp;&nbsp;<liferay-ui:message key="appreciate" /> </button>
				</div>
				<%} %>
				 
			</div> <!--  end span3 -->
		</div> <!--  end well --> 		
	</div> <!--  end row --> 
	
<%-- <div id="nyYouTab">
	<div id="learnTab" class="user-group-lessons">
		<ul class="nav nav-tabs" role="tablist">
			
			<li class="active" role="presentation">
				<a aria-controls="tabpanel_2" aria-selected="true" data-toggle="tab" href="#lessons" id="tab_1" role="tab">Lessons</a>
			</li>
			
			
			<li role="presentation">
			   <a aria-controls="tabpanel_2" aria-selected="false" data-toggle="tab" href="#members" id="tab_2" role="tab">Members</a>
			</li>
			<% if(usergroup.getUserId()==themeDisplay.getUserId() && groupPrivacy){%>
			<li role="presentation">
			   <a aria-controls="tabpanel_2" aria-selected="false" data-toggle="tab" href="#requestedMember" id="tab_3" role="tab">Membership Requests</a>
			</li>
			<%} %>
			<li role="presentation">
			   <a aria-controls="tabpanel_2" aria-selected="false" data-toggle="tab" href="#discussion" id="tab_4" role="tab">Discussion</a>
			</li>				
			
			<li role="presentation">
				<a aria-controls="tabpanel_2" aria-selected="false" data-toggle="tab" href="#about" id="tab_5" role="tab">About</a>
			</li>	
			
		</ul>
		<div class="tab-content">				
				<div aria-labelledby="tab_1" class="tab-pane active " id="lessons" role="tabpanel">
					<%
					if(groupPrivacy){ 
						if(accessRight || usergroup.getUserId()==themeDisplay.getUserId()){%>
							<div class="text-right" style="margin-bottom: 15px;">
								<a href="javascript:void(0);" class="btn btn-primary" onclick="<portlet:namespace/>AddLessons('<%=addLessonUrl%>','Add Lessons')">Add/Remove Lessons</a>
								<a class=" btn btn-primary" style="margin-left:10px;" href="<%=createLessonUrl%>">Create Lesson</a>
							</div>	
							<%@ include file="groupLessonResults.jsp" %>
						<%}else{%>
							<p> <b class="text-info">You don't have Permission to View Lesson</b> </p>
						<%}
					}else{%>
						<div class="text-right"  style="margin-bottom: 15px;">
							<a href="javascript:void(0);" class="btn btn-primary" onclick="<portlet:namespace/>AddLessons('<%=addLessonUrl%>','Add Lessons')">Add/Remove Lessons</a>
							<a class=" btn btn-primary" style="margin-left:10px;" href="<%=createLessonUrl%>">Create Lesson</a>
						</div>
						<%@ include file="groupLessonResults.jsp" %>
					
					<%}%>	
				</div>
				<div aria-labelledby="tab_2" class="tab-pane active" id="members" role="tabpanel">
					<c:if test="${empty members}">
	 
							<p> <b class="text-info">No members found.</b> </p> 
					</c:if>
					
					<%@ include file="members.jsp" %>
				</div>
				<%if(usergroup.getUserId()==themeDisplay.getUserId() && groupPrivacy){%>
				<div aria-labelledby="tab_3" class="tab-pane active" id="requestedMember" role="tabpanel">
					<c:if test="${empty requestedMembers}">
	 						<p> <b class="text-info">No Membership Requests Found</b> </p> 
					</c:if>
					<%@ include file="requestedMembers.jsp" %>
				</div>
				<%} %>

				<div aria-labelledby="tab_4" class="tab-pane active" id="discussion" role="tabpanel">
					<div style="overflow-x:hidden;overflow-y:auto;;max-height:250px">
						<%@ include file="groupDiscussion.jsp" %>
					</div>
				</div>
		
				<div aria-labelledby="tab_5" class="tab-pane active" id="about" role="tabpanel">
					Work In Progress
				</div>
		
		</div>
	</div> <!--  end learnTab -->
</div> <!-- end nyYouTab -->
</section> --%>


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
        		$("#group-"+groupId).html('<liferay-ui:message key="unrequest" />');
        		$("#group-"+groupId).removeClass('btn-info');
        		$("#group-"+groupId).addClass('btn-primary');
        		$("#group-"+groupId).data('sub','unrequest');
	        	}
        	else if(subsData.indexOf('unrequest')>=0)
	        	{
        		$("#group-"+groupId).html('<liferay-ui:message key="request-to-join" />');
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
            		$("#group-"+groupId).data('sub','requestjoin');
        		}else{
	        		$("#group-"+groupId).html('<liferay-ui:message key="join" />');
					$("#group-"+groupId).addClass('btn-warning');
					$("#group-"+groupId).data('sub','subscribe');
        		}
        		}
        	else{
        		
	        		$("#group-"+groupId).html('<liferay-ui:message key="leave" />');
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
	
	
	function acceptUsertoGroup(groupId,userId)
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
	        	$("#btn-"+userId).html('<liferay-ui:message key="accepted" />');
	    		$("#btn-"+userId).addClass('btn-info');
	    	}
	        
	      });
			
	}
	
	function <portlet:namespace/>AddLessons(url, windowTitle) {
		Liferay.Util.openWindow({
			dialog : {
				width : 500,
				height:520,
				align : Liferay.Util.Window.ALIGN_CENTER,
				cache : false,
				modal : true
			},

			title : windowTitle,
			id : 'AddLessons',
			uri : url
		});

	}
	
	Liferay.provide(window,
		    '<portlet:namespace/>closeAddLessonPopup',
		        function(popupIdToClose,fromPopup,withSuccessMsg) {
		            var popupDialog = Liferay.Util.Window.getById(popupIdToClose);
		            var frompop=fromPopup;
		            popupDialog.destroy();
		            if(withSuccessMsg != null && withSuccessMsg == 'yes'){
		            	closePopupForAllWithSuccessMsg('<liferay-ui:message key="group-lessons-added-removed-successfully" />');
		            }
		            if(!frompop)
		            	window.location.href='<%=PortalUtil.getAbsoluteURL(request,PortalUtil.getCurrentURL(request))%>';
		        },
		        ['liferay-util-window']
		    );
	
	
	
	function userGroupPopup(url) {
		 Liferay.Util.openWindow(
				{
	                dialog: {
                       width: 1000,
                       height:"auto",
                       align: Liferay.Util.Window.ALIGN_CENTER,
                       cache: false,
                       modal: true
	                },
	                title:'<h1 style="margin:0; line-height: normal;"><b><liferay-ui:message key="manage-group" /></b></h1>',
                   id: 'userGroupPopupId',                                                      
                   uri: url
  				}
           );
       }
	
	$(document).ready(function() {
        $('#createNew').fancySelect().on('change', function() { 
                 if($(this).val().indexOf('lesson')>=0){
                	 window.location.href='<%=createLessonUrl%>';
                 }else if($(this).val().indexOf('discussion')>=0){
                	 window.location.href='<%=discussion%>';
                 }else if($(this).val().indexOf('request')>=0){
                	 window.location.href='<%=createRequestUrl%>';
                 }
        });
	});
	
	var groupsUrl = '<%=groupsUrl%>';
	
	Liferay.provide(window,
		    'closeManageGroup',
		        function(popupIdToClose) {
		            var popupDialog = Liferay.Util.Window.getById(popupIdToClose);
		            popupDialog.hide();
		        },
		        ['liferay-util-window']
		    );
	
	Liferay.provide(window,
		    'closeManageGroupForDelete',
		        function(popupIdToClose) {
		            var popupDialog = Liferay.Util.Window.getById(popupIdToClose);
		            popupDialog.hide();
		            window.location.href=groupsUrl;
		        },
		        ['liferay-util-window']
		    );
	
	$( window ).load(function() {
		var i='${afterCreate}';
		if(i.trim().length >1){
			userGroupPopup('<%=userGrouoURL%>');
		}
	});

	
</script>