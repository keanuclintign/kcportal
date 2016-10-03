<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.UserGroup"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

	<%if(((List<User>)request.getAttribute("requestedMembers")).size()==0) {%>
	<h4 class="message-heading">
		<liferay-ui:message key="member-requests" />
	</h4>
	<%}else{%>
	<h4 class="message-heading"> <liferay-ui:message key="you-have" /> <%=((List<User>)request.getAttribute("requestedMembers")).size() %> 
		<liferay-ui:message key="member-request" /> 
	</h4>
	<%} %>
	<div class="message-body shadow"> 
		<ul class="unstyled">
		
		<%if(((List<User>)request.getAttribute("requestedMembers")).size()==0) {%>
		<span><liferay-ui:message key="no-member-requests" />. </span>
		<%} %>
		<c:forEach items="${requestedMembers}" var="user" varStatus="i">
		<c:set var="userId" value="${user.userId}" scope="page" />
		
			<li class="clearfix"> 
				<a href="#" class="user-name"> ${user.firstName} ${user.lastName} </a> 
				<span class="email-id">${user.emailAddress} </span>
				<span class="date"> 05-20-2014 </span> 
				<div class="pull-right">
					<button class="btn btn-primary"  id="btn-${user.userId}" onclick="acceptUsertoGroup(this,'${usergroupId}','${user.userId}')"> 
						<liferay-ui:message key="accept" /> 
					</button>
					<button class="btn btn-primary" onclick="declineUsertoGroup(this,'${usergroupId}','${user.userId}')">
						<liferay-ui:message key="decline" /> 
					</button>
				</div>
			</li>
		
		</c:forEach>		
		</ul>
	</div>


