<%@page import="javax.portlet.ResourceURL"%>
<%@page import="com.liferay.portal.model.Portlet"%>
<%@page import="com.liferay.portal.service.PortletLocalServiceUtil"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.liferay.portal.kernel.util.Base64"%>
<%@page import="com.liferay.portlet.social.model.SocialActivityFeedEntry"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.nyu.util.PageUtil"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page	import="com.liferay.portlet.documentlibrary.service.DLFileEntryLocalServiceUtil"%>
<%@page import="com.liferay.portlet.documentlibrary.model.DLFileEntry"%>
<%@page	import="com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil"%>
<%@page	import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil, com.liferay.portlet.social.service.SocialActivityLocalServiceUtil"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="com.nyu.service.DocumentFileLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.model.AssetEntry"%>
<%@ include file="/WEB-INF/jsp/init.jsp"%>
<%@page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil"%>
<%@page import="com.nyu.service.LessonLocalServiceUtil, com.liferay.portlet.asset.model.AssetCategory"%>
<%@page import="com.liferay.portlet.social.model.SocialRelationConstants, com.liferay.portlet.social.service.SocialRelationLocalServiceUtil" %>
<%@page import="com.nyu.model.Lesson"%>
<%@page import="com.nyu.model.DocumentFile"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.liferay.portlet.social.model.SocialActivity"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>


<c:if test="${fn:contains(lessonThumbnail,'<%= Constant.PORTLET_PROP_PORTLET_THEME %>')}">
	<meta property="og:image" content="https://<%=PortalUtil.getHost(request)%>${lessonThumbnail}" />
</c:if>
<c:if test="${!(fn:contains(lessonThumbnail,'<%= Constant.PORTLET_PROP_PORTLET_THEME %>'))}">
	<meta property="og:image" content="${lessonThumbnail}" />
</c:if>
<meta property="og:title" content="${lessonName}"/>
<meta property="og:description" content="${lessonDescription}" />



<c:set var="lessonId">${lessonId}</c:set>
<%long editLessonPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_CREATE_LESSON).getPlid();%>
<liferay-portlet:renderURL portletName="<%=Constant.PORTLET_CREATE_LESSON%>" plid="<%=editLessonPlId%>" var="redirectToEditPageUrl">
	<liferay-portlet:param name="action" value="editLesson" />
	<liferay-portlet:param name="lessonId" value="${lessonId}"/>
</liferay-portlet:renderURL>
<%
boolean userPermissionToAccess =GetterUtil.getBoolean(request.getAttribute(Constant.USER_PERMISSION_TO_ACCESS));
boolean isRedirectToEditPage =GetterUtil.getBoolean(request.getAttribute("isRedirectToEditPage"));
if(userPermissionToAccess && !isRedirectToEditPage){

Lesson lesson = (Lesson) request.getAttribute(Constant.LESSON);
String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),layout.isPrivateLayout(),themeDisplay);
String browseUrl=siteFriendlyUrl+Constant.PAGE_LESSON_BROWSE;
String homeUrl=siteFriendlyUrl+Constant.PAGE_HOME;
String requestLessonUrl=siteFriendlyUrl+Constant.PAGE_REQUEST_LESSON;
Date uploadTime = lesson.getUploadedTime();

%>

<%

String rlPortletId = Constant.PORTLET_REQUEST_LESSON;
long rlTargetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_REQUEST_LESSON).getPlid();
PortletURL showRequestLessonURL = PortletURLFactoryUtil.create(renderRequest, rlPortletId, rlTargetPlId, PortletRequest.RENDER_PHASE);
showRequestLessonURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);
showRequestLessonURL.setWindowState(WindowState.MAXIMIZED);
showRequestLessonURL.setParameter("requestLessonTitle", Constant.COMMON_REQUEST_LESSON);
String rlPortletNamespace = StringPool.UNDERLINE + rlPortletId + StringPool.UNDERLINE;
	
%>

<%-- <portlet:resourceURL id="appreciate" var="appreciateURL">
</portlet:resourceURL> --%>

<portlet:resourceURL id="appreciateLesson" var="appreciateLessonURL"/>
<portlet:resourceURL id="unAppreciateLesson" var="unAppreciateLessonURL"/>


<portlet:renderURL var="editLessonURL">
	<portlet:param name="action" value="editLesson" />
</portlet:renderURL>

<portlet:actionURL var="followUserURL" >
	<portlet:param name="type" value="<%= String.valueOf(SocialRelationConstants.TYPE_UNI_FOLLOWER) %>" />
	<portlet:param name="action" value="followUser" />
</portlet:actionURL>

<portlet:actionURL var="unFollowUserURL" >
	<portlet:param name="type" value="<%= String.valueOf(SocialRelationConstants.TYPE_UNI_FOLLOWER) %>" />
	<portlet:param name="action" value="unFollowUser" />
</portlet:actionURL>

<portlet:actionURL var="addLessonToPlaylistURL">
	<portlet:param name="action" value="addLessonToPlaylist" />
	<portlet:param name="lessonId" value="${lessonId}" />
</portlet:actionURL>
<portlet:renderURL var="showAuthorLessonURL" windowState="<%= WindowState.MAXIMIZED.toString() %>">
	<portlet:param name="action" value="authorLessons" />
</portlet:renderURL>

<portlet:renderURL var="showEmailURL" windowState="pop_up">
	<portlet:param name="action" value="email" />
	<portlet:param name="emailLessonId" value="${lessonId}" />
	<portlet:param name="subject" value='<%=lesson.getLessonName()+" - Lesson" %>' />
</portlet:renderURL>



<%


	boolean showFollowButton = false;
	boolean showUnFollowButton = false;
	
	String documentPath = "";
	long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
	
	DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(DLFileEntry.class);
	dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID,lessonClassNameId));
	dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_PK,lesson.getLessonId()));
	List<DLFileEntry> dlFileEntries = DLFileEntryLocalServiceUtil.dynamicQuery(dynamicQuery);
	if (dlFileEntries != null && dlFileEntries.size() > 0) {
		documentPath = themeDisplay.getPortalURL()
		+ themeDisplay.getPathContext() + "/documents/"
		+ dlFileEntries.get(0).getGroupId() + StringPool.SLASH
		+ dlFileEntries.get(0).getUuid();
	}

	String portletId = portletDisplay.getId();
	long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), "/create-playlist").getPlid();
	PortletURL showLessonURL = PortletURLFactoryUtil.create(renderRequest, portletId, targetPlId, PortletRequest.RENDER_PHASE);
	showLessonURL.setParameter("lessonsList", String.valueOf(lesson.getLessonId()));
	showLessonURL.setWindowState(WindowState.MAXIMIZED);
	String portletNamespace = portletDisplay.getNamespace();
	
	String embedurl=PortalUtil.getPortalURL(request)+"/widget"+"/web";
	embedurl += themeDisplay.getScopeGroup().getFriendlyURL()+"/lesson/-/"+Constant.PORTLET_VIEW_LESSON+"?_"+Constant.PORTLET_VIEW_LESSON+"_lessonId="+lesson.getLessonId();
	
	
	
	String facebookEmbedUrl=PortalUtil.getPortalURL(request)+"/web";
	facebookEmbedUrl += themeDisplay.getScopeGroup().getFriendlyURL()+Constant.PAGE_HOME+"/-/homepage"+Constant.PAGE_LESSON_BROWSE+"/"+lesson.getLessonId();
			
	String ShareUrl = URLEncoder.encode(embedurl, Constant.UTF_EIGHT);
	String FBShareUrl = URLEncoder.encode(facebookEmbedUrl, Constant.UTF_EIGHT);

	/* User author = null;
	try {
		author = UserLocalServiceUtil.getUser(lesson.getAuthor());
		request.setAttribute(Constant.AUTHOR, author);
	} catch (Exception e) {
	} */
	
	
	User author = CommonUtil.getAuthor(lesson.getCurrentAuthor());
	request.setAttribute(Constant.AUTHOR, author);

	DocumentFile documentFile = null;
	List<DocumentFile> documentFileList = LessonLocalServiceUtil
	.getDocumentFileList(Long.parseLong((String) pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID)));
	
	for (DocumentFile file : documentFileList) {
		if(file.getResourceType().equalsIgnoreCase(Constant.COMMON_YOUTUBE) || file.getResourceType().equalsIgnoreCase(Constant.EMBED)
			|| (file.getResourceType().equalsIgnoreCase(Constant.COMMON_STRING_CONSTANT_RESOURCE_SPACE_STRING) && (file.getDocumentName().endsWith(Constant.DOT_MP4) 
									|| file.getDocumentName().endsWith(Constant.DOT_ZIP)))){
			documentFile = file;
			request.setAttribute("documentFile", documentFile);
			break;
		}
	}
	long documentId=0l;
	
	if(Validator.isNotNull(request.getAttribute(Constant.DOCUMENT_ID))){
			documentId=(Long)request.getAttribute(Constant.DOCUMENT_ID);
			documentFile = DocumentFileLocalServiceUtil.getDocumentFile(documentId);
			request.setAttribute("documentFile",documentFile);
			
	}
	
	//int viewCount = CommonUtil.getIncrementedViewCount(user.getUserId(), Lesson.class.getName(), lesson.getLessonId());
int viewCount = CommonUtil.getViewCount(Lesson.class.getName(), lesson.getLessonId());
/* if(author.getUserId() != user.getUserId()){ 
	viewCount = CommonUtil.getIncrementedViewCount(user.getUserId(), Lesson.class.getName(), lesson.getLessonId());
}
else{
	viewCount = CommonUtil.getViewCount(Lesson.class.getName(), lesson.getLessonId());
} */

	
		
	
	int appreciatedCount = 0;
	String appreciatedUserIds = lesson.getAppreciatedUserIds();
	List<String> items = new ArrayList<String>();
	if (!appreciatedUserIds.isEmpty()) {
		items = Arrays.asList(appreciatedUserIds.split(","));
		appreciatedCount = items.size();
	}
	
	
	
	ResourceURL deleteLessonURL = renderResponse.createResourceURL();
	deleteLessonURL.setResourceID(Constant.LESSON_DELETED_BY_USER);
	deleteLessonURL.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID, (String) pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID));
	
	if(author!=null){
		
		showFollowButton = SocialRelationLocalServiceUtil.isRelatable(user.getUserId(), author.getUserId(), SocialRelationConstants.TYPE_UNI_FOLLOWER);
		showUnFollowButton = SocialRelationLocalServiceUtil.hasRelation(user.getUserId(), author.getUserId(), SocialRelationConstants.TYPE_UNI_FOLLOWER);
	}
%>
<c:set var="viewCount" value="<%=viewCount%>"/>
<c:set var="appreciatedCount" value="<%=appreciatedCount%>"/>
<c:set var="homeUrl" value="<%=homeUrl%>"></c:set>
<% if(uploadTime != null){ %>
<c:set var="lessonDuration" value="<%=CommonUtil.getDatesDuration(uploadTime.getTime(), 0)%>"/>
<%} %>

<div class="yui3-skin-sam">
  <div id="modal"></div>
</div>

<main role="main" id="inner_pages"> 
	<section class="container" style="padding-top: 10px;">
			<div class="row-fluid">
				<div class="span12">
					<%if(request.getParameter(Constant.LESSON_SUCCESS)!=null){ %>
						<span class="span12 alert alert-success" style="margin-bottom: 0px;"><%=request.getParameter(Constant.LESSON_SUCCESS)%></span>
						<script type="text/javascript">
							$(document).ready(function () {
							    setTimeout(function(){
							        $('.alert').fadeOut(500);
							    }, 3000);
							});	
						</script>
					<%} %>
				</div>
						
			</div>
			<c:set var="FBShareUrl" value="<%=FBShareUrl%>"/>
			<c:set var="ShareUrl" value="<%=ShareUrl%>"/>
			<c:set var="LessonName" value="<%=lesson.getLessonName()%>"/>
			<c:set var="EhowEmailURL" value="<%=showEmailURL%>"/>
			<c:set var="EmbedUrl" value="<%=embedurl %>"/>
			<c:set var="DeleteLessonUrl" value="<%=deleteLessonURL%>"/>
			<c:set var="unAppreciateLessonURL" value="<%=unAppreciateLessonURL.toString()%>"/>
			<c:set var="appreciateLessonURL" value="<%=appreciateLessonURL.toString()%>"/>
			
			<%@ include file="/WEB-INF/jsp/viewlesson/viewLesson.jsp"  %>
			<div class="row-fluid">	
			
			<!-- Comments Section -->
			<div class="span12">
			<% 
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_CLASS_PK, (String) pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID));
			%>
			<%@ include file="/WEB-INF/jsp/lessons/threadDiscussion.jsp" %>
			</div>
				
				
			</div> <!-- .row -->
		</section>
		
		<%@ include file="/WEB-INF/jsp/lessons/showActivities.jsp"  %>
		<div id="ymalike">
			<%@ include file="/WEB-INF/jsp/lessons/youMightAlsoLike.jsp"  %>
		</div>
<aui:script>

$('#followUserId').click(function(event) {
	$.ajax({
	  	url: "<%=followUserURL%>",
	  	data: { 
	  		"<portlet:namespace />followUser": "<%=author.getUserId()%>",
	  		 "<portlet:namespace />userId": "<%=user.getUserId()%>",
	  		}
	})
  	.done(function( msg ) {
	  	$("#followUserId").hide();
	  	$("#unFollowUserId").show();
  		  		
  	});
});

$('#unFollowUserId').click(function(event) {
	$.ajax({
	  	url: "<%=unFollowUserURL%>",
	  	data: { 
	  		"<portlet:namespace />unFollowUser": "<%=author.getUserId()%>",
	  		 "<portlet:namespace />userId": "<%=user.getUserId()%>",
	  		}
	})
  	.done(function( msg ) {
	  	$("#followUserId").show();
	  	$("#unFollowUserId").hide();
  		  		
  	});
});

</aui:script>

<script>

function showSuccessAlert(message){
	
	AUI().use(
	  		'aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent: '<p><b>'+message+'</b></p>',
	  				centered: true,
	  				modal: true,
	  				width: 350,
	  				zIndex: 999,
	  				resizable: false,
	  				toolbars: {
	  					footer: [
	  					{
	  						label: 'Close',
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
}


function appreciateLesson(appreciateLessonURL,unAppreciateLessonURL){
	 $.ajax({
	        url:appreciateLessonURL,
	        type: 'GET',
	        datatype:'html',
	        data: { 
		  		"<portlet:namespace />lessonId": "<%=lesson.getLessonId()%>",
		  		 "<portlet:namespace />userId": "<%=user.getUserId()%>",
		  	},
	        success: function(data){
	        		showSuccessAlert("Appreciation posted successfully.");
	        		$('.lesson_appreciate_block a').removeAttr("onclick");
	        		$('.lesson_appreciate_block a').attr("onclick","unAppreciateLesson('"+unAppreciateLessonURL+"','"+appreciateLessonURL+"')");
	        		$('.lesson_appreciate_block a i').attr("title","Already appreciated.");
	        		$('span.no_of_appreciatedCount').html("&nbsp; "+data+"  &nbsp; &nbsp; &nbsp;");
   		} 	
	  });
	 
};



function unAppreciateLesson(unAppreciateLessonURL,appreciateLessonURL){
	AUI().use(
	  		'aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent: '<p> <b>Are you sure you want to take your appreciation back?</b></p>', 
	  				centered: true,
	  				headerContent: null, 
	  				modal: true,
	  				width: 350,
	  				zIndex: 999,
	  				resizable: false,
	  				toolbars: {
	  					footer: [
	  					{
	  						label: 'Yes',
	  						on: {
	  							click: function() {
	  								modal.hide();
	  								$.ajax({
	  							        url:unAppreciateLessonURL,
	  							        type: 'GET',
	  							        datatype:'html',
	  							      data: { 
	  							  		"<portlet:namespace />lessonId": "<%=lesson.getLessonId()%>",
	  							  		 "<portlet:namespace />userId": "<%=user.getUserId()%>",
	  							  	},
	  							        success: function(data){
	  							        		showSuccessAlert("Unappreciation posted successfully.");
	  							        		$('.lesson_appreciate_block a').removeAttr("onclick");
	  							        		$('.lesson_appreciate_block a').attr("onclick","appreciateLesson('"+appreciateLessonURL+"','"+unAppreciateLessonURL+"')");
	  							        		$('.lesson_appreciate_block a i').attr("title","Appreciate This.")
	  							        		$('span.no_of_appreciatedCount').html("&nbsp; "+data+"  &nbsp; &nbsp; &nbsp;");
	  						    		} 	
	  							  });
	  							}
	  						}
	  					},
	  					{
	  						label: 'No',
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





AUI().use(
	'aui-tabview',
	function(Y) {
		new Y.TabView(
		{
			srcNode: '#playTab'
		}
		).render();
	}
);

$( document ).ready(function() {

	if('<%=author.getUserId()%>' == '<%=user.getUserId()%>'){
		$("#followUserId").hide();
		$("#unFollowUserId").hide();
	}else if('<%=showFollowButton %>' == 'false' && '<%=showUnFollowButton %>' == 'false'){
		$("#followUserId").show();
		$("#unFollowUserId").hide();
	}else if('<%=showFollowButton %>' == 'true'){
		$("#followUserId").show();
		$("#unFollowUserId").hide();
	}else if('<%=showUnFollowButton %>' == 'true'){
		$("#followUserId").hide();
	  	$("#unFollowUserId").show();
	}
});


	function addNewPlaylist(){
		var playlistName = $('#appendedInput').val().trim();
		if(playlistName.trim() != ""){
			location.href = "<%=showLessonURL%>&<%=portletNamespace%>playlistName="+playlistName;
		}else
			alert("please provide playlist name");
	}


	(function(window, document) {
		var $ = function(selector, context) {
			return (context || document).querySelector(selector)
		};

		var iframe = $("iframe"), domPrefixes = 'Webkit Moz O ms Khtml'
				.split(' ');

		var fullscreen = function(elem) {
			var prefix;
			// Mozilla and webkit intialise fullscreen slightly differently
			for (var i = -1, len = domPrefixes.length; ++i < len;) {
				prefix = domPrefixes[i].toLowerCase();

				if (elem[prefix + 'EnterFullScreen']) {
					// Webkit uses EnterFullScreen for video
					return prefix + 'EnterFullScreen';
					break;
				} else if (elem[prefix + 'RequestFullScreen']) {
					// Mozilla uses RequestFullScreen for all elements and webkit uses it for non video elements
					return prefix + 'RequestFullScreen';
					break;
				}
			}

			return false;
		};



		// Webkit uses "requestFullScreen" for non video elements
		var fullscreenother = fullscreen(document.createElement("iframe"));

		if (!fullscreen) {
			alert("Fullscreen won't work, please make sure you're using a browser that supports it and you have enabled the feature");
			return;
		}

		if($("#fullscreeniframe")){
			$("#fullscreeniframe").addEventListener("click", function() {
				// iframe fullscreen and non video elements in webkit use request over enter
				iframe[fullscreenother]();
			}, false);
		}
	})(this, this.document);
 
 function removeLesson(deleteLessonURL){
	AUI().use(
  		'aui-modal','aui-io-request',
  		function(Y) {
  			var modal = new Y.Modal(
  			{
  				bodyContent: '<p> <Strong>Are you sure you want to remove this lesson?</Strong></p>', centered: true,
  				headerContent: null, 
  				modal: true,
  				render: '#requestLesson',
  				width: 350,
  				zIndex: 999,
  				resizable: false,
  				toolbars: {
  					footer: [
  					{
  						label: 'Yes',
  						on: {
  							click: function() {
  								 Y.io.request(
								      deleteLessonURL,
								      {
								        on: {
								          success: function() {
								        	window.location.href = "<%=homeUrl%>";
								          }
								        }
								      }
								    );
  							}
  					}
  					},
  					{
  						label: 'Cancel',
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
}
 
 
 
 
 
</script>

<script>


AUI().use('node', 'node-focusmanager', function (A) {
		
		var doc = A.one(document),
		toggler = A.one('#share-button'),
		dropdown = A.one('#share-btn-menu');
		if(toggler != null){
			toggler.on('click', function(e) {
				dropdown.toggleClass('show');
				e.preventDefault();
				e.stopPropagation();
			});
			doc.on('click', function() {
				dropdown.removeClass('show');
			});	
		}
	});

function myEmailPopup(url) {
	Liferay.Util.openWindow(
		{
			dialog: {
				width: 600,
				height:500,
				align: Liferay.Util.Window.ALIGN_CENTER,
				cache: false,
				destroyOnClose:true,
				destroyOnHide:true,
				modal: true
			},
			
			title: 'Share via email',
			id: 'myEmailPopupId',				
			uri: url
		}
	);
}

Liferay.provide(window,
    'closeEmailPopup',
        function(popupIdToClose,withSuccessMsg) {
				var popupDialog = Liferay.Util.Window.getById(popupIdToClose);
            popupDialog.destroy();
            if(withSuccessMsg != null && withSuccessMsg == 'yes'){
            	closePopupForAllWithSuccessMsg('Lesson shared successfully.');
            }
        },
        ['liferay-util-window']
    );
</script>

<script>

function embedUrl(url) {
	
	AUI().use(
	  		'aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent: '<p style="padding: 15px 10px;cursor:text"><textarea style="cursor:text !important" readonly class="input-block-level" rows="5"><iframe src="'+url+'" width="100%" height="700" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></textarea></p>',
	  				centered: true,
	  				headerContent:'<strong>Copy this Url</strong>', 
	  				modal: true,
	  				render: '#embedUrl',
	  				width: 650,
	  				zIndex: 999,
	  				resizable: false,
	  				toolbars: {
	  					footer: [
	  					{
	  						label: 'Ok',
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
}


</script>
<% }else if(isRedirectToEditPage){%>
<script>
	window.location.href="<%=redirectToEditPageUrl%>";
</script>
<%} else{%>
${privacyCheckMessage}
<%} %>