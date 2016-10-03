<%@page import="com.nyu.util.Constant"%>
<%@page import="com.liferay.portal.service.UserGroupLocalServiceUtil"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.nyu.service.LessonLocalServiceUtil"%>
<%@page import="com.liferay.portlet.social.service.SocialActivityAchievementLocalService"%>
<%@page import="com.liferay.portlet.social.service.SocialActivityLocalServiceUtil"%>
<%
List<SocialActivity> activities1 = SocialActivityLocalServiceUtil.getActivities(model,0,100);
List<SocialActivity> activities=new ArrayList<SocialActivity>();

List<Lesson> lessons=LessonLocalServiceUtil.getLessonsUploadedByAuthor(PortalUtil.getUserId(request));
List<UserGroup> userGroups=UserGroupLocalServiceUtil.getUserUserGroups(PortalUtil.getUserId(request));
	Set<Long> PKsId=new HashSet<Long>();	
if(model.contains(Constant.CAPITAL_LESSON)){
	for(Lesson lesson:lessons)
		{
			PKsId.add(lesson.getLessonId());
		}
	
	 for(SocialActivity activitie:activities1){
		long classId=ClassNameLocalServiceUtil.getClassNameId(model);
		if(PKsId.contains(activitie.getClassPK()) && (activitie.getUserId()!=PortalUtil.getUserId(request)))
			activities.add(activitie);
	}
}else{
	for(UserGroup userGroup:userGroups)
	{
		PKsId.add(userGroup.getUserGroupId());
	}

 for(SocialActivity activitie:activities1){
	long classId=ClassNameLocalServiceUtil.getClassNameId(model);
	if(PKsId.contains(activitie.getClassPK()) && (activitie.getUserId()!=PortalUtil.getUserId(request)))
		activities.add(activitie);
}
}
String className = (String)request.getAttribute("liferay-ui:social-activities:className");

long classPK = GetterUtil.getLong((String)request.getAttribute("liferay-ui:social-activities:classPK"));
int feedDelta = GetterUtil.getInteger((String)request.getAttribute("liferay-ui:social-activities:feedDelta"));
String feedDisplayStyle = (String)request.getAttribute("liferay-ui:social-activities:feedDisplayStyle");
boolean feedEnabled = !PortalUtil.isRSSFeedsEnabled() ? false : GetterUtil.getBoolean((String)request.getAttribute("liferay-ui:social-activities:feedEnabled"));
String feedLink = (String)request.getAttribute("liferay-ui:social-activities:feedLink");
String feedLinkMessage = (String)request.getAttribute("liferay-ui:social-activities:feedLinkMessage");
String feedTitle = (String)request.getAttribute("liferay-ui:social-activities:feedTitle");
String feedType = (String)request.getAttribute("liferay-ui:social-activities:feedType");

if (activities == null) {
	activities = SocialActivityLocalServiceUtil.getActivities(0, className, classPK, QueryUtil.ALL_POS, QueryUtil.ALL_POS);
}

String selector = StringPool.BLANK;

Format dateFormatDate = FastDateFormatFactoryUtil.getSimpleDateFormat("MMMM d", locale, timeZone);
Format timeFormatDate = FastDateFormatFactoryUtil.getTime(locale, timeZone);
%>

