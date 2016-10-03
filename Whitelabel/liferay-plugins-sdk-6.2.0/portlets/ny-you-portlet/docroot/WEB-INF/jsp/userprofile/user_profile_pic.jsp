<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>		<%--	added by asif 	 --%>
<%@ include file="/WEB-INF/jsp/init.jsp"%>
<portlet:resourceURL var="updateProfilePictureURL" id="updateProfilePicture" /> 
<script src='<%=themeDisplay.getPathThemeJavaScript()%>/jquery/jquery-1.11.0.min.js' type="text/javascript"></script>

<portlet:resourceURL var="getTempPic" id="getTempPic" /> 
<portlet:resourceURL var="saveImage" id="saveImage" /> 

<div id="divLoading" style="display:none;">
	<div class="divLoadingclass" align="center" style="margin-top: 35%;"><img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt="" /> <label style="color:#8131AF;"><liferay-ui:message key="loading" /></label></div>
</div>    
<div class="existing-images clearfix" style="padding: 15px;">
	<div class="pull-left" style="margin-right: 15px;"> 
		<img id="<portlet:namespace/>current_pic" src="<%=user.getPortraitURL(themeDisplay)%>"/> 
	</div>
	
	<div>
		<input type="hidden" id="<portlet:namespace/>cropRegion" name="<portlet:namespace/>cropRegion" />
		<aui:form name="profilePicForm">
			<aui:input name="fileUpload" type="file" />
		</aui:form> 
		<div>
			<span onclick="<portlet:namespace/>saveCropRegion()" class="btn btn-primary normal"><liferay-ui:message key="save" /></span>
			<span onclick="<portlet:namespace />closeUploadImage()" class="btn normal"><liferay-ui:message key="close" /></span>
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
    function <portlet:namespace />closeUploadImage(withSuccessMsg){
    	 Liferay.Util.getOpener().<portlet:namespace />closeUploadImagePopup('uploadImagepopup',<portlet:namespace />updatedUrl,withSuccessMsg);
    }
    
    function <portlet:namespace />handleFileSelect(e){
    	var fd = new FormData(document.getElementById("<portlet:namespace />profilePicForm"));
    	var file = $('#<portlet:namespace/>fileUpload').val();
    	if(file != null && file != ''){
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
    	$.ajax({
            url: "<%=saveImage%>",
            type: "POST",
            data:{
            	"<portlet:namespace/>cropRegion":$('#<portlet:namespace/>cropRegion').val()
            } 
          }).done(function( data ) { 
        	  $("#<portlet:namespace/>current_pic").attr("src",data);
        	  <portlet:namespace />updatedUrl = data;
        	  $("#resetProfilePic").trigger("click");
        	  $("#croppedImage").hide();
        	  $("#croppedImageHead").hide();
        	  $('#<portlet:namespace/>cropRegion').val('');
        	  <portlet:namespace />closeUploadImage('yes');
          });
    	}
    }
    
    function <portlet:namespace/>initiateCropper(){
    	AUI().use(
    		 'aui-image-cropper',
    		 function(Y) {
    			 var imageCropper = new Y.ImageCropper({
    		       cropHeight:200,
    		       cropWidth: 200,
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
