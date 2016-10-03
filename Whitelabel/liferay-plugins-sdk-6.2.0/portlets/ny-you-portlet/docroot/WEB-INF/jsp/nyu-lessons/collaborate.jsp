<portlet:resourceURL var="removeUserLessonAccess" id="removeUserLessonAccess" />
<portlet:resourceURL var="assignUserLessonAccess" id="assignUserLessonAccess" />
<portlet:resourceURL var="addEditComment" id="addEditComment" />
<portlet:resourceURL var="changePrimaryContributorUrl" id="changePrimaryContributor" />
<c:if test="${userGroupId==0}">		
<div id="CollaborateTab" class="tab-pane">
	<div class="progress-content">
		<div class="row-fluid">
			<div class="span6">
				<h1>Who has access to this lesson?</h1>
				<ul class="group-list unstyled" id="collaboratorList">
					<li class="group-list-item">
					<p><b>Contributor</b></p>
					<c:if test="${currentUser eq lessonAdmin}">
					<span>You </span> 
					</c:if>
					<c:if test="${currentUser ne lessonAdmin}">
					<span>${lessonAdminName} </span> 
					</c:if>
						<label class="radio" style="display:none;">
							<input type="radio" name="contributor" onclick="selectContributor('<%=changePrimaryContributorUrl%>', ${lessonAdmin}, this);" 
							 value="${lessonAdmin}"> Assign as Primary Contributor
						 </label>
						 <button style="display:none;" class="close" data-id="${lessonAdmin}"><span class="icon-trash"> </span></button>
					</li>
					<c:forEach items="${members}" var="member" varStatus="i">
					<li class="group-list-item">
					<p><b>Collaborator</b></p>
					<c:if test="${currentUser eq member.userId}">
					<span>You </span> 
					</c:if>
					<c:if test="${currentUser ne member.userId}">
					<span> ${member.fullName} </span>
					<c:if test="${currentUser eq lessonAdmin}">
					<label class="radio" style="display:inline;">
							<input type="radio" name="contributor"  onclick="selectContributor('<%=changePrimaryContributorUrl%>', ${member.userId}, this);" 
							value="${member.userId}"> Assign as Primary Contributor
						 </label> 
						 <button class="close" data-id="${member.userId}"><span class="icon-trash"> </span></button>
						 </c:if>
					</c:if>
					</li>
					</c:forEach>	
				</ul>
				
				<!-- end group-list -->
				<h1>Invite more people</h1>
				<%@ include file="invitation.jsp" %>
				<!-- <div>
					<button class="btn btn-primary">Save Draft</button>
					<button class="btn">Cancel</button>
				</div> -->
			</div>
			<!-- end span6 -->

			<div class="span6">
				<h1>Comments</h1>
				<form id="discussion">
					<div class="control-group">
						<label for="inputComment" class="sr-only"> Comments </label>
						<div class="controls">
							<textarea rows="5" class="input-block-level" id="inputComment"
								name="inputComment"></textarea>
							<p id="enterCommentErrorId" style="display:none; color:red;">Please enter comment.</p>
						</div>
					</div>
					<button class="btn" id="addComment">Add Comment</button>
					<ul class="group-list unstyled scroll-overFlow" style="min-height: 250px; padding-bottom: 5px;">
						
						<!-- end group-list-item -->
					</ul>
					<!-- end group-list -->
				</form>
				<div class="text-right">
					<input type="button" class="btn btn-default" onclick="cancelLesson('<%=homeUrl%>')" value="Cancel" />
					<!-- <input type="button" id="saveContinue" name="saveContinue" class="btn btn-primary" value="Save" onclick="saveLessonDetails()"/> -->
				</div>
			</div>
			<!-- end span6 -->
		</div>
		<!-- end row-fluid -->
	</div>
	<!-- end progress-content -->
</div>
</c:if>

	
