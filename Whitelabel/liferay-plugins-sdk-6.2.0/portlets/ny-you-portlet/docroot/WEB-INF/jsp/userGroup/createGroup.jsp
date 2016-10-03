<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>			<%--	added by asif 	 --%>
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

<style>
.input-custom-mb{
margin-bottom:0px !important;
}

.btn.btn-primary.custom{
line-height: 18px;
height: 18px;
}
</style>

<portlet:renderURL var="redirectUrl">
<portlet:param name="group" value="yes"/>
</portlet:renderURL> 

<%
String groupWindowState ="";
if(layout.getFriendlyURL().equalsIgnoreCase(Constant.PAGE_GROUP)){
	groupWindowState = "maximized";
}else{
	groupWindowState = "normal";
}
%>
<portlet:renderURL var="groupDetailsUrl" windowState="<%=groupWindowState %>" >
	<portlet:param name="action" value="lessonUrl" />
	<portlet:param name="userGroupId" value="**usergroupId**" />
	<portlet:param name="afterCreate" value="yes" />
</portlet:renderURL>

<portlet:renderURL var="uploadImage" windowState="pop_up">
	<portlet:param name="action" value="uploadImage" />
</portlet:renderURL>

<portlet:resourceURL var="deleteImageURL" id="deleteImageURL" />
<% 
UserGroup userGroup = null; 
boolean groupPrivacy = false;
LayoutSet publicLS= null;
LayoutSet privateLS =null;
String logo=null;

if(request.getAttribute(Constant.USER_CAPITAL_GROUP)!=null)
	userGroup = (UserGroup)request.getAttribute(Constant.USER_CAPITAL_GROUP);

ResourceURL createGroupUrl = renderResponse.createResourceURL();
createGroupUrl.setResourceID("addUpdateGroup");

ResourceURL keywordUrl = renderResponse.createResourceURL();
keywordUrl.setResourceID("keywordRequest");
keywordUrl.setParameter(Constant.KEYWORD_ID,"**keywordId**");
keywordUrl.setParameter(Constant.KEYWORD_CAPITAL_NAME,"**keywordName**");

if(userGroup!=null){
	groupPrivacy = GetterUtil.getBoolean(userGroup.getExpandoBridge().getAttribute(Constant.GOROUP_PRIVACY));
	
	publicLS=LayoutSetLocalServiceUtil.getLayoutSet(userGroup.getGroupId(), false);
	if(publicLS.getLogo()){
		logo=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+publicLS.getLogoId();	
	}
		
	privateLS=LayoutSetLocalServiceUtil.getLayoutSet(userGroup.getGroupId(), true);
	if(privateLS.getLogo()){
		logo=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+privateLS.getLogoId();	
	}
	
	createGroupUrl.setParameter(Constant.GROUP_ACTION_TYPE, Constant.UPDATE_GROUP);
	createGroupUrl.setParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID, Long.toString(userGroup.getUserGroupId()));
	
}else{
	userGroup = UserGroupLocalServiceUtil.createUserGroup(0);
	createGroupUrl.setParameter(Constant.GROUP_ACTION_TYPE, "addGroup"); 
	logo = themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.GROUP_CARD_PLACEHOLDER;
}
%>

<%-- <script src='<%=themeDisplay.getPathThemeJavaScript()%>/jquery/jquery-1.11.0.min.js' type="text/javascript"></script>  --%>

	<aui:form id="createGroupForm" name="createGroupForm"  action="<%=createGroupUrl.toString() %>" enctype="multipart/form-data" >
		<aui:model-context bean="<%=userGroup%>" model="<%=UserGroup.class %>"/> 
		<aui:input type='text' placeholder="group-name" name="name" id="groupName"  label="group-name-required" cssClass="input-custom-mb input-block-level">
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
		<div style="margin-bottom: 10px;">
			<label><liferay-ui:message key="add-logo" /></label>
			<img src="<%=logo%>" id="groupImageId" style="height: 100px; width: 138px; margin-bottom: 5px;" class="img-polaroid"></img></br>
			<span class="btn btn-default" onclick="<portlet:namespace />uploadImage('<%=uploadImage%>','Upload Image')"><liferay-ui:message key="change" /></span>
			<span class="btn btn-default" id="deleteButtonId" onclick="<portlet:namespace/>deleteGroupImage()"><liferay-ui:message key="delete" /></span>				
		</div>
		<aui:input cssClass="input-block-level no-bottom-margin" id="groupDescription" value="<%=userGroup.getDescription() %>" label="description-required" name="groupDescription"  placeholder="group-description" type="textarea">
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
		<%@include file="/WEB-INF/jsp/common/includeCategory.jsp"%>
		<%@include file="/WEB-INF/jsp/common/includeTag.jsp"%> 				
		<aui:input  name="groupPrivacy"  type="hidden" value="<%=groupPrivacy %>" />
		
 	</aui:form>
	<footer class="text-center">
		<a href="javascript:void(0);" class="btn group-close-popup"> <liferay-ui:message key="Cancel" /> </a>
		<a href="javascript:void(0);" class="btn back-group-type"> <!-- <i class="icon-arrow-left"> </i> --> <liferay-ui:message key="back" /> </a>
		<a href="javascript:void(0);" onClick="addUpdateGroup('<%=createGroupUrl%>','<%=groupDetailsUrl%>','<%=keywordUrl%>',groupPrivacy)" class="btn btn-primary custom"> <liferay-ui:message key="create" /> </a>
	</footer>






<%-- <aui:form id="createGroupForm" name="createGroupForm"  action="<%=createGroupUrl.toString() %>" enctype="multipart/form-data" >
<aui:model-context bean="<%=userGroup%>" model="<%=UserGroup.class %>"/>
<div class="container ">
	<div class="row-fluid">
		<div class="span12 newMessage">
			<div class="control-group">
				<div class="controls"><aui:input name="name" value="<%=userGroup.getName() %>" id="groupName" autoFocus="true" label="Group Name" cssClass="field-required newMessageinput" placeholder="Group Name">
				<aui:validator name="maxLength">15</aui:validator>
				</aui:input>
				</div>
			</div>

			<div class="control-group">
				<div class="controls">
					<label id="fileUploadTitleId">Add Logo</label>
					<input type="file" name="groupLogo" id="fileUpload"/> 
					<aui:input id="fileUpload"  name="" type="file"/>
				</div>
				<div id="imgPrev">
					<canvas id="myCanvas" style="height: 50px; width: 80px;"></canvas>
					<aui:a id="deleteThumbnail" href="#" style="float:right;margin-top: 15px;">Delete</aui:a>
				</div>
			</div>
						
			<div class="control-group">
				<div class="controls"><aui:input cssClass="field-required newMessageinput" value="<%=userGroup.getDescription() %>" label="Group Description" name="groupDescription"  placeholder="Group Description" type="textarea" /></div>
			</div>
			
			<div class="control-group create-grp-btn">
			<div class="input-append input-block-level">
				<aui:field-wrapper>
					
					<aui:fieldset>
						<label>Categories</label>
						<aui:input type="assetCategories" id="categories" name="categories" label=""></aui:input>
					</aui:fieldset>
					<aui:fieldset cssClass="onlyTags">
						<label>Tags</label>
						<aui:input id="tags" name="tags" type="assetTags" label="" />
					</aui:fieldset>
				</aui:field-wrapper>
			</div>
			</div>
			
			<div class="control-group">
				<aui:input label="Make as Private" name="groupPrivacy"  type="checkbox" value="<%=groupPrivacy %>" />
			</div>
			<input type="hidden" value="" id="isImageDeletedID" name="isImageDeleted"/>	
			<input type="hidden" value="" id="isImageChangedID" name="isImageChanged"/>	
			<div class="controls pull-right">
			<button type="button"  onClick="addUpdateGroup('<%=createGroupUrl%>')" class="btn btn-primary btn-large">
				<% if(!userGroup.getName().equals("")){%>
					Update
				<%}else{ %>
					Create
				<%} %>
			</button></div>
			
			<div class="publishProcess" id="groupProcessing" align="center" style="display:none;">  						
  						<div style="width:400px;">
	  						<img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt="" align="center" style=" margin-top: 110px; " />
	  						<br>
	  							Processing...<br/>
	  							This may take a few seconds...
						</div>  						
  			</div>
  			
		</div>
	</div>
</div>
</aui:form> --%>
<%@include file="/WEB-INF/jsp/common/categoriesSelector.jsp"%>
<%@include file="/WEB-INF/jsp/common/tagsSelector.jsp"%>
<c:set var="groupnamespace"><portlet:namespace/></c:set>
<script>
var groupnamespace = "${groupnamespace}"; 
    
<%-- var loadDefaultThumbnail = function(actionType) {
	var canvas = document.getElementById('myCanvas');
	var context = canvas.getContext('2d');
	var existingThumb = '<%=logo%>'; 
	
	var img = new Image();
	
	img.onload = function() {
		       canvas.width = img.width;
		       canvas.height = img.height;		
		  	   context.drawImage(img, 0, 0);
	};
	
	if(existingThumb!='null' && existingThumb!=''){
		img.src = existingThumb+'&t='+'<%=new Date().getTime()%>';
		$('#'+namespace+'deleteThumbnail').show();
		$("#fileUpload").hide(); 
		$("#fileUploadTitleId").hide();
	}else{
		$('#<portlet:namespace/>deleteThumbnail').hide();
		$("#fileUpload").show();
		$("#fileUploadTitleId").show();
		$("#myCanvas").hide();
	}
	
};  --%>

$( document ).ready(function() {
	$('#<portlet:namespace/>deleteThumbnail').hide();
	/* loadDefaultThumbnail("default"); */
	
});

$('#<portlet:namespace/>deleteThumbnail').click(function() {
	$('#<portlet:namespace/>deleteThumbnail').hide();
	$("#fileUpload").show();
	$("#fileUploadTitleId").show();
	$("#myCanvas").hide();
	$('#isImageDeletedID').val("yes");

});	


$("#fileUpload").change(function(){
	$('#isImageChangedID').val("yes");
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

function <portlet:namespace/>deleteGroupImage() {
	var deleteImageURL = "<%=deleteImageURL%>";
	$.ajax({
        url:deleteImageURL,
        type: 'GET',
        datatype:'html',
        success: function(data){
        	$("#groupImageId").attr("src",data);
    	}
      });
}

Liferay.provide(window,
	    '<portlet:namespace/>closeUploadImagePopup',
	    
	        function(popupIdToClose,imgsrc,withSuccessMsg) {
	        if(imgsrc.trim() != ''){
	    	$("#groupImageId").attr("src",imgsrc);
	    	}
	    	Liferay.Util.getOpener().closeMainImagePopup(popupIdToClose);
		    	if(withSuccessMsg != null && withSuccessMsg == 'yes'){
		    		closePopupForAllWithSuccessMsg('<liferay-ui:message key="group-thumbnail-saved-successfully" />');
		    	}
	        },
	        ['liferay-util-window']
	    );
</script>

