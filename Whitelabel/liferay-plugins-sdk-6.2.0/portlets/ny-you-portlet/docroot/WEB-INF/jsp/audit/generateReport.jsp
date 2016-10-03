<%@page import="com.nyu.util.Constant"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="java.util.List"%>
<%@page import="com.nyu.model.AuditReport"%>

<% 
	List<AuditReport> auditReports=(List<AuditReport>)request.getAttribute(Constant.AUDIT_REPORTS);
%>

<table border="1">
<tr>
	</th><th><b><liferay-ui:message key="user-name" /></b></th><th><b><liferay-ui:message key="event-type" /></b></th><th><b><liferay-ui:message key="event-date" /></b></th><th><b><liferay-ui:message key="additional-info" /></b></th>
</tr>
<%
for(AuditReport auditReport:auditReports){%>
<tr>
	<td><%=auditReport.getUserName()%></td>
	<td><%=auditReport.getEventType()%></td>
	<td><%=auditReport.getCreateDate()%></td>
	<td><%=auditReport.getAdditionalInfo()%></td>
</tr>
<%}%>
</table>