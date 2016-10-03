
<portlet:renderURL var="addFeaturedLessonsURL" windowState="pop_up">
	<portlet:param name="action" value="addFeaturedLessons" />
</portlet:renderURL> 
	
<c:if test="${permissionChecker.isGroupAdmin(scopeGroupId) &&  empty userGroupId }">
	<div class="text-right" style="margin-bottom:15px;">
		<a href="javascript:void(0);" class="btn btn-primary" onclick="<portlet:namespace/>AddLessons('<%=addFeaturedLessonsURL.toString()%>','Add Lessons')"><liferay-ui:message key="add-remove-lessons" /></a>
	</div>	
</c:if>
	
	
	<%@ include file="results.jsp" %> 


<script>

function <portlet:namespace/>AddLessons(url, windowTitle) {
		Liferay.Util.openWindow({
			dialog : {
				width : 450,
				height:570,
				align : Liferay.Util.Window.ALIGN_CENTER,
				cache : false,
				modal : true,
				resizable: false
			},

			title : windowTitle,
			id : 'AddLessons',
			uri : url
		});

	}
	
	Liferay.provide(window,
		    '<portlet:namespace/>closeAddLessonPopup',
		        function(popupIdToClose,withSuccessMsg) {
		            var popupDialog = Liferay.Util.Window.getById(popupIdToClose);
		            popupDialog.destroy();
		            if(withSuccessMsg != null && withSuccessMsg == 'yes'){
		            	closePopupForAllWithSuccessMsg('Featured Lessons added/removed successfully.');
		            }
		            featuredLessons();
		        },
		        ['liferay-util-window']
		    );
</script>

