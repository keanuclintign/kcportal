<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

<%
String portletId = Constant.PORTLET_LESSON;
long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(),Constant.PAGE_LESSON_BROWSE).getPlid();
PortletURL showDocumentURL=PortletURLFactoryUtil.create(request, portletId, targetPlId, PortletRequest.RENDER_PHASE);
showDocumentURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);
String basnoURL=(String)request.getServletContext().getAttribute("basno_badge_best_lesson");
if(basnoURL == null){
	basnoURL = "";
}
%>	

	   <div class="row-fluid">
	   		<p ng-show="filteredItems.length==0" ng-cloak><liferay-ui:message key="no-lessons-found" />.</p>
			<div class="thumbnail-lessons span4" ng-repeat="lesson in filteredItems = (lesson | filter:searchPageWise| limitTo:limit)" ng-class="($index % 3 == 0) ? 'no-margin clearfix' : ''" style="position: relative" ng-cloak my-stuff-my-lessons-directive>
			<div class="my-flip">
				<div class="back">
					<div class="description">
						<p>{{lesson.description}}</p>
					</div>
					<a class="btn btn-primary" href="<%=showDocumentURL%>&_<%=Constant.PORTLET_LESSON%>_lessonId={{lesson.lessonId}}"> <liferay-ui:message key="go-to-lesson" /></a>
				</div>
				<article class="lesson shadow">
					<div class="body">
					<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>info-icon.png" class="info-flip-icon nyu-tooltip" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title='<liferay-ui:message key="description" />'>
					<header>
					 <a href="<%=showDocumentURL%>&_<%=Constant.PORTLET_LESSON%>_lessonId={{lesson.lessonId}}">
						<h3> 
							<img class="thumb-dimension" ng-src="{{lesson.documentPath}}">
							<span class="category">
								<span ng-repeat="category in lesson.categories">{{category.name}}, </span>
							</span>
							<span ng-class="(lesson.lessonFullName.length >53) ? 'nyu-tooltip' : ''" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title={{lesson.lessonFullName}} class="text-overFlow" style="padding-right: 20px;"> {{lesson.lessonName}} </span>
						</h3>
					 </a>
					</header>
					</div>
				 	<div class="content" style="height:51px"> 
						<img class="img-circle small-img" ng-src="{{lesson.userImage}}">
						<span class="text-overFlow user-in-card">
							<span ng-class="(lesson.userName.length >17) ? 'nyu-tooltip' : ''" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title={{lesson.userName}}> {{lesson.userName}}</span>
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