<%@page import="com.liferay.portal.kernel.util.PropsUtil"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="com.nyu.util.Constant"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://liferay.com/tld/portlet"   prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%-- <%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %> --%>			<%--	commented by asif	 --%>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page import="javax.portlet.PortletURL"%>
<%@page import="com.nyu.model.Lesson"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="com.liferay.util.portlet.PortletProps"%>
<%@page import="com.liferay.portlet.messageboards.service.MBMessageLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="com.liferay.portlet.messageboards.model.MBMessage"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>			<%--	added by asif 	 --%>

<%@page import="com.liferay.portlet.asset.service.AssetTagLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@page import="com.nyu.util.Constant"%>
<%@page import="com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.model.AssetTag"%>
<%@page import="com.liferay.portlet.asset.model.AssetVocabulary"%>
<%@page import="com.liferay.portlet.asset.model.AssetCategory"%>
<%@page import="com.nyu.util.UserGroupSortByTime"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Date"%>
<%@page import="javax.portlet.ResourceURL"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %> 
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.model.LayoutSet"%>
<%@page import="com.liferay.portal.service.LayoutSetLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.service.UserGroupLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.UserGroup"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="java.util.Date"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="javax.portlet.PortletMode"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="com.nyu.NoSuchNYUUserGroupException"%>
<%@page import="com.nyu.service.NYUUserGroupLocalServiceUtil"%>
<%@page import="com.nyu.model.NYUUserGroup"%>
<%@page import="com.nyu.service.UserGroupRequestLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.nyu.model.UserGroupRequest"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.liferay.portal.service.UserGroupLocalServiceUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.model.UserGroup"%>
<%@page import="com.liferay.portal.service.LayoutSetLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.LayoutSet"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.nyu.model.Lesson"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>	
<meta http-equiv="X-UA-Compatible" content="IE=10; IE=9; IE=8; IE=EDGE" />

<portlet:defineObjects />
<liferay-theme:defineObjects />

<c:set var="namespace"><portlet:namespace/></c:set>

<c:set var="context" value="${renderRequest.getContextPath()}"/>

<c:set var="engageLaunchServiceUrl" value="${context}/engage/launcher"/>

<c:if test="${showScriptValues ne 'no'}">
	<script type="text/javascript">
		var contextPath = "${renderRequest.getContextPath()}";
		var namespace = "${namespace}";
		var currentUserId= <%=themeDisplay.getUserId() %>;
		var current_context_page_name = "<%=layout.getFriendlyURL().substring(1) %>";
		var homeUrl = '<%=themeDisplay.getPortalURL()%>';
	</script>
</c:if>