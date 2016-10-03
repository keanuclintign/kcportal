<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>		<%--	added by asif 	 --%>

<%@ include file="groupDetail.jsp" %>
<c:set var="isTagRequired" value="false" />
<c:if test="${isUserMemberOfGroup}">
	<div class="row-fluid">
		<div class="span3">
			<%@ include file="navigationLink.jsp" %>
		</div>
		<div class="span9">
			<%@ include file="threadDiscussion.jsp" %>
		</div>
	</div>
	
	<script>
	$(function(){
		$('.discussionAnchor').addClass("active");
	});
	</script>
</c:if>
<c:if test="${!isUserMemberOfGroup}">
	<liferay-ui:message key="you-dont-have-permission-to-see-this-group-as-this-is-a-private-group" />.
	<span class="pull-right nyu-tooltip" title='<liferay-ui:message key="click-to-go-to-group-home-page" />'><a href="<%=groupHome%>"  style="font-size: 16px; text-decoration: none;"> <liferay-ui:message key="group-home" /> </a>
					<i class="icon-home"></i></span>
</c:if>