<meta property="og:image" content="https://<%=PortalUtil.getHost(request)%><%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>facebookLogo.jpg"/>
<link rel="image_src" type="image/jpeg" href="https://<%=PortalUtil.getHost(request)%><%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>facebookLogo.jpg" />

<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%
 String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),layout.isPrivateLayout(),themeDisplay);
 String homeUrl=siteFriendlyUrl+Constant.PAGE_HOME;
 %>
 <div class=container>
 <div class=span12>
		<a href='<%=homeUrl%>' ><button class="btn pull-right">Back</button></a>
</div>
</div>
<div class=container>
	<liferay-portlet:runtime portletName="viewlesson_WAR_nyyouportlet" queryString="_viewlesson_WAR_nyyouportlet_lessonId=${lessonId}"/>
</div>