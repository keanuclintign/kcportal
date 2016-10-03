<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<script src='<%=themeDisplay.getPathThemeJavaScript()%>/jquery/jquery-1.11.0.min.js' type="text/javascript"></script>
<portlet:resourceURL var="addSlideURL" id="addSlide" ></portlet:resourceURL>

<portlet:resourceURL var="editSlideURL" id="editSlide" ></portlet:resourceURL>

<portlet:renderURL var="uploadImage" windowState="pop_up">
	<portlet:param name="action" value="uploadImage" />
</portlet:renderURL>

<portlet:renderURL var="showSlidesURL" windowState="normal"/>

<portlet:resourceURL var="deleteSlideImageURL" id="deleteSlideImageURL" /> 
<div style="display: none">	
	<liferay-ui:input-editor name="discussionMessage" initMethod="" skipEditorLoading="false"
							toolbarSet="edit-in-place"  ></liferay-ui:input-editor>	
</div>
<div id="addSliderContent"> 	
	<div class="slide-message alert alert-success" style="margin: 15px; display: none;"> </div>
	<form action="#" onSubmit="event.preventDefault()" method="post" id="addUpdateSlideForm" enctype="multipart/form-data" name="addUpdateSlide" class="add-update-slide-form">
		<div class="control-group"> 
			<p id="noImageDescErrorId" style="display: none; color: red;">Please upload an image or enter content.</p>
			<label for="uploadImage" class="control-label"> Upload image </label>
			<!-- <input type="file" class="field input-block-level" id="uploadImage" name="uploadImage"> -->
			<img src="${slideImg}" id="slideImageId" style="height: 100px; width: 138px; margin-bottom: 5px;" class="img-polaroid" alt=""></img><br></br>
			<span class="btn btn-default normal" onclick="<portlet:namespace />uploadImage('<%=uploadImage%>','Upload Image')">Change</span>
			<span class="btn btn-default normal" id="deleteButtonId" data-id='${slideId}' onclick="deleteSlideImage(this)">Delete</span>
			 <aui:input id="thumbnailUpload"  name="file" type="hidden" label="Add Thumbnail" /> 
			 <aui:input id="fileUpload" name="dummy" type="hidden" label="Add Thumbnail" />
		</div>
			
			
		<div class="control-group"> 
			<aui:input name = "imageLink" type="text" label = "Link for Image:" value="${imageLink}"/>
			<p id="urlPatternErrorId" style="display: none; color: red;">Please enter the valid url.</p>
			<label for="uploadContent" class="control-label"> Content </label>
			<%-- <aui:input type="textarea" name="uploadContent" id="uploadContentId" cssClass="field input-block-level slide-content" label=""/> --%>
			<!-- <textarea class="field input-block-level" name="uploadContent" id="uploadContent"> </textarea>  -->
			<!-- <textarea name="slide-content-textarea" id="slide-content-textarea" class="field input-block-level" ></textarea> -->
			<textarea id="slide-content-textarea" name="slide-content-textarea" cols="" rows="">${slideDescription}</textarea>
			<aui:input type="hidden"  name="description" id="description"/>
			<aui:input type="hidden"  name="slideId" id="slideId" value="${slideId}"/>
			<p id="enterDescErrorId" style="display: none; color: red;">Please enter content.</p>
			<p id="descLengthErrorId" style="display: none; color: red;">Maximum 1000 characters are allowed.</p>
		</div>
		
		<div class="controls">
           	<label class="checkbox">
            	<input type="checkbox" name="isPositionSelected" id="isPositionSelected" class="slide-position-checkbox"> Position the description
            </label>
	        <div style="display: none;" class="position-radio-div"> 
	        	<!-- <label class="radio"> -->  
				<div class="control-group" id="contentPosition">  
					<label class="radio"> 
					<input type="radio" class="field position-right-radio" name="optionsRadios" value="padding-left" id="optionsRadiosLeft">
					Right </label>
					
					<label class="radio"> 
					<input type="radio" class="field position-left-radio" name="optionsRadios" value="padding-right" id="optionsRadiosRight">
					Left </label>
				</div>
			</div>
        </div>
		
		<footer style="background: #e4e4e4; padding: 15px;">
			<div class="text-right"> 
				<a href="javascript:void(0)" class="btn candel-slide-modal normal"> Cancel </a>
				<!-- <a href="#" class="btn btn-primary" id="addNewSlide" onclick="addHeaderSlide()"> Add </a>  -->
				<!-- <button type="button" class="btn btn-primary" id="addNewSlide" name="addNewSlide">Add</button> -->
				<c:if test="${!isEditSlide}">
				<aui:button type="submit" id="addNewSlide" name="addNewSlide" cssClass="upload-media-sumit normal" value="Add" />
				</c:if>
				<c:if test="${isEditSlide}">
				<aui:button type="submit" id="updateSlide" name="updateSlide" cssClass="upload-media-sumit normal" value="Update" />
				</c:if>
			</div>
		</footer>
		<!-- <div class="control-group"> 
			<label for="selectCollaborators" class="control-label"> Slide Position </label>
			<input type="text" class="field input-block-level">
		</div> -->
	</form>   
</div>  

<script type="text/javascript">

$(".add-update-slide-form" ).on('submit',function( event ) {
	
	var ckData = CKEDITOR.instances["slide-content-textarea"].getData();
	$("#<portlet:namespace/>description").val(ckData);
	if(!validateForm()){
		//addSlider.show();
		return false;
	}else{
		
		$("#enterDescErrorId").hide();
		$("#descLengthErrorId").hide();
		
		CKEDITOR.instances["slide-content-textarea"].setData("");
		
		var fd = new FormData($(this)[0]);
		$.ajax({
			url: '<%=addSlideURL%>',
			type: 'POST',
			data: fd,
            processData: false,  // tell jQuery not to process the data
            contentType: false   // tell jQuery not to set contentType
			
		}).done(function(data) { 
			//addSlider.hide();
			$("#slideImageId").attr("src",'<%=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER%>');
			$(".slide-position-checkbox").removeAttr("checked");
			$(".position-right-radio").removeAttr("checked");
			$(".position-left-radio").removeAttr("checked");
			$('.position-radio-div').hide();
			
			if(data=='update-success'){ 
				$( ".slide-message" ).text( "Slide updated successfully." );
			}	
			
			if(data=='add-success'){
				$( ".slide-message" ).text( "Slide added successfully." );
			}
  
			$( ".slide-message" ).show();
			setTimeout(function(){
					$( ".slide-message" ).empty();  
					//addSlider.hide();
					Liferay.Util.getOpener().<portlet:namespace />closePopup('addAndEditSlide',true);
				}, 2000);
			
		}).fail(function (event, jqXHR, ajaxSettings, thrownError) {
		
		});
	}
	
	
	
});

function <portlet:namespace/>uploadImage(url, windowTitle) {
	Liferay.Util.openWindow({
		dialog : {
			width : 800,
			align : Liferay.Util.Window.ALIGN_CENTER,
			cache : false,
			modal : true
		},

		title : windowTitle,
		id : 'uploadImagepopup',
		uri : url
	});

}

Liferay.provide(window,
	    '<portlet:namespace/>closeUploadImagePopup',
	        function(popupIdToClose,imgsrc) {
	    	if(imgsrc != null && imgsrc != ''){
	    		$("#slideImageId").attr("src",imgsrc);
	    	}
	    	$("#<portlet:namespace/>thumbnailUpload").val(imgsrc);
	    	Liferay.Util.getOpener().<portlet:namespace />closePopup('uploadImagepopup',false);
	        },
	        ['liferay-util-window']
	    );
	    
function deleteSlideImage(obj) {
	var deleteImageURL = "<%=deleteSlideImageURL%>";
	var slideId = $(obj).data("id");
	$.ajax({
        url:deleteImageURL,
        type: 'GET',
        datatype:'html',
        data:{
	  		<portlet:namespace/>slideId:slideId
		  },
        success: function(data){
        	//window.location.reload();
        	$("#slideImageId").attr("src",data);
    	}
      });
}

function escapeHtml(unsafe) {
    return unsafe.replace(/&amp;nbsp;/g, "").replace(/style=".*?"/g,"").replace(/&nbsp;/g, "").replace(/<p>&nbsp;<\/p>/g,"").replace(/<p>/g,"").replace(/<\/p>/g,"");
 }
 
 
function validateForm(){
	var isFormFilled = true;
	var description = $("#<portlet:namespace/>description").val();
	var descriptionLength = $("#cke_slide-content-textarea").find("iframe").contents().find("body").text().trim();
	var url = $("#<portlet:namespace/>imageLink").val();
	description = escapeHtml(description);
	$('#urlPatternErrorId').hide();
	$("#noImageDescErrorId").hide();
	$("#enterDescErrorId").hide();
	$("#descLengthErrorId").hide();
	if($("#slideImageId").attr("src") === '<%=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER%>'
			&& descriptionLength == ""){
		$("#noImageDescErrorId").show();
		$("#enterDescErrorId").hide();
		$("#descLengthErrorId").hide();
		isFormFilled = false; 
	}
	
	if(descriptionLength.length > 1000){
		$("#enterDescErrorId").hide();
		$("#descLengthErrorId").html("Content Length is:"+descriptionLength.length+", Maximum 1000 character is allowed").show();
		$("#noImageDescErrorId").hide();
		isFormFilled = false; 
	}
	if(url.trim().length > 0){
		var re_weburl = new RegExp("https?:\/\/(?:www\.|(?!www))[^\s\.]+\.[^\s]{2,}|www\.[^\s]+\.[^\s]{2,}");
		
		if(!re_weburl.test(url)){
			$('#urlPatternErrorId').show();
			isFormFilled = false;
		}
	}
	
	if($('.slide-position-checkbox').is(":checked") && ( $('.position-right-radio').is(":checked") || $('.position-left-radio').is(":checked") )
			&& descriptionLength == ""){
		$("#enterDescErrorId").show();
		$("#descLengthErrorId").hide();
		$("#noImageDescErrorId").hide();
		isFormFilled = false; 
	}
	
	return isFormFilled;
}


function clearForm(parent){
	$("#<portlet:namespace/>addNewSlide").show();
	$("#<portlet:namespace/>updateSlide").hide();
	//CKEDITOR.instances["slide-content-textarea"].setData("");
	$("#slide-content-textarea").jqteVal("");
	$("#slideImageId").attr("src",'<%=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER%>');
	$(".position-right-radio").removeAttr("checked");
	$(".position-left-radio").removeAttr("checked");
	$('.position-radio-div').hide();
	$("#enterDescErrorId").hide();
	$("#descLengthErrorId").hide();
	$("#noImageDescErrorId").hide();
}


$('#isPositionSelected').on('click', function(){
	
	if($(this).is(':checked')) {
		$(".position-right-radio").removeAttr("checked");
		$(".position-left-radio").removeAttr("checked");
		$(this).parent().next().show();  // checked
	}
	else {
		$(".position-right-radio").removeAttr("checked");
		$(".position-left-radio").removeAttr("checked");
		$(this).parent().next().hide();  // unchecked
	}
	
});

$('.candel-slide-modal').on('click', function(){
	Liferay.Util.getOpener().<portlet:namespace />closePopup('addAndEditSlide',false);
});

function replaceTextareaAsEditor(i){
	try{
		CKEDITOR.replace(i,{
	        height: 100,
	        width: '100%',
	        removePlugins : 'elementspath' ,
	        resize_enabled: false,
	        customConfig: '${context}/js/editorConfig.js'
		});
	}catch(err)
	{}
}

$(function(){
	replaceTextareaAsEditor("slide-content-textarea");
	var position = '${slidePosition}';
	if(position != ''){
		$('#isPositionSelected').attr('checked', true);
		$(".position-radio-div").show();
		if(position == 'padding-left'){
			$('#optionsRadiosLeft').attr('checked', true);
		}else{
			$('#optionsRadiosRight').attr('checked', true);
		}
	}
});
</script>