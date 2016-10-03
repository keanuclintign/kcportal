
<%@page import="com.nyu.util.Constant"%>
<portlet:renderURL var="redirectURL" />
<portlet:renderURL var="subjectPageURL" >
	<portlet:param name="action" value="subjectPage"/>
</portlet:renderURL>
<portlet:renderURL var="filterByRequestURL" >
	<portlet:param name="action" value="filterRequest"/>
</portlet:renderURL>


<div class="span3"> 
			<aside id="navigation">
				<ul class="nav nav-pills nav-stacked all-request" ng-show="filterByRequestType.length==0" ng-cloak>
					<li><a href="<%=redirectURL%>">
					<h3>
						<liferay-ui:message key="requests" />
					</h3></a></li>
					<li><a href="<%=subjectPageURL%>">
						<liferay-ui:message key="category" />
					</a></li>
					<li class="active"><a href="javascript:void(0);" onclick="filterBy('<%=Constant.LATEST %>',this)">
						<liferay-ui:message key="latest" />				<%--	<%=Constant.LATEST %>	comment by asif, added by asif--%>
					</a></li>
					<li><a href="javascript:void(0);" onclick="filterBy('<%=Constant.POPULAR %>',this)">
						<liferay-ui:message key="popular" />				<%--<%=Constant.POPULAR %>		comment by asif, added by asif--%>
					</a></li>
					<li><a href="javascript:void(0);"  onclick="filterBy('<%=Constant.ANSWERED %>',this)">
						<liferay-ui:message key="answered" />				<%--	<%=Constant.ANSWERED %>	comment by asif, added by asif--%>
					</a></li>
					<li><a href="javascript:void(0);" onclick="filterBy('<%=Constant.OPEN %>',this)">
						<liferay-ui:message key="open" />				<%--	<%=Constant.OPEN %>	comment by asif, added by asif--%>
					</a></li> 
				</ul>
				
				<ul class="nav nav-pills nav-stacked filter-request" ng-show="filterByRequestType.length!=0" ng-cloak>
					<li><a href="<%=redirectURL%>">
					<h3>
						<liferay-ui:message key="requests" />
					</h3></a></li>
					<li>
						<a href="<%=subjectPageURL%>">
							<liferay-ui:message key="category" />
						</a></li>
					<li><a href="<%=redirectURL%>&_<%=Constant.PORTLET_REQUEST_LESSON%>_filterBy=<%=Constant.LATEST %>" >
						<liferay-ui:message key="latest" />			<%--	<%=Constant.LATEST %>	comment by asif, added by asif--%>
					</a></li>
					<li><a href="<%=redirectURL%>&_<%=Constant.PORTLET_REQUEST_LESSON%>_filterBy=<%=Constant.POPULAR %>">
						<liferay-ui:message key="popular" />			<%--	<%=Constant.POPULAR %>	comment by asif, added by asif--%>
					</a></li>
					<li><a href="<%=redirectURL%>&_<%=Constant.PORTLET_REQUEST_LESSON%>_filterBy=<%=Constant.ANSWERED %>">
						<liferay-ui:message key="answered" />			<%--	<%=Constant.ANSWERED %>	comment by asif, added by asif--%>
					</a></li>
					<li><a href="<%=redirectURL%>&_<%=Constant.PORTLET_REQUEST_LESSON%>_filterBy=<%=Constant.OPEN %>">
						<liferay-ui:message key="open" />			<%--	<%=Constant.OPEN %>	comment by asif, added by asif--%>
					</a></li> 
				</ul>
				<BR><BR>
				<a href="#" class="btn input-medium btn-primary" id="makeRequest">
					<liferay-ui:message key="make-a-request" />
				</a>
				<BR><BR>
				<section id="tagAffix" ng-show="filterByRequestType.length==0">	
					<div id="tags" class="hidden-phone">
						<h3> 
							<liferay-ui:message key="tags" /> 
							<span ng-show='requestCloudTags.length>0'>
								<a href="javascript:void(0)" ng-click="searchRequestByTag('all')" 
								class="btn btn-default pull-right">
									<liferay-ui:message key="reset" />
								</a>
							</span>
						</h3> 
						 <ul>
							<li ng-repeat="tag in requestCloudTags | unique:'id'" class="tag{{$index%5+1}}" ng-cloak>
						   
							<a href="javascript:void(0)" ng-click="searchRequestByTag(tag.id)">{{tag.name}},</a>
						</li> 
						</ul> 
						<br/> 
					</div>
					
					
					
					<div id="searchContent" class="custom-search">
						<i class="icon-search"></i>
						<input id="requestSearch" type="text" ng-model="searchRequestPageWise" value="" title='<liferay-ui:message key="search" />' size="30" name="Search">
						
					</div>
				</section> <!-- end tagAffix -->
			</aside>
</div> <!-- end span3 --> 