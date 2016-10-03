
<%@page import="com.nyu.util.Constant"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="java.util.List"%>
<% 
List<User> TOUReports=(List<User>)request.getAttribute(Constant.TOU_REPORTS);
%>

<table border="1">
<tr>
	</th><th><b>User Name</b></th><th><b>Agreed to TOU</b></th><th><b>Date of Agreement</b></th><th><b>Last Login Date</b></th>
</tr>
<%
for(User user:TOUReports){%>
<tr>
	<td><%=user.getFullName()%></td>
	<td><%=user.getAgreedToTermsOfUse()?"Yes":"No"%></td>
	<td><%if(user.getLastLoginDate()!=null){%>	
			<%=user.getLastLoginDate()!=null ?CommonUtil.dateAsPerFormatForCitation(GetterUtil.getDate(user.getExpandoBridge().getAttribute("agree-date"),null),Constant.EEEE_MMM_D_YYYY):"Never Login"%>
		<%}else{%>
			Not Applicable
		<%}%>
	</td>
	<td><%=user.getLastLoginDate()!=null ?CommonUtil.getDatesDuration(user.getLastLoginDate().getTime(), 0):"Never Login"%></td>
</tr>
<%}%>
</table>