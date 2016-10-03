<%@page import="com.nyu.util.Constant"%>
<%@page import="com.nyu.service.persistence.NYUUserGroupUtil"%>
<%@page import="com.nyu.model.NYUUserGroup"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.UserGroup"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<div class="row-fluid">
<portlet:resourceURL var="authenticationURL" id="authenticationURL" /> 
<portlet:resourceURL var="memberDeleteURL" id="memberDeleteURL" />
<h4><b><liferay-ui:message key="members" /></b></h4>
	<c:forEach items="${members}" var="user" varStatus="i">
	<c:set var="userId" value="${user.userId}" scope="page" />
		<%
		Long userId = GetterUtil.getLong(pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_USER_ID));
		String autho_info=UserLocalServiceUtil.getUser(userId).getExpandoBridge().getAttribute(Constant.EXPANDO_FIELD_AUTHOR_INFO).toString();
		if(autho_info.length() > 90)
			autho_info=autho_info.substring(0, 90)+" ...";
		User memberAuthor = CommonUtil.getAuthor(userId);
		boolean isAdmin=adminIDs.contains(userId+"");
		%>
	<ul class="unstyled" id="groupMembers">
		<%if(groupPrivacy && (usergroup.getUserId()==themeDisplay.getUserId() || hasAdminRights)){
		%>
		<li>
			<img class="icon-user" src="${user.getPortraitURL(themeDisplay)}">
			<% if(usergroup.getUserId()==themeDisplay.getUserId() && usergroup.getUserId()==memberAuthor.getUserId()){ %>
					<span class="user-name"><liferay-ui:message key="you" /></span>
					<span class="emai-id">${user.emailAddress}</span> 
			<%}else{ %>
				<span class="user-name">${user.firstName} ${user.lastName}</span>
				<span class="emai-id">${user.emailAddress}</span> 
				<%if(usergroup.getUserId()!=memberAuthor.getUserId()){%>
			        <select class="select-box" onchange="authenticate_fnc(this,'<%=authenticationURL%>', '${usergroup.userGroupId}');" data-memberId="${user.userId}">
			   			<option value="viewOnly">View Only</option>
			        	<option value="administrator" <%=isAdmin?"selected='selected'":""%>><liferay-ui:message key="administrator" /></option>
			  		</select>
			  		
			  		<span class="pull-right" style="padding-right: 20px; position: relative; z-index: 1;"">
						<a class="cursor-pointer nyu-tooltip" data-memberId="${user.userId}" onclick="memDelete_fnc(this,'<%=memberDeleteURL%>', '${usergroup.userGroupId}');" title='<liferay-ui:message key="delete-member" />'>
						<i class="icon-trash"></i>	</a>
					</span>
	  			<%}
			}%> 
	  	</li>
		<%}else{ %>
		<li>
			<img class="icon-user" src="${user.getPortraitURL(themeDisplay)}">
			<% if(memberAuthor.getUserId()==themeDisplay.getUserId()){ %>
				<span class="user-name"><liferay-ui:message key="you" /></span>
				<span class="emai-id">${user.emailAddress}</span> 
			<%}else{ %>
				<span class="user-name">${user.firstName} ${user.lastName}</span>
				<span class="emai-id">${user.emailAddress}</span>
			<%}%> 
	  	</li>
		<%}%>
	</ul>	
 </c:forEach>
</div>


<script type="text/javascript">

 function authenticate_fnc(id, authenticationURL, groupId) {
	var memberId=$(id).data('memberid');
    var selectedValue = $(id).val();
    var yes = $(".yes");
    var no = $(".no");
    $.ajax({
        url:authenticationURL,
        type: 'GET',
        datatype:'html',
        data:{
        	"<portlet:namespace />selectedValue": selectedValue,
        	"<portlet:namespace />memberId": memberId,
        	"<portlet:namespace />groupId": groupId,
        },
        success: function(data){
         }
      });
   }
 
 
 function memDelete_fnc(id,memberDeleteURL,groupId) {
		var memberId=$(id).data('memberid');
		AUI().use(
		  		'aui-modal',
		  		function(Y) {
		  			var modal = new Y.Modal(
		  			{
		  				bodyContent: '<p> <Strong><liferay-ui:message key="are-you-sure-you-want-to-remove-this-member" /></Strong></p>', centered: true,
		  				headerContent: null, 
		  				modal: true,
		  				render: '#members',
		  				width: 350,
		  				zIndex: 999,
		  				resizable: false,
		  				toolbars: {
		  					footer: [
		  					{
		  						label: '<liferay-ui:message key="Yes" />',
		  						on: {
		  							click: function() {
		  								$.ajax({
		  							        url:memberDeleteURL,
		  							        type: 'GET',
		  							        datatype:'html',
		  							        data:{
		  							        	"<portlet:namespace />groupId": groupId,
		  							        	"<portlet:namespace />memberId": memberId,
		  							        },
		  							        success: function(data){
		  							        	$(id).parent().remove();
		  							        	modal.hide();
		  							         }
		  							      });
		  								
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
		  			}
		  		).render();
		  	  	});
	   }

  </script>


