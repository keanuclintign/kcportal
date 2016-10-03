<%@page import="com.liferay.portal.model.UserGroup"%>
<%@page import="com.nyu.model.Lesson"%>
<%@page import="com.liferay.portal.kernel.dao.orm.QueryUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portal.kernel.util.FastDateFormatFactoryUtil"%>
<%@page import="java.text.Format"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@ page import="com.liferay.portlet.social.model.SocialActivity" %>
<%@page import="com.liferay.portlet.social.model.SocialActivityFeedEntry" %>
<%@page import="com.liferay.portlet.social.service.SocialActivityInterpreterLocalServiceUtil" %>
<%@page import="com.liferay.portlet.social.service.SocialActivityLocalServiceUtil" %>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.kernel.util.DateUtil"%>
<%@page import="com.liferay.portal.model.Portlet"%>
<%@page import="com.liferay.portal.service.PortletLocalServiceUtil"%>
<%@page import="com.liferay.portlet.social.service.SocialActivityInterpreterLocalServiceUtil"%>
<%@page import="com.liferay.portlet.social.model.SocialActivityFeedEntry"%>
<%@page import="java.util.Date"%>
<%@page import="com.liferay.portal.service.ServiceContextFactory"%>
<%@page import="com.liferay.portal.service.ServiceContext"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<div id="dashboardActivity">
<%
String[] classNames={Lesson.class.getName(),UserGroup.class.getName()};
for(String model:classNames){%>
	<div class="box" >
		<h1>
		<% 
		String icon=model.contains(Constant.CAPITAL_LESSON)?"lesson-header-icon.png":"usergroup-activity-icon.png";
		%>
		<%-- <img src="<%=themeDisplay.getPathThemeImages()+Constant.PORTLET_PROP_PATH_VENDOR%><%=icon%>" alt=""/> --%>
		<%=model.contains(Constant.CAPITAL_LESSON)?"Lesson Activity":"Group Activity"%>
		</h1>
		<div style="overflow-x:hidden;overflow-y:auto;;max-height:250px">
			<%@ include file="/WEB-INF/jsp/activity/page.jsp" %>
		</div>
	</div> <!--  end box  -->
<%}%>
</div>