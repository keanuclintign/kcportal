<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.nyu.service.AnswerRequestLocalServiceUtil"%>
<%@page import="com.nyu.model.AnswerRequest"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="java.util.List"%>
<%@page import="com.nyu.model.RequestLesson"%>
<%@page import="com.nyu.service.RequestLessonLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>			<%--	added by asif 	 --%>


<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/requestLessons.js?<%=new Date().getTime()%>"></script>
<portlet:renderURL var="allRequestURL">
	<portlet:param name="action" value="allRequest"/>
</portlet:renderURL>


<div class="container"  id="allRequestController" ng-controller="requestLessonsController">
	<div class="row-fluid">
		<%@include file="navigation.jsp" %>
		<div class="span9" id="requestForInfo"> 
			<div class="row-fluid">
				<div class="span4">
					<h1> <liferay-ui:message key="request-categories" /> </h1>
				</div> <!-- end span4 -->
				<div class="span4">
					<label for=""> <liferay-ui:message key="sort-by" />: </label>
					<select ng-model="selectFilter">
					  <option value="categoryName"><liferay-ui:message key="a-to-z" /></option>
					  <option value="-categoryName"><liferay-ui:message key="z-to-a" /></option>
					  <!-- <option>Most Recent</option>
					  <option>Most Appreciated</option>
					  <option>Most View</option> --> 
					</select>
				</div>
			</div>
			
			<div class="row-fluid">
			 <div class="span4 thumbnail-test" ng-repeat="subject in subjectJson | orderBy:selectFilter">
					<div class="shadow">
						<h4 class="text-overFlow"> <a href="<%=allRequestURL%>&_<%=Constant.PORTLET_REQUEST_LESSON%>_categoryId={{subject.categoryId}}""> {{subject.categoryName}} </h4><hr/>
						<p> {{subject.RequestCount}} 
						<span ng-if="subject.RequestCount > 1"> <liferay-ui:message key="requests" /> </span>
						 <span ng-if="subject.RequestCount <= 1"> <liferay-ui:message key="request" /> </span>
						 </p>
						<p> {{subject.answerCount}}
						 <span ng-if="subject.answerCount > 1"> <liferay-ui:message key="answers" /> </span>
						 <span ng-if="subject.answerCount <= 1"> <liferay-ui:message key="answer" /> </span> 
						</p>
						<!-- <p> <i class="icon-calendar"> </i> Last Request 2d Ago </p> -->
					</div> <!-- end shadow -->
				</div><!-- <--end span4 --> 
			</div>
		
	</div> <!-- end row-fluid -->
	</div> <!-- end requestForInfo -->
	<%@include file="createRequest.jsp" %>
</div> <!-- end container -->


	<script>
	
	$(document).ready(function(){
		
		var e = $('#allRequestController');
		var scope = angular.element(e).scope();
		scope.$apply(function(){
		scope.subjectJson=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_SUBJECT_JSON)%>));	
		scope.selectFilter="categoryName";
		});
		
		$('#requestForInfo').find('.thumbnail-test').each(function(i,val){	
		    if(i%3 == 0) {  
		      $(this).addClass('no-margin clearfix');
		    }
		});
		
		$('#requestForInfo').on('change',function(){

			  $(this).find('.thumbnail-test').removeClass('no-margin clearfix');
			  
			  $(this).find('.thumbnail-test').each(function(i,val){	
					    if(i%3 == 0) {  
					      $(this).addClass('no-margin clearfix');
					    }
					});
		});
		
	});
	
	</script>