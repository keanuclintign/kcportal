<%--
/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@page import="javax.portlet.PortletMode"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.liferay.portlet.social.model.SocialActivityCounter"%>
<%@page import="com.liferay.portlet.social.model.SocialActivityCounterConstants"%>
<%@page import="com.liferay.portlet.social.service.SocialActivityCounterLocalServiceUtil"%>
<%@page import=" com.liferay.portlet.social.service.SocialRelationLocalServiceUtil"%>
<%@page import="com.liferay.portlet.social.util.SocialCounterPeriodUtil" %>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.*"%>
<%@ include file="/html/portlet/user_statistics/init.jsp" %>
<%
	SimpleDateFormat formatter = new SimpleDateFormat( "MMMM yyyy " );  
	String date = formatter.format( new java.util.Date() ); 
	 PortletURL topContributorUrl= PortletURLFactoryUtil.create(request, "lessons_WAR_nyyouportlet", layout.getPlid(), "RESOURCE_PHASE");
	topContributorUrl.setPortletMode(PortletMode.VIEW);
%>
<div id="display-top-contributors-180" style="display:none">
</div>
<div id="top-contributors-180">
<h3><b>Top contributor(s) of the month <%=date%></b></h3>
<%

PortletURL portletURL = renderResponse.createRenderURL();

List<String> rankingNamesList = new ArrayList<String>();

if (rankByParticipation) {
	rankingNamesList.add(SocialActivityCounterConstants.NAME_PARTICIPATION);
}

if (rankByContribution) {
	rankingNamesList.add(SocialActivityCounterConstants.NAME_CONTRIBUTION);
}

String[] rankingNames = rankingNamesList.toArray(new String[rankingNamesList.size()]);

if (!rankingNamesList.isEmpty()) {
	SearchContainer searchContainer = new SearchContainer(renderRequest, null, null, SearchContainer.DEFAULT_CUR_PARAM, 9, portletURL, null, null);
	  

	int total = SocialActivityCounterLocalServiceUtil.getUserActivityCountersCount(scopeGroupId, rankingNames);

	searchContainer.setTotal(total);

	List<String> selectedNamesList = new ArrayList<String>();

	selectedNamesList.add(SocialActivityCounterConstants.NAME_CONTRIBUTION);
	selectedNamesList.add(SocialActivityCounterConstants.NAME_PARTICIPATION);

	if (displayAdditionalActivityCounters) {
		for (int displayActivityCounterNameIndex : displayActivityCounterNameIndexes) {
			selectedNamesList.add(PrefsParamUtil.getString(portletPreferences, request, "displayActivityCounterName" + displayActivityCounterNameIndex));
		}
	}

	String[] selectedNames = selectedNamesList.toArray(new String[selectedNamesList.size()]);

	List<Tuple> results = SocialActivityCounterLocalServiceUtil.getUserActivityCounters(scopeGroupId, rankingNames, selectedNames, searchContainer.getStart(), searchContainer.getEnd());

	searchContainer.setResults(results);
	if(results!=null && results.size()>0){
        searchContainer.setTotal(results.size());
	}

	List resultRows = searchContainer.getResultRows();

	for (int i = 0; i < results.size(); i++) {
		Tuple tuple = results.get(i);

		ResultRow row = new ResultRow((Map<String, SocialActivityCounter>)tuple.getObject(1), (Long)tuple.getObject(0), i);

		// User display

		row.addJSP("/html/portlet/user_statistics/user_display.jsp", application, request, response);

		// Add result row

		resultRows.add(row);
	}

	String rankingNamesMessage = LanguageUtil.format(pageContext, rankingNames[0], StringPool.BLANK);

	for (int i = 1; i < rankingNames.length; i++) {
		rankingNamesMessage = LanguageUtil.format(pageContext, "x-and-y", new Object[] {rankingNamesMessage, rankingNames[i]});
	}
	%>


	<%-- <c:if test="<%= showHeaderText %>">
		<div class="top-users">
			<c:if test="<%= total > 0 %>">
				<liferay-ui:message arguments="<%= total %>" key="top-users-out-of-x" /> <%= LanguageUtil.format(pageContext, "ranking-is-based-on-x", rankingNamesMessage) %><br />
			</c:if>
		</div>
	</c:if> --%>

	<c:if test="<%= total == 0 %>">
		<liferay-ui:message key="there-are-no-active-users-for-this-period" />
	</c:if>

	<liferay-ui:search-iterator paginate="<%= false %>" searchContainer="<%= searchContainer %>" />

	<c:if test="<%= results.size() > 0 %>">
		<div class="taglib-search-iterator-page-iterator-bottom" id="<portlet:namespace />searchTopUsers">
			<liferay-ui:search-paginator searchContainer="<%= searchContainer %>" type="article" />
		</div>
	</c:if>

	<aui:script use="aui-io-plugin-deprecated">
		var searchTopUsers = A.one('#<portlet:namespace />searchTopUsers');

		if (searchTopUsers) {
			var parent = searchTopUsers.ancestor();

			parent.plug(
				A.Plugin.IO,
				{
					autoLoad: false
				}
			);

			searchTopUsers.all('a').on(
				'click',
				function(event) {
					event.preventDefault();

					var uri = event.currentTarget.get('href').replace(/p_p_state=normal/i, 'p_p_state=exclusive');

					parent.io.set('uri', uri);
					parent.io.start();
				}
			);
		}
	</aui:script>

<%
}
else {
%>

	<div class="alert alert-info portlet-configuration">
		<a href="<%= portletDisplay.getURLConfiguration() %>" onClick="<%= portletDisplay.getURLConfigurationJS() %>">
			<liferay-ui:message key="please-configure-this-portlet-and-select-at-least-one-ranking-criteria" />
		</a>
	</div>

<%
}
%>
<%@include file="previousMonth_userStat.jsp" %>
</div>