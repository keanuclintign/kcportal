<%@page import="java.util.Date"%>
<%@page import="com.nyu.model.DocumentSection"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.nyu.model.LessonObjectives"%>
<%@page import="com.liferay.portlet.documentlibrary.service.DLFileEntryLocalServiceUtil"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil"%>
<%@page import="com.liferay.portlet.documentlibrary.model.DLFileEntry"%>
<%@page import="com.nyu.service.LessonLocalServiceUtil"%>
<%@ page import="com.liferay.util.portlet.PortletProps, com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="com.nyu.model.Lesson"%>
<%@page import="com.liferay.util.portlet.PortletProps"%>
<%@page import="com.liferay.portal.model.UserGroup"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.nyu.service.Lesson_UsergroupsLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>			<%--	added by asif 09-10-2015	 --%>
<style> 
	.aui .btn { font-weight: normal; } 
	.nav.nav-pills {
  		display: inline-block; 
  	}
  	footer nav.container { text-align: center; }
</style>
<script type="text/javascript" src = "<%=request.getContextPath()%>/js/angular/lessonSection.js?<%=new Date().getTime()%>"></script>

<portlet:renderURL var="uploadImage" windowState="pop_up">
	<portlet:param name="action" value="uploadImage" />
</portlet:renderURL>
<%
String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),layout.isPrivateLayout(),themeDisplay);
String homeUrl=siteFriendlyUrl+Constant.PAGE_HOME;
%>

<portlet:resourceURL var="publishLessonURL" id="publishLesson"/>
<portlet:resourceURL var="deleteImageURL" id="deleteImageURL" />

<portlet:actionURL var="saveLessonDetailsURL">
	<portlet:param name="action" value="saveLessonDetails" />
	<portlet:param name="lessonId" value="${lessonId}"/>
</portlet:actionURL>

<portlet:resourceURL var="uuidURL" id="generateDocUUID">
</portlet:resourceURL>

<portlet:resourceURL var="SaveLessonSections" id="SaveLessonSections">
<portlet:param name="update" value="edit" />
</portlet:resourceURL>

<portlet:resourceURL var="saveAsDraft" id="saveAsDraft">
<portlet:param name="lessonId" value="${lessonId}" />
</portlet:resourceURL>

<portlet:renderURL var="reloadEditpage">
	<portlet:param name="action" value="editLesson" />
	<portlet:param name="lessonId" value="${lessonId}"/>
	<portlet:param name="openContentInEdit" value="yes"/>
</portlet:renderURL> 

<c:set var="reloadEditpage" value="<%=reloadEditpage%>" />
<c:set var="currentUser" value="<%=PortalUtil.getUserId(request)%>" />

<liferay-portlet:renderURL
	var="addCategoryPopupURL"
	portletName="147"
	windowState="<%=LiferayWindowState.POP_UP.toString() %>">
</liferay-portlet:renderURL>
<%

long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
String documentPath = "";
String thumbnailPath = null;
String documentName = "";

Lesson lesson = null;
long requestId = 0;
long lessonId = 0;
List<LessonObjectives> lessonObjectives = null;
int objectiveCount = 1;
long userGroupId=0l;
if(request.getAttribute(Constant.LESSON)!=null){
	lesson = (Lesson)request.getAttribute(Constant.LESSON);
	lessonObjectives = (List<LessonObjectives>)request.getAttribute(Constant.LESSON_OBJECTIVES);
	objectiveCount = lessonObjectives.size()==0 ? 1 : lessonObjectives.size();
	requestId = lesson.getRequestLessonId();
	userGroupId=lesson.getPublishWithProfile();
}

List<DocumentSection> documentSectionList = (List<DocumentSection>)request.getAttribute(Constant.COMMON_DOCUMENT_SECTION);
%>
<c:set var="userGroupId" value="<%=userGroupId %>"/>

<div id="lesson-section-content" style="display:none" ng-controller = "lessonSectionController">
	<%@ include file="/WEB-INF/jsp/nyu-lessons/lessonSectionTemplate.jsp" %>
</div>

<div class="container">
	<!-- ============== TAB COMPONENT ==================== --> 
	<div class="lesson-content shadow" style="padding: 10px 20px">
	<div id="nyYouTab"  class="edit-lesson">
		<!-- TAB LINKS -->
		<ul class="nav nav-tabs">
			<li class="pull-right"><a href="#PreviewAndPublish" style="margin-right: 0;">Preview and Publish</a></li>	
			<c:if test="${userGroupId==0}">		
				<li class="pull-right"><a href="#CollaborateTab">Editors</a></li>
			</c:if>
			<li id="nyYouTabContentTab" class="pull-right"><a href="#ContentTab">Content</a></li>
			<li class="pull-right active"><a href="#DetailsTab">Overview</a></li>
			<!-- <li class="pull-left"> <span> Introduction to Biology </span> </li>
			<li class="pull-left"> <span> Published 08/20/15 </span> </li> -->
		</ul> <!-- END TAB LINKS -->
	 
		<!-- TAB CONTENT -->
		<div class="tab-content">		
			<%@ include file="editPreviewLesson.jsp" %>
			
			<%@ include file="collaborate.jsp" %>
			
			<div id="ContentTab" class="tab-pane" ng-controller = "lessonSectionController">
			<%@ include file="editContentSection.jsp" %>
			<%@ include file="/WEB-INF/jsp/nyu-lessons/media.jsp" %>
			</div>
			
			<div id="DetailsTab" class="tab-pane" style="position:relative;">
			<liferay-ui:asset-categories-error />
				<liferay-ui:asset-tags-error />
				<div class="progress-content">
					<div class="lesson-details"> 
					<aui:form action="#" method="post" id="lessonForm" enctype="multipart/form-data" name="saveLessonDetails" >
					<aui:model-context bean="<%=lesson %>" model="<%=Lesson.class %>"/>
							<div class="row-fluid">	
								<div class="span6">
									<div class="control-group">
										<label class="control-label" >
										<liferay-ui:message key="lesson-title-required" />
										<a href="#" class="nyu-tooltip" title="<liferay-ui:message key='this-will-appear-as-a-title-of-the-lesson-everywhere-including-lesson-cards' />">
										<img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></a></label>
										<aui:input type="text" name="lessonName" label=""
											id="lessonTitleId" value="${lesson.lessonName}" onChange="updateTitle(this)"
											cssClass="form-control input-block-level">
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
										<aui:input type="textarea" name="description" style="height: 150px;"
											id="lessonDescId" onChange="updateDecsription(this)"
											cssClass="input-block-level" label="" value="${lesson.description}">
											<aui:validator name="maxLength" errorMessage="Please-enter-description-below-thousands-characters" >1000</aui:validator>
										</aui:input>	
									</div>
									
									<aui:input name="lessonMode" type="hidden" value="edit"></aui:input>
									
									<div class="control-group">
										<label class="control-label" for="inputConcepts" ><liferay-ui:message key="learning-objective" />
										<a href="#" class="nyu-tooltip" title='<liferay-ui:message key="click-below-to-add-additional-objectives" />'>
										<img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></a></label>
										<div id="<portlet:namespace/>pureObjective">
											<%if(lessonObjectives!=null && lessonObjectives.size()>0){
												int count = 1;
												for(LessonObjectives lo : lessonObjectives){%>
												<input type="text" name='objective<%=count%>' id="objective<%=count%>" class="input-block-level objective-validation" value='<%=lo.getObjective()%>'>
												<input type="hidden" name='objectiveId<%=count%>' value="<%=lo.getId()%>">
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
											<div class="controls">
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
																thumbnailPath = themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER ;
														}
														}
													else{
																thumbnailPath = themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER ;
														} 
													%>
													
												<img src="<%=thumbnailPath+"?"+new Date().getTime()%>" id="userImageId" style="width: 145px; margin-bottom: 5px;" class="img-polaroid"></img></br>
												<span class="btn btn-default" onclick="<portlet:namespace />uploadImage('<%=uploadImage%>','Upload Image')">Change</span>
												<span class="btn btn-default" id="deleteButtonId" onclick="deleteUserImage()">Delete</span>
												 <aui:input id="thumbnailUpload"  name="file" type="hidden" label="Add Thumbnail" /> 
												 <aui:input id="fileUpload" name="dummy" type="hidden" label="Add Thumbnail" />
											</div>
										</div>
									</div> 
							<div class="control-group">
								<label class="control-label" for="thumbnail" style="margin-top:-4px;"><liferay-ui:message key="are-you-answering-a-request" />?
									<a href="#" class="nyu-tooltip" title='<liferay-ui:message key="if-your-lesson-is-answering-any-of-the-existing-request-for-a-lesson-then-choose-from-the-dropdown" />'>
									<img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></a>
							 	</label>
								<div>
									<a href="javascript:void(0)" class="btn" id="requestNo" name="requestNo"> No </a>
									<a href="javascript:void(0)" class="btn" id="requestYes" name="requestYes"> Yes </a>
									<aui:input id="requestLessonCheck" name="requestLessonCheck" type="hidden" />
									
										<div id="lessonRequests" style="display:none; margin-top: 10px;">
											<aui:select name="requestLesson" label="null">
												<aui:option value="0">select</aui:option>
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
						
						<%-- <c:if test="${permissionChecker.isGroupAdmin(scopeGroupId)}">
							<button style="bottom: 15px; left: 85px; position: absolute;" id="category2-label" class="btn btn-default" type="button" onclick="<portlet:namespace />addCategories('<%=addCategoryPopupURL%>')">
							<i class="icon-plus"></i> Add Categories</button> 
						</c:if> --%>								 
						<%-- <aui:input id="tags" name="tags" autoSize="true" resizable="true" type="assetTags" label="Tags" /> --%> 
						<aui:input type="hidden" name="courseId" value="SMPL101"  title="Emptying the Session Textbox will create a value as MINI-xx"/> 			
									
									
								</div> <!-- end span6 -->
							</div> <!-- end  row-fluid -->	
							<div class="row-fluid text-right">
							<div class="span7 text-left content-disclaimer">
								<strong>Note:</strong><i> Any information entered will be lost if the back or forward button on the browser is clicked.</i>
							</div>		
								<input type="button" class="btn btn-default" onclick="cancelLesson('<%=homeUrl%>')" value="Cancel" />
								<input type="button" id="saveContinue" name="saveContinue" class="btn btn-primary" value="Save" onclick="saveLessonDetails()"/> 	
							</div> <!-- end  row-fluid -->
						</aui:form>	<!-- end form -->	
					</div> <!-- end lesson-details -->
				</div> <!-- end progress-content -->
				
				<div class="processingImg" align="center" style="display:none;">
					<img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt=""/> 
				</div>
			
				<%String editLessonSaved = request.getAttribute(Constant.EDIT_LESSON_SAVED)!=null ? (String)request.getAttribute(Constant.EDIT_LESSON_SAVED) : ""; %>
				<div class="custom-alert details-process-alert text-left">  						
					<div class="message-body" style="top:50%; margin-top:-75px"> 
							<h4 class="message-heading"> <i class="icon-info-sign" style="font-size: 30px;"></i>  </h4>
							<div class="content"> 
								Lesson details saved successfully and available in My Lessons under My Stuff
							</div>
					</div>  <!--  end message-body --> 						
				</div> <!--  end custom-alert -->
		
				<div class="custom-alert section-process-alert text-left">  						
					<div class="message-body" style="top:50%; margin-top:-75px"> 
							<h4 class="message-heading"> <i class="icon-info-sign" style="font-size: 30px;"></i>  </h4>
							<div class="content"> 
								Lesson content saved successfully and available in My Lessons under My Stuff
							</div>
					</div>  <!--  end message-body --> 						
				</div> <!--  end custom-alert -->
			</div> <!-- end DetailsTab -->
			
		</div> <!-- end tab-content -->
	</div> <!-- end nyYouTab -->
	</div>
</div> <!-- end container -->
<%@include file="/WEB-INF/jsp/common/categoriesSelector.jsp"%>
<%@include file="/WEB-INF/jsp/common/tagsSelector.jsp"%>
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


</aui:script>

<script>
	  
		$( document ).ready(function() {
			
			if('<%=editLessonSaved%>'!='' && '<%=editLessonSaved%>'=='detailsSavedSuccess'){
				$('.details-process-alert').show();
				setTimeout(function(){
					$('.details-process-alert').hide();
				}, 4000);
			}
			
			if('<%=editLessonSaved%>'!='' && '<%=editLessonSaved%>'=='contentSavedSuccess'){
				$('.section-process-alert').show();
				setTimeout(function(){
					$('.section-process-alert').hide();
				}, 4000);
			}
			
			$('#checkGroup').hide();
			if($("input[type='radio']:checked").val()=="private"){
				$('#checkGroup').show(); 
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
					  var addInput = "<input type='text' style='margin-bottom:10px;' name='objective"+objectiveCounter+" 'id='objective"+objectiveCounter+"'class='input-block-level objective-validation'>";
					  $("#<portlet:namespace/>pureObjective").append(addInput);
				 }
				 
				  hideAddObjective();
			});

			function hideAddObjective(){
				 if(objectiveCounter == 5){
					  $('a#addObjective').hide();
					  $('#addObjectiveHelp').hide();
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
				$('.processingImg').show();
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
<%@ include file="commonScript.jsp" %>
 <script>
//Remove Access USER
$('.close').on('click',function(){
	var userId = $(this).data('id');
	var currentDom=$(this);
	AUI().use(
	  		'aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent: '<p> <Strong>Are you sure you want to remove this member?</Strong></p>', centered: true,
	  				headerContent: null, 
	  				modal: true,
	  				render: '#members',
	  				width: 350,
	  				zIndex: 999,
	  				resizable: false,
	  				toolbars: {
	  					footer: [
	  					{
	  						label: 'Yes',
	  						on: {
	  							click: function() {
	  								$.ajax({
	  									url : '<%=removeUserLessonAccess%>',
	  								  	type : 'GET',
	  								  	async : false,
	  								  	data:{
	  								  		<portlet:namespace/>lessonId:${lessonId},
	  								  		<portlet:namespace/>userId:userId
	  									  },
	  								  	success: function(data){
	  								  			
	  									}
	  								});
	  								currentDom.parent().remove();
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
	
});

$('.userAccess').on('change',function(){
	var userId = $(this).data('id');
	var type = $(this).val();
	$.ajax({
		url : '<%=assignUserLessonAccess%>',
	  	type : 'GET',
	  	async : false,
	  	data:{
	  		<portlet:namespace/>lessonId:${lessonId},
	  		<portlet:namespace/>type:type,
	  		<portlet:namespace/>userId:userId
		  },
	  	success: function(data){
			
		}
	});
});


$('#addComment').on('click',function(){ 
	var commentDescription = $('#inputComment').val();
	var newComment = '';
	$("#enterCommentErrorId").hide();
	if(commentDescription.trim()==''){
		$("#enterCommentErrorId").html('Please enter comment.').show();
		return false;	
	}
	if(commentDescription.trim().length > 500){
		$("#enterCommentErrorId").html('Maximum 500 characters allowed.').show();
		return false;
	}
	
	$.ajax({
		url : '<%=addEditComment%>',
	  	type : 'GET',
	  	async : false,
	  	data:{
	  		<portlet:namespace/>lessonId:${lessonId},
	  		<portlet:namespace/>comment:commentDescription,
	    },
	  	success: function(data){
	  		var userDetails=JSON.parse(data);
	  		newComment = '<li class="group-list-item">'+
	  		'<div class="media">'+
	  			'<img src="'+userDetails.userImg+'" style="width: 45px; height: 45px;" alt="" class="media-object pull-left">'+
	  			'<div class="media-body">'+
	  				'<h5 class="media-heading">'+userDetails.userName+'</h5>'+  
	  				commentDescription
	  			'</div>'+
	  		'</div>'+
	  		'</li>';
	  		$('#discussion').find('.group-list').prepend(newComment);
	  		$('#inputComment').val("");
		}
	});	  
});


$(function(){
	var userDropDown=${userDropDownArray};
	
	var content = $('#lesson-section-content');
	var scope = angular.element(content).scope();
    scope.nyuLessonObjectives = JSON.parse(AllJsonNyuLessonObjectives.jsonNyuLessonObjectives);
	scope.$apply(function() {
   	});
	
	for(var i in userDropDown){
	     $("#"+userDropDown[i].dropDownId).val(userDropDown[i].dropDownValue);
	}
	var newComment = '';
	var userComments=${userCommentsArray};
	for(var i in userComments){
		newComment = newComment+'<li class="group-list-item">'+
  		'<div class="media">'+
  			'<img src="'+userComments[i].userImg+'" style="width: 45px; height: 45px;" alt="" class="media-object pull-left">'+
  			'<div class="media-body">'+
  				'<h5 class="media-heading">'+userComments[i].userName+'</h5>'+  
  				userComments[i].comment
  			'</div>'+
  		'</div>'+
  		'</li>';
	}
	$('#discussion').find('.group-list').append(newComment);
});

</script>
<!--*************************************** 
********************************************preview Js -->
<script type="text/javascript" src="<%=themeDisplay.getPathThemeJavaScript()%>/jquery/bootstrap.min.js"></script>  
<script>
$('#myCarouselSection').carousel({
	interval: false
});
	// TOGGLER USER INFO
YUI().use('aui-toggler', function(Y) {
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
});
</script>


<script>
function cancelLesson(homeUrl){
	AUI().use(
	  		'aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent: '<p> <Strong>Are you sure you want to discard the changes?</Strong></p>', centered: true,
	  				headerContent: null, 
	  				modal: true,
	  				width: 360,
	  				zIndex: 999,
	  				resizable: false,
	  				toolbars: {
	  					footer: [
	  					{
	  						label: 'Yes',
	  						on: {
	  							click: function() {
	  								modal.hide();
									window.location.href=homeUrl;
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
};

function saveAsDraftInEdit(){
	var lessonId = ${lessonId};
	$('.section-saveasdraft-alert').show();
	setTimeout(function(){
		window.location.href='<%=homeUrl%>';
	}, 2000);
	$.ajax({
		url : '<%=saveAsDraft%>',
	  	type : 'GET',
	  	async : false,
	  	success: function(data){
			
		}
	});
}



(function(){
	
	$('#lessonToggler').find('h1').on('click',function(){
		$(this).find('i').toggleClass('icon-chevron-right, icon-chevron-down');
	});
	
	$('#publishLessonPublish').click(function(){
		
		var share = $('#ShareWhere li a.active').data("share");
		var sharelabel ='';
		var privateType = '';
		var privateValue = ''; 
		if(share == 'private'){
			if($('#groupAndInvitation #userRadio').is(':checked')){
				privateType = 'user';
				privateValue = $('#ShareWhere li #selectedUsers').val();
			}else{
				privateType = 'userGroup';
				privateValue = $('#ShareWhere li #selectedUserGroups').val();
			}
			sharelabel = 'Private List (via group or by invitation only)';
		}else if(share == '<%= Constant.PORTLET_PROP_SITE_NAME_SMALL %>'){
			sharelabel = '<%=Constant.CURRENT_BRAND_NAME%> Community (Any alumnus, faculty, staff or student)';
		}else{
			sharelabel = 'General Public (via social media, etc.)';
		}
		var permission = $('#Permissions li a.active').data("permission");
		AUI().use(
		  		'aui-modal',
		  		function(Y) {
		  			var modal = new Y.Modal(
		  			{
		  				bodyContent: '<p> <Strong>Are you sure you want your lesson to be published to the '+sharelabel+'?</Strong></p>', centered: true,
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
		  								var lessonId = ${lessonId};
		  								$('.section-process-alert').show();
		  								$.ajax({
		  									url : '<%=publishLessonURL%>',
		  								  	type : 'GET',
		  								  	async : false,
		  								  	data:{
		  								  		<portlet:namespace/>lessonId:lessonId,
		  								  		<portlet:namespace/>share :share,
		  								  		<portlet:namespace/>privateType :privateType,
		  								  		<portlet:namespace/>privateValue :privateValue,
		  										<portlet:namespace/>permission :permission
		  									  },
		  								  	success: function(data){
		  								  		setTimeout(function(){
		  							  				$('.section-process-alert').hide();
		  											window.location.href='<%=homeUrl%>';
		  										}, 2000);
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
		<%-- if(viewLesson){
			window.location.href='<%=homeUrl%>';
		}
		 --%>
	});
	
$('#coAuthorLessonPublish').click(function(){
		var share = '${privacy}';
		var sharelabel ='';
		var privateType = '';
		var privateValue = ''; 
		if(share == 'private' || share == 'user'){
			if($('#groupAndInvitation #userRadio').is(':checked')){
				privateType = 'user';
				privateValue = $('#ShareWhere li #selectedUsers').val();
				share = 'private';
			}else{
				privateType = 'userGroup';
				privateValue = $('#ShareWhere li #selectedUserGroups').val();
				share = 'private';
			}
			sharelabel = 'Private List (via group or by invitation only)';
		}else if(share == '<%= Constant.PORTLET_PROP_SITE_NAME_SMALL %>'){
			sharelabel = '<%=Constant.CURRENT_BRAND_NAME%> Community (Any alumnus, faculty, staff or student)';
		}else{
			sharelabel = 'General Public (via social media, etc.)';
		}
		var permission ='${permission}';
		
		AUI().use(
		  		'aui-modal',
		  		function(Y) {
		  			var modal = new Y.Modal(
		  			{
		  				bodyContent: '<p> <Strong>Are you sure you want your lesson to be published to the '+sharelabel+'?</Strong></p>', centered: true,
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
		  								var lessonId = ${lessonId};
		  								$('.section-process-alert').show();
		  								$.ajax({
		  									url : '<%=publishLessonURL%>',
		  								  	type : 'GET',
		  								  	async : false,
		  								  	data:{
		  								  		<portlet:namespace/>lessonId:lessonId,
		  								  		<portlet:namespace/>share :share,
		  								  		<portlet:namespace/>privateType :privateType,
		  								  		<portlet:namespace/>privateValue :privateValue,
		  										<portlet:namespace/>permission :permission
		  									  },
		  								  	success: function(data){
		  								  		setTimeout(function(){
		  							  				$('.section-process-alert').hide();
		  											window.location.href='<%=homeUrl%>';
		  										}, 2000);
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
		<%-- if(viewLesson){
			window.location.href='<%=homeUrl%>';
		}
		 --%>
	});

})();




$(window).load((function(){
	if($('a.portlet-icon-back') != null){
		$('a.portlet-icon-back').remove();
	}
	if("${openContentInEdit}" == 'yes'){
		/* //$('#nyYouTabContentTab').trigger('click'); */
	}
}));

function swap(a, b) {
    a = $(a); b = $(b);
    var tmp = $('<span>').hide();
    a.before(tmp);
    b.before(a);
    tmp.replaceWith(b);
};

function selectContributor(changePrimaryContributorUrl, userId, obj){ 
	var currentLi = $(obj).closest('li'),
		collaboratorList = $(obj).closest('#collaboratorList'),
		firstLi = collaboratorList.find('li:first-child');
	
	AUI().use(
  		'aui-modal',
  		function(Y) {
  			var modal = new Y.Modal(
  			{
  				bodyContent: '<p> <Strong>Do you want to make the selected Collaborator as a Primary Contributor</Strong></p>', 
  				centered: true,
  				headerContent: null, 
  				modal: true,
  				width: 300,
  				zIndex: 999,
  				resizable: false,
  				toolbars: {
  					footer: [
  					{
  						label: 'Ok',
  						on: {
  							click: function() {
  								$.ajax({
  							        url:changePrimaryContributorUrl,
  							        type: 'GET',
  							        datatype:'html',
  							        data:{
  							        	"<portlet:namespace />updatedPrimaryContriutor":userId
  							        },
  							        success: function(data){  
  							        	swap(currentLi,firstLi);
  							        	
						        		collaboratorList.find('li').find('label').css('display','inline')
						        		.end().find('.close').css('display','inline')
						        		.end().find('b').text('Collaborator:');
						        		
						        		collaboratorList.find('li:first-child').find('label').css('display','none')
						        		.end().find('.close').css('display','none')
						        		.end().find('b').text('Contributor:');
						        		
  							        	modal.hide();
  									}
  							    });
  								
  								
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
//CARUOSEL LOADING ONE FRAME AT TIME SCRIPT<START>
var ShowDocumentCarousel =null;

$(function(){
	ShowDocumentCarousel = new carouselIframeLoader(1,${documentSection.size()},${documentSection.size()},"height: 277px; width: 100%; border:0;");
	ShowDocumentCarousel.createIframeInActiveItem($('.item.active'));
	$('.portlet-borderless-bar').remove();
});

$('.carousel-control.right').click(function(){
	ShowDocumentCarousel.rightClick();
});

$('.carousel-control.left').click(function(){
	ShowDocumentCarousel.leftClick();
});

$('.carousel-indicators li').click(function(){
	ShowDocumentCarousel.indicatorsClick($(this)); 
});

//CARUOSEL LOADING ONE FRAME AT TIME SCRIPT<END>
</script>
