<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>		<%--	added by asif 	 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:if test="${not empty usergroup}">
	<%@ include file="groupDetail.jsp" %>
	<c:set var="isTagRequired" value="true" />
	<c:if test="${isUserMemberOfGroup}">
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/js/angular/lessons.js"></script>
		<div class="row-fluid">
			<div class="span3">
				<%@ include file="navigationLink.jsp" %>
			</div>
			<div class="span9">
				<%@ include file="groupLessonResults.jsp" %>
			</div>
		</div>
		
		<script>
		$(function(){
			$('.lessonAnchor').addClass("active");
		});
		</script>
	</c:if>
	<c:if test="${!isUserMemberOfGroup}">
		<liferay-ui:message key="you-dont-have-permission-to-see-this-group-as-this-is-a-private-group" />.
		<span class="pull-right nyu-tooltip" title='<liferay-ui:message key="click-to-go-to-group-home-page" />' ><a href="<%=groupHome%>" style="font-size: 16px; text-decoration: none;"> <liferay-ui:message key="group-home" /> </a>
						<i class="icon-home"></i></span>
	</c:if>
</c:if>
<c:if test="${empty usergroup}">
	<h4>
		<liferay-ui:message key="this-group-is-no-longer-available" />
	</h4>
</c:if>