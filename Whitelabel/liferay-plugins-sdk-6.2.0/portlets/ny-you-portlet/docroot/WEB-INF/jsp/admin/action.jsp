<%@page import="com.nyu.model.Keywords"%>
<%@page import="com.liferay.portal.kernel.util.WebKeys"%> 
<%@page import="com.liferay.portal.kernel.dao.search.ResultRow"%> 
<%@page import="com.nyu.model.Basno"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>


<% ResultRow row = (ResultRow) request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW); 
String manageType=(String)request.getAttribute(Constant.MANAGE_TYPE);

if(manageType.equals("manageBadges")) {

	Basno badge = (Basno) row.getObject(); 
	String badgeId=String.valueOf(badge.getBadgeId());
	String jsMethod="javascript:editBadge('"+badgeId+"')";
%>
	<portlet:actionURL var="deleteBadgeURL">
		<portlet:param name="action" value="deleteBadge"/>
		<portlet:param name="badgeId" value="<%=badgeId %>"/>
	</portlet:actionURL>
	
	
	<liferay-ui:icon-menu>	
		<liferay-ui:icon image="edit" url="<%=jsMethod %>" 	message="edit-badge" /> 
		<liferay-ui:icon image="delete" 	message="delete-badge" url="<%=deleteBadgeURL %>" /> 
	</liferay-ui:icon-menu>

<%}%>

<%if(manageType.equals("manageKeywords")) {%>

	<% 
		Keywords keyword = (Keywords) row.getObject(); 
		String keywordId=String.valueOf(keyword.getId());
		String jsMethod="javascript:editKeyword('"+keywordId+"')";
		String deleteKeyword="javascript:deleteKeyword('"+keywordId+"')";
		%>
			
		<liferay-ui:icon-menu>	
			<liferay-ui:icon image="edit" url="<%=jsMethod %>" 	message="edit-keyword" /> 
			<liferay-ui:icon image="delete" message="delete-keyword" url="<%=deleteKeyword %>" /> 
		</liferay-ui:icon-menu>

<%}%>
