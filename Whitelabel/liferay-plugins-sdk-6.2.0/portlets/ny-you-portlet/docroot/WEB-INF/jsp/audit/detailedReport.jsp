<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

<c:set var="userId" value="${auditReport.userId}" scope="page" />
		
<table id="detailReport">
	<tr>
		<td>	<b><liferay-ui:message key="company-id" /> :</b> </td><td>${auditReport.companyId}</td>
	</tr>	
	<tr>
		<td>	<b><liferay-ui:message key="net-id" /></b> </td><td> <%=UserLocalServiceUtil.getUser(GetterUtil.getLong(pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_USER_ID))).getScreenName()%></td>
	</tr>	
	<tr>
		<td>	<b><liferay-ui:message key="user-name" /> :</b></td><td> ${auditReport.userName}</td>
	</tr>	
	<tr>
		<td>	<b><liferay-ui:message key="event-type" /> :</b></td><td> ${auditReport.eventType}</td>
	</tr>	
	<tr>
		<td>	<b><liferay-ui:message key="event-date" /> :</b></td><td> ${auditReport.createDate}</td>
	</tr>	
	<tr>
		<td>	<b><liferay-ui:message key="client-ip" /> :</b> </td><td>${auditReport.clientIP}</td>
	</tr>	
	<tr>
		<td>	<b><liferay-ui:message key="client-host" /> :</b></td><td> ${auditReport.clientHost}</td>
	</tr>	
	<tr>
		<td>	<b><liferay-ui:message key="server-name" /> :</b></td><td>${auditReport.serverName}</td>
	</tr>	
	<tr>
		<td>	<b><liferay-ui:message key="resource-id" />:</b> </td><td>${auditReport.classPK}</td>
	</tr>	
	<tr>
		<td>	<b><liferay-ui:message key="resource-type" /> :</b></td><td> ${auditReport.className}</td>
	</tr>	
	<tr>
		<td>	<b><liferay-ui:message key="message" />: </b></td><td>${auditReport.message}</td>
	</tr>	
	<tr>
		<td>	<b><liferay-ui:message key="additional-info" />:</b></td><td>${auditReport.additionalInfo}</td>
	</tr>	
</table>