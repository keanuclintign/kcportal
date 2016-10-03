
<%@page import="com.nyu.util.CommonUtil"%>
<%@ include file="/WEB-INF/jsp/activity/init.jsp" %>

<div class="taglib-social-activities">
	<table>

	<%
	ServiceContext serviceContext = ServiceContextFactory.getInstance(request);

	boolean hasActivities = false;

	Date now = new Date();

	int daysBetween = -1;
	if(model.contains(Constant.CAPITAL_LESSON)){
	for (SocialActivity activity : activities) {
	
		SocialActivityFeedEntry activityFeedEntry = SocialActivityInterpreterLocalServiceUtil.interpret(selector, activity, serviceContext);

		if (activityFeedEntry == null) {
			continue;
		}

		if (!hasActivities) {
			hasActivities = true;
		}

		Portlet portlet = PortletLocalServiceUtil.getPortletById(company.getCompanyId(), activityFeedEntry.getPortletId());

		int curDaysBetween = DateUtil.getDaysBetween(new Date(activity.getCreateDate()), now, timeZone);
	%>

		<c:if test="<%= curDaysBetween > daysBetween %>">

			<%
			daysBetween = curDaysBetween;
			%>

			<tr>
				<td class="day-separator" colspan="2">
					<c:choose>
						<c:when test="<%= curDaysBetween == 0 %>">
							<liferay-ui:message key="today" />
						</c:when>
						<c:when test="<%= curDaysBetween == 1 %>">
							<liferay-ui:message key="yesterday" />
						</c:when>
						<c:otherwise>
							<%= dateFormatDate.format(activity.getCreateDate()) %>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:if>

		<tr>
			<td class="portlet-icon">
				<img src="<%=themeDisplay.getPathThemeImages()+Constant.PORTLET_PROP_PATH_VENDOR %>lesson-activity-icon.png" alt=""/> 
			</td>
			<td class="activity-data">
				<div class="activity-title">
					<%
						User UserActivity=UserLocalServiceUtil.getUserById(activity.getUserId()); 
						String activityTitle=activityFeedEntry.getTitle();
					%>
					
					<%=UserActivity.getFullName()%> 
					 <span style="color:#0066FF;"><%=activityTitle.substring(0, activityTitle.indexOf("\""))%></span> 
					 <%=activityTitle.substring(activityTitle.indexOf("\"")+1,activityTitle.length()-1)%> 

				</div>
				<div class="activity-body">
					<span class="time"><%= timeFormatDate.format(activity.getCreateDate()) %></span>

					<%= activityFeedEntry.getBody() %>
				</div>
			</td>
		</tr>

	<%
	}}else{
	
	for (SocialActivity activity : activities) {
		

		if (!hasActivities) {
			hasActivities = true;
		}
	

		int curDaysBetween = DateUtil.getDaysBetween(new Date(activity.getCreateDate()), now, timeZone);
	%>

		<c:if test="<%= curDaysBetween > daysBetween %>">

			<%
			daysBetween = curDaysBetween;
			%>

			<tr>
				<td class="day-separator" colspan="2">
					<c:choose>
						<c:when test="<%= curDaysBetween == 0 %>">
							<liferay-ui:message key="today" />
						</c:when>
						<c:when test="<%= curDaysBetween == 1 %>">
							<liferay-ui:message key="yesterday" />
						</c:when>
						<c:otherwise>
							<%= dateFormatDate.format(activity.getCreateDate()) %>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:if>

		<tr>
			<td class="portlet-icon">
				<img src="<%=themeDisplay.getPathThemeImages()+Constant.PORTLET_PROP_PATH_VENDOR %>group-content-icon.png" alt=""/>
			</td>
			<td class="activity-data">
				<div class="activity-title">
					<%
						User UserActivity=UserLocalServiceUtil.getUserById(activity.getUserId()); 
						String activityTitle=activity.getExtraData();
					%>
					
					<%=UserActivity.getFullName()%> 
					 <span style="color:#0066FF;"><%=activityTitle%></span> 
					 <%="\""+UserGroupLocalServiceUtil.getUserGroup(activity.getClassPK()).getName()+"\" Group"%> 

				</div>
				<div class="activity-body">
					<span class="time"><%= timeFormatDate.format(activity.getCreateDate()) %></span>
					<%=CommonUtil.getDatesDuration(activity.getCreateDate(), 0)%>
				</div>
			</td>
		</tr>
	<%}}%>
	</table>

	<c:if test="<%= !hasActivities %>">
		<liferay-ui:message key="there-are-no-recent-activities" />
	</c:if>
</div>

<c:if test="<%= feedEnabled && !activities.isEmpty() %>">
	<div class="separator"><!-- --></div>

	<liferay-ui:rss
		delta="<%= feedDelta %>"
		displayStyle="<%= feedDisplayStyle %>"
		feedType="<%= feedType %>"
		message="<%= feedLinkMessage %>"
		name="<%= feedTitle %>"
		url="<%= feedLink %>"
	/>
</c:if>

<%!
%>