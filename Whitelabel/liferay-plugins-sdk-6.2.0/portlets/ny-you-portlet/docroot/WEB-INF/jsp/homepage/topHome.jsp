<%@page import="com.nyu.util.Constant"%>
<%@page import="com.nyu.model.RequestLesson"%>
<%@page import="java.util.Date"%>

<%
	String rlPortletId =Constant.PORTLET_REQUEST_LESSON;
	long rlTargetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_REQUEST_LESSON).getPlid();
	PortletURL showRequestLessonURL = PortletURLFactoryUtil.create(renderRequest, rlPortletId, rlTargetPlId, PortletRequest.RENDER_PHASE);
	showRequestLessonURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);
	showRequestLessonURL.setWindowState(WindowState.MAXIMIZED);
	showRequestLessonURL.setParameter("requestLessonTitle", Constant.COMMON_REQUEST_LESSON);
	String rlPortletNamespace = StringPool.UNDERLINE + rlPortletId + StringPool.UNDERLINE;
%>

<div class="container">
		<div class="row-fluid leftBlk">
			<div class="span6">
				<div class="create auto-margin">
					<div class="banner center-text border-left border-right">
							
						<h2><a href="<%=createLessonUrl%>"><button class="backgroundicon-create black background-left">Create</button></a></h2>
							
						<ul>
							<li>New Content</li>
							<li>Curate Existing Content</li>
							<li>Import Content</li>
						</ul>
							
						<h3>Top Lessons</h3>
					</div>
					<c:forEach items="${oneLesson}" var="lesson" varStatus="i">
		
						<c:set var="lessonId">${lesson.lessonId}</c:set>
						<c:set var="authorId">${lesson.author}</c:set>
						<c:set var="appreciatorUserIds">${lesson.appreciatedUserIds}</c:set>
						<c:set var="createdDate" value="${lesson.uploadedTime}" scope="page" />
						
						<%
							long lessonId = Long.parseLong((String) pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID));
							long authorId = Long.parseLong((String) pageContext.getAttribute(Constant.AUTHOR_ID));
							String appreciatorUserIds = (String) pageContext.getAttribute("appreciatorUserIds");
							String documentPath = CommonUtil.getDocumentPath(lessonId, lessonClassNameId, themeDisplay);
							User author = CommonUtil.getAuthor(authorId);
							request.setAttribute(Constant.AUTHOR, author);
							int viewCount = CommonUtil.getViewCount(Lesson.class.getName(), lessonId);
							int appreciatedCount = CommonUtil.getAppreciatedCount(appreciatorUserIds);
							Date createdDate = (Date)pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_CREATED_DATE);
							showLessonURL.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID,lessonId+"");
						%>	
				
						<article>
							<h4><a href="<%=showLessonURL%>">${lesson.lessonName}</a></h4>
							<div class="content">
								<p>${lesson.description}</p>
								
								<p>by <a href="<%=showAuthorLessonURL+"&"+portletNamespace+"authorId="+authorId%>">${author.firstName} ${author.lastName}</a></p>
							</div>
							<div class="infos">
								<div class="likes">
									<span aria-hidden="true" class="icon-thumbs-up"></span>
									&nbsp;<%=appreciatedCount %><span class="sr-only">Likes</span>
								</div>
								<div class="views">
									<span aria-hidden="true" class="icon-eye-open"></span>
									&nbsp;<%=viewCount %><span class="sr-only">views</span>
								</div>
								<div class="time"><%= CommonUtil.getDatesDuration(createdDate.getTime(), 0) %></div>
							</div>
						</article>
					</c:forEach>
				</div>
				<div class="show-more auto-margin">
					<a href="<%=browseUrl%>">
						<button class="btn btn-default btn-block">Show More Results</button>
					</a>
				</div>
			</div>

			<div class="span6">
				<div class="request auto-margin">
					
					<div class="box banner center-text border-left border-right">
						<h2><button  id="Request" Class="backgroundicon-request black background-left" >Request</button></h2>
								
						<ul>
							<li>Collaborator</li>
							<li>Information</li>
							<li>Lesson</li>
							<li>Opinion</li>
						</ul>
		
						<h3>Top Requests</h3>
						
					</div>
						<c:forEach items="${requestedLessons}" var="requestLesson" varStatus="i">
	   
						<c:set var="appreciatedUserIds" value="${requestLesson.appreciatedUserIds}"  scope="request"/>
						<c:set var="requestLessonId" value="${requestLesson.requestLessonId}"  scope="request"/>
						<c:set var="createdDate" value="${requestLesson.createdDate}" scope="page" />
						<c:set var="name" value="${requestLesson.name}" scope="page" />
						<%
							int appreciatedRequestLesssonCount = CommonUtil.getAppreciatedCount((String) request.getAttribute("appreciatedUserIds"));
							Date createdDate = (Date)pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_CREATED_DATE);
							
							long classPK = (Long)request.getAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID);
							long requestLessonNameId = ClassNameLocalServiceUtil.getClassNameId(RequestLesson.class);
							DynamicQuery dynamicQuery2 = DynamicQueryFactoryUtil.forClass(MBMessage.class);
							dynamicQuery2.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(classPK));
							dynamicQuery2.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID).eq(requestLessonNameId));
							List<MBMessage> commentsList =  MBMessageLocalServiceUtil.dynamicQuery(dynamicQuery2);
							String name=(String)pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_NAME);
									
						%> 
							<article>
								<c:if test="${fn:length(name) ge 50}">
									<h5><a href='<%=requestLessonUrl%>'><%=name.substring(0, 50)%>....</a></h5>
								</c:if>
								<c:if test="${fn:length(name) le 50}">
									<h5><a href='<%=requestLessonUrl%>'><%=name%></a></h5>
								</c:if>
								<div class="infos">
									<div class="likes">
										<span aria-hidden="true" class="icon-thumbs-up"></span>
										&nbsp;<%= appreciatedRequestLesssonCount %><span class="sr-only">Likes</span>
									</div>
									<div class="time"><%= CommonUtil.getDatesDuration(createdDate.getTime(), 0) %></div>
									<div class="responses"><%=commentsList .size()%> responses</div>
								</div>
							</article>
				</c:forEach>
					
				</div>
				<div class="show-more auto-margin">
					<a href="<%=requestLessonUrl%>">
						<button class="btn btn-default btn-block">Show More Results</button>
					</a>
				</div>
			</div>
			
		</div>
	</div>
	
<script>
$("#Request").click(function(){
                
                window.location.href='<%=showRequestLessonURL%>';
});
</script>
	