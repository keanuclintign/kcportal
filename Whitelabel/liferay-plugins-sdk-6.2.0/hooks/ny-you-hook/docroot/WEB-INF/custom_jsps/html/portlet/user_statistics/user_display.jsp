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

<%@ include file="/html/portlet/user_statistics/init.jsp" %>

<%
PortletURL topContributorUrl= PortletURLFactoryUtil.create(request, "lessons_WAR_nyyouportlet", layout.getPlid(), "RESOURCE_PHASE");
	topContributorUrl.setPortletMode(PortletMode.VIEW);
PortletURL portletURL = renderResponse.createRenderURL();

SearchContainer searchContainer = new SearchContainer(renderRequest, null, null, SearchContainer.DEFAULT_CUR_PARAM,9, portletURL, null, null);

ResultRow row = (ResultRow)request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);
  
Map<String, SocialActivityCounter> activityCounters = (Map<String, SocialActivityCounter>)row.getObject();
 
SocialActivityCounter contributionActivityCounter = activityCounters.get(SocialActivityCounterConstants.NAME_CONTRIBUTION);

if (contributionActivityCounter == null) {
	contributionActivityCounter = new SocialActivityCounterImpl();

	contributionActivityCounter.setName(SocialActivityCounterConstants.NAME_CONTRIBUTION);
}

if (!contributionActivityCounter.isActivePeriod(SocialActivityCounterConstants.PERIOD_LENGTH_SYSTEM)) {
	contributionActivityCounter.setCurrentValue(0);
}

SocialActivityCounter participationActivityCounter = activityCounters.get(SocialActivityCounterConstants.NAME_PARTICIPATION);

if (participationActivityCounter == null) {
	participationActivityCounter = new SocialActivityCounterImpl();

	participationActivityCounter.setName(SocialActivityCounterConstants.NAME_PARTICIPATION);
}

if (!participationActivityCounter.isActivePeriod(SocialActivityCounterConstants.PERIOD_LENGTH_SYSTEM)) {
	participationActivityCounter.setCurrentValue(0);
}

activityCounters.remove(SocialActivityCounterConstants.NAME_CONTRIBUTION);
activityCounters.remove(SocialActivityCounterConstants.NAME_PARTICIPATION);
%>

<a href="javascript:void(0);" onClick="authorLesson('<%=topContributorUrl.toString() %>','<%= GetterUtil.getLong(row.getPrimaryKey()) %>')" id=><liferay-ui:user-display
	userId="<%= GetterUtil.getLong(row.getPrimaryKey()) %>"
	userName=""
></a>
	<c:if test="<%= userDisplay != null %>">
		<div class="user-rank">
			<span class="statistics-label"><liferay-ui:message key="rank" />:</span> <%= searchContainer.getStart() + row.getPos() + 1 %>
		</div>

		<div class="contribution-score">
			<span class="statistics-label"><liferay-ui:message key='contribution-score' />:</span> <%= contributionActivityCounter.getCurrentValue() %>

			<c:if test="<%= showTotals %>">
				<span>(<liferay-ui:message key="total" />: <%= contributionActivityCounter.getTotalValue() %>)</span>
			</c:if>
		</div>

		<div class="participation-score">
			<span class="statistics-label"><liferay-ui:message key='participation-score' />:</span> <%= participationActivityCounter.getCurrentValue() %>

			<c:if test="<%= showTotals %>">
				<span>(<liferay-ui:message key="total" />: <%= participationActivityCounter.getTotalValue() %>)</span>
			</c:if>
		</div>
	</c:if>
</liferay-ui:user-display>

<c:if test="<%= displayAdditionalActivityCounters %>">
	<div class="separator"><!-- --></div>

	<%
	for (SocialActivityCounter activityCounter : activityCounters.values()) {
		if (!activityCounter.isActivePeriod(SocialActivityCounterConstants.PERIOD_LENGTH_SYSTEM)) {
			activityCounter.setCurrentValue(0);
		}
	%>

		<div class="social-counter-<%= activityCounter.getName() %>">
			<span class="statistics-label"><liferay-ui:message key='<%= "user.statistics." + activityCounter.getName() %>' />:</span> <%= activityCounter.getCurrentValue() %>

			<c:if test="<%= showTotals %>">
				<span>(<liferay-ui:message key="total" />: <%= activityCounter.getTotalValue() %>)</span>
			</c:if>
		</div>

	<%
	}
	%>

</c:if>
 


<script>
function authorLesson(url,id){

	 AUI().use('aui-base','liferay-portlet-url','aui-node', function(A) {
		$.ajax({
	        url:url+'&p_p_resource_id=userLessons',
	        type: 'GET',
	        datatype:'html',
	        data:{
	        	_lessons_WAR_nyyouportlet_authorId:id,
	        	
	        },
	        success: function(data){
	        	
	        	$("#hidden").hide();
	        	$(".tab-content>.active").html(data);
				$("#display-top-contributors-180").html(data);
				$("#top-contributors-180").hide();
				$("#display-top-contributors-180").show();
				$('#display-top-contributors-180').find('.thumbnail-content').each(function(i,val){	    
				    if(i%3 == 0) {  
				      $(this).addClass('no-margin clearfix');
				    }
				});
	        	
			}
	    }); 
	});  
  
}

//Add Bootstrap Class in top contributors
$(document).ready(function(){
	
	$('#top-contributors-180').find('.table').children('.table-data').addClass('row-fluid')
	.children('tr').addClass('span4 shadow').find('.avatar').addClass('img-circle');
	
	$('#top-contributors-180 table').find('tr').each(function(i,val){	    
	    if(i%3 == 0) {  
	      $(this).addClass('no-margin');
	    }
	});
	
});
</script> 
