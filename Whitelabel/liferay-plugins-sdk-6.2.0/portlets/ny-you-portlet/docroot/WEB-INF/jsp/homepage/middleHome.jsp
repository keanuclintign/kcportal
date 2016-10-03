<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.nyu.model.Lesson"%>
<%@page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@page import="java.util.Date"%>
<%@page import="com.nyu.util.Constant" %>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>

<%
String portletId = PortalUtil.getPortletId(request);
long targetPlId = themeDisplay.getPlid();
long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
PortletURL showLessonURL = PortletURLFactoryUtil.create(request, portletId, targetPlId, PortletRequest.RENDER_PHASE);
showLessonURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);
showLessonURL.setWindowState(WindowState.MAXIMIZED); 
%>	

<div id="lessonsController" ng-controller="LessonsController"> 
	   <div class="row-fluid">
	   		<p ng-show="filteredItems.length==0"><b>No lessons found.</b></p>
			<div class="thumbnail-lessons span4" ng-repeat="lesson in filteredItems = (lessons | orderBy:lessonFilter | filter:categoryId|filter:searchPageWise| filter:tagId | limitTo:limit)" ng-class="($index % 3 == 0) ? 'no-margin clearfix' : ''" style="position: relative" my-repeat-directive>
			<div class="my-flip">
				<div class="back">
					<div class="description">
						<p>{{lesson.description}}</p>
					</div>
					<a class="btn btn-primary" href="<%=showLessonURL%>&_homepage_WAR_nyyouportlet_lessonId={{lesson.lessonId}}"> Go to Lesson</a>
				</div>
				<article class="lesson shadow">
					<div class="body">
					<img class="info-flip-icon" src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>info-icon.png">
					<header>
				      <a href="<%=showLessonURL%>&_homepage_WAR_nyyouportlet_lessonId={{lesson.lessonId}}">
				       <h3>
						<img class="thumb-dimension" 	src="{{lesson.documentPath}}">	
				
							<span class="category">
							
								<span ng-repeat="category in lesson.categories">{{category.name}}, </span>
							</span>
							{{lesson.lessonName}}
						 </h3>
						 </a>
					</header>
					</div>
				 	<div class="content" style="height:51px"> 
						<img class="img-circle small-img" src="{{lesson.userImage}}">
						<span>{{lesson.userName}}</span> 
					</div> 
					<footer>
						<div class="infos">
							<div class="likes"><span aria-hidden="true" class="icon-thumbs-up"></span>
								&nbsp;{{lesson.appreciateCount}}<span class="sr-only">Likes</span>
							</div>
							<div class="views"><span class="icon-eye-open" aria-hidden="true"></span>
								&nbsp;{{lesson.viewCount}}<span class="sr-only">views</span>
							</div>
							<div class="time">{{lesson.uploadedTime}}</div>
						</div>
					</footer>
				</article>
			</div>
			</div> <!-- end ng-repeat span4 --> 
	   </div> <!-- end row-fluid -->

	
</div> <!-- MyLessonsController -->




	