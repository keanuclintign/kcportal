
<portlet:renderURL var="lessonUrl" windowState="maximized">
	<portlet:param name="action" value="lessonUrl" />
	<portlet:param name="userGroupId" value="${userGroupId}"/>
</portlet:renderURL>

<portlet:renderURL var="requestUrl" windowState="maximized">
	<portlet:param name="action" value="requestUrl" />
	<portlet:param name="userGroupId" value="${userGroupId}"/>
</portlet:renderURL>

<portlet:renderURL var="discussionUrl" windowState="maximized">
	<portlet:param name="action" value="discussionUrl" />
	<portlet:param name="userGroupId" value="${userGroupId}"/>
</portlet:renderURL>

<portlet:renderURL var="announcementUrl" windowState="maximized">
	<portlet:param name="action" value="announcementUrl"/>
	<portlet:param name="userGroupId" value="${userGroupId}"/>
</portlet:renderURL>

<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/navigation.js"></script>

<div id="navigation">
	<ul class="nav nav-pills nav-stacked">
		
		<li class="lessonAnchor"><a href="<%=lessonUrl%>"><liferay-ui:message key="lessons" /></a></li>
		<%-- <li><a href="<%=requestUrl%>">Requests</a></li> --%>
		<li class="requestAnchor"><a href="<%=requestUrl%>"><liferay-ui:message key="requests" /> </a></li>
		<li class="discussionAnchor"><a href="<%=discussionUrl%>"><liferay-ui:message key="discussions" /></a></li>
		<li class="announcementAnchor"><a href="<%=announcementUrl%>"><liferay-ui:message key="announcements" /></a></li>
	</ul>
	<c:if test="${isTagRequired}">
	<section id="tagAffix" class="hidden-phone">
		
		<div id="tags">
			<div id="tagController" ng-controller="TagController">
			
				<h1 style="line-height: normal;" ng-show="cloudTags.length > 0"><liferay-ui:message key="tags" />
					<span >
						<a href="javascript:void(0)" ng-click="filterByCloudTag(0)" class="btn btn-default pull-right"> <liferay-ui:message key="reset" /> </a>
					</span>
				</h1>
				<br>
				
				<h1 style="line-height: normal;" ng-show="tagsrequest.length > 0"><liferay-ui:message key="tags" /> 
					<span >
						<a href="javascript:void(0)" ng-click="searchRequestByTag('all')" class="btn btn-default pull-right"><liferay-ui:message key="reset" /></a>
					</span>
				</h1>
				<br>

				<ul>
					<li ng-repeat="tag in cloudTags | unique:'id'"
						class="tag{{$index%5+1}}" ng-cloak><a
						href="javascript:void(0)" ng-click="filterByCloudTag(tag.id)">{{tag.name}},</a>
					</li>
				</ul>
				
				<ul>
				<li  class="tag{{$index%5+1}}" ng-repeat="request in tagsrequest | unique:'id'" ng-cloak>
					<span ng-repeat="tags in request.tags" >
						<a ng-click="searchRequestByTag(tags.id)">{{tags.name}},</a>
					</span>
				</li> 
				</ul>
			
			</div>
		</div>
		<br/>
		<div id="searchContent" class="custom-search">  
			<i class="icon-search"></i>
			<input type="text" ng-model="searchPageWise" name="Search" id="searchPageWise" size="30" value="" placeholder='<liferay-ui:message key="search-place-holder" />'/> 
		</div>
		
	</section>
	</c:if>
</div>

<script>
	$(function(){
		// Sticky top 
		if($('#tagAffix').offset() != null){
	        var tagFixedTop = $('#tagAffix').offset().top; 
	        $(window).scroll(function(){
	                        var windowTop = $(window).scrollTop();
	                        if(tagFixedTop < windowTop){
	                            $('#tagAffix').css({
	                                            position: 'fixed',
	                                            top: 0,
	                                            width: '20%'
	                            });
	                        }
	                        else{
	                             $('#tagAffix').css({
	                                             position: 'static',
	                                             width: '100%'
	                                             
	                             });
	                        }
	        });
		}
		
	});
</script>