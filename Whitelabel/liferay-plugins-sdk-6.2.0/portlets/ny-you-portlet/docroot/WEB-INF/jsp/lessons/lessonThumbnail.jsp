<%@ include file="/WEB-INF/jsp/init.jsp"%>
<portlet:resourceURL var="updateProfilePictureURL" id="updateProfilePicture" /> 
<script src='<%=themeDisplay.getPathThemeJavaScript()%>/jquery/jquery-1.11.0.min.js' type="text/javascript"></script>


    <style>
		.aui-cropped-image {
	 	 background: url("http://alloyui.com/image-cropper/img/crop-image.jpg") no-repeat 0 0;
		  border: 1px solid #111;
		  display: inline-block;
		  
		}
	</style>
    
    
   <%--  <%if(request.getAttribute("update_success")!=null){ %>
					<span class="span12 alert alert-success" style="margin-bottom: 0px;"><%=request.getAttribute("update_success")%></span>
			<%} %> --%>
    
	<img id="<portlet:namespace/>current_pic" src="<%=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER%>"></img>
	<aui:form method="post" id="fm" name="fm">
        <aui:input type="file" name="fileUpload"  label="Select a file:"/>
        <div id="image" style="background-image:none;background-size:100% 100%" ></div>
        <aui:button type="button" value="Upload" onclick="submitForm();"/>
        
        <aui:button type="button" onclick="closeUploadImage()" value="close" />
    </aui:form>
  
<div class="aui-layout aui-image-cropper">
  <div id="cropped-view" class="column w50">
    <div class="aui-column-content aui-cropped-output">
      <div class="aui-cropped-image" id="croppedImage"></div>
      <input type="hidden" id="cropRegion_x">
      <input type="hidden" id="cropRegion_y">
      <input type="hidden" id="cropRegion_width">
      <input type="hidden" id="cropRegion_height">
      <input type="hidden" id="original_width">
      <input type="hidden" id="original_height">
      <div class="status" id="status"></div>
    </div>
  </div>
</div>
    <script type="text/javascript"> 
    var updatedUrl='';
    function closeUploadImage()
    {
    	 Liferay.Util.getOpener().<portlet:namespace />closeUploadImagePopup('uploadImagepopup',updatedUrl);
    }


	var url;
    
    function <portlet:namespace />handleFileSelect(e){
      
    	var reader = new FileReader();
    	    reader.onload = function(event){
    	        var img = new Image();
            	img.onload = function(){
            	if(img.width>600){
            		$("#image").css('width',600+'px');
            		$("#image").css('height',400+'px');
            		document.getElementById('original_width').value = 600;
      		    	document.getElementById('original_height').value = 400;
    	        }
            	else
            		{
            		$("#image").css('width',img.width+'px');
            		$("#image").css('height',img.height+'px');
            		document.getElementById('original_width').value = img.width;
      		    	document.getElementById('original_height').value =img.height;
            		}
            	}
    	        img.src = event.target.result;
    	        $("#image").css('background-image', 'url("' + img.src + '")');
        	    $(".aui-cropped-image ").css('background', 'url("' +img.src+ '")no-repeat scroll 0 0');
        	    url='url("' + img.src + '")no-repeat scroll 0 0';
        	    $(".image-cropper-crop").css("display","none");
        	    cropImage();
    	    }
    	    reader.readAsDataURL(e.target.files[0]); 
    	    
    }

    document.getElementById('<portlet:namespace/>fileUpload').addEventListener('change', <portlet:namespace />handleFileSelect, false);

      
       
    
        function submitForm() {
            var fd = new FormData(document.getElementById("<portlet:namespace />fm"));
            fd.append("cropRegion_x", document.getElementById('cropRegion_x').value);
            fd.append("cropRegion_y", document.getElementById('cropRegion_y').value);
            fd.append("cropRegion_width", document.getElementById('cropRegion_width').value);
            fd.append("cropRegion_height", document.getElementById('cropRegion_height').value);
            fd.append("original_width", document.getElementById('original_width').value);
            fd.append("original_height", document.getElementById('original_height').value);
            $.ajax({
              url: "<%=updateProfilePictureURL%>",
              type: "POST",
              data: fd,
              enctype: 'multipart/form-data',
              processData: false,  // tell jQuery not to process the data
              contentType: false   // tell jQuery not to set contentType
            }).done(function( data ) {
                $('#<portlet:namespace/>current_pic').attr("src",data);
                updatedUrl=data;
                $(".aui-cropped-image ").css('background', url);
				
        		AUI().use('aui-modal',
					function(X) {
						var modal = new X.Modal(
						{
						bodyContent: '<p> <Strong>Image updated successfully</Strong></p>', centered: true,
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
            });
            return false;
        }
      
        function cropImage(){
        AUI().use(
      		  'aui-image-cropper',
      		  function(Y) {
      		    var imageCropper = new Y.ImageCropper(
      		      {
      		        srcNode:'#image',
      		        x: 100,
      		        y: 100,
      		        
      		      }
      		    ).render();

      		//    var statusTPL = '<strong class="x">x: {x}</strong><strong class="y">y: {y}</strong><strong class="height">height: {height}</strong><strong class="width">width: {width}</strong>';

      		    var updateImage = function() {
      		      var cropRegion = imageCropper.get('region');

      		     /*  croppedImage.setStyles(
      		        {
      		          'backgroundPosition': (-cropRegion.x) + 'px ' + (-cropRegion.y) + 'px',
      		          height: cropRegion.height,
      		          width: cropRegion.width
      		        }
      		      ); */
      		    	document.getElementById('cropRegion_x').value = cropRegion.x;
      		    	document.getElementById('cropRegion_y').value = cropRegion.y;
      		    	document.getElementById('cropRegion_width').value = cropRegion.width;
      		    	document.getElementById('cropRegion_height').value = cropRegion.height;
      		      	//croppedImage.html(Y.Lang.sub(statusTPL, cropRegion));
      		    };

      		    imageCropper.after(
      		      'crop',
      		      function(event) {
      		        updateImage();
      		      }
      		    );
/* 
      		    var croppedImage = Y.one('#croppedImage');

      		    var croppedStatus = Y.one('#croppedStatus');
      		    
      		    croppedImage.show(); */

      		    updateImage();

      		   
      		  }
      		);
        }
    </script>
