<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="com.nyu.util.Constant"%>

<% 
String groupQueryString = StringPool.UNDERLINE+Constant.PORTLET_LESSON+"_userGroupId="+pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
%>

<liferay-portlet:runtime portletName="<%=Constant.PORTLET_LESSON%>" queryString="<%=groupQueryString%>" />
