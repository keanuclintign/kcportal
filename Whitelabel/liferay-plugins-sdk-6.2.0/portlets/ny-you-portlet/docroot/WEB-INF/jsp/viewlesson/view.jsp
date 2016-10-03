
<%@page import="com.liferay.portal.kernel.util.UnicodeFormatter"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.nyu.service.DocumentFileLocalServiceUtil"%>
<%@page import="com.nyu.service.LessonLocalServiceUtil"%>
<%@page import="com.nyu.model.DocumentFile"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portlet.documentlibrary.service.DLFileEntryLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil"%>
<%@page import="com.liferay.portlet.documentlibrary.model.DLFileEntry"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="com.nyu.model.Lesson"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp"%>
<meta property="og:image" content="https://<%=PortalUtil.getHost(request)%><%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>facebookLogo.jpg"/>
<link rel="image_src" type="image/jpeg" href="https://<%=PortalUtil.getHost(request)%><%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>facebookLogo.jpg" />

<portlet:resourceURL var="lessonNote" id="lessonNote" /> 

<div id="lessonForm" style="display:none">
<aui:form >
 <aui:input type="text" id="chapterId" name="chapterId" label="Enter the Chapter Id"/>
  <aui:input type="text" name="chapterName" label="Enter the Chapter Name"/>
</aui:form>
</div>

<c:set var="lessonId">${lessonId}</c:set>
<c:set var="documentId"><%=request.getParameter(Constant.DOCUMENT_ID)%></c:set>

<%
	response.addHeader( "X-FRAME-OPTIONS", "ALLOW-FROM https://portal.nyugts.com" );
	String boxDocportletId=PortalUtil.getPortletId(request);
	if(layout.getNameCurrentValue().equalsIgnoreCase("browse")){
		boxDocportletId=Constant.PORTLET_LESSON;
	}
	PortletURL boxDocURL=PortletURLFactoryUtil.create(request,boxDocportletId,themeDisplay.getPlid(), PortletRequest.RENDER_PHASE);
	boxDocURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);
	Lesson lesson =(Lesson) request.getAttribute(Constant.LESSON);
	if(lesson==null){
%>	
	<h3> <b class="text-info">No lesson found.</b> </h3>
					
<%	}else if((layout.isPublicLayout() && Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC.equals(lesson.getLessonPrivacy())) || layout.isPrivateLayout()) {

	lesson = (Lesson) request.getAttribute(Constant.LESSON);
	boxDocURL.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lesson.getLessonId()+"");
	boxDocURL.setParameter(Constant.DOCUMENT_ID, "");
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

	/* String portletId = portletDisplay.getId();
	long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), "/create-playlist").getPlid();
	PortletURL showLessonURL = PortletURLFactoryUtil.create(renderRequest, portletId, targetPlId, PortletRequest.RENDER_PHASE);
	showLessonURL.setParameter("lessonsList", String.valueOf(lesson.getLessonId()));
	showLessonURL.setWindowState(WindowState.MAXIMIZED);
	String portletNamespace = portletDisplay.getNamespace(); */
	
	
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
	
	if(Validator.isNotNull(request.getAttribute(Constant.DOCUMENT_ID)) && ParamUtil.getLong(request,Constant.DOCUMENT_ID)!=0){
			documentId=ParamUtil.getLong(request,Constant.DOCUMENT_ID);
			documentFile = DocumentFileLocalServiceUtil.getDocumentFile(documentId);
			request.setAttribute("documentFile",documentFile);
			
	}
	
	User author = CommonUtil.getAuthor(lesson.getAuthor());
	request.setAttribute(Constant.AUTHOR, author);
	
	
	int viewCount = 0;
	if(author.getUserId() != user.getUserId()){ 
		viewCount = CommonUtil.getIncrementedViewCount(user.getUserId(), Lesson.class.getName(), lesson.getLessonId());
	}
	else{
		viewCount = CommonUtil.getViewCount(Lesson.class.getName(), lesson.getLessonId());
	}
		
			boolean hasAppreciated = false;
		
		int appreciatedCount = 0;
		String appreciatedUserIds = lesson.getAppreciatedUserIds();
		List<String> items = new ArrayList<String>();
		if (!appreciatedUserIds.isEmpty()) {
			items = Arrays.asList(appreciatedUserIds.split(","));
			hasAppreciated = items.contains(themeDisplay.getUserId()+"");
			appreciatedCount = items.size();
		}
	
	boolean showChapterButton=false;
	String hasVedioTranscript = null;
	//pageContext.setAttribute("hasVedioTranscript", hasVedioTranscript, PageContext.REQUEST_SCOPE);
%>	
	<h1>${lesson.lessonName}</h1>
					<div>
						<div class="tab-content">
							<div role="tabpanel" aria-labelledby="tab_1" class="tab-pane active" id="tabpanel_1">
								
								<div class="row-fluid">
								<div class="span7">
								<c:set var="downloadURL">${documentFile.downloadUrl}</c:set>
								<c:set var="documentName">${documentFile.documentName}</c:set>
									
								<c:choose>
									<c:when test='<%=Validator.isNull(documentFile) %>'>
										<p>There is no video attached to this Lessons, Please look in to Additional Documents.</p>
									</c:when>
									<c:when test='${documentFile.resourceType eq "youtube"}'>
										<div class="fl engageFrame">
											<iframe src="${documentFile.documentPath}"
												style="height: 370px; width: 640px;border:0;" webkitallowfullscreen
												mozallowfullscreen allowfullscreen></iframe>
										</div>								
	
									</c:when>
									<c:when test='${documentFile.resourceType eq "embed"}'>
										<div class="fl engageFrame">
										<%
										String tempUrl=documentFile.getDocumentPath();
										if(documentFile.getDocumentPath().contains(Constant.PORTLET_PROP_VENDOR_VENDOR_GTS_COM)){
										tempUrl=documentFile.getDocumentPath().replace(Constant.PORTLET_PROP_VENDOR_VENDOR_GTS_COM,"knowledgecommons.nyu.edu");
										}
										%>
											<iframe src="<%=tempUrl%>"
												style="height: 370px; width:100%;" webkitallowfullscreen
												mozallowfullscreen allowfullscreen></iframe>
											<br />
											<a href="#"><img id="fullscreeniframe" class="pull-right" style="width: 30px; 
												height: 30px; border:0; margin-left: 599px; margin-top: -31px; position: absolute; z-index: 1;" 
												alt="View Fullscreen" src="<%=themeDisplay.getPathThemeImages()%>/<%= Constant.PORTLET_PROP_ONLY_VENDOR_NAME %>/fullscreen.png" /></a>
										</div>

									</c:when>
									<c:when test="${fn:contains(documentName, '.scorm')}">
										    <%-- <object type="text/html" data="${downloadURL}"
										           style="height: 370px; width:100%;">
										    </object> --%>
										    <a href="${downloadURL}" target="_blank" style=" background: #000000;
 											 												 display: block; height: 370px; text-align: center;  width: 100%; text-decoration: none;">
										    	<img src="<%=themeDisplay.getPathThemeImages()+ Constant.PORTLET_PROP_PATH_VENDOR  %>nyu_video_cover.png" style="margin: 15% 0 -30px; width: 25%;">
										    	<p><b><font color="white">Video will open in a separate window</font></b></p>
										    </a> 
									</c:when>
									<c:otherwise>
										<c:set var="addChapterUrl" value='${engageLaunchServiceUrl}/resourceId/${documentFile.resourceId}/lessonId/${lesson.lessonId}/authorId/${user.userId}/chapterId/0' scope="page"/>
										<%
										showChapterButton=true;
										%>
										<div class="fl engageFrame">	
											<iframe src="${addChapterUrl}"
												style="height: 370px; width: 100%; border:0;" webkitallowfullscreen
												mozallowfullscreen allowfullscreen></iframe>
											<br />
										</div>
									</c:otherwise>
								</c:choose>
								
								</div>
								<div class="span5">
									<%if(lesson.getUploadedById()==PortalUtil.getUserId(request))
									{%>
									<div id="editLesson" style="min-height:370px;display:none">	
															
										<liferay-ui:input-editor name="messageEditor" skipEditorLoading="false" initMethod="getLessonNote"  toolbarSet="edit-in-place" ></liferay-ui:input-editor>
									
									</div>
									<div id="previewLesson" class="user-editbox">
											<!-- <p><b>Lesson Notes:</b><p> -->
											<div id="data-preview"> ${lesson.lessonNote} </div>
									</div>
									
									<button id="previewButton" onclick="previewNote()" class="btn btn-default">Edit</button>		
									<%if(showChapterButton){ %>
										<button id="addChapter" onclick="addChapter('${addChapterUrl}')" class="btn btn-default">Add Chapter</button>			
									<%}%>
									<button  onclick="lessonNote('${lessonId}')" class="pull-right btn btn-default">Save</button>
									<%}else{ %>
									
										<div class="span12">
											<div class="user-editbox">
												<!-- <p><b>Lesson Notes:</b></p> -->
												 ${lesson.lessonNote} 
											</div>
										</div>
									<%} %>
								</div>
								
								</div>
								<div class="row-fluid">
								<div class="span7">
								<p>${lesson.description}</p>
								</div>
															
								</div>
							</div>
						</div>
					</div> 
					
				<%@ include file="/WEB-INF/jsp/lessons/playList.jsp"  %>	
				
<%}else{%>
	<h3> <b class="text-info">This is private Lesson...!</b> </h3>
<%} %>	
				
				
				
<script>

function lessonNote(lessonId)
{
	
	var userComment=window.<portlet:namespace />messageEditor.getHTML().replace(/<a/gi,"<a onclick='event.preventDefault();changeIframe(this.href, this.target)'");
	if(userComment.trim() == ''){
		AUI().use('aui-modal',
					function(Y) {
						var modal = new Y.Modal(
						{
						bodyContent: '<p> <Strong>Please Provide Notes.</Strong></p>', centered: true,
						headerContent: null, 
						modal: true,
						cssClass:'popup_alert',
						width: 350,
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
						}).render();
	  				});
		return false;
	}
	else{
	$.ajax({
        url:'<%=lessonNote%>',
        type: 'POST',
        datatype:'html',
        data:{
        	<portlet:namespace/>userNote:userComment,
        	<portlet:namespace/>lessonId:lessonId,
             },
        success: function(data){
        	AUI().use('aui-modal',
					function(Y) {
						var modal = new Y.Modal(
						{
						bodyContent: '<p> <Strong>'+data+'</Strong></p>', centered: true,
						headerContent: null, 
						modal: true,
						cssClass:'popup_alert',
						width: 350,
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
						}).render();
	  				});
        	
        }
    });
	}
}	

function <portlet:namespace />getLessonNote(data) {
	 var content = '<%=lesson!=null ? UnicodeFormatter.toString(lesson.getLessonNote()) : "" %>';
    return  content ;
               
   }


function previewNote() {
	$('#previewLesson').toggle();
	$('#editLesson').toggle();
	$('#previewLesson #data-preview').html(window.<portlet:namespace />messageEditor.getHTML().replace(/<a/gi,"<a onclick='event.preventDefault();changeIframe(this.href, this.target)'"));
	var buttonVal=$('#previewButton').text();
	if(buttonVal.indexOf('Preview')>=0)
		{
		$('#previewButton').text('Edit');
		}
	else
		{
		$('#previewButton').text('Preview');
		}
	
   }


$(document).ready(function() {
    $('#whoViewedCarousel').carousel({
    	interval: false
	});
    $('#peopleUfollowCarousel').carousel({
    	interval: false
	});
    $('#documentViewedCarousel').carousel({
    	interval: false,
	});
     
});

function changeIframe(url,target)
{
	var	href=url;
	var existinghref='${engageLaunchServiceUrl}';
	var additionalDocs = "_WAR_nyyouportlet_documentId=";
	
	if(url.indexOf('<%= Constant.PORTLET_PROP_VENDOR_VENDOR_GTS_COM %>')>=0)
		url=url.replace('<%= Constant.PORTLET_PROP_VENDOR_VENDOR_GTS_COM %>','knowledgecommons.nyu.edu');
	
	if(url.indexOf(existinghref)>=0 ){
		var frameData='<iframe src="'+url+'" style="height: 370px; width: 100%; border:0;" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>';
		$(".engageFrame").html(frameData);
	}
	else if(url.indexOf(additionalDocs)>=0){
		var boxUrl='<%=boxDocURL%>';
		boxUrl=boxUrl+url.substr(url.lastIndexOf('=')+1);
		window.open(boxUrl,'_self');
	}
	else{
		if(target!='')
			window.open(url,target);
		else
			window.open(url,'_blank');
	}
}

function addChapter(url) {
	$('#<portlet:namespace/>chapterId').val("");
	$('#<portlet:namespace/>chapterName').val("");
	AUI().use(
	  		'aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent:$('#lessonForm').show(),
	  				centered: true,
	  				headerContent:'<strong>Chapter Link</strong>', 
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
	  								
	  								var link="Chapter"+" "+$('#<portlet:namespace/>chapterId').val()+" "+"-"+" "+$('#<portlet:namespace/>chapterName').val();
	  								var updatedcontent=window.<portlet:namespace />messageEditor.getHTML()+"<p><a href='"+url.slice(0,url.length-1)+$('#<portlet:namespace/>chapterId').val()+"'>"+link+"</a></p>";
	  								window.<portlet:namespace />messageEditor.setHTML(updatedcontent);
	  								$('#previewLesson #data-preview').html(window.<portlet:namespace />messageEditor.getHTML().replace(/<a/gi,"<a onclick='event.preventDefault();changeIframe(this.href, this.target)'"));
	  								modal.hide();
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

<script type="text/javascript" src="<%=themeDisplay.getPathThemeJavaScript()%>/jquery/bootstrap.min.js"></script>    
				