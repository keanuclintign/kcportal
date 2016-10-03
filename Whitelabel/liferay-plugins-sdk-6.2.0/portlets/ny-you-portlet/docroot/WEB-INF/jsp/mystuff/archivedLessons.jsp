<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="com.nyu.util.Constant"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<portlet:resourceURL var="archivedLessonsURL" id="archivedLessons">
</portlet:resourceURL>


<div> 
	<h1> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>lesson-archive-icon.png">
		<liferay-ui:message key="archieve" />[<liferay-ui:message key="admin" />] 
	</h1>
	<div id="inappropriate" class="ny-you-tab">
				<!-- TAB LINKS -->
				<ul class="nav nav-tabs">
					<li class="active"><a href="#<portlet:namespace/>inappropriate" id="<portlet:namespace/>inappropriateLessons" onclick="userAndGroupDeletedLessons('<%=Constant.INAPPROPRIATE%>','archivedLessonsController')">
						<liferay-ui:message key="inappropriate-content" />
					</a></li>
					<li><a href="#<portlet:namespace/>deletedGroup" onclick="userAndGroupDeletedLessons('<%=Constant.LESSON_FROM_DELETED_GROUP%>','deletedGroupLessonsController')" id="<portlet:namespace/>deletedGroupLessons">
						<liferay-ui:message key="lesson-from-deleted-group" />
					</a></li>
					<li><a href="#<portlet:namespace/>userDeleted" onclick="userAndGroupDeletedLessons('<%=Constant.LESSON_DELETED_BY_USER%>','userDeletedLessonsController')" id="<portlet:namespace/>userDeletedLessons">
						<liferay-ui:message key="lesson-deleted-by-user" />
					</a></li>
					<li><a href="#<portlet:namespace/>quarantine" onclick="userAndGroupDeletedLessons('<%=Constant.MARKEDAS_QUARANTINE%>','quarantineLessonsController')" id="<portlet:namespace/>quarantineLessons">
						<liferay-ui:message key="quarantined-lesson" />
					</a></li>
					
				</ul> <!-- END TAB LINKS -->
				<!-- TAB CONTENT -->
				
				<div class="tab-content">
					<div id="<portlet:namespace/>inappropriate" class="tab-pane ">
						<div id="archivedLessonsController" data-namespace="<portlet:namespace/>" ng-controller="LessonsController">
							<jsp:include page="inAppropriateLessons.jsp"></jsp:include>
							<div class="pagination text-right">
					              <ul ng-hide="filteredItems.length==0"> 
				                     <li class="previousPagination"  ng-show="filteredItems.length==archivedLessons.length"> 
				                           <button  onclick="getArchivedLessons('archivedLessonsController','<%=Constant.INAPPROPRIATE %>','previous')">
				                           		« <liferay-ui:message key="prev" />
				                           </button> 
				                     </li> 
				                     <li class="nextPagination" ng-show="filteredItems.length==archivedLessons.length">
				                            <button  onclick="getArchivedLessons('archivedLessonsController','<%=Constant.INAPPROPRIATE %>','next')">
				                            	<liferay-ui:message key="next" /> »
				                            </button> 
				                     </li> 
					              </ul> 
       						</div>
						</div>
					</div>
					<div id="<portlet:namespace/>deletedGroup" class="tab-pane " >
						<div id="deletedGroupLessonsController" data-namespace="<portlet:namespace/>" ng-controller="LessonsController">
							<jsp:include page="userAndGroupDeletedLessons.jsp"></jsp:include>
							<div class="pagination text-right">
								<ul ng-hide="filteredItems.length==0"> 
									<li class="previousPagination" ng-show="filteredItems.length==archivedLessons.length"> 
										<button  onclick="getArchivedLessons('deletedGroupLessonsController','<%=Constant.LESSON_FROM_DELETED_GROUP%>','previous')">
											« <liferay-ui:message key="prev" />
										</button> 
									</li> 
									<li class="nextPagination" ng-show="filteredItems.length==archivedLessons.length">
										<button  onclick="getArchivedLessons('deletedGroupLessonsController','<%=Constant.LESSON_FROM_DELETED_GROUP%>','next')">
											<liferay-ui:message key="next" /> »
										</button> 
									</li> 
								</ul> 
							</div>
						</div>
					</div>
					<div id="<portlet:namespace/>userDeleted" class="tab-pane " >
						<div id="userDeletedLessonsController" data-namespace="<portlet:namespace/>" ng-controller="LessonsController">
							<jsp:include page="userAndGroupDeletedLessons.jsp"></jsp:include>
							<div class="pagination text-right">
								<ul ng-hide="filteredItems.length==0"> 
									<li class="previousPagination" ng-show="filteredItems.length==archivedLessons.length"> 
										<button  onclick="getArchivedLessons('userDeletedLessonsController','<%=Constant.LESSON_DELETED_BY_USER%>','previous')">
											« <liferay-ui:message key="prev" />
										</button> 
									</li> 
									<li class="nextPagination" ng-show="filteredItems.length==archivedLessons.length" >
										<button  onclick="getArchivedLessons('userDeletedLessonsController','<%=Constant.LESSON_DELETED_BY_USER %>','next')">
											<liferay-ui:message key="next" /> »
										</button> 
									</li> 
								</ul> 
							</div>
						</div>
					</div>
					<div id="<portlet:namespace/>quarantine" class="tab-pane " >
						<div id="quarantineLessonsController" data-namespace="<portlet:namespace/>" ng-controller="LessonsController">
							<jsp:include page="userAndGroupDeletedLessons.jsp"></jsp:include>
							<div class="pagination text-right">
								<ul> 
									<li class="previousPagination" ng-show="filteredItems.length==archivedLessons.length"> 
										<button  onclick="getArchivedLessons('quarantineLessonsController','<%=Constant.MARKEDAS_QUARANTINE %>','previous')">
											« <liferay-ui:message key="prev" />
										</button> 
									</li> 
									<li class="nextPagination" ng-show="filteredItems.length==archivedLessons.length">
										<button  onclick="getArchivedLessons('quarantineLessonsController','<%=Constant.MARKEDAS_QUARANTINE %>','next')">
											<liferay-ui:message key="next" /> »
										</button> 
									</li> 
								</ul> 
							</div>
						</div>
					</div>
					
				</div>
		</div> <!-- end nyYouTab -->
</div>


<script>
$(function(){
	 YUI().use('aui-tabview', function(Y) {
			new Y.TabView(
			  {
				srcNode: '#inappropriate'
			  }
			).render();
			if(archivedLessonsTabActive=='qurantineTab'){
				userAndGroupDeletedLessons('<%=Constant.MARKEDAS_QUARANTINE%>','quarantineLessonsController')
			 	Y.one('#inappropriate .nav-tabs li:last-child').simulate('click');
			}
		});
	
});

function getArchivedLessons(id,markedAs,pagination){
		var e = $('#'+id);
		var scope = angular.element(e).scope();
		var showCount=60;
		var start = 0;
		var end = showCount;

	
	
 	if(pagination == 'next'){
		start = scope.end;
		end = scope.end + showCount;
	}else if(pagination == 'previous'){ //previous
		start = scope.start - showCount;
		end = scope.start;
	}
    $.ajax({
        url:'<%=archivedLessonsURL.toString() %>',
        type: 'GET',
        async: false,
        data:{
        	<portlet:namespace/>archiveType:markedAs,
        	<portlet:namespace/>start:start,
        	<portlet:namespace/>end:end,
        	<portlet:namespace/>categoryId:scope.categoryId,
        	<portlet:namespace/>tagId:scope.tagId
        	
        },
        success: function(data){
			var allLessonData=JSON.parse(data);	        
	    	scope.lessonFilter="";
	    	if(scope.categoryId==0){
	    		scope.categories=JSON.parse(allLessonData.getCategories);
	    		
	    		scope.categoryId = 0;
	    	}
	    	if(scope.tagId==0){
	    		scope.tags=JSON.parse(allLessonData.getTags);
	    		scope.tagId = 0;
	    	}
	    	scope.archivedLessons = JSON.parse(allLessonData.getLessons);
	    	scope.start=allLessonData.start;
	    	scope.end=allLessonData.end;
	    	scope.load();
	    	 if(scope.$root.$$phase != '$apply'){
            	 scope.$apply(function() {});
             }
	    	if(scope.start<showCount)
	    		$('#'+id+' .previousPagination').find('button').attr('disabled',true);
	    	else
	    		$('#'+id+' .previousPagination').find('button').attr('disabled',false);
	    
				
	    	if(allLessonData.endResult)
	    		$('#'+id+' .nextPagination').find('button').attr('disabled',false);
	    	else
	    		$('#'+id+' .nextPagination').find('button').attr('disabled',true);
     	} 
        
    });
}
</script>