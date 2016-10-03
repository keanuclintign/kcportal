
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="com.nyu.util.Constant"%>
<portlet:resourceURL id="deleteLesson" var="deleteLessonURL"/>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%
String portletId = Constant.PORTLET_LESSON;
long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_LESSON_BROWSE).getPlid();
PortletURL showDocumentURL=PortletURLFactoryUtil.create(request, portletId, targetPlId, PortletRequest.RENDER_PHASE);
showDocumentURL.setParameter("fromTab","qurantineTab");
showDocumentURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);

String basnoURL=(String)request.getServletContext().getAttribute("basno_badge_best_lesson");
if(basnoURL == null){
	basnoURL = "";
}
PortletURL editUrl = PortletURLFactoryUtil.create(request, Constant.PORTLET_CREATE_LESSON, themeDisplay.getPlid(), PortletRequest.RENDER_PHASE);
editUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_STRING_CONSTANT_EDIT_LESSON);
editUrl.setWindowState(LiferayWindowState.MAXIMIZED);
//editUrl.setParameter("lessonId", lessonId+"");
%>	

<div> 
	
	<div class="filter-form row-fluid">
			<div class="span4">
					<label class="pull-left" for="Category"> 
						<liferay-ui:message key="category" />  
					</label>
					<select ng-model="categoryId" ng-change="filterByCategory();" >
						<option value="0">
							<liferay-ui:message key="all" />
						</option>
						<option ng-repeat="category in categories" value='{{category.id}}'>{{category.name}}</option>
					</select> 
			</div>
			<div class="span4">
					<label for="Tag" class="pull-left">
						<liferay-ui:message key="tag" />
					</label>  
					<select ng-model="tagId" ng-change="filterByTag();" >
						<option value="0">
							<liferay-ui:message key="all" />
						</option>
						<option ng-repeat="tag in tags" value='{{tag.id}}'>{{tag.name}}</option>
					</select>	
			</div> 	<!-- end span4 --> 
	</div> <!-- end span12 -->
	
	
  
	  
	   <div class="row-fluid">
	   		<p ng-show="filteredItems.length==0" ng-cloak>
	   			<liferay-ui:message key="no-lessons-found" />.
	   		</p>
			<div class="thumbnail-lessons span4" ng-repeat="lesson in filteredItems = (archivedLessons | filter:categoryId  | filter:tagId | limitTo:limit)" ng-class="($index % 3 == 0) ? 'no-margin clearfix' : ''" style="position: relative" ng-cloak my-stuff-my-lessons-directive>
			<div class="my-flip">
				<div class="back">
					<div class="description">
						<p>{{lesson.description}}</p>
					</div>
					<a class="btn btn-primary" href="<%=showDocumentURL%>&_<%=Constant.PORTLET_LESSON%>_lessonId={{lesson.lessonId}}"> 
						<liferay-ui:message key="go-to-lesson" />
					</a>
				</div>
				<article class="lesson shadow">
					<div class="body">
					<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>info-icon.png" class="info-flip-icon nyu-tooltip" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title='<liferay-ui:message key="description" />'>
					<header>
					 <a href="<%=showDocumentURL%>&_<%=Constant.PORTLET_LESSON%>_lessonId={{lesson.lessonId}}">
						<h3> 
							<img class="thumb-dimension" ng-src="{{lesson.documentPath}}">
							<span class="category">
								<span ng-repeat="category in lesson.categories" my-inside-directive>{{category.name}}, </span>
							</span>
							<span ng-class="(lesson.lessonFullName.length >53) ? 'nyu-tooltip' : ''" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title={{lesson.lessonFullName}} class="text-overFlow" style="padding-right: 20px;"> {{lesson.lessonName}} </span>
						 </h3>
						 </a>
					</header>
					</div>
				 	<div class="content"> 
						<img class="img-circle small-img" ng-if="lesson.userGroupDocumentPath.length==0" ng-src="{{lesson.userImage}}"> 
						<img class="img-circle small-img" ng-if="lesson.userGroupDocumentPath.length>0" ng-src="{{lesson.userGroupDocumentPath}}"> 
						
						
						<span class="text-overFlow user-in-card">
							<span ng-if="lesson.userGroupName.length==0" ng-class="(lesson.userName.length >17) ? 'nyu-tooltip' : ''" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title={{lesson.userName}}> {{lesson.userName}}</span>
							<span ng-if="lesson.userGroupName.length>0" ng-class="(lesson.userGroupName.length >17) ? 'nyu-tooltip' : ''" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title={{lesson.userGroupName}}> {{lesson.userGroupName}}</span>
						</span>
						<c:if test='<%=Constant.IS_BADGES_REQUIRE%>'>
						<span class="pull-right" ng-if="lesson.viewCount>=<%=Constant.BEST_LESSON_VIEW_COUNT%> || lesson.appreciateCount>=<%=Constant.BEST_LESSON_APPRECIATE_COUNT%>">
								<img class="basno-certificate" src="<%=basnoURL%>"/>
						</span>
						</c:if>
					</div> 
					<footer>
						<div class="infos">
							<div class="likes"><span aria-hidden="true" class="{{lesson.privacyIcon}}"></span>&nbsp;
							<span aria-hidden="true" class="icon-thumbs-up"></span>
								&nbsp;{{lesson.appreciateCount}}<span class="sr-only">
									<liferay-ui:message key="likes" />
								</span>
							</div>
							<div class="views"><span class="icon-eye-open" aria-hidden="true"></span>
								&nbsp;{{lesson.viewCount}}<span class="sr-only">
									<liferay-ui:message key="views" />
								</span>
							</div>
							<div class="time">{{lesson.uploadedTime}}</div>
						</div>
					</footer>
				</article>
			</div>
			</div> <!-- end ng-repeat span4 --> 
	   </div> <!-- end row-fluid -->
	
</div> <!-- MyLessonsController -->