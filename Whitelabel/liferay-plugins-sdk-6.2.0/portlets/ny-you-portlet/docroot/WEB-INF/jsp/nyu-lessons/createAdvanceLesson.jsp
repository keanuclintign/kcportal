<%@page import="org.apache.http.Consts"%>
<%@page import="javax.portlet.PortletSession"%>
<%@page import="com.nyu.service.Lesson_UsergroupsLocalServiceUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page import="com.liferay.portlet.documentlibrary.service.DLFileEntryLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil"%>
<%@page import="com.liferay.portlet.documentlibrary.model.DLFileEntry"%>
<%@page import="com.nyu.model.LessonObjectives"%>
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
<script src='<%=themeDisplay.getPathThemeJavaScript()%>/jquery/jquery-1.11.0.min.js' type="text/javascript"></script>

<meta http-equiv="X-UA-Compatible" content="IE=10; IE=9; IE=8; IE=EDGE" />

<script src="<%=request.getContextPath()%>/js/jquery-dateFormat.min.js"></script>

<portlet:renderURL var="uploadImage" windowState="pop_up">
	<portlet:param name="action" value="uploadImage" />
</portlet:renderURL>

<portlet:resourceURL var="deleteImageURL" id="deleteImageURL" />

<portlet:renderURL var="editLessonURL" >
	<portlet:param name="action" value="editLesson" />
</portlet:renderURL>
<c:set var="publishWithGroupProfile" value="<%=Constant.PUBLISH_WITH_GROUPPROFILE %>"/>
<c:set var="publishWithUserProfile" value="<%=Constant.PUBLISH_WITH_USERPROFILE %>"/>

<portlet:actionURL var="saveLessonDetailsURL">
	<portlet:param name="action" value="saveLessonDetails" />
	<portlet:param name="fromPreviewEdit" value="${fromPreviewEdit}" />
	<portlet:param name="collaborationRequestId" value='<%=request.getAttribute(Constant.COLLABORATION_REQUEST_ID)!=null ? request.getAttribute(Constant.COLLABORATION_REQUEST_ID).toString() : null %>' />
	<c:if test="${not empty userGroupId}">
		<portlet:param name="userGroupId" value="${userGroupId}"/>
		<portlet:param name="publishedProfile" value="${publishedProfile}"/>
	</c:if>
	<portlet:param name="basicLesson" value='<%=GetterUtil.getString(request.getAttribute(Constant.BASIC_LESSON),Constant.NO_BASIC_LESSON)%>' />
	
</portlet:actionURL>

<liferay-portlet:renderURL
	var="addCategoryPopupURL"
	portletName="147"
	windowState="<%=LiferayWindowState.POP_UP.toString() %>">
</liferay-portlet:renderURL>


<%

String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),layout.isPrivateLayout(),themeDisplay);
String homeUrl=siteFriendlyUrl+Constant.PAGE_HOME;

Lesson lesson = null;
long requestId = 0;
long lessonId = 0;
List<LessonObjectives> lessonObjectives = null;
int objectiveCount = 1;
long userGroupId=0l;
if(request.getAttribute(Constant.LESSON)!=null){
	lesson = (Lesson)request.getAttribute(Constant.LESSON);
	lessonObjectives = (List<LessonObjectives>)request.getAttribute(Constant.LESSON_OBJECTIVES);
	objectiveCount = lessonObjectives.size();
	requestId = lesson.getRequestLessonId();
	userGroupId=lesson.getPublishWithProfile();
}

String documentPath = "";
String thumbnailPath = null;
String documentName = "";
long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
List<Long> userGroupIds = null;
List<UserGroup> lessonGroups = null;
boolean gChecked=true;

%>
<c:if test="${empty userGroupId}">
<c:set var="userGroupId" value="<%=userGroupId %>"/>
</c:if>

<portlet:renderURL var="backToChooseLessonURL" >
<portlet:param name="action" value="dummy" />
<%if(Validator.isNotNull(lesson)){%>
<portlet:param name="lessonId" value="<%=String.valueOf(lesson.getLessonId())%>"/>
<%} %>
<c:if test="${not empty userGroupId}">
<portlet:param name="userGroupId" value="${userGroupId}"/>
</c:if>

</portlet:renderURL>




<!-- multistep form -->

<div id="createLesson" class="row">
	<!-- progressbar -->
	<ul id="progressbar">
		<li class="active"><liferay-ui:message key="start" /></li>
		<li class="active"><liferay-ui:message key="overview" /></li>
		<li><liferay-ui:message key="content" /></li>
		<li><liferay-ui:message key="preview-and-save" />
		</li>
	</ul>
	<div class="progress-content">	
		<div class="shadow lesson-details"> 
			<%-- <aui:form action='<%=saveLessonDetailsURL.toString()%>' method="post" id="lessonForm" enctype="multipart/form-data" name="saveLesson" > --%>
			<aui:form action="#" method="post" id="lessonForm" enctype="multipart/form-data" name="saveLessonDetails" >
				<liferay-ui:asset-categories-error />
				<liferay-ui:asset-tags-error />
				<aui:model-context bean="<%=lesson %>" model="<%=Lesson.class %>"/>
				
				<div class="row-fluid">	
					<div class="span6">
						<div class="control-group">
						<label class="control-label" >
							<liferay-ui:message key="lesson-title-required" />
							<a href="#" class="nyu-tooltip" title="<liferay-ui:message key='this-will-appear-as-a-title-of-the-lesson-everywhere-including-lesson-cards' />">
							<img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></a></label>
							<aui:input type="text" name="lessonName" label="" id="lessonTitleId" onChange="updateTitle(this)"  cssClass="form-control input-block-level">
								<aui:validator name="required" errorMessage="please-enter-title"/>
								<aui:validator name="maxLength" errorMessage="maximum-75-characters-allowed" >75</aui:validator>
							</aui:input>
								
						</div> 	
						<div class="control-group">
								<label class="control-label" for="inputDesribe" style="margin-top:-7px;"> 
								<liferay-ui:message	key="what-is-the-purpose-of-the-lesson" />?
								<a href="#" class="nyu-tooltip" title="<liferay-ui:message key='a-brief-description-of-the-lesson-This-will-display-below-the-lesson-window' />">
									<img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png" />
								</a>
								 </label>
								<aui:input type="textarea" name="description" helpMessage="A brief description of the lesson. This will display below the lesson window" 
											onChange="updateDecsription(this)" id="lessonDescId" cssClass="input-block-level" label="" style="height: 150px">
									<aui:validator name="maxLength" errorMessage="Please-enter-description-below-thousands-characters" >1000</aui:validator>
								</aui:input>			
											
								<%-- <aui:input type="textarea" helpMessage="A brief description of the lesson. This will display below the lesson window" name="description" id="lessonDescId" onChange="updateDecsription(this)" cssClass="input-block-level" label="What is the purpose of the lesson"/> --%>
								<p id="enterDescErrorId" style="display:none; color:red;"></p>	
						</div> 
						<div class="control-group">
							<label class="control-label" for="inputConcepts" ><liferay-ui:message key="learning-objective" />
							<a href="#" class="nyu-tooltip" title='<liferay-ui:message key="click-below-to-add-additional-objectives" />'>
							<img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></a></label>
							<div id="<portlet:namespace/>pureObjective">
								<%if(lessonObjectives!=null && lessonObjectives.size()>0){
									int count = 1;
									for(LessonObjectives lo : lessonObjectives){%>
									<input type="text" name='objective<%=count%>' id="objective<%=count%>" class="input-block-level objective-validation" value='<%=lo.getObjective()%>' />
									<input type="hidden" name='objectiveId<%=count%>' value="<%=lo.getId()%>" />
								<%count++;
									}
									 } else{%>
									<aui:input type="text" name="objective1" label="" id="objective1" onChange=""  cssClass="form-control input-block-level objective-validation"/>
								<%} %>
								
							</div>
							<span id="objective-validation-error" class="clearfix" style="display:none;color:red"><liferay-ui:message key="maximum-75-characters-allowed" /></span>
							<a href="javascript:void(0)" class="btn" id="addObjective" style="margin-bottom: 5px; margin-top:-2px;"> <i class="icon-plus"> </i> <liferay-ui:message key="add-more-objectives" /></a>
							<a href="#" class="nyu-tooltip" title='<liferay-ui:message key="this-will-add-additional-container-to-type-in-more-objectives" />' id="addObjectiveHelp">
							<img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></a>
						</div>	 
						
					</div> <!-- end span6 -->
					
					<div class="span6"> 
						
						<div class="control-group">
							<label class="control-label" for="thumbnail"><liferay-ui:message key="thumbnail-image" />  
							
							<a href="#" class="nyu-tooltip" title='<liferay-ui:message key="this-will-appear-as-a-lesson-image-everywhere-including-cards-for-easy-identification" />'>
									<img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></a>
							
							
							</label>
							
							<div id="thumbnail">
											<%
											if(request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID)!=null){
												lessonId = lesson.getLessonId();
												DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(DLFileEntry.class);
												dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID, lessonClassNameId));
												dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_PK, lesson.getLessonId()));
												List<DLFileEntry> dlFileEntries = DLFileEntryLocalServiceUtil.dynamicQuery(dynamicQuery);
												if(dlFileEntries!=null && dlFileEntries.size()>0){
														thumbnailPath = themeDisplay.getPortalURL() + themeDisplay.getPathContext() + "/documents/" + dlFileEntries.get(0).getGroupId() + StringPool.SLASH + dlFileEntries.get(0).getUuid();
												}else{
														thumbnailPath = themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER;
												}
												}
											else{
														thumbnailPath = themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER;
												} 
											%>
											
										<img src="<%=thumbnailPath%>" id="userImageId" style="width: 145px; margin-bottom: 5px;" class="img-polaroid"></img></br>
							
							
								<span class="btn btn-default" onclick="<portlet:namespace />uploadImage('<%=uploadImage%>','Upload Image')"><liferay-ui:message key="change" /></span>
								<span class="btn btn-default" id="deleteButtonId" onclick="deleteUserImage()"><liferay-ui:message key="delete" /></span>
								 <aui:input id="thumbnailUpload"  name="file" type="hidden" label="Add Thumbnail" /> 
								 <aui:input id="fileUpload" name="dummy" type="hidden" label="Add Thumbnail" />
							</div>
						</div>
						
						<div class="control-group">
							<label class="control-label" for="thumbnail" style="margin-top:-4px;"><liferay-ui:message key="are-you-answering-a-request" />?

							<a href="#" class="nyu-tooltip" title='<liferay-ui:message key="if-your-lesson-is-answering-any-of-the-existing-request-for-a-lesson-then-choose-from-the-dropdown" />'>
							<img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></a>

							 </label>
							<div>
								<a href="javascript:void(0)" class="btn" id="requestNo" name="requestNo" > <liferay-ui:message key="no" /> </a>
								<a href="javascript:void(0)" class="btn" id="requestYes" name="requestYes"> <liferay-ui:message key="yes" /> </a>
								<aui:input id="requestLessonCheck" name="requestLessonCheck" type="hidden" />
								
									<div id="lessonRequests" style="display:none; margin-top: 10px;">
										<aui:select name="requestLesson" label="null">
											<aui:option value="0"><liferay-ui:message key="select" /></aui:option>
											<c:forEach items="${requestedLessons}" var="requestLesson" varStatus="i">
											<c:set var="lessonRequestId" scope="session" value='<%=requestId%>'/>
												<aui:option id="${requestLesson.requestLessonId}" name="requestLessons" label="${requestLesson.name}" value="${requestLesson.requestLessonId}" selected="${requestLesson.requestLessonId == lessonRequestId}"/>
											</c:forEach>
										</aui:select>
									</div>
							</div>
						</div>
						<%@include file="/WEB-INF/jsp/common/includeCategory.jsp"%>
						<%@include file="/WEB-INF/jsp/common/includeTag.jsp"%>
						<%-- <aui:input id="tags"  helpMessage="You can choose from the list or create/add new."  name="tags" autoSize="true" resizable="true" type="assetTags" label="Tags" /> --%>  
						<aui:input type="hidden" name="courseId" value="SMPL101"  title="Emptying the Session Textbox will create a value as MINI-xx"/> 
					</div> <!-- end span6 -->
				</div> <!-- end  row-fluid -->	
				<div class="row-fluid text-right">	
					<div class="span7 text-left content-disclaimer">
						<strong><liferay-ui:message key="note" />:</strong>
						<i> <liferay-ui:message key="any-information-entered-will-be-lost-if-the-back-or-forward-button-on-the-browser-is-clicked" />.</i>
					</div>	
					<aui:input type="hidden" name="courseId" value="SMPL101"  title="Emptying the Session Textbox will create a value as MINI-xx"/>	
					<aui:input type="hidden" name="basicLesson" value='<%=request.getAttribute(Constant.BASIC_LESSON)%>' />
					
					<%if(request.getAttribute(Constant.LESSON)!=null){%>
						<aui:input type="hidden" name="lessonId" id="lessonId" value='<%=lesson.getLessonId() %>' />		
					<%}%>
					
					<a href='<%=backToChooseLessonURL.toString() %>' class="previous btn btn-default" ><liferay-ui:message key="cancel" /> </a>
					<button type="button" class="btn btn-primary" id="saveAsDraftId" name="saveContinue" value="Save and continue" onclick="saveLessonDetails()" ><liferay-ui:message key="save-and-continue" /></button>
				</div> <!-- end  row-fluid -->
				<a href="<%=editLessonURL.toString()%>&amp;${namespace}lessonId=189" hidden="true" style="text-decoration: none">
						<span class="span4">
							<span><liferay-ui:message key="edit-lesson" /></span>
						</span>
				</a>
				
				
			</aui:form>	<!-- end form -->
			<div class="processingImg" align="center" style="display:none;">
				<img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt="" /> 
			</div>
		</div> <!-- end lesson-details -->
		
	</div> <!-- end span9 offset1 -->
	
</div> <!-- end createLesson -->
<%@include file="/WEB-INF/jsp/common/categoriesSelector.jsp"%>
<%@include file="/WEB-INF/jsp/common/tagsSelector.jsp"%>
<script>   

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
        	$("#userImageId").attr("src",data);
    	}
      });
}


</script>

<aui:script>

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
	    
	        function(popupIdToClose,imgsrc,withSuccessMsg) {
	        if(imgsrc.trim() != ''){
	    	$("#userImageId").attr("src",imgsrc);
	    	$("#<portlet:namespace/>thumbnailUpload").val(imgsrc);
	    	}
	    	Liferay.Util.getOpener().closeMainImagePopup(popupIdToClose);
	    	if(withSuccessMsg != null && withSuccessMsg == 'yes'){
	    		closePopupForAllWithSuccessMsg('<liferay-ui:message key="lesson-thumbnail-saved-successfully" />');
	    	}
	        },
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

$("#<portlet:namespace/>lessonTitleId").blur(function(){
	  if($("#<portlet:namespace/>lessonTitleId").val().length > 75){
			$("#enterTitleErrorId").html('<liferay-ui:message key="maximum-75-characters-allowed" />');
			$("#enterTitleErrorId").show();
		}else{
			$("#enterTitleErrorId").hide();
		}
});

</aui:script>
<script type="text/javascript">
//Adding Objectives textbox dynamically
$( document ).ready(function() {
	
	
	if($('.radioCheck:checked').val()!="private"){
		$('#checkGroup').hide();	
	}
	$('.radioCheck').on('change',function(){	
		$('#checkGroup').hide(); 
		$('.checkbox-check').attr("checked", false);
		if($(this).val()=="private"){
			$('#checkGroup').show(); 
		}		
	});
	
	$("#"+namespace+"requestLessonCheck").val("no");
	var objectiveCounter = parseInt('<%=objectiveCount%>');
	
	hideAddObjective();
	
	$('a#addObjective').on('click',function(){
	  if(objectiveCounter < 5){
		  objectiveCounter = objectiveCounter+1;
		  var addInput = "<input type='text' style='margin-top:-9px; margin-bottom: 20px;' name='objective"+objectiveCounter+" 'id='objective"+objectiveCounter+"'class='input-block-level objective-validation' />"; 
		  $("#<portlet:namespace/>pureObjective").append(addInput);
	  }
	  hideAddObjective();
	  
	});
	
	function hideAddObjective(){
		 if(objectiveCounter == 5){
			  $('a#addObjective').hide();
			  $('a#addObjectiveHelp').hide();
			  
		 }
	}

	$("#requestYes").click(function(){
			$(this).attr('disabled', 'true');
			$("#requestNo").removeAttr("disabled");
			$("#"+namespace+"requestLessonCheck").val("yes");
			$("#lessonRequests").show();
			
	});

	$("#requestNo").click(function(){
		$(this).attr('disabled', 'true');
		$("#requestYes").removeAttr("disabled");
		$("#"+namespace+"requestLessonCheck").val("no");
		$("#lessonRequests").hide();
	});
	
	$("#lessonDescId").blur(function(){
		  if($("#<portlet:namespace/>lessonTitleId").val().length > 75){
				$("#enterDescErrorId").html('<liferay-ui:message key="maximum-75-characters-allowed" />');
				$("#enterDescErrorId").show();
			}else{
				$("#enterDescErrorId").hide();
			}
	});
	
	if('<%=requestId%>'!='0'){
	    $("#requestYes").attr('disabled', 'true');
		$("#requestNo").removeAttr("disabled");
		$("#"+namespace+"requestLessonCheck").val("yes");
		$("#lessonRequests").show(); 
	 }else if('<%=lessonId%>'!='0' && '<%=requestId%>'=='0'){
		 $("#requestNo").attr('disabled', 'true');
		 $("#requestYes").removeAttr("disabled");
	 }
	
});

/** Save Lesson Details **/
saveLessonDetails = function(){
	if( validateLessonDetailsForm() ){
		
		$(".processingImg").show();
		
		jQuery('form').each( function (x, obj ){
			if( obj.name.indexOf( namespace + 'saveLessonDetails') > -1){
				$("#"+obj.name).attr("action", '<%=saveLessonDetailsURL%>');
				obj.submit();
			}
		});
	}
};



$(document).on('blur','.objective-validation',function(){
	var showObjectiveValidationError = false;
	if($(this).val().trim().length > 75){
		$("#objective-validation-error").show();
		$(this).css({'color':'red',"border-color":"red"});
	}else{
		$('.objective-validation').each(function(){
			if($(this).val().trim().length > 75){
				showObjectiveValidationError = true;
			}
		});
		if(!showObjectiveValidationError){
			$("#objective-validation-error").hide();
		}
		$(this).css({'color':'#333',"border-color":"#ccc"});	
	}
});

function validateLessonDetailsForm(){
	var isFormFilled = true;
	
	if($("#<portlet:namespace/>lessonTitleId").val().trim() == ""){
		$("#<portlet:namespace/>lessonTitleId").focus().blur().focus();
		isFormFilled = false; 
	}
	if($("#<portlet:namespace/>lessonTitleId").val().trim().length > 75){
		$("#<portlet:namespace/>lessonTitleId").focus().blur();
		isFormFilled = false; 
	}
	if($("#<portlet:namespace/>lessonDescId").val().trim().length >1000){
		$("#<portlet:namespace/>lessonDescId").focus().blur();
		isFormFilled = false; 
	}
	if($("#<portlet:namespace/>lessonDescId").val().trim().length >1000){
		$("#<portlet:namespace/>lessonDescId").focus().blur();
		isFormFilled = false; 
	}
			
	$('.objective-validation').each(function(){
		if($(this).val().trim().length > 75){
			$("#objective-validation-error").show()
			$(this).css({'color':'red',"border-color":"red"});
			isFormFilled = false; 
		}
	});
		
	return isFormFilled;	
}
</script>