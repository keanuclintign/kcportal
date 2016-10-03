<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@page import="com.liferay.portal.model.UserGroup"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.kernel.util.PropsUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>

<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@page import="com.nyu.service.LessonLocalServiceUtil"%>
<%@page import="com.nyu.model.Lesson"%>
<%@ page import="com.liferay.util.portlet.PortletProps, com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@ page import="com.nyu.model.DocumentFile"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.nyu.model.RequestLesson"%>
<%@page import=" com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import=" com.liferay.portal.kernel.dao.orm.QueryUtil"%>
<%@page import=" java.util.concurrent.CopyOnWriteArrayList"%>

<meta http-equiv="X-UA-Compatible" content="IE=10; IE=9; IE=8; IE=EDGE" />

<script src="<%=request.getContextPath()%>/js/jquery-dateFormat.min.js"></script>

<portlet:renderURL var="backToChooseLessonURL" >
	<portlet:param name="action" value="dummy" />
</portlet:renderURL>

<portlet:renderURL var="uploadImage" windowState="pop_up">
	<portlet:param name="action" value="uploadImage" />
</portlet:renderURL>

<portlet:resourceURL var="deleteImageURL" id="deleteImageURL" />

<liferay-portlet:renderURL
	var="addCategoryPopupURL"
	portletName="147"
	windowState="<%=LiferayWindowState.POP_UP.toString() %>">
</liferay-portlet:renderURL>
<!-- multistep form -->
<div id="createLesson" class="row">
	 <!-- progressbar -->
	<ul id="progressbar">
		<li class="active">Start</li>
		<li class="active">Overview</li>
		<li>Content</li>
		<li>Preview and Save
		</li>
	</ul>
	<!--content divs
	<div class="progress-content">
		<div class="shadow lesson-start">
			<h1> What do you want to create? </h1>
			<ul>
				<li id="basicLesson">			
					<a href="#" class="row-fluid"> 
						<span class="span4">
							<i class="icon-file"> </i> 
							<span> Basic Lesson </span>
						</span>
						<span class="span8">1. Describe the lesson<BR>
						2. Add Content<BR>
						3. Save Drafts to My Stuff and/or Publish </span>
					</a>
				</li> 
				<li id="advancedLesson">			
					<a href="#" class="row-fluid"> 
						<span class="span4">
							<i class="icon-book"></i> 
							<span> Advanced Lesson </span>
						</span>
						<span class="span8"> 1. Describe the lesson<BR>
						2. Add Content and Organise into Sections <BR> 
						3. Save Drafts to My Stuff and/or Publish </span>
					</a>
				</li> 
				<li id="newCourse">			
					<a href="#" class="row-fluid"> 
						<span class="span4">
							<i class="icon-stop"></i>
							<span> Build a Track </span>
						</span>
						<span class="span8"> Combine lessons together into a track<BR>
						Add quizzes and analytics<BR>
						Share with the VENDOR community  </span>
					</a>
				</li> 
			</ul>
		</div> end  shadow 
	</div> end span9 offset1 -->
	
	<div class="progress-content">
		<div class="shadow lesson-details"> 
			<aui:form action="#" method="post" id="lessonForm" enctype="multipart/form-data" name="saveLesson" >
				<div class="control-group">
					<!-- <label class="control-label" for="inputTitle">Title</label> -->
					<div class="controls">
						<!-- <input type="text" id="lessonName" id="lessonTitleId" class="input-block-level"> -->
						<aui:input type="text" name="lessonName" label="Title" id="lessonTitleId" onChange="updateTitle(this)"  placeholder="Enter title" cssClass="form-control input-block-level"/>
					</div>
				</div> 	
				<div class="control-group">
					<label class="control-label" for="thumbnail"> Thumbnail Image </label>
					<div class="controls">
					<!-- <input type="file" id="thumbnail"> -->
						<img src="<%=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER %>" id="userImageId" style="height: 100px; width: 150px;"></img></br>
						<span class="btn btn-default" onclick="<portlet:namespace />uploadImage('<%=uploadImage%>','Upload Image')">change</span>
						<span class="btn btn-default" id="deleteButtonId" onclick="deleteUserImage()">Delete</span>
						<aui:input id="thumbnailUpload"  name="file" type="hidden" label="Add Thumbnail" /> 
						<aui:input id="fileUpload" name="dummy" type="hidden" label="Add Thumbnail" />
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="inputDesribe"> Describe the purpose of the lesson </label>
					<div class="controls">
					<!-- <textarea rows="5" class="input-block-level" id="inputDesribe" name="inputDesribe"></textarea> -->
					<textarea  name="description" class="input-block-level" id="lessonDescId" onChange="updateDecsription(this)" ></textarea>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="inputCategories">Categories</label>
					<div class="controls">
					<!-- <input type="text"  class="input-block-level" id="inputCategories"> -->
					<aui:input name="categories" type="assetCategories" />
					<c:if test="${permissionChecker.isGroupAdmin(scopeGroupId)}">
						<button id="category2-label" class="btn btn-default pull-right" type="button" onclick="<portlet:namespace />addCategories('<%=addCategoryPopupURL%>')">
						Add Categories</button>
					</c:if>	
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="inputTags">Tags</label>
					<div class="controls">
					<!-- <input type="text" class="input-block-level" id="inputTags"> -->
					<aui:field-wrapper>
						<aui:fieldset>
							<aui:input id="tags" name="tags" autoSize="true" resizable="true" type="assetTags" label="" />
						</aui:fieldset>
					</aui:field-wrapper>
					</div>
				</div>
				
				<input type="button" id="saveContinue" name="saveContinue" class="btn btn-primary" value="Save and continue" /> 				
				<a href='<%=backToChooseLessonURL.toString() %>' class="previous btn btn-default" >Back </a>
				<input type="button" class="btn btn-default" value="Cancel" /> 
			</aui:form>
		</div> <!-- end lesson-details -->
	</div> <!-- end span9 offset1 -->
	
	<!-- <div class="progress-content">
		<div class="lesson-content shadow">
			<div class="page">	
				<h1> PAGE 1 </h1>
				<div class="row-fluid">
					<div class="span6">
						<h3> Left Column </h3>	
						<div class="btn-group">
							<button class="btn">Find Files</button>
							<button class="btn">Upload</button>
							<button class="btn">Embed</button>
							<button class="btn">Add Text</button>
							<button class="btn">Add Widget</button>
						</div>
					</div> end span6
					<div class="span6">
						<h3> Right Column </h3>	
						<div class="btn-group">
							<button class="btn">Find Files</button>
							<button class="btn">Upload</button>
							<button class="btn">Embed</button>
							<button class="btn">Add Text</button>
							<button class="btn">Add Widget</button>
						</div>
					</div> end span6
				</div> end row-fluid
			</div>
			<div class="page">	
				<h1> PAGE 2 </h1>
				<div class="row-fluid">
					<div class="span6">
						<h3> Left Column </h3>	
						<div class="btn-group">
							<button class="btn">Find Files</button>
							<button class="btn">Upload</button>
							<button class="btn">Embed</button>
							<button class="btn">Add Text</button>
							<button class="btn">Add Widget</button>
						</div>
					</div> end span6
					<div class="span6">
						<h3> Right Column </h3>	
						<div class="btn-group">
							<button class="btn">Find Files</button>
							<button class="btn">Upload</button>
							<button class="btn">Embed</button>
							<button class="btn">Add Text</button>
							<button class="btn">Add Widget</button>
						</div>
					</div> end span6
				</div> end row-fluid
			</div>
			<div class="text-center"> <button class="btn btn-primary" style="margin-top: 15px;"> <i class="icon-plus"> </i> Add Another Page </button></div>
			<input type="button" id="saveContinue" name="saveContinue" class="btn btn-primary" value="Save and continue" /> 				
			<input type="button" name="previous" id="previous" class="previous btn btn-default" value="Back" />
			<input type="button" class="btn btn-default" value="Cancel" /> 
		</div> end lesson-content	 
	</div> end span9 offset1
	
	<div class="progress-content">
		<div class="lesson-preview-save shadow"> 
			<h1> Characteristics of Life </h1>
			<div class="row-fluid">
				<div class="span6">
					<p> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>video_placeholder.png"> </p>
					<div class="pagination">
						<span>  Page :  </span>
						<div class="btn-group pull-right"> 
							<button class="btn">1</button>
							<button class="btn">2</button>
							<button class="btn">3</button>
							<button class="btn">4</button>
						</div>
					</div>
				</div> end span6
				<div class="span6">
					<p> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar tempor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam fermentum, nulla luctus pharetra vulputate, felis tellus mollis orci, sed rhoncus sapien nunc eget odio. </p>
					<p> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar tempor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam fermentum, nulla luctus pharetra vulputate, felis tellus mollis orci, sed rhoncus sapien nunc eget odio. </p>
				</div> end span6
			</div> end row-fluid
			<input type="button" name="previous" class="previous btn btn-default" value="Previous" />
			<input type="button" class="btn btn-default" value="Cancel" /> 
			<div class="pull-right">
				<input type="button" class="btn btn-default" value="Save Draft" /> 
				<input type="button" class="btn btn-primary" value="Publish" /> 
			</div>
		</div> end lesson-preview-save		
		
	</div> end span8 offset2 -->
</div> <!-- end createLesson -->


<script> 
var current_fs, next_fs, previous_fs; //fieldsets 

$("#basicLesson, #saveContinue").click(function(){
	current_fs = $(this).closest('.progress-content');
	next_fs = $(this).closest('.progress-content').next();
	$("#progressbar li").eq($("div.progress-content").index(next_fs)).addClass("active");
	 
	next_fs.show();  
	current_fs.hide();
});

/*$(".next").click(function(){  
	
	current_fs = $(this).parent();
	next_fs = $(this).parent().next();
	
	//activate next step on progressbar using the index of next_fs
	$("#progressbar li").eq($("div.progress-content").index(next_fs)).addClass("active");
	 
	next_fs.show();  
	current_fs.hide();
}); */

$(".previous").click(function(){ 
	
	current_fs = $(this).closest('.progress-content');
	previous_fs = $(this).closest('.progress-content').prev();
	
	//de-activate current step on progressbar
	$("#progressbar li").eq($("div.progress-content").index(current_fs)).removeClass("active");
	 
	previous_fs.show();  
	current_fs.hide();
}); 


function <portlet:namespace />handleFileSelect(e){
	var fileName = document.getElementById('<portlet:namespace/>fileUpload').value;
	var exten = fileName.substr(fileName.lastIndexOf('.'), fileName.length) || fileName;
	if(exten.toLowerCase() !='.jpg' && exten.toLowerCase() !='.jpeg' && exten.toLowerCase() !='.png') {
		document.getElementById('<portlet:namespace/>fileUpload').value = "";
		alert("Please upload either JPEG/JPG/PNG file.");
		return false;
	}
	var canvas=document.getElementById("myCanvas"); // grabs the canvas element
	var context=canvas.getContext("2d"); // returns the 2d context object
	    var reader = new FileReader();
	    reader.onload = function(event){
	        var img = new Image();
        	img.onload = function(){
	            canvas.width = img.width;
	            canvas.height = img.height;
	            context.drawImage(img,0,0);
	            $('#<portlet:namespace/>deleteThumbnail').show();
	        }
	        img.src = event.target.result;
	        $("#video-placeholder").hide();
	        $("#<portlet:namespace/>fileUpload").hide();
	        $("#thumbnail label").hide();
	        $('#divPreviewImage ul').html('<img id="thumbMainPreview" style="margin: 0 5px 5px 0; width: 633px; height: 300px; padding:5px;" src="'+ img.src +'">');
	       
	    }
	    reader.readAsDataURL(e.target.files[0]); 
	    
}

function deleteUserImage() {
	var deleteImageURL = "<%=deleteImageURL%>";
	$.ajax({
        url:deleteImageURL,
        type: 'GET',
        datatype:'html',
        success: function(data){
        	//window.location.reload();
        	$("#userImageId").attr("src",data);
    	}
      });
}

</script>

<aui:script>

function <portlet:namespace/>uploadImage(url, windowTitle) {
	Liferay.Util.openWindow({
		dialog : {
			width : 700,
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
	        function(popupIdToClose,imgsrc,withSuccessMsg) {
	        if(imgsrc.trim() != ''){
	    	$("#userImageId").attr("src",imgsrc);
	    	$("#<portlet:namespace/>thumbnailUpload").val(imgsrc);
	    	}
	    	Liferay.Util.getOpener().closeMainImagePopup(popupIdToClose);
			if(withSuccessMsg != null && withSuccessMsg == 'yes'){
	    		closePopupForAllWithSuccessMsg('Lesson thumbnail saved successfully.');
	    	}	        },
	        ['liferay-util-window']
	    );



function <portlet:namespace />addCategories(url) {

	Liferay.Util.openWindow(
		{
			dialog: {
				cache: false,
				//height:auto,
				//width:auto,
				modal: true
			},
			id: 'testPopupIdUnique',				
			uri: url
		}
	);
}
</aui:script>