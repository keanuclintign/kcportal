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

<%@ include file="/html/taglib/ui/search/init.jsp" %>

<%
long groupId = ParamUtil.getLong(request, namespace + "groupId");

Group group = themeDisplay.getScopeGroup();

String keywords = ParamUtil.getString(request, namespace + "keywords");

PortletURL portletURL = null;

if (portletResponse != null) {
	LiferayPortletResponse liferayPortletResponse = (LiferayPortletResponse)portletResponse;

	portletURL = liferayPortletResponse.createLiferayPortletURL(PortletKeys.SEARCH, PortletRequest.RENDER_PHASE);
}
else {
	portletURL = new PortletURLImpl(request, PortletKeys.SEARCH, plid, PortletRequest.RENDER_PHASE);
}

portletURL.setParameter("struts_action", "/search/search");
portletURL.setParameter("redirect", currentURL);
portletURL.setPortletMode(PortletMode.VIEW);
portletURL.setWindowState(WindowState.MAXIMIZED);

pageContext.setAttribute("portletURL", portletURL);
%>

<form class="navbar-search" action="<%= portletURL.toString() %>" method="get" name="<%= randomNamespace %><%= namespace %>fm" onSubmit="<%= randomNamespace %><%= namespace %>search(); return false;">
<liferay-portlet:renderURLParams varImpl="portletURL" />
<label for="main-search" class="sr-only">Search Terms</label>
<input class="search-query input-xlarge" name="<%= namespace %>keywords" size="30" title="<liferay-ui:message key="search" />" type="text" value="<%= HtmlUtil.escapeAttribute(keywords.replaceAll("\"", "").replace("*",""))%>" />

<!-- style="display:none" added by Marlabs -->
<select style="display:none" name="<%= namespace %>groupId" title="<liferay-ui:message key="scope" /> ">
	<option value="0" <%= (groupId == 0) ? "selected" : "" %>><liferay-ui:message key="everything" /></option>
	<option value="<%= group.getGroupId() %>" <%= (groupId != 0) ? "selected" : "" %>><liferay-ui:message key='<%= "this-" + (group.isOrganization() ? "organization" : "site") %>' /></option>
</select>

<!-- Changed for Marlabs -->
<%-- <input align="absmiddle" border="0" src="<%= themeDisplay.getPathThemeImages() %>/common/search.png" title="<liferay-ui:message key="search" />" type="image" /> --%>
<input align="absmiddle" border="0" class="btn nyu-search-hook-btn" value="<liferay-ui:message key="search" />" type="button" onclick="<%= randomNamespace %><%= namespace %>search()"/>

<aui:script>
	function <%= randomNamespace %><%= namespace %>search() {
		var keywords = document.<%= randomNamespace %><%= namespace %>fm.<%= namespace %>keywords.value;

		keywords = keywords.replace(/^\s+|\s+$/, '');
		if(keywords.split(" ").length == 1 && keywords.trim().length > 0){
			keywords = keywords+'*';
			document.<%= randomNamespace %><%= namespace %>fm.<%= namespace %>keywords.value=keywords;
		}
		if (keywords != '') {
			if(keywords.indexOf(' ') >= 0 || keywords.indexOf('-') >= 0 )
			{
			document.<%= randomNamespace %><%= namespace %>fm.<%= namespace %>keywords.value="\""+keywords+"\"";
			}
			submitForm(document.<%= randomNamespace %><%= namespace %>fm);
		}
	}
</aui:script>