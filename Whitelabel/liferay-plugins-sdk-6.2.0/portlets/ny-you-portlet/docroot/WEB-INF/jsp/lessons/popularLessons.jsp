	
	<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %> 	<%--	added by asif 	 --%>
	
	
	<div class="filter-form">
			<div class="span4">
				<label for="Category" class="pull-left"><liferay-ui:message key="show" /></label> 
				<select ng-model="lessonFilter" ng-change="filterByCount();" >
					<option value="viewCount" ><liferay-ui:message key="most-viewed" /></option>
					<option value="appreciateCount"><liferay-ui:message key="most-appreciated" /></option>
				</select>
				
			</div>
			<div class="span4">
					<label class="pull-left" for="Category"> <liferay-ui:message key="category" /> </label>
					<select ng-model="categoryId" ng-change="filterByCategory('popular');" >
						<option value="0"><liferay-ui:message key="all" /></option>
						<option ng-repeat="category in categories" value='{{category.id}}'>{{category.name}}</option>
					</select> 
			</div>
			<div class="span4">
					<label for="Tag" class="pull-left"><liferay-ui:message key="tag" /></label>  
					<select ng-model="tagId" ng-change="filterByTag('popular');" >
						<option value="0"><liferay-ui:message key="all" /></option>
						<option ng-repeat="tag in tags" value='{{tag.id}}'>{{tag.name}}</option>
					</select>	
			</div> 	<!-- end span4 --> 
	</div> <!-- end span12 -->
	<%@ include file="results.jsp" %>
	 <p class="clearfix">
		<span class="pull-left" style="display:none" id="previousPagination" ng-show="filteredItems.length==lessons.length"><b><a href="#" onclick="getPopularLessons('previous')"><liferay-ui:message key="previous" /></a></b></span>
		<span class="pull-right" style="display:none" id="nextPagination" ng-show="filteredItems.length==lessons.length"><b><a href="#" onclick="getPopularLessons('next')"><liferay-ui:message key="next" /></a></b></span>
	</p>
 
 
	 