<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>		<%--	added by asif 	 --%>

<%@ include file="groupDetail.jsp" %>
<c:set var="isTagRequired" value="true" />
<c:if test="${isUserMemberOfGroup}">
	<div class="span4">
		<%@ include file="navigationLink.jsp" %>
	</div>
	<div class="span8">
		<%@ include file="threadDiscussion.jsp" %>
	</div>
</c:if>
<c:if test="${!isUserMemberOfGroup}">
	<%-- You don't have permission to see this group as this is private group.	--%>
	<liferay-ui:message key="you-dont-have-permission-to-see-this-group-as-this-is-a-private-group" />
	<span><a href="<%=groupHome%>" style="font-size: 16px; text-decoration: none;"> <liferay-ui:message key="group-home" /> </a>
					<i class="icon-home"></i></span>
</c:if>