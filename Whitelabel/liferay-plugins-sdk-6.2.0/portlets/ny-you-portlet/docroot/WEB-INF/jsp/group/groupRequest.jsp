
<%@ include file="groupDetail.jsp" %>
<c:set var="isTagRequired" value="true" />
<c:if test="${isUserMemberOfGroup}">
	<script type="text/javascript"
		src="<%=request.getContextPath()%>/js/angular/requestLessons.js"></script>
	<div class="row-fluid" id="allRequestController" ng-controller="requestLessonsController">
		<div class="span3">
			 <%@ include file="navigationLink.jsp" %> 
		</div>
		<div class="span9 container" >
			<%@ include file="requestResult.jsp" %>
		</div>
	</div>
	
	<script>
	$(function(){
		$('.requestAnchor').addClass("active"); 
		var str=JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_ALL_REQUEST_JSON)%>);
		var json=JSON.parse(str);
		var e = $('#allRequestController');
		var scope = angular.element(e).scope();
		scope.$apply(function() {
			scope.categoryName='<%=request.getAttribute("categoryName")%>';
			scope.filterByRequestType="";
			if(scope.categoryName=="null"){
				scope.categoryName=0;
			}
			scope.allJsonRequests=json;
			scope.items=json;
			scope.tagsrequest=json;
			
		}); 
	});
	
	</script>
</c:if>
<c:if test="${!isUserMemberOfGroup}">
	<liferay-ui:message key="you-dont-have-permission-to-see-this-group-as-this-is-a-private-group" />.
	<span class="pull-right nyu-tooltip" title='<liferay-ui:message key="click-to-go-to-group-home-page" />'><a href="<%=groupHome%>" style="font-size: 16px; text-decoration: none;"> <liferay-ui:message key="group-home" /> </a>
					<i class="icon-home"></i></span>
</c:if>