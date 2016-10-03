<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>		<%--	added by asif 	 --%>

<%@ include file="/WEB-INF/jsp/init.jsp"%>

<portlet:resourceURL var="updateProfilePictureURL" id="updateProfilePicture" /> 
<script src='<%=themeDisplay.getPathThemeJavaScript()%>/jquery/jquery-1.11.0.min.js' type="text/javascript"></script>

<portlet:resourceURL var="getTempPic" id="getTempPic" /> 
<portlet:resourceURL var="saveImage" id="saveImage" /> 
<portlet:resourceURL var="deleteImageURL" id="deleteImageURL">
	<portlet:param name="clearTempOnly" value="yes"/>
</portlet:resourceURL>

<div id="loadingMask" style="display:none;" class="content-mask">
  <img src="<%= Constant.PORTLET_PROP_VENDOR_PORTLET_IMAGES %>nyuloading.gif" alt="" style="margin-top: 30%;">
  <p> <liferay-ui:message key="saving" />....</p>
</div>
<div id="divLoading" style="display:none;">
	<div class="divLoadingclass" align="center" style="margin-top: 35%;"><img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt="" /> <label style="color:#8131AF;"><liferay-ui:message key="loading" /></label></div>
</div>    
<div class="existing-images clearfix" style="padding: 15px;">
	<div class="pull-left" style="margin-right: 15px;"> 
		<img id="<portlet:namespace/>current_pic" src="<%=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.GROUP_CARD_PLACEHOLDER%>"></img>
	</div>
	
	<div>
		<input type="hidden" id="<portlet:namespace/>cropRegion" name="<portlet:namespace/>cropRegion" />
		<aui:form name="profilePicForm">
			<label><liferay-ui:message key="file-upload" /> <span id="emptyAndFormatFileErr" style="display:none;color:red"></span></label>
			<aui:input name="fileUpload" type="file" label=""/>
		</aui:form> 
		<div>
			<span onclick="<portlet:namespace/>saveCropRegion()" class="btn btn-primary normal"><liferay-ui:message key="save" /></span>
			<span onclick="closeUploadImage()" class="btn normal"><liferay-ui:message key="close" /></span>
			<span id="resetProfilePic" class="hidden"><liferay-ui:message key="reset" /></span>
		</div>
	</div>
	
</div> <!-- end existing-images row-fluid -->
<div class="clearfix">
	<div id="preview"  class="pull-left" style="padding: 0 15px;"></div>
	<div class="pull-left">
		<h4 class="hide" style="margin-top:0" id="croppedImageHead"> <liferay-ui:message key="preview" /> </h4>
		<div class="hide" id="croppedImage"></div>
	</div>
</div>
    <script type="text/javascript"> 
    var <portlet:namespace />updatedUrl='';
    function closeUploadImage(withSuccessMsg){
    	if(withSuccessMsg == null || withSuccessMsg != 'yes'){
    		var deleteImageURL = "<%=deleteImageURL%>";
    		$.ajax({
    	        url:deleteImageURL,
    	        type: 'GET',
    	        datatype:'html',
    	        async:true,
    	    });
    	}
    	Liferay.Util.getOpener().<portlet:namespace />closeUploadImagePopup('uploadImagepopup',<portlet:namespace />updatedUrl,withSuccessMsg);
    }
    
    function <portlet:namespace />handleFileSelect(e){
    	var fd = new FormData(document.getElementById("<portlet:namespace />profilePicForm"));
    	var file = $('#<portlet:namespace/>fileUpload').val();
    	if(file != null && file != ''){
    		
    		var stringLengthFile = file.length;
    		var reverseFile = "";
    		for(stringLengthFile-- ; stringLengthFile>=0 ;stringLengthFile--){
    			reverseFile += file[stringLengthFile];
    		}
    		var imageExtension = (reverseFile.split("."))[0];
    		imageExtension = imageExtension.toLowerCase();
    		imageExtension = imageExtension.split("").reverse().join("")
    		var allImageExtension = ["tif","tiff","gif","jpeg","jpg","jif","jfif","jp2","jpx","j2k","j2c","fpx","pcd","png"];
    		if(jQuery.inArray( imageExtension, allImageExtension ) < 0){
    			$('#emptyAndFormatFileErr').html('(<liferay-ui:message key="please-select-image-only" />...)');
    			$('#emptyAndFormatFileErr').show();
    			return;
    		}
    		
    		$('#emptyAndFormatFileErr').hide();
    		$('#preview').html($("#divLoading").html());
	    	$.ajax({
	            url: "<%=getTempPic%>",
	            type: "POST",
	            data: fd,
	            enctype: 'multipart/form-data',
	            processData: false,  // tell jQuery not to process the data
	            contentType: false   // tell jQuery not to set contentType
	          }).done(function( data ) { 
	        	 var image = document.createElement("img");
	        	 image.src="data:image/png;base64," + data; 
	        	 $("#croppedImage").css('background', 'url("' +image.src+ '")no-repeat scroll 0 0');
	        	 $('#preview').html(image);
	        	 <portlet:namespace/>initiateCropper();
	        	 $('#<portlet:namespace/>fileUpload').val('');
	          });
    	}
    }
    
    document.getElementById('<portlet:namespace/>fileUpload').addEventListener('change', <portlet:namespace />handleFileSelect, false);
    
    function <portlet:namespace/>saveCropRegion(){
    	var file = $('#<portlet:namespace/>cropRegion').val();
    	if(file != null && file != ''){
    	$('#loadingMask').show();
    	$.ajax({
            url: "<%=saveImage%>",
            type: "POST",
            data:{
            	"<portlet:namespace/>cropRegion":$('#<portlet:namespace/>cropRegion').val()
            } 
          }).done(function( data ) { 
        	  $("#<portlet:namespace/>current_pic").attr("src","data:image/jpg;base64," + data);
        	  <portlet:namespace />updatedUrl = "data:image/jpg;base64," + data;
        	  $("#resetProfilePic").trigger("click");
        	  $("#croppedImage").hide();
        	  $("#croppedImageHead").hide();
        	  $('#<portlet:namespace/>cropRegion').val('');
        	  $('#loadingMask').hide();
        	  closeUploadImage('yes');
          });
    	}else{
    		$('#emptyAndFormatFileErr').html('(<liferay-ui:message key="please-upload-the-image" />...)');
    		$('#emptyAndFormatFileErr').show();
    	}
    }
    
    function <portlet:namespace/>initiateCropper(){
    	AUI().use(
    		 'aui-image-cropper',
    		 function(Y) {
    			 var imageCropper = new Y.ImageCropper({
    		       cropHeight:210,
    		       cropWidth: 300,
    		       minHeight :150,
    		       minWidth : 150,
    		       destroyed :true,
    		       preserveRatio : true,
    		       srcNode: '#preview img',
    		       x: 50,
    		       y: 50,
    		     }).render();
    			 var statusTPL = '';
    			 var cropRegion = imageCropper.get('region');
    			 var croppedImage = Y.one('#croppedImage');
    			 var croppedImageHead = Y.one('#croppedImageHead');
    			 
    			 $('#<portlet:namespace/>cropRegion').val(JSON.stringify(cropRegion));
    			 imageCropper.after('crop',function(event) {
    				croppedImage.show();
    				croppedImageHead.show();
    				var cropRegion = imageCropper.get('region');
    				croppedImage.setStyles({
    				  'backgroundPosition': (-cropRegion.x) + 'px ' + (-cropRegion.y) + 'px',
    				  height: cropRegion.height,
    				  width: cropRegion.width
    				});
    				croppedImage.html(Y.Lang.sub(statusTPL, cropRegion));
    			 	$('#<portlet:namespace/>cropRegion').val(JSON.stringify(cropRegion));
    	     	});
    			 Y.one('#resetProfilePic').on(
    				      'click',
			      function (event) {
			        imageCropper.destroy();
			      });
    		 }); 
    }
    
        
    </script>
