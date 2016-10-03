
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
 <h1> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyGroups.png">
 	<liferay-ui:message key="my-groups" />
 </h1>
 <%
 String action = request.getParameter(Constant.COMMON_STRING_CONSTANT_ACTION);
 String queryString = StringPool.UNDERLINE+Constant.PORTLET_USERGROUP+"_fromMyStuff=true&action="+action;
 
 %>
 <liferay-portlet:runtime portletName="<%=Constant.PORTLET_USERGROUP%>" queryString="<%=queryString %>" />



