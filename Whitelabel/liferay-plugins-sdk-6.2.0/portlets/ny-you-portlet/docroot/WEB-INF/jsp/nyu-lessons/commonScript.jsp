<%@page import="com.nyu.util.Constant"%>
<script type="text/javascript" src = "<%=request.getContextPath()%>/js/commonWidgets.js"></script> 
<script type="text/javascript" src="/<%= Constant.PORTLET_PROP_PORTLET_THEME %>/js/jquery/sortable.js"></script>


<script>
// ONLOAD PAGE SECTION TEMPLATE
	
	
	<%-- function addLessonSection(){
		lessonSectionIndex++;
		var lessonSectionId = "lesson-section-"+lessonSectionIndex;
		var template = $('#lesson-section-content').html().replace("**sectionId**",lessonSectionId);
		var AllJsonNyuLessonObjectives=<%=request.getAttribute("jsonNyuLessonObjectives")%>; 
		$('#mySortableLayout').append(template);
		bindEvent();
		var content = $('#'+lessonSectionId);
		var scope='';
		angular.element(document).injector().invoke(function($compile) {
	         scope = angular.element(content).scope();
	         scope.nyuLessonObjectives = JSON.parse(AllJsonNyuLessonObjectives.jsonNyuLessonObjectives);
	        $compile(content)(scope);
	    });
		scope.$apply(function() {
	    	
       	});
	} --%>
	var lessonSectionIndex=${documentSection.size()};
	var docUploaded=false;
	var resourceFileModal;
	var AllJsonNyuLessonObjectives=<%=request.getAttribute(Constant.JSON_VENDOR_LESSON_OBJECTIVES)%>; 
	function addLessonSection(){
		lessonSectionIndex++;
		var textareaToEditorId = lessonSectionIndex;
		var lessonSectionId = "lesson-section-"+lessonSectionIndex;
		var lessonSectionNumber = "Section "+lessonSectionIndex;
		var template = $('#lesson-section-content').html().replace("**sectionIndexOrder**",lessonSectionIndex).replace("**sectionId**",lessonSectionId).replace("**sectionIndex**",lessonSectionNumber).replace(/#textAreaId#/g,textareaToEditorId);
		//var AllJsonNyuLessonObjectives=<%=request.getAttribute("jsonNyuLessonObjectives")%>; 
		$('#mySortableLayout').append(template);
		$('.adv-content-thumb').attr('src','${lessonImg}');
		bindEvent();
	}
	$(function(){
		if(lessonSectionIndex==0){
			addLessonSection();
		}	
	});
(function(){
	bindEvent();
	var sectionParent = $('#mySortableLayout');
	
	sectionParent.find('.section-content').hide(); 
	
	
	// ANOTHER PAGE TEMPLATE
	//----------------------------------------------------
	$('.add-another-page').on('click',function(){		  
		$('#mySortableLayout').find('.section-content').hide();
		$('#mySortableLayout').find('.expand-add-media').text('Add Text and Media').css('marginRight','-56px');
		addLessonSection();
	}) 
	
	// UPLOAD DROPDOWN 
	//----------------------------------------------------
	sectionParent.on('click','.lesson-upload',function(){ 
		//$('#mySortableLayout').find('.upload-data').hide();
		$(this).closest('.advanced-page').find('.upload-data').toggle(); 
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
		$('#mySortableLayout').find('.expand-add-media').text('Add Text and Media').css('marginRight','-56px');
		
		if(btnText == "Collapse Section") {
			element.text('Add Text and Media');		
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
		var currentContent = currentParent.find('.section-content');
		var editorIndex = element.closest('.advanced-page').data("index");
		showEditorsBySectionIndex(editorIndex);
		$('#mySortableLayout').find('.expand-add-media').text('Add Text and Media').css('marginRight','-56px');
		element.next().text('Collapse Section').css('marginRight','-45px');
		sectionParent.find('.section-content').hide();
		currentContent.show();
		toggleElement(objectPopover, $('.open-objectives'));   
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
//MODAL FOR AD MEDIA

YUI().use('aui-modal', function(Y) {
    resourceFileModal = new Y.Modal(
      {
        contentBox: '#modalContent',
        centered: true,		
        destroyOnHide: false,
        headerContent: '<h3><b>Add from Archive</b></h3>',  
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

function bindEvent(){	
	
	//CLOSE CUSTOM MODAL
	//----------------------------------------------------
	$('.custom-modal-box').hide();	
	$('a.cancel-upload-btn').click(function(event){ 
		$(this).closest('.section-content').find('.upload-media-modal-box').hide();	
		event.preventDefault();
	});
	
	//DELETE LESSION
	//----------------------------------------------------
	$('.delete-lesson').on('click',function(event){
		confirmModal('Do you want to delete the section ?',this);
		/* event.preventDefault();
		if(confirmModal('Do you want to delete the section ?')) {
			$(this).closest('.advanced-page').remove();	
		} */
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
		/* $(this).closest('.section-content').find('.embed-content').removeClass('hidden');
		$(this).parent().find('.btn-availability').attr("disabled","true"); */
		var editorIndex = $(this).closest('.advanced-page').data("index");
		if(CKEDITOR.instances['upload-textarea-'+editorIndex].getData().trim() == ''){
			CKEDITOR.instances['upload-textarea-'+editorIndex].setData(CKEDITOR.instances['upload-textarea-'+editorIndex].getData());
		}
		//$(this).removeAttr("disabled");
		/*$(this).closest('.section-content').find('.initial-content').addClass('hidden');*/
		$(this).closest('.advanced-page').find('.embed-error').hide();
		//$(this).closest('.advanced-page').find('.upload-media-btn').hide();
		//$(this).closest('.advanced-page').find('.add-media-btn').hide();
		//$(this).closest('.advanced-page').find('.upload-content').hide();  
		$(this).closest('.advanced-page').find('.section-content-error').hide();
		$(this).closest('.advanced-page').find('.modalbody .embed-url-empty-error').hide();
		$(this).closest('.advanced-page').find('.embed-media-modal-box').fadeIn();			
		$(this).closest('.advanced-page').find('.embed-media-input').val(existinglUrl); 
	});
	
	$('.embed-media-url').on('click', function(){ 
		var embelUrl = $(this).closest('.advanced-page').find('.embed-media-input').val();
		var isWrongUrl = true;
		$(this).closest('.advanced-page').find('.section-content-error').hide();
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
			$(this).closest('.advanced-page').find('.upload-content .iframeClass').hide();
			$(this).closest('.advanced-page').find('.upload-media-ready').hide();
			$(this).closest('.advanced-page').find('.upload-media-file-name').hide();
			
			$(this).closest('.advanced-page').find('.resourceIdClass').empty();
			$(this).closest('.advanced-page').find('.docUuIdClass').empty();
			$(this).closest('.advanced-page').find('.imageUrlClass').empty();
			$(this).closest('.advanced-page').find('.docTitleClass').empty();
			$(this).closest('.advanced-page').find('.docAutoTranscript').empty();
			$(this).closest('.advanced-page').find('.docUploadType').empty();
			
			/* $(this).closest('.advanced-page').find('.embed-content .upload-media-file-preview').hide(); 
			$(this).closest('.advanced-page').find('.embed-content .embed-content-player').show();*/
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
		/* $(this).closest('.embed-content').find('.embed-error').remove(); */
		
		if(embedUrl==null || embedUrl==''){
			/* $(this).closest('.embed-content').append('<span class="embed-error" style="color:red">*please Enter Url</span>') */
			$(this).closest('.embed-content').find('.embed-error').show();
		}else{
			$(this).closest('.embed-content').addClass('hidden'); 
			$(this).closest('.section-content').find('.initial-content').removeClass('hidden');
		}
	});
	
	// ADD TEXT
	//----------------------------------------------------
	$('.lesson-add-text').on('click',function(){
		$(this).parent().find('.btn-availability').attr("disabled","true");
		$(this).removeAttr("disabled");
		var editorIndex = $(this).closest('.advanced-page').data("index");
		replaceTextareaAsEditor("lessonDescription-textarea-"+editorIndex);
		$(this).closest('.section-content').find('.text-content').removeClass('hidden');
		$(this).closest('.section-content').find('.initial-content').addClass('hidden');
	});
	
	// ADD TEXT DELETE
	//----------------------------------------------------
	$('.text-delete').on('click',function(){
		$(this).closest('.text-content').find('textarea').val('');
		$(this).closest('.text-content').addClass('hidden');  
		var editorIndex = $(this).closest('.advanced-page').data("index");
		CKEDITOR.instances['lessonDescription-textarea-'+editorIndex].setData('');
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
			$(this).closest('.text-content').append('<span class="text-content-error" style="color:red">*please Enter text</span>');
		}else{
			$(this).closest('.text-content').addClass('hidden');  
			$(this).closest('.section-content').find('.initial-content').removeClass('hidden');
		}
	});
	 
	// Sortable Section
	//----------------------------------------------------
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
 
	$('.section-title').on('click', '.insert-text', function(e) {
		e.stopPropagation();  
		/* var existVal=$(this).html().trim();
		if(existVal=='(Insert title)'){
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
	
	//Section wise Upload Media
	var uploadMediaAjax;
	$( ".upload-media-form" ).submit(function( event ) {
		event.preventDefault();
		//alert( $(this).closest('.advanced-page').html() );
		//alert( $(this).html() );
		
		var form = $(this)[0]; 
		
		if($(this).find('.mediaFileName').val()==''){
			$(".media-upload-file-error").html("Please select a file to upload");
			$(".media-upload-file-error").show();
			return false;
		}else{
			$(".media-upload-file-error").hide();
			var isCorrectFormat = checkUploadedFile($(this).find('.mediaFileName').val());
			if(!isCorrectFormat){
				$(".media-upload-file-error").html("Please upload only supported formats");
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
		//$(form).closest('.advanced-page').find('.lesson-embed').hide();
		
		$(form).closest('.advanced-page').find('.add-media-btn').attr('disabled', 'disabled');
		$(form).closest('.advanced-page').find('.upload-media-btn').attr('disabled', 'disabled');
		$(form).closest('.advanced-page').find('.lesson-embed').attr('disabled', 'disabled');
				
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
		            alert("Upload progress is not supported.");
		        }
		       return myXhr;
			} 
		}).done(function(data) {
			var responseObj = jQuery.parseJSON(data);
			var encodedTitle = escape(docTitle);
			var currentSection = $(form).closest('.advanced-page');
			docUuid = generateDocUUID(documentUuidURL);
			$(sectionObj).closest('.upload-content').find('.iframeClass').hide();
			if(currentSection.find('.resourceIdClass').html()!='' && currentSection.find('.resourceIdClass').html() > 0){
				currentSection.find('.resourceReplaced').html('yes');
			}
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
			
			currentSection.find('.iframeClass').hide();
			
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
			alert("error "+thrownError)
			$(form)[0].reset();
			docUploaded=false;
		
		});
		function checkUploadedFile(filename){
			var extSplit = filename.split('.');
			var extReverse = extSplit.reverse();
			var ext = extReverse[0].toLowerCase();
			if(ext === "mp4" || ext === "zip" || ext === "pdf" || ext === "txt" ||ext === "jpg" ||
					ext === "jpeg" || ext === "png"){
			  return true;
			} else {
			  	return false;
			}
		}
		function showAddMediaProgress(evt) {
			$(form).closest('.advanced-page').find('.media-progress-number').show();
			//Session Auto Extend While Uploading<Start>
			var checkForUploadExtend = '<%=PortletProps.get("session.minimum.time.for.uploading.extend")%>';
			checkForUploadExtend = checkForUploadExtend*60*1000;
			if(globalPortalTimeCalculation < checkForUploadExtend){
				sessionKeepAlive();
				globalPortalTimeCalculation ="<%=PropsUtil.get(PropsKeys.SESSION_TIMEOUT)%>";
				globalPortalTimeCalculation = globalPortalTimeCalculation*60*1000;
			}
			//Session Auto Extend While Uploading<END>
			if (evt.lengthComputable) {
				$(form).closest('.advanced-page').find('.upload-media-ready').hide();
				$(form).closest('.advanced-page').find('.media-progress-number').show();
				$(form).closest('.advanced-page').find('.progress').show();
				//$(form).closest('.advanced-page').find('.media-progress-bar').show();
	        	//$(form).closest('.advanced-page').find('.upload-media-cancel').show();
				var percentComplete = Math.round(evt.loaded * 100 / evt.total);
				$(form).closest('.advanced-page').find('.media-progress-number').html(percentComplete.toString() + '%');
				$(form).closest('.advanced-page').find('.progress .bar').css("width",percentComplete.toString()+"%");
				
				if(percentComplete == 100 ){
					$(form).closest('.advanced-page').find('.media-progress-number').hide();
					//$(form).closest('.advanced-page').find('.media-progress-bar').hide();
					$(form).closest('.advanced-page').find('.progress').hide();
					//$(form).closest('.advanced-page').find('.upload-media-cancel').hide();
					//$(form).closest('.advanced-page').find('.upload-media-ready').show();
				}
			}
			else {
				$(form).closest('.advanced-page').find('.media-progress-number').html('unable to compute');
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
		   $(this).closest('.advanced-page').find('.upload-media-file-preview').attr('src','<%=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.CONTENT_PREVIEW_PLACEHOLDER%>');
			
		   $(this).hide();
		   
		   $(this).closest('.advanced-page').find('.media-progress-number').empty();
		   $(this).closest('.advanced-page').find('.media-progress-number').hide();
		 //  $(form).closest('.advanced-page').find('.media-progress-bar').hide();
		 	$(form).closest('.advanced-page').find('.progress').hide();
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
		  						label: 'Ok',
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
}
	
	
	
 // End bindEvent function

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
	  
	var existingSecIds = '${sectionAndDocIdArray}';
	  function saveSections(){
		  	var validteSection = validateSectionData();
			var lessonId = '<%=request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID)%>';
			var resourceType = '';
			var viewLesson=false;
			var totalLength = $("#mySortableLayout .advanced-page ").length;
			var sectionIndex = 0;
			var currentSecIds = [];
			if(validteSection){
			$(".processingImg").show();
			$("#mySortableLayout").find('.advanced-page').each(
				function(i, val) {
					sectionIndex = sectionIndex + 1;
					var order = i+1;
					var e = $(this);
					viewLesson=false;
					var scope = angular.element(e).scope();
					var sectionId=e.data("sectionid");
					var documentId=e.data("documentid");
					var editorIndex = e.data("index");
					var secObj ={};
					secObj ["sectionId"] = sectionId;
					secObj ["documentId"] = documentId;
					currentSecIds.push(secObj);
					var isResourceReplaced = $(this).find('.resourceReplaced').html();
					var resourceId = $(this).find('.resourceIdClass').html();
					var imageurl = $(this).find('.imageUrlClass').html();
					var docTitle = $(this).find('.docTitleClass').html();
					var docUuid = $(this).find('.docUuIdClass').html();
					var docAutoTranscript = $(this).find('.docAutoTranscript').html();
					var learningObjIds =$(this).find('.learn-selected-ids').val();
					
					
					scope.sectionTitle=getSectionTitle($(this));
					if(scope.sectionTitle == null){
						return false;
					}
					
					scope.embedUrl=processEmbedUrl($(this).find('.scope-embed-url').val());
					if(resourceId!=null && resourceId!='' && resourceId>0){
						resourceType = 'resourceSpace';
						
					}else{
						resourceType=getresourceType($(this));	
					}
					try{
						//scope.lessonDescription = CKEDITOR.instances['lessonDescription-textarea-'+editorIndex].getData();
						/* if(resourceType=='embed'){
							scope.lessonDescription=CKEDITOR.instances['embed-textarea-'+editorIndex].getData();
						}else if(resourceType=='resourceSpace'){
							scope.lessonDescription=CKEDITOR.instances['upload-textarea-'+editorIndex].getData();
						} */
						scope.lessonDescription=CKEDITOR.instances['upload-textarea-'+editorIndex].getData();
					}catch(err){
							//scope.lessonDescription =  $(this).find('.scope-lesson-description').val();
							/* if(resourceType=='embed'){
								scope.lessonDescription=$(this).find('.scope-embed-text').val();
							}else if(resourceType=='resourceSpace'){
								scope.lessonDescription=$(this).find('.scope-upload-text').val();
							} */
							
						scope.lessonDescription=$(this).find('.scope-upload-text').val();
					}
					$.ajax({
						url : '<%=SaveLessonSections%>',
					  	type : 'POST',
					  	async : false,
					  	data:{
					  		<portlet:namespace/>lessonId:lessonId,
					  		<portlet:namespace/>sectionId:sectionId,
					  		<portlet:namespace/>documentId:documentId,
					  		<portlet:namespace/>resourceType:resourceType,
						  	<portlet:namespace/>sectionTitle : scope.sectionTitle,
						  	<portlet:namespace/>lessonDescription : scope.lessonDescription,
						  	<portlet:namespace/>embedUrl : scope.embedUrl,
						  	<portlet:namespace/>resourceReplaced : isResourceReplaced,
						  	<portlet:namespace/>resourceId : resourceId,
						  	<portlet:namespace/>imageUrl : imageurl,
						  	<portlet:namespace/>docTitle : unescape(docTitle),
						  	<portlet:namespace/>docUuid : docUuid,
						  	<portlet:namespace/>docAutoTranscript : docAutoTranscript,
						  	<portlet:namespace/>docDescription : scope.docDescription,
						  	<portlet:namespace/>sectionLength : totalLength,
						  	<portlet:namespace/>sectionIndex : sectionIndex,
						  	<portlet:namespace/>existingIds : existingSecIds,
						  	<portlet:namespace/>currentSecIds:JSON.stringify(currentSecIds),
						  	<portlet:namespace/>learningObjIds : learningObjIds,
						  	<portlet:namespace/>sectionOrder :order
						  	
						  },
					  	success: function(data){
							if(sectionIndex == totalLength){
								if('${fromPreviewEdit}' == 'yes'){
									window.location.href = '${previewLessonUrl}';
								}else{
									window.location.href = '${reloadEditpage}';
								}
								
							}
						}
					});
			});
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
					//lessonDescEditor = $(this).find('.scope-lesson-description').val();
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
						&& ($(this).find('.resourceIdClass').text().trim()=='' || $(this).find('.resourceIdClass').text().trim()=='0')
						&& lessonDescEditor.trim()==''){
						//$(this).find('.section-content-error').html('Add any section content.');
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
			 	embedUrl = embedUrl.replace("<%=Constant.HTTPS_DOUBLE_SLASH%>","");
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
		var i = 'lessonDescription-textarea-'+scope.data("index");
		var lessonDescEditor;
		try{
			lessonDescEditor =CKEDITOR.instances[i].getData();
		}catch(err){
			lessonDescEditor = null;
		}
		if(scope.find('.scope-embed-url').val() != null && scope.find('.scope-embed-url').val() != ''){
			resourceType = 'embed';
		}else if(lessonDescEditor != null && lessonDescEditor.trim() != ''){
			resourceType = 'narrative';
		}
		return resourceType;
	}
	
	function getSectionTitle(scope){
		//var sectionTitle=scope.find('.sectionTitle').html();
		var sectionTitle= scope.find('.sectionTitle').val();
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
		scope.find('.sectionTitleErrorId').empty();
		
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
	/* $(obj).closest('.advanced-page').find('.lesson-embed').hide(); */
	$(obj).closest('.advanced-page').find('.iframe').hide();
	$(obj).closest('.advanced-page').find('.section-content-error').hide();
} 

function uploadMedia(eventTitle, obj) {
	$(obj).closest('.advanced-page').find('.section-content-error').hide();
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
	if($(sectionObj).parent().find('.resourceIdClass').html()!='' && $(sectionObj).parent().find('.resourceIdClass').html() > 0){
		$(sectionObj).parent().find('.resourceReplaced').html('yes');
	}
	$(sectionObj).parent().find('.resourceIdClass').html($(obj).parent().find('.mediaResourceId').val());
	$(sectionObj).parent().find('.imageUrlClass').html(docUrl);
	$(sectionObj).parent().find('.docTitleClass').html(encodedDocTitle);
	$(sectionObj).parent().find('.docAutoTranscript').html('');
	$(sectionObj).parent().find('.docUploadType').html('existing');

	$(sectionObj).closest('.upload-content').find('.iframeClass').hide();
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
	AUI().use(
  		'aui-modal',
  		function(Y) {
  			cancelAddMediaModal = new Y.Modal(
  			{
  				bodyContent: '<p> <Strong>Are you sure you want to cancel the upload ?</Strong></p>', centered: true,
  				headerContent: null, 
  				modal: true,
  				render: '#add_media_rsrc_spc',
  				width: 350,
  				zIndex: 999,
  				resizable: false,
  				toolbars: {
  					footer: [
  					{
  						label: 'Yes',
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
  						label: 'Cancel',
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
				$("#mediaSelectUploadFileId").html("Please select a file to upload");
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
	


YUI().use('aui-tabview', function(Y) {
	new Y.TabView(
	  {
		srcNode: '#nyYouTab'
	  }
	).render();  
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
	        height:198,
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
	//replaceTextareaAsEditor("lessonDescription-textarea-"+editorIndex);
	//replaceTextareaAsEditor("embed-textarea-"+editorIndex);
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
		var totalLength = $("#mySortableLayout .advanced-page ").length;
		var sectionIndex = 0;
		var currentSecIds = [];
		
		$(".processingImg").show();
		$("#mySortableLayout").find('.advanced-page').each(
			function(i, val) {
				sectionIndex = sectionIndex + 1;
				var order = i+1;
				var e = $(this);
				viewLesson=false;
				var scope = angular.element(e).scope();
				var sectionId=e.data("sectionid");
				var documentId=e.data("documentid");
				var editorIndex = e.data("index");
				var secObj ={};
				secObj ["sectionId"] = sectionId;
				secObj ["documentId"] = documentId;
				currentSecIds.push(secObj);
				var isResourceReplaced = $(this).find('.resourceReplaced').html();
				var resourceId = $(this).find('.resourceIdClass').html();
				var imageurl = $(this).find('.imageUrlClass').html();
				var docTitle = $(this).find('.docTitleClass').html();
				var docUuid = $(this).find('.docUuIdClass').html();
				var docAutoTranscript = $(this).find('.docAutoTranscript').html();
				var learningObjIds =$(this).find('.learn-selected-ids').val();
				
				
				scope.sectionTitle=getSectionTitle($(this));
				
				scope.embedUrl=processEmbedUrl($(this).find('.scope-embed-url').val());
				if(resourceId!=null && resourceId!='' && resourceId>0){
					resourceType = 'resourceSpace';
					
				}else{
					resourceType=getresourceType($(this));	
				}
				try{
					//scope.lessonDescription = CKEDITOR.instances['lessonDescription-textarea-'+editorIndex].getData();
					/* if(resourceType=='embed'){
						scope.lessonDescription=CKEDITOR.instances['embed-textarea-'+editorIndex].getData();
					}else if(resourceType=='resourceSpace'){
						scope.lessonDescription=CKEDITOR.instances['upload-textarea-'+editorIndex].getData();
					} */
					scope.lessonDescription=CKEDITOR.instances['upload-textarea-'+editorIndex].getData();
				}catch(err){
						//scope.lessonDescription =  $(this).find('.scope-lesson-description').val();
						/* if(resourceType=='embed'){
							scope.lessonDescription=$(this).find('.scope-embed-text').val();
						}else if(resourceType=='resourceSpace'){
							scope.lessonDescription=$(this).find('.scope-upload-text').val();
						} */
						
					scope.lessonDescription=$(this).find('.scope-upload-text').val();
				}
				
				if(resourceType != null && resourceType !='' && resourceType !='narrative'){
				$.ajax({
					url : '<%=SaveLessonSections%>',
				  	type : 'POST',
				  	async : false,
				  	data:{
				  		<portlet:namespace/>lessonId:lessonId,
				  		<portlet:namespace/>sectionId:sectionId,
				  		<portlet:namespace/>documentId:documentId,
				  		<portlet:namespace/>resourceType:resourceType,
					  	<portlet:namespace/>sectionTitle : scope.sectionTitle,
					  	<portlet:namespace/>lessonDescription : scope.lessonDescription,
					  	<portlet:namespace/>embedUrl : scope.embedUrl,
					  	<portlet:namespace/>resourceReplaced : isResourceReplaced,
					  	<portlet:namespace/>resourceId : resourceId,
					  	<portlet:namespace/>imageUrl : imageurl,
					  	<portlet:namespace/>docTitle : unescape(docTitle),
					  	<portlet:namespace/>docUuid : docUuid,
					  	<portlet:namespace/>docAutoTranscript : docAutoTranscript,
					  	<portlet:namespace/>docDescription : scope.docDescription,
					  	<portlet:namespace/>sectionLength : totalLength,
					  	<portlet:namespace/>sectionIndex : sectionIndex,
					  	<portlet:namespace/>existingIds : existingSecIds,
					  	<portlet:namespace/>currentSecIds:JSON.stringify(currentSecIds),
					  	<portlet:namespace/>learningObjIds : learningObjIds,
					  	<portlet:namespace/>sectionOrder :order,
					  	<portlet:namespace/>autoSave :'true'
					  	
					  },
				  	success: function(data){
						if(sectionIndex == totalLength){
														
						}
					}
				});
			}else{
				$(this).remove();
				totalLength = totalLength-1;
				sectionIndex = sectionIndex-1;
			}
		});
		if('${fromPreviewEdit}' == 'yes'){
			window.location.href = '${previewLessonUrl}';
		}else{
			window.location.href = '${reloadEditpage}';
		} 
	
}

</script>
<c:if test="${not empty userGroupArray || not empty userArray}">
	<script>
	$(function(){
	YUI().use('aui-modal','node-event-simulate','aui-tabview', function(Y) {
	    //TAB for Publish lesson
	    var publishLessonTab = new Y.TabView({ srcNode: '#publishTab' }); 
	    publishLessonTab.render();
	    
	    //MODAL for Publish lesson
	    var modal = new Y.Modal(
	      {
	                    contentBox: '#publishModalContent',
	                    centered: true,                 
	                    destroyOnHide: false,
	                    headerContent: '<h3 class="text-center"> Publish Lesson </h3>',  
	                    modal: true,
	                    render: '#publishModal', 
	                    visible: false,
	                    width: 350,
	                    resizable: false
	      }
	    ).render(); 
	    
	    //Reset the modal box
	    Y.one('#publishDialogue').on('click', function() {
	                    modal.show(); 
	                    publishLessonTab.disableTab(1);
	                    Y.one('#publishTab.publish-lesson li:first-child').simulate('click');
	                    Y.one('#publishLessonBack').setStyle('display', 'none'); 
	                    Y.one('#publishLessonPublish').setStyle('display', 'none');  
	                    Y.one('#publishLessonNext').setStyle('display', 'inline-block');
	                    Y.one('#groupAndInvitation').setStyle('display', 'none');
	                    Y.one('#ShareWhere ul.unstyled').setStyle('display', 'inline-block');                                                         
	    });
	    
	    //Hiding modal box on click of cancel and publish button
	    Y.one('#publishLessonCancel').on('click',function(){
	    	Y.one('#publishTab.publish-lesson li:first-child').simulate('click');
	    	modal.hide();  
	    }); 
	    Y.one('#publishLessonPublish').on('click',function(){ modal.hide(); });      
	    
	    //On Click of back button hidding back and publish button with share where? tab
	    Y.one('#publishLessonBack').on('click',function(){ 
	                    this.setStyle('display', 'none');
	                    Y.one('#publishTab.publish-lesson li:first-child').simulate('click');
	                    Y.one('#publishLessonPublish').setStyle('display', 'none'); 
	                    Y.one('#publishLessonNext').setStyle('display', 'inline-block');
	    });
	    
	    //On Click of next button showing back and publish button with permission tab
	    Y.one('#publishLessonNext').on('click',function(){ 
	                    publishLessonTab.enableTab(1);
	                    this.setStyle('display', 'none');
	                    Y.one('#publishTab.publish-lesson li:last-child').simulate('click');
	                    Y.one('#publishLessonPublish').setStyle('display', 'inline-block');
	                    Y.one('#publishLessonBack').setStyle('display', 'inline-block'); 
	    }); 
	    
	    //On Click of Share Where? TAB button hiding back and publish button
	    Y.one('#publishTab.publish-lesson li:first-child').on('click',function(){ 
	                    Y.one('#publishLessonBack').setStyle('display', 'none'); 
	                    Y.one('#publishLessonPublish').setStyle('display', 'none'); 
	                    Y.one('#publishLessonNext').setStyle('display', 'inline-block');
	    });           
	    
	    //On Click of Share Where? TAB content showing permission tab 
	    Y.all('#ShareWhere li.permission-tab a').on('click',function(){ 
	                    Y.one('#publishLessonNext').setStyle('display', 'none'); 
	                    Y.one('#publishTab.publish-lesson li:last-child').simulate('click');
	                    Y.one('#publishLessonPublish').setStyle('display', 'inline-block');
	                    Y.one('#publishLessonBack').setStyle('display', 'inline-block'); 
	    }); 
	    
	}); 
	
	$('#privateList a').on('click', function(){
	    $(this).closest('ul.unstyled').hide();
	    $('#groupAndInvitation').show();
	    $('#publishLessonNext').hide();  
	    return false;
	}); 
	
	$('#ShareWhere li a').on('click', function(){ 
		$('#ShareWhere li a.active').removeClass('active');
		$(this).addClass('active');	
	});
	
	$('#Permissions li a').on('click', function(){ 
		$('#Permissions li a.active').removeClass('active');
		$(this).addClass('active');	
	});
	
	$('#groupSelected').on('click',function(){
		var userGroupId = '';
		var userId = '';
		if($('#groupAndInvitation #userGroupRadio').is(':checked')){
			$('#groupAndInvitation .userGroup input.checkbox').each(function(i){
				if($(this)[0].checked){
					if(userGroupId == ''){
						userGroupId =$(this).val();
					}else{
						userGroupId = userGroupId+','+$(this).val();
					}
				}
			});
			if(userGroupId.trim() == ''){
				<portlet:namespace/>customAlert('please select user Group');
			}else{
				$('#ShareWhere li a.active').removeClass('active');
				$('#ShareWhere li a.private').addClass('active');
				$('#publishLessonNext').show(); 
				$('#ShareWhere li #selectedUserGroups').val(userGroupId);
				$('#groupAndInvitation').hide().prev().show(); 
			}
		}else if($('#groupAndInvitation #userRadio').is(':checked')){
			$('#groupAndInvitation .user input.checkbox').each(function(i){
				if($(this)[0].checked){
					if(userId == ''){
						userId =$(this).val();
					}else{
						userId = userId+','+$(this).val();
					}
				}
			});
			if(userId.trim() == ''){
				<portlet:namespace/>customAlert('please select user');
			}else{
				$('#ShareWhere li a.active').removeClass('active');
				$('#ShareWhere li a.private').addClass('active');
				$('#publishLessonNext').show();
				$('#ShareWhere li #selectedUsers').val(userId);
				$('#groupAndInvitation').hide().prev().show(); 
			}
		}else{
			<portlet:namespace/>customAlert('please select sharing category');
		}
	});
	
	$('#groupSelectedCancel').on('click',function(){
		$('#ShareWhere li a.active').removeClass('active');
		$('#ShareWhere li a.public').addClass('active');
		$('#publishLessonNext').show();
		$('#groupAndInvitation').hide().prev().show();
	});
	
	$('#groupAndInvitation #userRadio').on('click',function(){
		$('#groupAndInvitation .userGroup .content').addClass('hide');
		$('#groupAndInvitation #previewUserGroupList').addClass('hide');
		$('#groupAndInvitation #previewUserList').removeClass('hide');
		$('#groupAndInvitation .user .content').removeClass('hide');
		
	});
	
	$('#groupAndInvitation #userGroupRadio').on('click',function(){
		$('#groupAndInvitation .userGroup .content').removeClass('hide');
		$('#groupAndInvitation #previewUserGroupList').removeClass('hide');
		$('#groupAndInvitation #previewUserList').addClass('hide');
		$('#groupAndInvitation .user .content').addClass('hide');
	});
	
	var userGroupArray =${userGroupArray};
	var lessonPrivacy = '${privacy}';
	var lessonPermission = '${permission}';
	var publishWithId = '${hiddenUserGroupIds}';
	if(publishWithId != null && publishWithId != ''){
		$('#ShareWhere li #selectedUserGroups').val('${hiddenUserGroupIds}');
	}
	if(lessonPrivacy != null && lessonPrivacy != ''){
		if(lessonPrivacy == 'private'){
			$('#ShareWhere li a.active').removeClass('active');
			$('#ShareWhere li a.private').addClass('active');
			$('#ShareWhere li #selectedUserGroups').val('${hiddenUserGroupIds}');
			$('#groupAndInvitation #userGroupRadio').attr('checked','checked');
			$('#groupAndInvitation .userGroup .content').removeClass('hide');
			$('#groupAndInvitation #previewUserGroupList').removeClass('hide');
			$('#groupAndInvitation #previewUserList').addClass('hide');
		}else if(lessonPrivacy == 'user'){
			$('#ShareWhere li a.active').removeClass('active');
			$('#ShareWhere li a.private').addClass('active');
			$('#ShareWhere li #selectedUsers').val('${hiddenUserIds}');
			$('#groupAndInvitation #userRadio').attr('checked','checked');
			$('#groupAndInvitation .user .content').removeClass('hide');
			$('#groupAndInvitation #previewUserGroupList').addClass('hide');
			$('#groupAndInvitation #previewUserList').removeClass('hide');
		}else if(lessonPrivacy == 'NYOU'){
			$('#ShareWhere li a.active').removeClass('active');
			$('#ShareWhere li a.nyyou').addClass('active');
		}else{
			$('#ShareWhere li a.active').removeClass('active');
			$('#ShareWhere li a.public').addClass('active');
		}
	}
	if(lessonPermission != null && lessonPermission != ''){
		if(lessonPermission == 'view_reuse'){
			$('#Permissions li a.active').removeClass('active');
			$('#Permissions li a.view_reuse').addClass('active');
		}else if(lessonPermission == 'view_reuse_attribution'){
			$('#Permissions li a.active').removeClass('active');
			$('#Permissions li a.view_reuse_attribution').addClass('active');	
		}else if(lessonPermission == 'view'){
			$('#Permissions li a.active').removeClass('active');
			$('#Permissions li a.view').addClass('active');
			if($('#Permissions li').hasClass('voilating')){
				$('#Permissions li a.active').removeClass('active');
				$('#Permissions li a.view_reuse').addClass('active');
			}
		}
	}
	var e = $('.userGroupListController');
	var scope = angular.element(e).scope();
	scope.userGroupArray = userGroupArray;
	scope.userArray = ${userArray};
	scope.$apply(function() {});
	});
	
	function <portlet:namespace/>customAlert(data){
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
	</script>
</c:if>