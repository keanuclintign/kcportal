<%@page import="com.nyu.util.Constant"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portlet.documentlibrary.model.DLFileEntry"%>
<%@page import="com.liferay.portlet.documentlibrary.service.DLFileEntryLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<script type="text/javascript" src = "<%=request.getContextPath()%>/js/angular/lessonSection.js?<%=new Date().getTime()%>"></script>	
<script type="text/javascript" src = "<%=request.getContextPath()%>/js/commonWidgets.js"></script> 
<script type="text/javascript" src = "<%=request.getContextPath()%>/js/request-lesson.js"></script> 
<script type="text/javascript" src="/<%= Constant.PORTLET_PROP_PORTLET_THEME %>/js/jquery/sortable.js"></script>


<portlet:renderURL var="previewAdvanceLesson" >
	<portlet:param name="action" value="viewAdvanceLesson" />
	<portlet:param name="lessonId" value='<%=request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID) %>' />
	<portlet:param name="basicLesson" value='<%=GetterUtil.getString(request.getAttribute(Constant.BASIC_LESSON))%>' />
</portlet:renderURL>

<portlet:resourceURL var="SaveLessonSections" id="SaveLessonSections"/>

<portlet:resourceURL var="uuidURL" id="generateDocUUID">
</portlet:resourceURL>

<portlet:resourceURL var="cancelLessonURL" id="cancelLessonURL"/>

<%
String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),layout.isPrivateLayout(),themeDisplay);
String homeUrl=siteFriendlyUrl+Constant.PAGE_HOME;
String thumbnailPath = null;
long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
Lesson lesson = (Lesson)request.getAttribute(Constant.LESSON);
if(lesson!=null){
	DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(DLFileEntry.class);
	dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID, lessonClassNameId));
	dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_PK, lesson.getLessonId()));
	List<DLFileEntry> dlFileEntries = DLFileEntryLocalServiceUtil.dynamicQuery(dynamicQuery);
	if(dlFileEntries!=null && dlFileEntries.size()>0){
			thumbnailPath = themeDisplay.getPortalURL() + themeDisplay.getPathContext() + "/documents/" + dlFileEntries.get(0).getGroupId() + StringPool.SLASH + dlFileEntries.get(0).getUuid();
	}else{
			thumbnailPath = themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER ;
	}
	}
else{
			thumbnailPath = themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER ;
	} 

%>
<c:set var="userGroupId" value="<%=lesson.getPublishWithProfile()%>"/>
<c:set var="publishWithProfile" value="<%=Constant.PUBLISH_WITH_GROUPPROFILE %>"/>
<portlet:renderURL var="createAdvanceLessonURL" >
	<portlet:param name="action" value="createAdvanceLesson" />
	<portlet:param name="lessonId" value='<%=request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID) %>' />
	<portlet:param name="fromPreviewEdit" value='yes' />
	<portlet:param name="basicLesson" value='<%=GetterUtil.getString(request.getAttribute(Constant.BASIC_LESSON),Constant.NO_BASIC_LESSON)%>' />
	
	<portlet:param name="userGroupId" value="<%=String.valueOf(lesson.getPublishWithProfile()) %>"/>
</portlet:renderURL>

<!-- <div id="lessonSectionControllerId" ng-controller="lessonSectionController">  -->
<div id="lesson-section-content" style="display:none" ng-controller = "lessonSectionController">
	<%@ include file="/WEB-INF/jsp/nyu-lessons/lessonSectionTemplate.jsp" %>
</div>
<div style="display:none">	
	<liferay-ui:input-editor name="discussionMessage" initMethod="" skipEditorLoading="false"
							toolbarSet="edit-in-place"  ></liferay-ui:input-editor>	
</div>

<div id="createLesson" class="row">
	<!-- progressbar -->
	<ul id="progressbar">
		<li class="active"><liferay-ui:message key="start" /></li>
		<li class="active"><liferay-ui:message key="overview" /></li>
		<li class="active"><liferay-ui:message key="content" /></li>
		<li><liferay-ui:message key="preview-and-save" /></li>
	</ul>
	<div class="progress-content">
		<div class="lesson-content shadow">
			<div class="preview-lesson-details">
				<h1> <%=lesson.getLessonName() %> </h1>
				<p><%=lesson.getDescription() %></p>
			</div>
			<!-- <h4> Lesson Outline </h4> -->
			<div id="mySortableLayout">	
				
			</div> <!-- end mySortableLayout -->	
				<%if(!(GetterUtil.getString(request.getAttribute(Constant.BASIC_LESSON),Constant.NO_BASIC_LESSON).equals(Constant.BASIC_LESSON))){ %>	
					<div class="text-center"> 
						<button class="btn btn-primary add-another-page" style="margin-top: 15px;"> <i class="icon-plus"> </i><liferay-ui:message key="add-another-section" /> </button>
					</div>
				<%} %>
			<!-- <input type="button" saveSections id="sectionSaveContinue"  name="saveContinue" class="btn btn-primary" value="Save and continue" /> -->
			<div class="text-right">
			<div class="span7 text-left content-disclaimer">
				<strong><liferay-ui:message key="note" />:</strong><i><liferay-ui:message key="any-information-entered-will-be-lost-if-the-back-or-forward-button-on-the-browser-is-clicked" />.</i>
			</div>	
				<input type="button" onclick="saveSections()"   name="saveContinue" class="btn btn-primary" value='<liferay-ui:message key="save-and-continue" />' /> 				
				<a href='<%=createAdvanceLessonURL.toString() %>' class="previous btn btn-default" ><liferay-ui:message key="back" /> </a>
				<button type="button" title="<liferay-ui:message key="small-cancel" />" class="previous btn btn-default" onclick="cancelLesson('<%=cancelLessonURL%>','<%=homeUrl%>');">
					<liferay-ui:message key="cancel" /></button>
			</div>
				
			<div class="custom-alert section-process-alert">  						
				<div class="message-body"> 
						<h4 class="message-heading"> <liferay-ui:message key="alert" />  </h4>
						<div class="content"> 
							<liferay-ui:message key="please-wait-till-section-upload-process-is-complete" />.
							<div class="text-right">
							<button type="button" class="btn" id="alertMessageBoxButton" ><liferay-ui:message key="ok" /></button>
							</div> 
						</div>
				</div>  <!--  end message-body --> 						
			</div> <!--  end custom-alert -->
			
			<div class="custom-alert section-load" style="display: block; background: rgba(255,255,255,0.3)"> 
			
			</div>
			
			<div class="processingImg" align="center" style="display:none;">
				<img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt=""   /> 
			</div>
			
		</div> <!-- end lesson-content --> 
	</div> <!-- end progress-content --> 
 </div> <!--  end createLesson  --> 
	<div class="hide" id="transcribeTemplate" >
		<p> <Strong><liferay-ui:message key="please-select-the-type-of-transcript-for-the-video-you-are-uploading" /> ?</Strong></p>
		<p style="margin: 0px">
			<%-- <span><input type="radio" name="transcribe" class="is-checked-transcribe" value="<%=Constant.TRANSCRIBE_SPHINX%>" /></span><span><%=Constant.TRANSCRIBE_SPHINX%></span> --%>
			<span><input type="radio" name="transcribe" class="is-checked-transcribe" checked="checked" value="<%=Constant.TRANSCRIBE_AUTOMATED%>" /></span><span><%=Constant.TRANSCRIBE_AUTOMATED%></span>
			<%-- <span><input type="radio" name="transcribe" class="is-checked-transcribe" value="<%=Constant.TRANSCRIBE_MANUAL%>" /></span><span><%=Constant.TRANSCRIBE_MANUAL%></span> --%>
			<span><input type="radio" name="transcribe" class="is-checked-transcribe" value="<%=Constant.TRANSCRIBE_NONE%>" /></span><span><%=Constant.TRANSCRIBE_NONE%></span>
		</p>
		<p class="text-left content-disclaimer" style="margin: 0px"><strong><liferay-ui:message key="note" />:</strong><i id="yui_patched_v3_11_0_3_1441175231250_53"> <liferay-ui:message key="transcription-will-be-available-after-sometime" />.</i> </p>
	</div>
<script>

function cancelLesson(cancelLessonUrl,homeUrl){
	AUI().use('aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent: '<p> <Strong><liferay-ui:message key="do-you-want-to-discard-changes" />?</Strong></p>', centered: true,
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
	  									url: cancelLessonUrl,
	  									dataType: 'html',
	  									processData: false,
	  									contentType: false,
	  									type: 'POST',
	  									success: function(data){
	  										modal.hide();
	  										window.location.href=homeUrl;
	  									}
	  								});
	  							}
	  					}
	  					},
	  					{
	  						label: '<liferay-ui:message key="no" />',
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
</script>

<%@ include file="/WEB-INF/jsp/nyu-lessons/media.jsp" %>


<script> 
	// ONLOAD PAGE SECTION TEMPLATE
	var lessonSectionIndex=0;
	var docUploaded=false;
	var resourceFileModal;
	var AllJsonNyuLessonObjectives=<%=request.getAttribute(Constant.JSON_VENDOR_LESSON_OBJECTIVES)%>; 
	$(function(){
		var content = $('#lesson-section-content');
		var scope = angular.element(content).scope();
	    scope.nyuLessonObjectives = JSON.parse(AllJsonNyuLessonObjectives.jsonNyuLessonObjectives);
		scope.$apply(function() {
       	});
		addLessonSection();
		
		 

		
	});
	function addLessonSection(){
		lessonSectionIndex++;
		var textareaToEditorId = lessonSectionIndex;
		var lessonSectionId = "lesson-section-"+lessonSectionIndex;
		var lessonSectionNumber = "Section "+lessonSectionIndex;
		var template = $('#lesson-section-content').html().replace("**sectionIndexOrder**",lessonSectionIndex).replace("**sectionId**",lessonSectionId).replace("**sectionIndex**",lessonSectionNumber).replace(/#textAreaId#/g,textareaToEditorId);
		<%-- var AllJsonNyuLessonObjectives=<%=request.getAttribute("jsonNyuLessonObjectives")%>; --%> 
		$('#mySortableLayout').append(template);
		$('.adv-content-thumb').attr('src','<%=thumbnailPath%>');
		bindEvent();
		/* var content = $('#'+lessonSectionId);
		var scope='';
		angular.element(document).injector().invoke(function($compile) {
	         scope = angular.element(content).scope();
	         scope.nyuLessonObjectives = JSON.parse(AllJsonNyuLessonObjectives.jsonNyuLessonObjectives);
	        //$compile(content)(scope);
	    });
		scope.$apply(function() {
	    	
       	}); */
	}
(function(){
	
	var sectionParent = $('#mySortableLayout');
	bindEvent();
	
	// ANOTHER PAGE TEMPLATE
	//----------------------------------------------------
	$('.add-another-page').on('click',function(){		  
		$('#mySortableLayout').find('.section-content').hide();
		$('#mySortableLayout').find('.expand-add-media').text('<liferay-ui:message key="add-text-and-media" />').css('marginRight','-56px');
		addLessonSection();
	}); 
	
	// UPLOAD DROPDOWN 
	//----------------------------------------------------
	sectionParent.on('click','.lesson-upload',function(){ 
		//$('#mySortableLayout').find('.upload-data').hide();
		//$(this).closest('.advanced-page').find('.section-content-error').empty();
		//$(this).closest('.advanced-page').find('.section-content-error').hide();
		
		$(this).closest('.advanced-page').find('.upload-data').toggle(); 
		
		$(this).closest('.advanced-page').find('.progress-fail-error').hide();
	});
 
	
	// SECTION EXPAND COLLAPSE
	//----------------------------------------------------
	sectionParent.on('click','.expand-add-media',function(evt){ 
		
		// Current Section Elements		
		var element = $(this);
		var btnText = element.text();
		
		var editorIndex = element.closest('.advanced-page').data("index");
		var currentParent = element.closest('.advanced-page');
		var currentContent = currentParent.find('.section-content');  
		showEditorsBySectionIndex(editorIndex);
		$('#mySortableLayout').find('.expand-add-media').text('<liferay-ui:message key="add-text-and-media" />').css('marginRight','-56px');
		if(btnText == "Collapse Section") {
			element.text('<liferay-ui:message key="add-text-and-media" />');		
			element.css('marginRight','-56px');
		}else {
			element.text('Collapse Section');	
			element.css('marginRight','-45px');
		}

		
		evt.preventDefault(); 		
		toggleElement(currentContent, $('.section-active')); 
		/* evt.stopPropagation();  */    
	});  
	
	$('body').on('click',function(){
		// hiding objetive popover
		$('.learning-objectives-popover.open-objectives').hide();
	});
	
	// OBJECT POPOVER
	//----------------------------------------------------
	sectionParent.on('click','.learning-objectives',function(event){ 
		var element = $(this);
		var objectPopover = element.closest('.section-title').find('.learning-objectives-popover');	
		var currentParent = element.closest('.advanced-page');
		var currentContent = currentParent.find('.section-content'); 
		var editorIndex = element.closest('.advanced-page').data("index");
		showEditorsBySectionIndex(editorIndex);
		sectionParent.find('.section-content').hide();
		currentContent.show();
		toggleElement(objectPopover, $('.open-objectives'));   
		$('#mySortableLayout').find('.expand-add-media').text('<liferay-ui:message key="add-text-and-media" />').css('marginRight','-56px');
		element.next().text('Collapse Section').css('marginRight','-45px');
		event.stopPropagation(); 
	});
	
	sectionParent.on('click', '.learning-objectives-popover', function(event){
		event.stopPropagation(); 
	}); 
	
	sectionParent.on('click','.close-popover, #saveObjective, #cancelObjective',function(e){
		$(this).closest('.learning-objectives-popover').hide();
		e.stopPropagation(); 
	}); 
 
})();
function toggleElement(element, className){
	 if(element.css('display') != 'block'){
		 	className.hide().removeClass(className);
		 	element.addClass(className).show();
		} 
		else {
			$(className).hide().removeClass(className);
		} 
}

function bindEvent(){	
	
	//SET LESSON THUMBNAIL TO EACH SECTION
	//$('.adv-content-thumb').attr('src',thumbnailPath);
	
	//CLOSE CUSTOM MODAL
	//----------------------------------------------------
	$('.custom-modal-box').hide();	
	$('a.cancel-upload-btn').click(function(event){ 
		$(this).closest('.section-content').find('.upload-media-modal-box').hide();		
		event.preventDefault();
	});
	
	//DELETE LESSION
	//----------------------------------------------------
	$('.delete-lesson').on('click',function(){
		confirmModal('<liferay-ui:message key="do-you-want-to-delete-the-section" />',this);
		
		// if(confirmModal('Do you want to delete the section ?')) {
			//$(this).closest('.advanced-page').remove();	
		//} 
	});

	// UPLOAD
	//----------------------------------------------------
	$('.lesson-upload').on('click',function(){
		var uploadContent = $(this).closest('.section-content').find('.upload-content'); 	
		var initialContent = $(this).closest('.section-content').find('.initial-content');
		var editorIndex = $(this).closest('.advanced-page').data("index");
		replaceTextareaAsEditor("upload-textarea-"+editorIndex);
		uploadContent.removeClass('hidden');	 
		initialContent.addClass('hidden'); 
	});

	 
	
	// REPLACE 
	//----------------------------------------------------
	$('button.back-btn').on('click',function(){
		$(this).closest('.upload-content').addClass('hidden');  				
		$(this).closest('.section-content').find('.initial-content').removeClass('hidden');
		$(this).closest('.advanced-page').find('.progress-fail-error').hide();
		if(docUploaded){
			$(this).closest('.section-content').find('.drop-down-menu .btn-group').find('button:first').nextAll().attr('disabled','true'); 
		}else{
			$(this).closest('.section-content').find('.drop-down-menu .btn-group').find('button:first').nextAll().removeAttr('disabled'); 
		}
	});
	
 
	// EMBED URL
	//----------------------------------------------------
	$('.lesson-embed').on('click',function(){
		var existinglUrl = $(this).closest('.advanced-page').find('.scope-embed-url').val();
		//$(this).closest('.advanced-page').find('.section-content-error').empty();
		//$(this).closest('.advanced-page').find('.section-content-error').hide();
		var editorIndex = $(this).closest('.advanced-page').data("index");
		CKEDITOR.instances['upload-textarea-'+editorIndex].setData(CKEDITOR.instances['upload-textarea-'+editorIndex].getData()); 
		/* $(this).closest('.section-content').find('.embed-content').removeClass('hidden'); */
		/* $(this).parent().find('.btn-availability').attr("disabled","true"); */
		/* $(this).removeAttr("disabled"); */
		/* $(this).closest('.section-content').find('.initial-content').addClass('hidden'); */
		$(this).closest('.advanced-page').find('.progress-fail-error').hide();
		$(this).closest('.advanced-page').find('.embed-error').hide();
		/* $(this).closest('.advanced-page').find('.upload-content').hide();  */ 
		$(this).closest('.advanced-page').find('.section-content-error').hide();
		$(this).closest('.advanced-page').find('.modalbody .embed-url-empty-error').hide();
		$(this).closest('.advanced-page').find('.embed-media-modal-box').fadeIn();	
		$(this).closest('.advanced-page').find('.embed-media-input').val(existinglUrl); 	
		$(this).closest('.advanced-page').find('.section-content-error').hide();
		
	});
	$('.embed-media-url').on('click', function(){ 
		var embelUrl = $(this).closest('.advanced-page').find('.embed-media-input').val();
		var isWrongUrl = true;
		if(embelUrl.trim().length==0){
			$(this).closest('.advanced-page').find('.modalbody .embed-url-empty-error').show();
		}else if(embelUrl.trim().length>0){
			var regex = new RegExp(/(https):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i);
			var youtubeRegex = new RegExp(/^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$/);
			var regVimeo =new RegExp(/^(player\.vimeo\.com|\/\/player\.vimeo\.com|http:\/\/player\.vimeo\.com|https:\/\/player\.vimeo\.com|vimeo\.com|\/\/vimeo\.com|http:\/\/vimeo\.com|https:\/\/vimeo\.com)/);
 			if((youtubeRegex.test(embelUrl))){
 				isWrongUrl = false;
			}
			else if((regVimeo.test(embelUrl))){
				isWrongUrl =false;
			}
			else if((regex.test(embelUrl))){
				isWrongUrl =false;
			}
		}
		
		if(isWrongUrl && embelUrl.trim().length>0){
			$(this).closest('.advanced-page').find('.modalbody .embed-url-empty-error').hide();
			$(this).closest('.advanced-page').find('.modalbody .modal-embed-url-error').show();
		}else if(embelUrl.trim().length>0){
			$(this).closest('.advanced-page').find('.modalbody .modal-embed-url-error').hide();
			$(this).closest('.advanced-page').find('.embed-media-modal-box').fadeOut();
			$(this).closest('.advanced-page').find('.scope-embed-url').val(embelUrl);	
			$(this).closest('.advanced-page').find('.upload-content .upload-media-file-preview').hide();
			$(this).closest('.advanced-page').find('.upload-content .embed-content-player').show();
			
			$(this).closest('.advanced-page').find('.upload-media-ready').hide();
			$(this).closest('.advanced-page').find('.upload-media-file-name').hide();
			
			$(this).closest('.advanced-page').find('.resourceIdClass').empty();
			$(this).closest('.advanced-page').find('.docUuIdClass').empty();
			$(this).closest('.advanced-page').find('.imageUrlClass').empty();
			$(this).closest('.advanced-page').find('.docTitleClass').empty();
			$(this).closest('.advanced-page').find('.docAutoTranscript').empty();
			$(this).closest('.advanced-page').find('.docUploadType').empty();
			
			/* $(this).closest('.advanced-page').find('.embed-content .embed-content-preview').hide();
			$(this).closest('.advanced-page').find('.embed-content .embed-content-player').show(); */
			
			/* $(this).closest('.advanced-page').find('.embed-content .embed-content-iframe').attr("src",embelUrl);
			$(this).closest('.advanced-page').find('.embed-content .embed-content-iframe').show(); */
		}
	});
	$('.cancel-embet-url').on('click', function(event){  
		$(this).closest('.advanced-page').find('.modalbody .modal-embed-url-error').hide();
		$(this).closest('.advanced-page').find('.modalbody .embed-url-empty-error').hide();
		$(this).closest('.advanced-page').find('.embed-media-modal-box').fadeOut();	
		event.preventDefault();
	});
	
	// EMBED URL DELETE
	//----------------------------------------------------
	$('.embed-delete').on('click',function(){
		$(this).closest('.embed-content').find('input').val('');
		$(this).closest('.embed-content').find('textarea').val('');
		$(this).closest('.embed-content').addClass('hidden'); 
		$(this).closest('.section-content').find('.initial-content').removeClass('hidden').find('.btn-availability').removeAttr("disabled");
	});
	
	// EMBED SAVE URL
	//----------------------------------------------------
	$('.embed-save').on('click',function(){
		var embedUrl = $(this).closest('.embed-content').find('input').val();
		//$(this).closest('.embed-content').find('.embed-error').remove();
		
		if(embedUrl==null || embedUrl==''){
			/* $(this).closest('.embed-content').append('<p class="embed-error" style="color:red">Please enter Url</p>'); */   
			 $(this).closest('.embed-content').find('.embed-error').show();
			
		}else{
			$(this).closest('.embed-content').addClass('hidden'); 
			$(this).closest('.section-content').find('.initial-content').removeClass('hidden');
		}
	});
	
	// ADD TEXT
	//----------------------------------------------------
	$('.lesson-add-text').on('click',function(){
		//$(this).closest('.advanced-page').find('.section-content-error').empty();
		//$(this).closest('.advanced-page').find('.section-content-error').hide();
		var editorIndex = $(this).closest('.advanced-page').data("index");
		replaceTextareaAsEditor("lessonDescription-textarea-"+editorIndex);
		$(this).parent().find('.btn-availability').attr("disabled","true");
		$(this).removeAttr("disabled");
		$(this).closest('.section-content').find('.text-content').removeClass('hidden');
		$(this).closest('.section-content').find('.initial-content').addClass('hidden');
		
		$(this).closest('.advanced-page').find('.progress-fail-error').hide();
	});
	
	// ADD TEXT DELETE
	//----------------------------------------------------
	$('.text-delete').on('click',function(){
		$(this).closest('.text-content').find('textarea').val('');
		$(this).closest('.text-content').addClass('hidden');  
		$(this).closest('.section-content').find('.initial-content').removeClass('hidden').find('.btn-availability').removeAttr("disabled");
	}); 
	
	// ADD TEXT SAVE
	//----------------------------------------------------
	$('.text-save').on('click',function(){
		var textContent = $(this).closest('.text-content').find('textarea').val();
		$(this).closest('.text-content').find('.text-content-error').remove();
		var editorIndex = $(this).closest('.advanced-page').data("index");
		var lessonDescription=CKEDITOR.instances['lessonDescription-textarea-'+editorIndex].getData();
		if(lessonDescription==null ||lessonDescription==''){
			$(this).closest('.text-content').append('<span class="text-content-error" style="color:red"><liferay-ui:message key="please-enter-text" /></span>');
		}else{
			$(this).closest('.text-content').addClass('hidden');  
			$(this).closest('.section-content').find('.initial-content').removeClass('hidden');
		}
	});
	 
	// Sortable Section
	//----------------------------------------------------
	$( "#mySortableLayout" ).sortable({
			handle: ".drag-drop-handler",
			placeholder: "ui-state-highlight",
			start: function(event,ui){
			    unloadEditors(ui.item);
			  },
			  stop: function(event,ui){
			    loadEditors(ui.item);
			  }
	}); 
	
	function unloadEditors(id) {
		var editorIndex = $(id).closest('.advanced-page').data("index");
		try{
			CKEDITOR.instances[ "upload-textarea-"+editorIndex ].destroy();
		}catch(err)
		{}
	}
	function loadEditors(id) {
		var editorIndex = $(id).closest('.advanced-page').data("index");
		replaceTextareaAsEditor("upload-textarea-"+editorIndex)
	}
	
	$('.drag-drop-handler').hover(function(){
		$(this).addClass("move-pointer");		
	},function(){
		$(this).removeClass("move-pointer");
	});
	
	// Section Title
	//----------------------------------------------------
	$('.insert-text').on('click',function(e){
		e.stopPropagation();
	});
	$('.insert-text').bind('click', function(e) {
		
		/* var existVal=$(this).html().trim();
		if(existVal=='Click here to insert title (Required)'){
			existVal='';
		}else if(existVal.indexOf('<input')>=0){
			return false;
		}
        $(this).css("border","").html("<input class='input-xxlarge' type='text' value='"+existVal+"'/>"); */
        
		
        
    }).focusout(
        function() {
        	
        	var existVal = $(this).val();
            if(existVal.trim()!=""){
            	$(this).closest('.section-title').find('p.section-title-error').empty();
        		$(this).closest('.section-title').find('p.section-title-error').hide();
            }
        	/* var titleVal=$(this).children('input').val();
        	if(titleVal != null && titleVal.trim()==''){
        		$(this).html('(Insert title)');
        	}else{
        		$(this).html(titleVal);
        		$(this).closest('.section-title').find('p.section-title-error').empty();
        		$(this).closest('.section-title').find('p.section-title-error').hide();
        	} */
     });
		
	
	
	// LESSON SECTION DRAG & DROP
/* 	YUI().use('aui-sortable-layout',function(Y) {
		new Y.SortableLayout(
		  {
			dragNodes: '.advanced-page',
			dropNodes: '#mySortableLayout'
		  }
		);
	}); */
	
	//Section wise Upload Media
	var uploadMediaAjax;
	$( ".upload-media-form" ).submit(function( event ) {
		event.preventDefault();
		//alert( $(this).closest('.advanced-page').html() );
		//alert( $(this).html() );
		
		var form = $(this)[0]; 
		$(form).closest('.advanced-page').find('.progress-fail-error').hide();
		
		if($(this).find('.mediaFileName').val()==''){
			$(".media-upload-file-error").html('<liferay-ui:message key="please-select-a-file-to-upload" />');
			$(".media-upload-file-error").show();
			return false;
		}else{
			$(".media-upload-file-error").hide();
			var isCorrectFormat = checkUploadedFile($(this).find('.mediaFileName').val());
			if(!isCorrectFormat){
				$(".media-upload-file-error").html('<liferay-ui:message key="please-upload-only-supported-formats" />');
				$(".media-upload-file-error").show();
				return false;
			}
		}
		
		if(($(this).find('.mediaFileName').val().substring($(this).find('.mediaFileName').val().lastIndexOf("."), $(this).find('.mediaFileName').val().length)).toLowerCase() == '.mp4' ){
			addMediaToResourceSpace(form);
		}
		
		var docTitle = $(this).find('.mediaFileName').val().replace(/.*(\/|\\)/, '');
		$(this).find('.media-file-title').val(docTitle.substring(0,docTitle.indexOf(".")));
		
		if((docTitle.substring(docTitle.lastIndexOf("."), docTitle.length)).toLowerCase() != '.mp4'){
			$(form).closest('.upload-media-modal-box').hide();
		}
		
		form = $(this)[0];//Again create Form object with Title value set in provious lines.
		var fd = new FormData(form);
		
		$(form).closest('.advanced-page').find('.add-media-btn').attr('disabled', 'disabled');
		$(form).closest('.advanced-page').find('.upload-media-btn').attr('disabled', 'disabled');
		$(form).closest('.advanced-page').find('.lesson-embed').attr('disabled', 'disabled');
		
		/* $(form).closest('.advanced-page').find('.lesson-embed').hide(); */
		uploadMediaAjax = $.ajax({
			type: $(form).attr('method'),
			url: $(form).attr('action'),
			data: fd,
			processData: false,
			contentType: false,
			cache: false,
			crossDomain: true,
			xhr: function() {
		        myXhr = new window.XMLHttpRequest();
		        if(myXhr.upload){
		            myXhr.upload.addEventListener('progress',showAddMediaProgress, false);
		        } else {
		            alert('<liferay-ui:message key="upload-progress-is-not-supported" />');
		        }
		       return myXhr;
			} 
		}).done(function(data) {
			var responseObj = jQuery.parseJSON(data);
			var encodedTitle = escape(docTitle);
			var currentSection = $(form).closest('.advanced-page');
			docUuid = generateDocUUID(documentUuidURL);
			currentSection.find('.resourceIdClass').html(responseObj.resourceId);
			currentSection.find('.docUuIdClass').html(docUuid);
			currentSection.find('.imageUrlClass').html(responseObj.imageurl);
			currentSection.find('.docTitleClass').html(encodedTitle);
			currentSection.find('.docAutoTranscript').html(addMediaAutoTranscript);
			currentSection.find('.upload-media-file-name').html('<b>'+docTitle+'</b>');
			currentSection.find('.upload-media-file-preview').attr('src',responseObj.imageurl);
			
			currentSection.find('.upload-media-file-preview').show(function(){
				currentSection.find('.upload-media-file-name').show();
				currentSection.find('.upload-media-ready').show();
			});
			
			currentSection.find('.docUploadType').html('new');
			currentSection.find('.section-content-error').hide();
			
			currentSection.find('.add-media-btn').removeAttr('disabled');
			currentSection.find('.upload-media-btn').removeAttr('disabled');
			currentSection.find('.lesson-embed').removeAttr('disabled');
			
			currentSection.find('.upload-content .embed-content-player').hide();
			currentSection.find('.scope-embed-url').val("");
			currentSection.find('.embed-media-input').val(""); 
			
			currentSection.find('.delete-btn').show();
			
			$(form)[0].reset();
			docUploaded=true;
			addMediaAutoTranscript='None';
			//$(sectionObj).parent().find('.resourceIdClass').html(responseObj.resourceId);
		}).fail(function (event, jqXHR, ajaxSettings, thrownError) {
			$(this).closest('.advanced-page').find('.media-progress-number').empty();
			$(this).closest('.advanced-page').find('.media-progress-number').hide();
			//$(form).closest('.advanced-page').find('.media-progress-bar').hide();
			$(form).closest('.advanced-page').find('.progress').hide();
			$(form).closest('.advanced-page').find('.progress-fail-error').show();
			$(form)[0].reset();
			docUploaded=false;
		
		});
		
		function checkUploadedFile(filename){
			var extSplit = filename.split('.');
			var extReverse = extSplit.reverse();
			var ext = extReverse[0].toLowerCase();
			if(ext === "mp4" || ext === "zip" || ext === "docx" || ext === "doc" ||ext === "xlsx" || ext === "xls" 
					|| ext === "ppt" || ext === "pptx" || ext === "pdf" || ext === "txt" ||ext === "jpg" ||
					ext === "jpeg" || ext === "png"){
			  return true;
			} else {
			  	return false;
			}
		}
		function showAddMediaProgress(evt) {
			$(form).closest('.advanced-page').find('.media-progress-number').show();
			var checkForUploadExtend = '<%=PortletProps.get("session.minimum.time.for.uploading.extend")%>';
			checkForUploadExtend = checkForUploadExtend*60*1000;
			
			if(globalPortalTimeCalculation < checkForUploadExtend){
				sessionKeepAlive();
				globalPortalTimeCalculation ="<%=PropsUtil.get(PropsKeys.SESSION_TIMEOUT)%>";
				globalPortalTimeCalculation = globalPortalTimeCalculation*60*1000;
			}
			if (evt.lengthComputable) {
				$(form).closest('.advanced-page').find('.upload-media-ready').hide();
				$(form).closest('.advanced-page').find('.media-progress-number').show();
				$(form).closest('.advanced-page').find('.progress').show();
				//$(form).closest('.advanced-page').find('.media-progress-bar').show();
	        	//$(form).closest('.advanced-page').find('.upload-media-cancel').show();
				var percentComplete = Math.round(evt.loaded * 100 / evt.total);
				$(form).closest('.advanced-page').find('.media-progress-number').html(percentComplete.toString() + '%');
				$(form).closest('.advanced-page').find('.progress .bar').css("width",percentComplete.toString()+"%");
				/* $(form).closest('.advanced-page').find('.media-progress-bar').attr("value",percentComplete); */
				
				if(percentComplete == 100 ){
					$(form).closest('.advanced-page').find('.media-progress-number').hide();
					$(form).closest('.advanced-page').find('.progress').hide();
					/* $(form).closest('.advanced-page').find('.media-progress-bar').hide(); */
					//$(form).closest('.advanced-page').find('.upload-media-cancel').hide();
					//$(form).closest('.advanced-page').find('.upload-media-ready').show()
				}
			}
			else {
				$(form).closest('.advanced-page').find('.media-progress-number').html('<liferay-ui:message key="unable-to-compute" />');
			}
		}
	});
	
	// Delete Section Media
	$('.delete-btn').click(function(){
		   $(this).siblings('.resourceIdClass').empty();
		   $(this).siblings('.imageUrlClass').empty();
		   $(this).siblings('.docTitleClass').empty();
		   $(this).siblings('.docUuIdClass').empty();
		   $(this).siblings('.docAutoTranscript').empty();
		   $(this).siblings('.docUploadType').empty();
		   
		   $(this).closest('.advanced-page').find('.upload-media-file-name').empty();
		   $(this).closest('.advanced-page').find('.upload-media-file-preview').attr('src', '<%=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.CONTENT_PREVIEW_PLACEHOLDER %>');
			
		   $(this).hide();
		   
		   $(this).closest('.advanced-page').find('.media-progress-number').empty();
		   $(this).closest('.advanced-page').find('.media-progress-number').hide();
		   $(this).closest('.advanced-page').find('.progress').hide();
		   //$(this).closest('.advanced-page').find('.media-progress-bar').hide();
		 //  $(this).closest('.advanced-page').find('.upload-media-cancel').hide();
		   $(this).closest('.advanced-page').find('.upload-media-ready').hide();
			
		   docUploaded = false;
	});
	
	// Cancel Media Upload Progress
	/* $('.upload-media-cancel').click(function(){
		uploadMediaAjax.abort();
		$(this).prev().empty();//Emptying media-progress-number span
		$(this).hide();//Hiding current cancel button
		
	}); */
	
	function addMediaToResourceSpace(obj){
		AUI().use('aui-modal',
		  		function(Y) {
					$('.progress-content').find('#uploadMediaModalBox').hide();
		  			amConfirmTranscriptModal = new Y.Modal(
		  			{
		  				bodyContent: $('#transcribeTemplate').html(), centered: true,
		  				headerContent: null, 
		  				modal: true,
		  				render: '#add_media_rsrc_spc',
		  				width: 350,
		  				zIndex: 999,
		  				cssClass:'transcribeModalPopupClass',
		  				resizable: false,
		  				toolbars: {
		  					footer: [
		  					{
		  						label: '<liferay-ui:message key="ok" />',
		  						on: {
		  							click: function() {
		  								$('.transcribeModalPopupClass .is-checked-transcribe').each(function(){
		  									if($(this).is(':checked')){
		  										addMediaAutoTranscript = $(this).val();
		  									}	
		  								});
		  										  							
		  								amConfirmTranscriptModal.hide();
		  								$(obj)[0].reset(); 
		  							}
		  						}
		  					},
		  					]
		  				}
		  			}
		  		).render();
		  	});
	};
	
	$("#alertMessageBoxButton").click(function(){$(this).closest('.section-process-alert').hide();}); 
	
} // End bindEvent function




//MODAL FOR AD MEDIA

YUI().use('aui-modal', function(Y) {
    resourceFileModal = new Y.Modal(
      {
        contentBox: '#modalContent',
        centered: true,		
        destroyOnHide: false,
        headerContent: '<h3><b>Add from <%=Constant.CURRENT_BRAND_NAME%> Archive</b></h3>',  
		modal: true,
        render: '#addMediaModal', 
		visible: false,
        width: 350,
        zIndex: 999
      }
    ).render();
    var divContent = $('.toggler-header-collapsed').next();
    
    Y.one('body').delegate('click', function(){  
		divContent.hide();
		$('#modalContent , #addMediaModal').show();
		$("#searchPageWise").val("");
		resourceData();
		resourceFileModal.show();  }, 'button.add-media-btn');
    
    
	/* Y.all('button.add-media-btn').on('click', function() {
		alert('media');
		divContent.hide();
		$('#modalContent , #addMediaModal').show();
		$("#searchPageWise").val("");
		resourceData();
		resourceFileModal.show(); 
    });  */
	 
	
	$('.toggler-header-collapsed').on('click', function() {  
		if($(this).next().css('display') != 'block'){ 
		 	$('.toggler-active').hide().removeClass('toggler-active');
		 	$(this).next().addClass('toggler-active').show();
		} 
		else { 
			$('.toggler-active').hide().removeClass('toggler-active');
		}  
		
	}); 
  }
);
// MODAL FOR AD MEDIA
/* YUI().use('aui-toggler',function(Y) {
    new Y.TogglerDelegate(
      {
        animated: true,
        closeAllOnExpand: true,
        container: '#myMediaToggler',
        content: '.content',
        expanded: false,
        header: '.header',
        transition: {
          duration: 0.2,
          easing: 'cubic-bezier(0, 0.1, 0, 1)'
        }
      }
    );
  }
); */


// TOGGLER USER INFO
	/* YUI().use('aui-toggler', function(Y) {
		new Y.TogglerDelegate(
		  {
			animated: true,
			closeAllOnExpand: true,
			container: '#lessonToggler',
			content: '.content-toggler',
			expanded: false,
			header: '.header-toggler',
			transition: {
			  duration: 0.2,
			  easing: 'cubic-bezier(0, 0.1, 0, 1)'
			}
		  }
		);
	  }
	); */ 
function saveSections(){
	
	var validteSection = validateSectionData();
	var lessonId = '<%=request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID)%>';
	var resourceType = '';
	var viewLesson=false;
	if(validteSection){
		$(".processingImg").show();
		$("#mySortableLayout").find('.advanced-page').each(
				function(i, val) {
					var order = i+1;
					var e = $(this);
					viewLesson=false;
					var editorIndex = e.data("index");
					var scope = angular.element(e).scope();
					scope.editorIndex = editorIndex;
					var resourceId = $(this).find('.resourceIdClass').html();
					var imageurl = $(this).find('.imageUrlClass').html();
					var docTitle = $(this).find('.docTitleClass').html();
					var docUuid = $(this).find('.docUuIdClass').html();
					var docAutoTranscript = $(this).find('.docAutoTranscript').html();
					var docUploadType = $(this).find('.docUploadType').html();
					var learningObjIds =$(this).find('.learn-selected-ids').val();
					
					if($(this).find('.media-progress-number').is(':visible')){
						$(".section-process-alert").show();
						return false;
					}else{
						$(".section-process-alert").hide();
					}
					
					 scope.sectionTitle=getSectionTitle($(this));
					
					if(!scope.sectionTitle){
						return false;
					} 
					scope.embedUrl=processEmbedUrl($(this).find('.scope-embed-url').val());
					if(resourceId!='null' && resourceId!=''){
						resourceType = 'resourceSpace';
					}else{
						resourceType=getresourceType(scope);	
					}
						try{
							scope.lessonDescription=CKEDITOR.instances['upload-textarea-'+editorIndex].getData();
						}catch(err){
							scope.lessonDescription=$(this).find('.scope-upload-text').val();
						}	
					$.ajax({
						url : '<%=SaveLessonSections%>',
					  	type : 'POST',
					  	async : false,
					  	data:{
					  		<portlet:namespace/>lessonId:lessonId,
					  		<portlet:namespace/>resourceType:resourceType,
						  	<portlet:namespace/>sectionTitle : scope.sectionTitle,
						  	<portlet:namespace/>lessonDescription : scope.lessonDescription,
						  	<portlet:namespace/>embedUrl : scope.embedUrl,
						  	<portlet:namespace/>resourceId : resourceId,
						  	<portlet:namespace/>imageUrl : imageurl,
						  	<portlet:namespace/>docTitle : unescape(docTitle),
						  	<portlet:namespace/>docUuid : docUuid,
						  	<portlet:namespace/>docAutoTranscript : docAutoTranscript,
						  	<portlet:namespace/>docDescription : scope.docDescription,
						  	<portlet:namespace/>docUploadType : docUploadType,
						  	<portlet:namespace/>learningObjIds : learningObjIds,
						  	<portlet:namespace/>sectionOrder :order
						  	
						  },
					  	success: function(data){
							viewLesson=true;
						}
					});
			});
			if(viewLesson){
				window.location.href='<%=previewAdvanceLesson%>';
			}
	}
	
}
	
	  function validateSectionData(){
			 var contentEntered = true;
			 if($("#mySortableLayout .advanced-page").length <= 0){
				 contentEntered = false;
				 customAlert('<liferay-ui:message key="atleast-one-section-required" />');
				 return false;
			 }
			 $("#mySortableLayout").find('.advanced-page').each(
						function(i, val) {
					var i = 'lessonDescription-textarea-'+$(this).data("index");
					var lessonDescEditor;
					try{
					lessonDescEditor =CKEDITOR.instances[i].getData();
					}catch(err){
					lessonDescEditor = '';
					}		

					if(!getSectionTitle($(this))){
						contentEntered = false;
						//return false;
					}
					if($(this).find('.scope-embed-url').val().trim().length>0){
						var regex = new RegExp(/(https):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i);
						var youtubeRegex = new RegExp(/^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$/);
						var regVimeo =new RegExp(/^(player\.vimeo\.com|\/\/player\.vimeo\.com|http:\/\/player\.vimeo\.com|https:\/\/player\.vimeo\.com|vimeo\.com|\/\/vimeo\.com|http:\/\/vimeo\.com|https:\/\/vimeo\.com)/);
			 			if((youtubeRegex.test($(this).find('.scope-embed-url').val().trim()))){
						}
						else if((regVimeo.test($(this).find('.scope-embed-url').val().trim()))){
						}
						else if(!(regex.test($(this).find('.scope-embed-url').val().trim()))){
							//$(this).find('.section-content-error,.section-embed-url-error').html('Please Embed Only Https (or) Youtube (or) Vimeo Links');
							$(this).find('.section-embed-url-error').show();
							var editorIndex = $(this).data("index");
							showEditorsBySectionIndex(editorIndex);
							$(this).find('.section-content').addClass('section-active');
							$(this).find('.section-content').show();
							$(this).find('.section-content-error').hide();
							
							contentEntered = false;
						}
					}else if($(this).find('.scope-embed-url').val().trim()=='' 
							&& $(this).find('.resourceIdClass').text().trim()=='' 
							&& lessonDescEditor.trim()==''){
					//	$(this).find('.section-content-error').html('Add any section content.');
						$(this).find('.section-content-error').show();
						var editorIndex = $(this).data("index");
						showEditorsBySectionIndex(editorIndex);
						$(this).find('.section-content').addClass('section-active');
						$(this).find('.section-content').show();
						$(this).find('.section-embed-url-error').hide();
						
						contentEntered = false;
						
					}else{
						 $(this).find('.section-content').hide();
					}
					
			});
			 
			return contentEntered;
			
	}
	  
	  function processEmbedUrl(embedUrl){
			if(embedUrl != null){
				var regVimeo =new RegExp(/^(vimeo\.com|\/\/vimeo\.com|http:\/\/vimeo\.com|https:\/\/vimeo\.com)/);
				if((embedUrl.indexOf('youtube')>0 || embedUrl.indexOf('YOUTUBE')>0) && embedUrl.indexOf("&")>0){
					 embedUrl = embedUrl.substring(0,embedUrl.indexOf("&"));
				 }
				if((regVimeo.test(embedUrl.trim()))){
					embedUrl = "player.vimeo.com/video/"+embedUrl.substr(embedUrl.lastIndexOf("/")+1);
				}
					embedUrl = embedUrl.replace("http://","");
				 	embedUrl = embedUrl.replace("<%= Constant.HTTPS_DOUBLE_SLASH %>","");
				 if(embedUrl.indexOf('youtube')>0 || embedUrl.indexOf('YOUTUBE')>0){
					 embedUrl = embedUrl.replace("=","/");
					 embedUrl = embedUrl.replace("watch?","");
					 embedUrl = embedUrl.replace("/v/","/embed/");			 
					// embedIcon = "http://i.ytimg.com/vi/" + embedUrl.substring(embedUrl.lastIndexOf("/")+1,embedUrl.length) + "/1.jpg";
				 }else if(embedUrl.indexOf("youtu.be")>=0){
					 embedUrl = "www.youtube.com/embed/"+embedUrl.substr(embedUrl.lastIndexOf("/")+1);
				}
			}
		return embedUrl; 
		}
	
	function getresourceType(scope){
		var resourceType='';
		var i = 'lessonDescription-textarea-'+scope.editorIndex;
		try{
			scope.lessonDescription =CKEDITOR.instances[i].getData();
		}catch(err){
			scope.lessonDescription = null;
		}
		if(scope.embedUrl != null && scope.embedUrl != ''){
			resourceType = 'embed';
		}else if(scope.lessonDescription != null && scope.lessonDescription != ''){
			resourceType = 'narrative';
		}
		return resourceType;
	}
	
	function getSectionTitle(scope){
		var sectionTitle= scope.find('.sectionTitle').val();//scope.find('.sectionTitle').html();
		if(sectionTitle.trim()==""){
			scope.find('.section-title-error').html('<liferay-ui:message key="please-enter-title" />');
			scope.find('.section-title-error').show();
			return false;	
		}
		if(sectionTitle.trim().length > 75){
			scope.find('.section-title-error').html('<liferay-ui:message key="maximum-75-characters-allowed" />');
			scope.find('.section-title-error').show();
			return false;	
		}
		return sectionTitle;
	}
	
	$(document).on('blur','input.sectionTitle',function(){
		$(this).parent().parent().parent().find('.section-title-error').hide();
	
		if($(this).val().trim()==""){
			$(this).parent().parent().parent().find('.section-title-error').html('<liferay-ui:message key="please-enter-title" />');
			$(this).parent().parent().parent().find('.section-title-error').show();
		}
		if($(this).val().trim().length > 75){
			$(this).parent().parent().parent().find('.section-title-error').html('<liferay-ui:message key="maximum-75-characters-allowed" />');
			$(this).parent().parent().parent().find('.section-title-error').show();
		}
	});
	
<%-- 		$(document).ready(function(){
			var AllJsonNyuLessonObjectives=<%=request.getAttribute("jsonNyuLessonObjectives")%>;  
			var e = $('#lessonSectionControllerId');
	    	scope = angular.element(e).scope();
	    	scope.$apply(function() {
		    	scope.nyuLessonObjectives = JSON.parse(AllJsonNyuLessonObjectives.jsonNyuLessonObjectives);
		    	scope.load();
	       	});
     
}); --%>
</script> 


<!--  Add Media - Start --> 
<script>
var addMediaTranscriptDialogClose = false;
var addMediaRsrcSpacId = document.getElementById("add_media_rsrc_spc");
var addMediaAutoTranscript='None';
var amConfirmTranscriptModal;
var documentUuidURL = '<%=uuidURL.toString()%>';
var cancelAddMediaModal;
var sectionObj;
var docUuid = '';


function addMedia(obj){
	sectionObj = obj;
	$(obj).closest('.advanced-page').find('.progress-fail-error').hide();
	/* $(obj).closest('.advanced-page').find('.lesson-embed').hide(); */
	$(obj).closest('.advanced-page').find('.section-content-error').hide();
	$(obj).closest('.advanced-page').find('.section-content-error').hide();
} 

function uploadMedia(eventTitle, obj) {
	$(obj).closest('.advanced-page').find('.section-content-error').hide();
	$(obj).closest('.advanced-page').find('.progress-fail-error').hide();
	$(obj).closest('.section-content').find('.upload-media-modal-box').show();
	$(obj).closest('.section-content').find('.media-upload-file-error').hide(); 
}

function addMediaFiles(obj){
	var docTitle = unescape($(obj).parent().find('.mediaFileName').val());
	var encodedDocTitle = escape($(obj).parent().find('.mediaFileName').val());
	var docUrl = $(obj).parent().find('.mediaFilePath').val();
	docUuid = $(obj).parent().find('.mediaDocUuid').val();
	if(docUuid == null || docUuid.trim() == ''){
		docUuid = generateDocUUID(documentUuidURL);
	}	
	$(sectionObj).parent().find('.docUuIdClass').html(docUuid);
	$(sectionObj).parent().find('.resourceIdClass').html($(obj).parent().find('.mediaResourceId').val());
	$(sectionObj).parent().find('.imageUrlClass').html(docUrl);
	$(sectionObj).parent().find('.docTitleClass').html(encodedDocTitle);
	$(sectionObj).parent().find('.docAutoTranscript').html('');
	$(sectionObj).parent().find('.docUploadType').html('existing');
	
	$(sectionObj).closest('.advanced-page').find('.upload-media-file-name').html('<b>'+docTitle+'</b>');
	$(sectionObj).closest('.advanced-page').find('.upload-media-file-name').show();
	$(sectionObj).closest('.advanced-page').find('.upload-media-file-preview').attr('src',docUrl);
	$(sectionObj).closest('.advanced-page').find('.upload-media-file-preview').show();
	
	$(sectionObj).closest('.advanced-page').find('.upload-content .embed-content-player').hide();
	
	$(sectionObj).closest('.advanced-page').find('.delete-btn').show();
	
	$(sectionObj).closest('.advanced-page').find('.upload-media-ready').hide();
	$(sectionObj).closest('.advanced-page').find('.scope-embed-url').val("");
	$(sectionObj).closest('.advanced-page').find('.embed-media-input').val(""); 
	
	docUploaded=true;
	resourceFileModal.hide(); 
}

function cancelAddMedia(eventTitle){
	AUI().use('aui-modal', function(Y) {
  			cancelAddMediaModal = new Y.Modal(
  			{
  				bodyContent: '<p> <liferay-ui:message key="are-you-sure-you-want-to-cancel-the-upload" /> ?</p>', 
  				centered: true,
  				headerContent: null, 
  				modal: true,
  				render: '#add_media_rsrc_spc',
  				width: 350,
  				zIndex: 999,
  				resizable: false,
  				toolbars: {
  					footer: [
  					{
  						label: '<liferay-ui:message key="yes" />',
  						on: {
  							click: function() {
  								uploadAjax.abort();
  								$("#mediaFileUploadFail").hide();
  								$("#mediaUploadFileInprogressId").hide();
  								$('#mediaDivLoading').hide();
  								//$('#divPreviewImage').hide();
  								$('#mediaCancelUpload').hide();
  								$('#mediaProgressbar').hide();
  								$('#mediaProgressNumber').hide();
  								$('#formAddMedia').each(function(){
  								    this.reset();
  								});
  								if(eventTitle != 'cancel')
  									addMediaRsrcSpacId.style.visibility =  "hidden"; 
  								
  								cancelAddMediaModal.hide();
  							}
  						}
  					},
  					{
  						label: '<liferay-ui:message key="cancel" />',
  						on: {
  							click: function() {
  								$("#mediaUploadFileInprogressId").hide();
  								cancelAddMediaModal.hide();
  							}
  						}
  					}
  					]
  				}
  			}
  		).render();
  	  	});
}

function generateDocUUID(uuidURL) {
	var documentUUID = '';
    
	$.ajax({
        url:uuidURL,
        type: 'GET',
        datatype:'text',
        async: false,
        success: function(data){
        	documentUUID = data;	
        }
	});
	
   return documentUUID;
};

setAddMediaFormValues = function (){
	var isFormFilled = true;
	jQuery(':input(:text)').each( function (x, obj ){
		 if ( $("#userfileId").val() == "" ){
			/* if( document.getElementById(namespace + "existingDocPath[]") == null || document.getElementById(namespace + "existingDocPath[]") == 'undefined'){
				$("#mediaSelectUploadFileId").html('<liferay-ui:message key="please-select-a-file-to-upload" />');
				$("#mediaSelectUploadFileId").show();
			} */
			
			isFormFilled = false; 
			return false;
		}
	});
	return isFormFilled;
};

	//Enable Section Content after Whole page is loaded
	$(window).bind("load", function() {
	  $('.section-load').hide();
	});
	
	
	
	function saveObjectives(id){
		var nyuObjIds =  id.parent().parent().find('.nyu-obj-class')
	    var objArray = ''; 
		var selectedNames=''
	      nyuObjIds.each(function(i){
	    	  if($(this).is(':checked')){
	    		  if(objArray.trim() == ''){
	    			  objArray =$(this).val();
	    		  }else{
	    			  objArray = objArray+","+$(this).val();
	    		  }
	    		  selectedNames = selectedNames + '<span class="label label-info">'+$(this).parent().next().html()+'</span>';  
	    	  }
	      });
		id.parent().parent().find('.learn-selected-ids').val(objArray);
		id.parent().parent().parent().parent().parent().find('.learn-selected-names').html(selectedNames);
	}
	
	
	function replaceTextareaAsEditor(i){
		try{
			CKEDITOR.replace(i,{
		        height: 198,
		        width: '100%',
		        toolbar:'simple',
		        removePlugins : 'elementspath' ,
		        resize_enabled: false,
		        customConfig: ''
			});
		}catch(err)
		{}
	}
	
	function showEditorsBySectionIndex(editorIndex){
		replaceTextareaAsEditor("upload-textarea-"+editorIndex);
		replaceTextareaAsEditor("lessonDescription-textarea-"+editorIndex);
		replaceTextareaAsEditor("embed-textarea-"+editorIndex);
	}
	
	//#SESSION EXTEND AND AUTO SAVE
	var globalPortalTimeCalculation ="<%=PropsUtil.get(PropsKeys.SESSION_TIMEOUT)%>";
	globalPortalTimeCalculation = globalPortalTimeCalculation*60*1000;
	
	$(function(){
	    setInterval(function(){
	    	globalPortalTimeCalculation = globalPortalTimeCalculation-1000;
	   		
	    	var checkForAutoSavingExtend = '<%=PortletProps.get("session.minimum.time.for.autosaving.extend")%>';
	   		checkForAutoSavingExtend = checkForAutoSavingExtend*60*1000;
	   		
	   		
	   		if(globalPortalTimeCalculation < checkForAutoSavingExtend){
	   			autoSaving();
	    		sessionKeepAlive();
				globalPortalTimeCalculation ="<%=PropsUtil.get(PropsKeys.SESSION_TIMEOUT)%>";
				globalPortalTimeCalculation = globalPortalTimeCalculation*60*1000;
	    	}
	    },1000);
	});
	
	Liferay.provide(
		    window,
		   'sessionKeepAlive',
		   function(A) {
		    	Liferay.Session.extend();
		   }
	);
	
	function autoSaving(){
		var lessonId = '<%=request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID)%>';
		var resourceType = '';
		var viewLesson=false;
		//$(".processingImg").show();
		$("#mySortableLayout").find('.advanced-page').each(
				function(i, val) {
					var order = i+1;
					var e = $(this);
					viewLesson=false;
					var editorIndex = e.data("index");
					var scope = angular.element(e).scope();
					scope.editorIndex = editorIndex;
					var resourceId = $(this).find('.resourceIdClass').html();
					var imageurl = $(this).find('.imageUrlClass').html();
					var docTitle = $(this).find('.docTitleClass').html();
					var docUuid = $(this).find('.docUuIdClass').html();
					var docAutoTranscript = $(this).find('.docAutoTranscript').html();
					var docUploadType = $(this).find('.docUploadType').html();
					var learningObjIds =$(this).find('.learn-selected-ids').val();
					
					if($(this).find('.media-progress-number').is(':visible')){
						$(".section-process-alert").show();
						return false;
					}else{
						$(".section-process-alert").hide();
					}
					
					scope.sectionTitle=getSectionTitle($(this));
					
					
					scope.embedUrl=processEmbedUrl($(this).find('.scope-embed-url').val());
					if(resourceId!='null' && resourceId!=''){
						resourceType = 'resourceSpace';
					}else{
						resourceType=getresourceType(scope);	
					}
						try{
							scope.lessonDescription=CKEDITOR.instances['upload-textarea-'+editorIndex].getData();
						}catch(err){
							scope.lessonDescription=$(this).find('.scope-upload-text').val();
						}
					if(resourceType != null && resourceType !='' && resourceType !='narrative'){
						$.ajax({
							url : '<%=SaveLessonSections%>',
						  	type : 'POST',
						  	async : false,
						  	data:{
						  		<portlet:namespace/>lessonId:lessonId,
						  		<portlet:namespace/>resourceType:resourceType,
							  	<portlet:namespace/>sectionTitle : scope.sectionTitle,
							  	<portlet:namespace/>lessonDescription : scope.lessonDescription,
							  	<portlet:namespace/>embedUrl : scope.embedUrl,
							  	<portlet:namespace/>resourceId : resourceId,
							  	<portlet:namespace/>imageUrl : imageurl,
							  	<portlet:namespace/>docTitle : unescape(docTitle),
							  	<portlet:namespace/>docUuid : docUuid,
							  	<portlet:namespace/>docAutoTranscript : docAutoTranscript,
							  	<portlet:namespace/>docDescription : scope.docDescription,
							  	<portlet:namespace/>docUploadType : docUploadType,
							  	<portlet:namespace/>learningObjIds : learningObjIds,
							  	<portlet:namespace/>sectionOrder :order,
							  	<portlet:namespace/>autoSave :'true'
							  },
						  	success: function(data){
								viewLesson=true;
							}
						});
					}	
			});
			window.location.href='<%=previewAdvanceLesson%>';
	}
	
</script>


<!--  Add Media - End -->
