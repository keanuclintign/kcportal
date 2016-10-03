<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portal.security.permission.PermissionChecker"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>			<%--	added by asif 	 --%>

<portlet:renderURL var="requestDetailURL" windowState="MAXIMIZED">
	<portlet:param name="action" value="requestDetails"/>
</portlet:renderURL>
<portlet:resourceURL id="deleteRequest" var="deleteRequestURL"/> 
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/requestLessons.js?<%=new Date().getTime()%>"></script>
	
	
<%
String filterBy=ParamUtil.getString(request,"filterBy");
String groupId=StringPool.BLANK;
String myRequest=StringPool.BLANK;
if(Validator.isNotNull(request.getAttribute(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID))){
	groupId=(String)request.getAttribute(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
}
if(Validator.isNotNull(request.getAttribute(Constant.COMMON_STRING_CONSTANT_MY_REQUEST))){
	myRequest=(String)request.getAttribute(Constant.COMMON_STRING_CONSTANT_MY_REQUEST);
}
%>	

<div class="container" id="allRequestController" ng-controller="requestLessonsController">

	<div class="row-fluid">
		<%@include file="navigation.jsp" %>
		<div class="span9" id="requestForInfo">  
		
				<header ng-show=categoryName!=0 ng-cloak> 
				<h3>
				<i class="icon-folder-close"> </i>
				{{categoryName}} 
				</span> 
				</h3>
				</header>
				
			<div id="nyYouTab" class="clearfix" style="padding: 0;">
				<!-- TAB LINKS -->
				<ul class="nav nav-tabs">
					<li class="active" onclick="filterData('All Requests')"><a href="allRequests">
						<liferay-ui:message key="all-requests" />
					</a></li>
					<li><a href="#Information" onclick="filterData('req_Information')">
						<liferay-ui:message key="small-information" />
					</a></li>
					<li><a href="#anOpinion" onclick="filterData('req_Opinion')">
						<liferay-ui:message key="an-opinion" />
					</a></li>
					<li><a href="#aLesson" onclick="filterData('req_Lesson')">
						<liferay-ui:message key="a-lesson" />
					</a></li>
					<li><a href="#aCollaborator" onclick="filterData('req_Collaborator')">
						<liferay-ui:message key="a-collaborator" />
					</a></li>
				</ul> <!-- END TAB LINKS --> 
				<!-- TAB CONTENT -->
				<div class="tab-content" >
				
					<div id="allRequests" class="tab-pane">
						<p ng-show="allRequest.length==0">
							<liferay-ui:message key="no-requests-found" />.
						</p>
						<div ng-repeat="request in allRequest=(allJsonRequests | filter:searchRequestPageWise | filter:tagId | filter:{answerCount:answered}  | orderBy:item | offset: currentPage*itemsPerPage | limitTo: itemsPerPage)">
						
						<span ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right: 20px; position: relative; z-index: 1;"">
						<a class="cursor-pointer nyu-tooltip" ng-click="deleteRequest('<%=deleteRequestURL %>',request.requestLessonId)" title='<liferay-ui:message key="delete-request" />'>
						<i class="icon-trash"></i>	</a>
						</span>
						
						<blockquote class="row">
							
							<div class="span9">
								
								<p><a href="<%=requestDetailURL%>&_<%=Constant.PORTLET_REQUEST_LESSON%>_requestLessonId={{request.requestLessonId}}">{{request.name}}</a></p> 
								<BR><p class="signature">     
									{{request.userName}}   &nbsp; &nbsp;
									{{request.crateDate}} &nbsp; &nbsp;
									<i class="icon-thumbs-up"> </i> {{request.appreciatedCount}} &nbsp; &nbsp;
									<span ng-if=request.answerCount!=0 class="label label-success">
									 {{request.answerCount}} 
									 <span ng-if="request.answerCount > 1"> <liferay-ui:message key="answers" /> </span>
									 <span ng-if="request.answerCount <= 1"> <liferay-ui:message key="answer" /> </span>
									</span>
									<span ng-if=request.answerCount==0 class="label label-default">
									 	<liferay-ui:message key="no-answer-yet" /> 
									</span>
								</p>
							</div> 
						
								
								<div class="span3 text-center hidden-phone" ng-if=request.answerType=='req_Lesson'> 
									<p><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-lesson.gif">
									<small>
										<liferay-ui:message key="request-for-lesson" />
									</small></p>
								</div>
								
								<div class="span3 text-center hidden-phone" ng-if=request.answerType=='req_Information'> 
									<p><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-group-chat.gif"/>
									<small>
										<liferay-ui:message key="request-for-information" />
									</small></p>
								</div>
								
								<div class="span3 text-center hidden-phone" ng-if=request.answerType=='req_Opinion'> 
									<p><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-slate.gif"/>
									<small>
										<liferay-ui:message key="request-for-opinion" />
									</small></p>
								</div>
								
								<div class="span3 text-center hidden-phone" ng-if=request.answerType=='req_Collaborator'> 
									<p><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-user-group.gif"/>
									<small>
										<liferay-ui:message key="request-for-collaboration" />
									</small></p>
								</div>
							
						</blockquote>   
						</div>
						
					
					</div> <!-- end allRequest-->
					
					<div id="information" class="tab-pane">
						<p ng-show="requestforInfo.length==0">
							<liferay-ui:message key="no-requests-found" />.
						</p>
						<div ng-repeat="request in requestforInfo=(allJsonRequests | filter:'req_Information' | filter:tagId | filter:searchRequestPageWise | filter:{answerCount:answered}  | orderBy:item | offset: currentPage*itemsPerPage | limitTo: itemsPerPage)">
						
						<span ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right: 20px; position: relative; z-index: 1;"">
						<a class="cursor-pointer nyu-tooltip" ng-click="deleteRequest('<%=deleteRequestURL %>',request.requestLessonId)" title='<liferay-ui:message key="delete-request" />'>
						<i class="icon-trash"></i>	</a>
						</span>
						
						<blockquote class="row-fluid">
							<div class="span9">
								<p><a href="<%=requestDetailURL%>&_<%=Constant.PORTLET_REQUEST_LESSON%>_requestLessonId={{request.requestLessonId}}">{{request.name}}</a></p>  
								<p class="signature">  
									{{request.userName}}   &nbsp; &nbsp;
									{{request.crateDate}} &nbsp; &nbsp;
									<i class="icon-thumbs-up"> </i> {{request.appreciatedCount}} &nbsp; &nbsp;
									
									<span ng-if=request.answerCount!=0 class="label label-success">
									{{request.answerCount}}
									 <span ng-if="request.answerCount > 1"> <liferay-ui:message key="answers" /> </span>
									 <span ng-if="request.answerCount <= 1"> <liferay-ui:message key="answer" /> </span>
									</span>
									
									<span ng-if=request.answerCount==0 class="label label-default">
									 <liferay-ui:message key="no-answer-yet" /> 
									</span>
								</p>
							</div> 
							<div class="span3 text-center hidden-phone"> 
								<p><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-group-chat.gif"/>
								<small>
									<liferay-ui:message key="request-for-information" />
								</small></p>
							</div>
						</blockquote>   
						
						
						</div>
						
					
					</div> <!-- end information-->
					
					<div id="anOpinion" class="tab-pane">
						<p ng-show="requestforOpinion.length==0">
							<liferay-ui:message key="no-requests-found" />.
						</p>
						<div ng-repeat="request in requestforOpinion=(allJsonRequests | filter:'req_Opinion' | filter:tagId | filter:searchRequestPageWise | filter:{answerCount:answered}  | orderBy:item | offset: currentPage*itemsPerPage | limitTo: itemsPerPage)" >
						
						<span ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right: 20px; position: relative; z-index: 1;"">
						<a class="cursor-pointer nyu-tooltip" ng-click="deleteRequest('<%=deleteRequestURL %>',request.requestLessonId)" title='<liferay-ui:message key="delete-request" />'>
						<i class="icon-trash"></i>	</a>
						</span>
						
						<blockquote class="row-fluid">
							<div class="span9">
								<p><a href="<%=requestDetailURL%>&_<%=Constant.PORTLET_REQUEST_LESSON%>_requestLessonId={{request.requestLessonId}}">{{request.name}}</a></p> 
								<p class="signature">  
									{{request.userName}}   &nbsp; &nbsp;
									{{request.crateDate}} &nbsp; &nbsp;
									<i class="icon-thumbs-up"> </i> {{request.appreciatedCount}} &nbsp; &nbsp;
									
									<span ng-if=request.answerCount!=0 class="label label-success">
									{{request.answerCount}}
									 <span ng-if="request.answerCount > 1"> <liferay-ui:message key="answers" /> </span>
									 <span ng-if="request.answerCount <= 1"> <liferay-ui:message key="answer" /> </span> 
									</span>
									<span ng-if=request.answerCount==0 class="label label-default">
									 	<liferay-ui:message key="no-answer-yet" /> 
									</span>
								</p>
							</div> 
							<div class="span3 text-center hidden-phone" ng-if=request.answerType=='req_Opinion'> 
								<p><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-slate.gif"/>
								<small>
									<liferay-ui:message key="request-for-opinion" />
								</small></p>
							</div>
						</blockquote>   
						
						
						</div>
					</div> <!-- end anOpinion -->
					
					<div id="aLesson" class="tab-pane">
						<p ng-show="requestforLesson.length==0">
							<liferay-ui:message key="no-requests-found" />.
						</p>
						<div ng-repeat="request in requestforLesson=(allJsonRequests | filter:'req_Lesson' | filter:tagId | filter:searchRequestPageWise | filter:{answerCount:answered}  | orderBy:item | offset: currentPage*itemsPerPage | limitTo: itemsPerPage)">
						
						<span ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right: 20px; position: relative; z-index: 1;"">
						<a class="cursor-pointer nyu-tooltip" ng-click="deleteRequest('<%=deleteRequestURL %>',request.requestLessonId)" title='<liferay-ui:message key="delete-request" />'>
						<i class="icon-trash"></i>	</a>
						</span>
						
						<blockquote class="row-fluid">
							<div class="span9">
								<p><a href="<%=requestDetailURL%>&_<%=Constant.PORTLET_REQUEST_LESSON%>_requestLessonId={{request.requestLessonId}}">{{request.name}}</a></p> 
								<p class="signature">   
									{{request.userName}}   &nbsp; &nbsp;
									{{request.crateDate}} &nbsp; &nbsp;
									<i class="icon-thumbs-up"> </i> {{request.appreciatedCount}} &nbsp; &nbsp;
									
									<span ng-if=request.answerCount!=0 class="label label-success">
									 {{request.answerCount}}
									 <span ng-if="request.answerCount > 1"> <liferay-ui:message key="answers" /> </span>
									 <span ng-if="request.answerCount <= 1"> <liferay-ui:message key="answer" /> </span> 
									</span>
									<span ng-if=request.answerCount==0 class="label label-default">
									 	<liferay-ui:message key="no-answer-yet" /> 
									</span>
									
								</p>
							</div> 
							<div class="span3 text-center hidden-phone" ng-if=request.answerType=='req_Lesson'> 
									<p><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-lesson.gif">
									<small>
										<liferay-ui:message key="request-for-lesson" />
									</small></p>
							</div>
						</blockquote>   
						
						
						</div>
					</div> <!-- end aLesson -->
					
					<div id="aCollaborator" class="tab-pane">
						<p ng-show="requestforColloboration.length==0">
							<liferay-ui:message key="no-requests-found" />.
						</p>
						<div ng-repeat="request in requestforColloboration=(allJsonRequests | filter:'req_Collaborator' | filter:tagId | filter:searchRequestPageWise | filter:{answerCount:answered} | orderBy:item | offset: currentPage*itemsPerPage | limitTo: itemsPerPage)">
						
						<span ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right: 20px; position: relative; z-index: 1;"">
						<a class="cursor-pointer nyu-tooltip" ng-click="deleteRequest('<%=deleteRequestURL %>',request.requestLessonId)" title='<liferay-ui:message key="delete-request" />'>
						<i class="icon-trash"></i>	</a>
						</span>
						
						<blockquote class="row-fluid">
							<div class="span9">
								<p><a href="<%=requestDetailURL%>&_<%=Constant.PORTLET_REQUEST_LESSON%>_requestLessonId={{request.requestLessonId}}">{{request.name}}</a></p> 
								<p class="signature">    
									{{request.userName}}   &nbsp; &nbsp;
									{{request.crateDate}} &nbsp; &nbsp;
									<i class="icon-thumbs-up"> </i> {{request.appreciatedCount}} &nbsp; &nbsp;
									
									<span ng-if=request.answerCount!=0 class="label label-success">
									 {{request.answerCount}}
									 <span ng-if="request.answerCount > 1"> <liferay-ui:message key="answers" /> </span>
									 <span ng-if="request.answerCount <= 1"> <liferay-ui:message key="answer" /> </span>
									</span>
									<span ng-if=request.answerCount==0 class="label label-default">
									 	<liferay-ui:message key="no-answer-yet" /> 
									</span>
									
								</p>
							</div> 
							<div class="span3 text-center hidden-phone" ng-if=request.answerType=='req_Collaborator'> 
								<p><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-user-group.gif"/>
								<small>
									<liferay-ui:message key="request-for-collaboration" />
								</small></p>
							</div>
						</blockquote>   
						
						
						</div>
					</div> <!-- end aCollaborator --> 
				</div>
			</div> <!-- end nyYouTab --> 
		</div> <!-- end requestForInfo -->
	</div> <!-- end row-fluid -->
	<div ng-repeat="request in filterItem =(allJsonRequests | filter:type  | filter:searchRequestPageWise | filter:tagId | filter:{answerCount:answered}  | orderBy:item )"></div>
	
	<div class="pagination pull-right" ng-if="items.length>0" ng-cloak>
        <ul >
          <li ng-class="prevPageDisabled()">
            <a href ng-click="prevPage()">
            	« <liferay-ui:message key="prev" />
            </a>
          </li>
          <li ng-class="nextPageDisabled()">
            <a href ng-click="nextPage()">
            	<liferay-ui:message key="next" /> »
            </a>
          </li>
        </ul>
	</div>
	<%@include file="createRequest.jsp" %>
</div> <!-- end container -->
<div id="addRequestPopUp"> </div>
<script>
	
	// TAB
	YUI().use('aui-tabview', function(Y) {
		new Y.TabView(
		  {
			srcNode: '#nyYouTab'
		  }
		).render();
	});
</script>
<script>
	var popular="<%=Constant.POPULAR%>";
	var latest="<%=Constant.LATEST%>";
	var open="<%=Constant.OPEN %>";
	var answered="<%=Constant.ANSWERED%>";
	$(document).ready(function(){
		var str=JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_ALL_REQUEST_JSON)%>);
		loadAllRequest(str);
		var groupId="<%=groupId%>";
		var myRequest="<%=myRequest%>";
		if(groupId.length>0){
			 $(window).on('load', function(){ 
				$('#makeRequest')[0].click();	
				$('.sendTo').last().attr("checked",true);
				$("#"+groupId).attr('selected','selected');
				$('#checkGroup').show(); 
			}); 
		}
		if(myRequest.length>0){
			 $(window).on('load', function(){ 
				$('#makeRequest')[0].click();	
			}); 
		}
		
	});
	
	function loadAllRequest(allRequest){
		var json=JSON.parse(allRequest);
		var e = $('#allRequestController');
		var scope = angular.element(e).scope();
		scope.$apply(function() {
			scope.categoryName='<%=request.getAttribute("categoryName")%>';
			scope.filterByRequestType="";
			if(scope.categoryName=="null"){
				scope.categoryName=0;
			}
			scope.allJsonRequests=json;
			scope.tagsrequest=json;
			scope.type=""; 
			scope.requestCloudTags=[];
		 	for(var i=0;i<scope.tagsrequest.length; i++){
			
			 	var tags=scope.tagsrequest[i].tags;
				for(var j = 0; j < tags.length; j++) {
					scope.requestCloudTags.push({id:tags[j].id,name:tags[j].name});
			    } 
			} 
		}); 
		var filterType="<%=filterBy%>";
		if(filterType.length>0){
			filterBy(filterType,this);
			$( ".all-request li").removeClass('active');
			$( ".all-request li a:contains("+filterType+")").closest('li').addClass('active');
		} 
	}
	function filterData(type){
		var e = $('#allRequestController');
		var scope = angular.element(e).scope();
		if(type=="All Requests"){
			type="";
		}
		scope.$apply(function() {
			scope.type=type;
		});
	}
	
	function filterBy(filterType, obj){
		var e = $('#allRequestController');
		var scope = angular.element(e).scope();
		var type=$("#nyYouTab li.active").find("a").text();	
		switch(type){
		  	case "Information":
			  	type ="req_Information";
		        break;
		    case "An Opinion":
		    	type ="req_Opinion";
				break;
		    case "A Lesson":
	    		type ="req_Lesson";
				break;
		    case "A Collaborator":
	    		type ="req_Collaborator";
				break;
		    case "All Requests":
	    		type ="";
				break;
		}
		$(obj).parent().siblings().removeClass('active').end().addClass('active');
		
		if(filterType==popular){
		  scope.item='-appreciatedCount';
		  scope.answered="";
		}
		
		if(filterType==latest){
			 scope.item='';
			 scope.answered="";
		}
		if(filterType==open){
			 scope.item='';
			 scope.answered='0';
		}
		if(filterType==answered){
			 scope.item='';
			 scope.answered='!0';
		}
		scope.$apply(function() {
			scope.type=type;
		});
	}
	
</script>