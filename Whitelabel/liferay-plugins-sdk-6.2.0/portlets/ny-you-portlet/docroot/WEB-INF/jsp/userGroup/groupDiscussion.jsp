<%@page import="com.nyu.portlet.social.activities.NyuMemberActivityKeys"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@page import="com.liferay.portlet.social.util.SocialCounterPeriodUtil"%>
<%@page import="com.liferay.portal.service.UserGroupLocalServiceUtil"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.nyu.service.LessonLocalServiceUtil"%>
<%@page import="com.liferay.portlet.social.service.SocialActivityAchievementLocalService"%>
<%@page import="com.liferay.portlet.social.service.SocialActivityLocalServiceUtil"%>
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
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="org.joda.time.LocalDate"%>


<%
String to=new LocalDate().monthOfYear().getAsText() + " " + new LocalDate().getDayOfMonth(); 
String from=new LocalDate().monthOfYear().getAsText() +" "+ new LocalDate().minusDays(6).dayOfMonth().get();
Calendar cal = Calendar.getInstance();
long fromDate=cal.getTimeInMillis();
cal.add(Calendar.DATE, -6);
long toDate=cal.getTimeInMillis(); 
%>
<h3> <liferay-ui:message key="this-week" />: <%=from%>  -  <%=to%></h3>
<% 
DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(SocialActivity.class);
dynamicQuery.add(RestrictionsFactoryUtil.eq("classNameId",ClassNameLocalServiceUtil.getClassNameId(UserGroup.class.getName())));
dynamicQuery.add(RestrictionsFactoryUtil.eq("classPK",userGroupId));
dynamicQuery.add(RestrictionsFactoryUtil.between("createDate",toDate,fromDate));
List<SocialActivity> activities= SocialActivityLocalServiceUtil.dynamicQuery(dynamicQuery);
int requestAcceptedCount=0;
int commentsAddedCount=0;
int LessonPublishedCount=0;

for(SocialActivity activity:activities){
	
	if(activity.getType()==NyuMemberActivityKeys.ACCEPT_TO_JOIN_GROUP || activity.getType()== NyuMemberActivityKeys.ACCEPT_INVITATION ){
		 requestAcceptedCount++;	
	}
	if(activity.getType()== NyuMemberActivityKeys.ADD_LESSON_TO_GROUP){
		LessonPublishedCount++;	
	}
	if(activity.getType()== NyuMemberActivityKeys.ADD_COMMENT){
		commentsAddedCount++;	
	}
	
}
%>
<ul class="unstyled">
	<li> <i class="icon-file"></i> <span><%=LessonPublishedCount %>&nbsp;<liferay-ui:message key="lesson-published" /> </span> </li>
	<li> <i class="icon-comment"></i>&nbsp;<span><%=commentsAddedCount %>&nbsp;<liferay-ui:message key="comment-added" /> </span> </li>
	<li> <i class="icon-check"></i> <span><%=requestAcceptedCount %>&nbsp;<liferay-ui:message key="new-request-accepted" /> </span> </li>
</ul> 
