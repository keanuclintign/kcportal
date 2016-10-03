<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %> 		<%--	added by asif 	 --%>

<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="org.joda.time.LocalDate"%>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/userStats.js"></script>
<% 
String currentMonth=new LocalDate().minusMonths(0).monthOfYear().getAsText() + StringPool.SPACE + new LocalDate().minusMonths(0).year().getAsText(); 
String lastMonth=new LocalDate().minusMonths(1).monthOfYear().getAsText() + StringPool.SPACE + new LocalDate().minusMonths(1).year().getAsText(); 
%>
<portlet:renderURL var="userContributionUrl">
  <portlet:param name="action" value="lessonAndRequests"/>
  <portlet:param name="from" value="contributor"/>
</portlet:renderURL>
<div id="userStatsController" ng-controller="userStatsController">
	<div id="currentMonthcontributors" > 
		<h3><strong> <liferay-ui:message key="top-contributor-s-of-the-month" /> <%=currentMonth %> </strong></h3> 
		<section class="row-fluid">
			<article class="span4 shadow thumbnail-lessons" ng-repeat="currentMonth in currentMonth | offset: currentMonth_currentPage*itemsPerPage | limitTo: itemsPerPage" ng-class="($index % 3 == 0) ? 'no-margin clearfix' : ''">
			    <div class="media">
			     <a class="pull-left" href="#">
			          <img class="media-object img-circle" ng-src="{{currentMonth.documentPath}}">
			     </a>
				<div class="media-body">
			       	<h4 class="media-heading"><a href="#"><a href="<%=userContributionUrl%>&_<%=Constant.PORTLET_CONTRIBUTOR%>_userId={{currentMonth.userId}}"> {{currentMonth.userName}}</a></h4>
			         <ul class="unstyled">
			             <li> <p> <strong> <liferay-ui:message key="rank" />: </strong> <br> {{currentMonth.rank}} </p></li>
			             <li> 
			             	<p> <strong> <liferay-ui:message key="contribution-score" />: </strong> <br> 
			             		{{currentMonth.contributionCurrentValue}}  
			             		(<liferay-ui:message key="total" />: {{currentMonth.contributionTotalValue}}) 
			             	</p>
			             </li>
			             <li> 
			             	<p> 
			             		<strong> <liferay-ui:message key="participation-score" />:  </strong> <br> 
			             		{{currentMonth.particpationCurrentValue}}  
								(<liferay-ui:message key="total" />: {{currentMonth.particpationTotalValue}})
							</p>
			             </li>
			         </ul>
			   	</div> <!-- end media-body -->
				</div> <!-- end media-object -->
			</article>
		</section>
		<div class="pagination" align="right" ng-if="currentMonth_items.length>0" ng-cloak>
		        <ul >
		          <li ng-class="currentMonth_PrevPageDisabled()">
		            <a href ng-click="currentMonth_PrevPage()">« <liferay-ui:message key="prev" /></a>
		          </li>
		          <li ng-class="currentMonth_nextPageDisabled()">
		            <a href ng-click="currentMonth_nextPage()"><liferay-ui:message key="next" /> »</a>
		          </li>
		        </ul>
			</div>
	</div> <!--  end current Month contributors -->
	
	<div id="lastMonthContributors">
		<div id="contributorsToggler">
			<h3 class="alert cursor-pointer" style="line-height: 20px;"> <strong>
				<liferay-ui:message key="top-contributor-s-of-the-last-month" /> <%=lastMonth %>  
         		<i class="pull-right icon-chevron-right" style="line-height: 20px;"> </i>
          	</strong></h3> 
          	<div>
        	<section class="row-fluid">
				<article class="span4 shadow thumbnail-lessons" ng-repeat="previousMonthStat in previousMonthStats | offset: previousMonth_previousPage*itemsPerPage | limitTo: itemsPerPage" ng-class="($index % 3 == 0) ? 'no-margin clearfix' : ''">
				    <div class="media">
				     <a class="pull-left" href="#">
				          <img class="media-object img-circle" ng-src="{{previousMonthStat.documentPath}}">
				     </a>
					<div class="media-body">
				       	<h4 class="media-heading"><a href="<%=userContributionUrl%>&_<%=Constant.PORTLET_CONTRIBUTOR%>_userId={{previousMonthStat.userId}}"> {{previousMonthStat.userName}}</a></h4>
				         <ul class="unstyled">
				             <li> <p> <strong> <liferay-ui:message key="rank" />: </strong> <br> {{previousMonthStat.rank}} </p></li>
				             <li>
				             	<p> <strong> <liferay-ui:message key="contribution-score" />: </strong> <br> 
				             	 	{{previousMonthStat.contributionCurrentValue}}  
				             	 	(<liferay-ui:message key="total" />: {{previousMonthStat.contributionTotalValue}})  
				             	</p>
				             </li>
				             <li> 
				             	<p> <strong> <liferay-ui:message key="participation-score" />:   </strong> <br> 
				             		{{previousMonthStat.particpationCurrentValue}}  
				             		(<liferay-ui:message key="total" />: {{previousMonthStat.particpationTotalValue}})
								</p>
				             </li>
				         </ul>
				   	</div> <!-- end media-body -->
					</div> <!-- end media-object -->
				</article>
			</section>
			<div class="pagination pull-right" ng-if="previousMonth_items.length>0" ng-cloak>
		        <ul >
		          <li ng-class="previousMonth_PrevPageDisabled()">
		            <a href ng-click="previousMonth_PrevPage()">« <liferay-ui:message key="prev" /></a>
		          </li>
		          <li ng-class="previousMonth_nextPageDisabled()">
		            <a href ng-click="previousMonth_nextPage()"><liferay-ui:message key="next" /> »</a>
		          </li>
		        </ul>
			</div>
			</div>
		</div> <!--  end contributorsToggler -->
	</div> <!--  end lastYearContributors --> 
</div>
<script>

$(document).ready(function(){
	var currentMonthStats=JSON.stringify(<%=request.getAttribute(Constant.CURRENT_MONTH_STATE)%>);
	var previousMonthStats=JSON.stringify(<%=request.getAttribute(Constant.LAST_MONTH_STATE)%>);
	var e = $('#userStatsController');
	var scope = angular.element(e).scope();
	scope.$apply(function() {
		scope.currentMonth=JSON.parse(currentMonthStats);
		scope.previousMonthStats=JSON.parse(previousMonthStats);
		scope.currentMonth_items =scope.currentMonth;
		scope.previousMonth_items =scope.previousMonthStats;
	});
	
	// Custome Toggle
	$('#contributorsToggler h3').next().hide();
    $('#contributorsToggler h3').click(function(){
    	
   		$(this).find('i.pull-right').toggleClass('icon-chevron-down icon-chevron-right');
    	$(this).next().toggle();
    });
});


</script>