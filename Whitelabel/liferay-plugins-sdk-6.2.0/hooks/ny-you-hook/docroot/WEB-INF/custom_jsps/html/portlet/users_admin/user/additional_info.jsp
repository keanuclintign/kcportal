<%@ include file="/html/portlet/users_admin/init.jsp" %>

<%
User selUser = (User)request.getAttribute("user.selUser");
%>

<h3><liferay-ui:message key="additional_info" /></h3>

<aui:fieldset>
	<liferay-ui:custom-attribute-list
		className="com.liferay.portal.model.User"
		classPK="<%= (selUser != null) ? selUser.getUserId() : 0 %>"
		editable="<%= true %>"
		label="<%= true %>"
	/>
</aui:fieldset>