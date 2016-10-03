<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>	<%--	added by asif 	 --%>

	
	<div class="filter-form row-fluid">
			<div class="span4">
					<label class="pull-left" for="Category"> <liferay-ui:message key="category" /> </label>
					<select id='latestCategory' ng-model="categoryId" ng-change="filterByCategory('latest');" >
						<option value="0"><liferay-ui:message key="all" /></option>
						<option ng-repeat="category in categories" value='{{category.id}}'>{{category.name}}</option>
					</select> 
			</div>
			<div class="span4">
					<label for="Tag" class="pull-left"><liferay-ui:message key="tag" /></label>  
					<select id='latestTag' ng-model="tagId" ng-change="filterByTag('latest');" >
						<option value="0"><liferay-ui:message key="all" /></option>
						<option ng-repeat="tag in tags" value='{{tag.id}}'>{{tag.name}}</option>
					</select>	
			</div> 	<!-- end span4 --> 
	</div> <!-- end span12 -->
	
	<%@ include file="results.jsp" %>
	<p class="clearfix">
		<span class="pull-left" style="display:none" id="previousPagination" ng-show="filteredItems.length==lessons.length"><b><a href="#" onclick="getLatestLessons('previous')"><liferay-ui:message key="previous" /></a></b></span>
		<span class="pull-right" style="display:none" id="nextPagination" ng-show="filteredItems.length==lessons.length"><b><a href="#" onclick="getLatestLessons('next')"><liferay-ui:message key="next" /></a></b></span>
	</p>


				

