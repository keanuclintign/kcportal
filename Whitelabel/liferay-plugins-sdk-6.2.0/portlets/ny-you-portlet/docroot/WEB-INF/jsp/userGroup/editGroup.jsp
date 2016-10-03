<%@page import="com.nyu.util.Constant"%>
<%@page import="com.liferay.portal.kernel.util.UnicodeFormatter"%>
<%@page import="java.util.Date"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="java.io.File"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.model.LayoutSet"%>
<%@page import="com.liferay.portal.service.LayoutSetLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.liferay.portal.service.UserGroupLocalServiceUtil"%>
<%@page import="javax.portlet.ResourceURL"%>
<%@page import="com.liferay.portal.model.UserGroup"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="com.sun.jersey.api.JResponse.AJResponseBuilder"%>


<portlet:renderURL var="groupDetailsUrl" >
	<portlet:param name="action" value="groupUrl" />
	<portlet:param name="userGroupId" value="**usergroupId**" />
	<portlet:param name="afterCreate" value=" " />
</portlet:renderURL>
<portlet:renderURL var="redirectUrl">
<portlet:param name="group" value="yes"/>
</portlet:renderURL> 
<portlet:renderURL var="uploadImage" windowState="pop_up">
	<portlet:param name="action" value="uploadImage" />
</portlet:renderURL>

<portlet:resourceURL var="deleteImageURL" id="deleteImageURL" />


 <div style="display:none">
	<liferay-ui:input-editor name="dummy" initMethod="" skipEditorLoading="false"
										 toolbarSet="simple"  ></liferay-ui:input-editor>
</div> 

<% 
ResourceURL groupUrl = renderResponse.createResourceURL();
groupUrl.setResourceID("addUpdateGroup");

ResourceURL keywordUrl = renderResponse.createResourceURL();
keywordUrl.setResourceID("keywordRequest");
keywordUrl.setParameter(Constant.KEYWORD_ID,"**keywordId**");
keywordUrl.setParameter(Constant.KEYWORD_CAPITAL_NAME,"**keywordName**");

if(usergroup!=null){
		
	publicLS=LayoutSetLocalServiceUtil.getLayoutSet(usergroup.getGroupId(), false);
	if(publicLS.getLogo()){
		logo=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+publicLS.getLogoId();	
	}
		
	privateLS=LayoutSetLocalServiceUtil.getLayoutSet(usergroup.getGroupId(), true);
	if(privateLS.getLogo()){
		logo=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+privateLS.getLogoId();	
	}
	
	groupUrl.setParameter(Constant.GROUP_ACTION_TYPE, Constant.UPDATE_GROUP);
	groupUrl.setParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID, Long.toString(usergroup.getUserGroupId()));
	
}else{
	usergroup = UserGroupLocalServiceUtil.createUserGroup(0);
	groupUrl.setParameter(Constant.GROUP_ACTION_TYPE, "addGroup"); 
}

PortletURL deleteGroupURL = renderResponse.createRenderURL();
deleteGroupURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION,"deleteGroup");
deleteGroupURL.setParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID, userGroupId.toString());	
deleteGroupURL.setWindowState(LiferayWindowState.EXCLUSIVE);
%>

<div class="row-fluid">
<div class="span8 group-edit-form"> 
	<aui:form id="createGroupForm" name="createGroupForm"  action="<%=groupUrl.toString() %>" enctype="multipart/form-data" >
		<aui:model-context bean="<%=usergroup%>" model="<%=UserGroup.class %>"/> 
		
		<div id="groupNameField" class="hidden">
			<aui:input type='text' placeholder="group-name" value="<%=usergroup.getName() %>" name="name" id="groupName"  label="group-name-required" cssClass="newMessageinput no-bottom-margin">
				<aui:validator name="custom" errorMessage="please-enter-the-group-name">
					function (val, fieldNode, ruleValue) {
					var result = false;
					if (val.length>0) {
					result = true;
					}
					return result;
					}
				</aui:validator>
				<aui:validator name="maxLength" errorMessage="group-name-should-not-exceed-more-than-seven-five-characters" >75</aui:validator>
			</aui:input>
			<a href="javascript:void(0)" onclick="javascript:$('#groupNameField,#groupNameValue').toggleClass('hidden')">
				<liferay-ui:message key="edit" />
			</a>
		</div>
		<div id="groupNameValue">
			<span><%=usergroup.getName()%></span>
			<a href="javascript:void(0)" onclick="javascript:$('#groupNameField,#groupNameValue').toggleClass('hidden')">
				<liferay-ui:message key="edit" />
			</a>
		</div>
		
		 <div style="margin-bottom: 10px;">
			<img src="<%=logo%>" id="groupImageId" style="height: 100px; width: 138px; margin-bottom: 5px;" class="img-polaroid"></img></br>
			<span class="btn btn-default" onclick="<portlet:namespace />uploadImage('<%=uploadImage%>','Upload Image')">
				<liferay-ui:message key="change" />
			</span>
			<span class="btn btn-default" id="deleteButtonId" onclick="<portlet:namespace/>deleteGroupImage()">
				<liferay-ui:message key="delete" />
			</span>				
		 </div>			
		
		
		<div id="groupDiscriptionField"  class="hidden">
			<aui:input cssClass="newMessageinput no-bottom-margin" value="<%=usergroup.getDescription() %>" label="description" name="groupDescription"  placeholder="group-description" type="textarea">
			<aui:validator name="custom" errorMessage="please-enter-the-description">
					function (val, fieldNode, ruleValue) {
					var result = false;
					if (val.length>0) {
					result = true;
					}
					return result;
					}
			</aui:validator>
			<aui:validator name="maxLength" errorMessage="Please-enter-description-below-thousands-characters" >1000</aui:validator>
			</aui:input>
		</div>
		
		<div>
			<span id="groupDiscriptionValue"><%=usergroup.getDescription()%></span>
			<a href="javascript:void(0)" onclick="javascript:$('#groupDiscriptionValue,#groupDiscriptionField').toggleClass('hidden')">
				<liferay-ui:message key="edit" />
			</a>
		</div>
			
		<%@include file="/WEB-INF/jsp/common/includeCategory.jsp"%>
		<%@include file="/WEB-INF/jsp/common/includeTag.jsp"%>			
		<aui:input  name="groupPrivacy"  type="hidden" value="<%=groupPrivacyValue%>" />
		<aui:input cssClass="newMessageinput no-bottom-margin" value='<%=nyuUG!=null ? nyuUG.getAbout() : "" %>' label="about" name="groupAbout"  placeholder="about" type="textarea">
			<aui:validator name="custom" errorMessage="special-characters-not-allowed">
					function (val, fieldNode, ruleValue) {
					var result = true;
					var regAboutDataExp = /^[a-zA-Z0-9.! ]*$/;
					 if (!regAboutDataExp.test(val)) {
					    return false;
					 }
					return result;
					}
			</aui:validator>
		<aui:validator name="maxLength" errorMessage="should-not-exceed-more-than-two-hundre-characters" >200</aui:validator>
		</aui:input>
		<input type="hidden" value="" id="isImageDeletedID" name="isImageDeleted"/>	
		<input type="hidden" value="" id="isImageChangedID" name="isImageChanged"/>	
	</aui:form>
	
	<p style="margin-top: 10px;">
		<span class="btn" onClick="addUpdateGroup('<%=groupUrl%>','<%=groupDetailsUrl%>','<%=keywordUrl%>','<%=groupPrivacyValue%>')">
			<liferay-ui:message key="save" />
		</span>
		<span class="btn" onClick="cancelUpdate()">
			<liferay-ui:message key="cancel" />
		</span>  
		<button type="button" title='<liferay-ui:message key="delete" />' class="btn btn-default white" onclick="deleteGroup('<%=deleteGroupURL%>');">
			<liferay-ui:message key="delete" />
		</button>
	</p>
	</div> <!-- span6 offset3 -->
</div> <!-- end row-fluid -->

	
 
	
<c:set var="groupnamespace"><portlet:namespace/></c:set>

<script>
var groupnamespace = "${groupnamespace}"; 
var loadDefaultThumbnail = function(actionType) {
	var existingThumb = '<%=logo%>'; 
	var img = new Image();
	if(existingThumb.indexOf("<%= Constant.PORTLET_PROP_PORTLET_THEME %>/images/") >= 0){
		img.src = existingThumb;	
	}else{
		img.src = existingThumb+'&t='+'<%=new Date().getTime()%>';
	}
}
$( document ).ready(function() {
	loadDefaultThumbnail("default");
});
<%-- $('#editor').click(function() {
	try{
		CKEDITOR.replace('group-about',{
	        height:230,
	        width: '100%',
	        toolbar:'simple',
	        customConfig: ''
		}).setData('<%=nyuUG.getAbout()%>').dom.element('body').parentNode.contentEditable = editable;
	 
	}catch(err)
	{}
}); --%>


function cancelUpdate()
{
 	Liferay.Util.getOpener().closeManageGroup('userGroupPopupId');
}

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

function <portlet:namespace/>deleteGroupImage() {
	var deleteImageURL = "<%=deleteImageURL%>";
	$.ajax({
        url:deleteImageURL,
        type: 'GET',
        datatype:'html',
        success: function(data){
        	$("#groupImageId,.groupImageId").attr("src",data);
        	$("#isImageDeletedID").val("yes");
    	}
      });
}

Liferay.provide(window,
	    '<portlet:namespace/>closeUploadImagePopup',
	    
	        function(popupIdToClose,imgsrc,withSuccessMsg) {
	        if(imgsrc.trim() != ''){
	    	$("#groupImageId,.groupImageId").attr("src",imgsrc);
	    	$("#isImageDeletedID").val("no");
	    	}
	    	Liferay.Util.getOpener().closeMainImagePopup(popupIdToClose);
	    	if(withSuccessMsg != null && withSuccessMsg == 'yes'){
	    		closePopupForAllWithSuccessMsg('<liferay-ui:message key="group-thumbnail-saved-successfully" />');
	    	}
	        },
	        ['liferay-util-window']
	    );

</script>
