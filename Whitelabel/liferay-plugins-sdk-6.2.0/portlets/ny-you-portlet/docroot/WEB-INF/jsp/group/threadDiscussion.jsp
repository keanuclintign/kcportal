<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>		<%--	added by asif 	 --%>

<portlet:resourceURL var="groupDiscussion" id="groupDiscussion" />
<portlet:resourceURL var="deleteDiscussion" id="deleteDiscussion" />

<!-- <h3><b>Discussion</b></h3> -->

<span id="discussionToggler"  class="btn btn-warning"><liferay-ui:message key="start-new-discussion" /></span>

<div id="lessonDiscussion" style="display:none">
	<label><b><liferay-ui:message key="title" /> :</b></label>
	<input type="text" id="<portlet:namespace/>discussionTitle"  name="<portlet:namespace/>discussionTitle" />
	
	<label><b><liferay-ui:message key="body" /> :</b></label>
	<liferay-ui:input-editor name="discussionMessage" initMethod="" skipEditorLoading="false"
										 toolbarSet="edit-in-place"  ></liferay-ui:input-editor>
	<button class="btn btn-primary" onclick="lessonDiscussion(${usergroup.userGroupId},'0',true)"><liferay-ui:message key="save" /></button>
	<button class="btn cancel-discussion" onclick="javascript:$('#lessonDiscussion').hide()"><liferay-ui:message key="cancel" /></button>
</div>

	<div id="<portlet:namespace/>discussionContent" style="margin-top:10px">
		<%@ include file="/WEB-INF/jsp/group/discussionResults.jsp" %>
	</div>

<script>

$("#discussionToggler,.discussionReply").click(function(){
	$("#lessonDiscussion").toggle();
	CKEDITOR.instances['<portlet:namespace />discussionMessage'].focus();
	
});
var currentReplyBox;

$(document).on('click','.cancel-discussion',function(){
	$('#<portlet:namespace/>discussionTitle').val("");
	try{ currentReplyBox.setData("");}catch(err){}
	try{ window.<portlet:namespace />discussionMessage.setHTML("");}catch(err){}
});

function openReplyDiscussion(obj,i){
	$('.textareaClass').hide();
	$('#textareaDiv'+i).show();
	try{
		currentReplyBox=CKEDITOR.replace('textarea'+i,{
	        height:140,
	        width: '100%',
	        toolbar:'simple',
	        startupFocus : true,
	        customConfig: ''
		});
	}catch(err){
		CKEDITOR.instances['textarea'+i].focus();
	}
}

function saveReplyDiscussion(lessonId,i){
	var reply=currentReplyBox.getData();
	window.<portlet:namespace />discussionMessage.setHTML(reply);
	lessonDiscussion(lessonId,i,false);
	$("#<portlet:namespace/>discussionContent").animate({ 
        scrollTop: $('#textareaDiv'+i).offset().top 
    }, 600);
}

function lessonDiscussion(lessonId,messageId,titleFlag){
	var checkTitleFlag=titleFlag; 
	if(checkTitleFlag){
		var title=$('#<portlet:namespace/>discussionTitle').val();
		if(title.trim() == ''){
			return customDialog('Title');
		}
		if(title.trim().length > 75){
			return customDialog('title below 75 characters');
		}
	}
	var userComment=window.<portlet:namespace />discussionMessage.getHTML();
	var userCommentsLength = $("#cke_<portlet:namespace />discussionMessage").find("iframe").contents().find("body").text().trim();
	if(userCommentsLength.length <= 0){
		if(userComment.toLowerCase().indexOf('<iframe') != -1){
			userCommentsLength = userComment;
		}
	}
	if(userCommentsLength.trim() == ''){
		return customDialog('Message');
	}
	else{
	$.ajax({
        url:'<%=groupDiscussion%>',
        type: 'POST',
        datatype:'html',
        data:{
        	<portlet:namespace/>userNote:userComment,
        	<portlet:namespace/>title:title,
        	<portlet:namespace/>userGroupId:lessonId,
        	<portlet:namespace/>messageId:messageId,
             },
        success: function(data){
        	$('#<portlet:namespace/>discussionContent').html(data);
        	$('#lessonDiscussion').hide();
        	$('#<portlet:namespace/>discussionTitle').val("");
        	window.<portlet:namespace />discussionMessage.setHTML('');
        	lessonAccordinActivate();
        }
    });
	}
}


function customDialog(item){
	AUI().use('aui-modal',
			function(Y) {
				var modal = new Y.Modal(
				{
				bodyContent: '<p> <Strong><liferay-ui:message key="please-provide" /> '+item+'.</Strong></p>', centered: true,
				headerContent: null, 
				modal: true,
				cssClass:'popup_alert',
				width: 350,
				zIndex: 999,
				resizable: false,
				toolbars: {
				footer: [
							{
	  						label: '<liferay-ui:message key="ok" />',
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

function lessonAccordinActivate(){
YUI().use( 'aui-toggler', function(Y) {
	new Y.TogglerDelegate(
	  {
		animated: true,
		closeAllOnExpand: true,
		container: '#lesson-discuss-accordin',
		content: '.discussion-content',
		expanded: false,
		header: '.header',
		transition: {
		  duration: 0.2,
		  easing: 'cubic-bezier(0, 0.1, 0, 1)'
		}
	  }
	);
});
}

$(function(){
	lessonAccordinActivate();
});

function <portlet:namespace/>deleteDiscussion(messageId,isHeader){
	var content='';
	if(isHeader == 'true'){
		content = '<liferay-ui:message key="are-you-sure-you-want-to-remove-this-discussion" />';
	}else{
		content = '<liferay-ui:message key="are-you-sure-you-want-to-remove-this-reply" />';
	}
	
	AUI().use('aui-modal',function(Y) {
	var modal = new Y.Modal(
	{
		bodyContent: '<p> <Strong>'+content+'</Strong></p>', centered: true,
		headerContent: null, 
		modal: true,
		render: '#requestLesson',
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
					        url:'<%=deleteDiscussion%>',
					        type: 'POST',
					        datatype:'html',
					        data:{
					        	<portlet:namespace/>userGroupId:'${usergroup.userGroupId}',
					        	<portlet:namespace/>messageId:messageId,
					        	<portlet:namespace/>isHeader:isHeader
					             },
					        success: function(data){
								$('.'+messageId+'-class').remove();
					        }
					    });
						modal.hide();
					}
			}
			},
			{
				label: '<liferay-ui:message key="cancel" />',
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
