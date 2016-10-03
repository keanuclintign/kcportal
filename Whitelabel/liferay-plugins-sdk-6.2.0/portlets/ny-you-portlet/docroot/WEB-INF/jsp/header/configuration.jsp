<%@ include file="/WEB-INF/jsp/init.jsp" %>
<div>
<liferay-portlet:actionURL var="saveUrl" portletConfiguration="true">
</liferay-portlet:actionURL>

<aui:form action="<%=saveUrl%>" >
	<aui:input name="videoUrl" label="take-a-tour-video-url" value="${takeTourVideoUrl}" ></aui:input>
	<aui:button value="save" type="submit" ></aui:button>
</aui:form>
</div>