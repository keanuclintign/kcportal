
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="com.nyu.util.Constant"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%
String portletId = Constant.PORTLET_LESSON;
long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_LESSON_BROWSE).getPlid();
PortletURL showDocumentURL=PortletURLFactoryUtil.create(request, portletId, targetPlId, PortletRequest.RENDER_PHASE);
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
	        <p ng-show="publishedFiltereddItems.length==0">
	        	<liferay-ui:message key="no-lessons-found" />
	        </p>
			<div class="thumbnail-lessons span4" ng-repeat="lesson in publishedFiltereddItems = (lessons | filter:categoryId |filter:{status:'published'} | filter:tagId | limitTo:limit)" ng-class="($index % 3 == 0) ? 'no-margin clearfix' : ''"  style="position: relative" my-stuff-my-lessons-directive>
			<div class="my-flip">
				<div class="back">
					<div class="description">
						<p>{{lesson.description}}</p>
					</div>
					
					<span ng-if=lesson.status=='draft'>
						<a class="btn btn-primary" href="<%=editUrl%>&_<%=Constant.PORTLET_CREATE_LESSON%>_lessonId={{lesson.lessonId}}"> 
							<liferay-ui:message key="go-to-lesson" />
						</a>
					</span>
					<span ng-if=lesson.status!='draft'>
					<a class="btn btn-primary" href="<%=showDocumentURL%>&_<%=Constant.PORTLET_LESSON%>_lessonId={{lesson.lessonId}}"> 
						<liferay-ui:message key="go-to-lesson" />
					</a>
					</span>
				</div>
				<article class="lesson shadow">
					<div class="body">
					<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>info-icon.png" class="info-flip-icon nyu-tooltip" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title='<liferay-ui:message key="description" />'>
					<header>
					<span ng-if=lesson.status=='draft'>
					<a href="<%=editUrl%>&_<%=Constant.PORTLET_CREATE_LESSON%>_lessonId={{lesson.lessonId}}">
				       <h3>
						<img class="thumb-dimension" ng-src="{{lesson.documentPath}}">					
							<span class="category">
								<span ng-repeat="category in lesson.categories">{{category.name}}, </span>
							</span>
							<span ng-class="(lesson.lessonFullName.length >53) ? 'nyu-tooltip' : ''" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title={{lesson.lessonFullName}} class="text-overFlow" style="padding-right: 20px;"> {{lesson.lessonName}} </span>
						 </h3>
						 </a>
						</span> 
						<span ng-if=lesson.status!='draft'>
				      	<a href="<%=showDocumentURL%>&_<%=Constant.PORTLET_LESSON%>_lessonId={{lesson.lessonId}}">
				       	<h3>
					       <span ng-if=lesson.authorId!=currentUserId class="nyu-tooltip ang-tooltip status-icon" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title='<liferay-ui:message key="collaborated-lesson" />' style="background: #520c7b"> 
	  							<i class="fa fa-user-plus custom-icon"> </i>
						   </span>
						   
						   <span ng-if="lesson.hasCollaborator == 'true' && lesson.authorId == currentUserId" class="nyu-tooltip ang-tooltip status-icon" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title='<liferay-ui:message key="your-lesson" />' style="background: #27ae60"> 
	  							<i class="fa fa-user-plus custom-icon"> </i>
						   </span>
							<img class="thumb-dimension" 	ng-src="{{lesson.documentPath}}">	
				
							<span class="category">
							
								<span ng-repeat="category in lesson.categories">{{category.name}}, </span>
							</span>
							<span ng-class="(lesson.lessonFullName.length >53) ? 'nyu-tooltip' : ''" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title={{lesson.lessonFullName}} class="text-overFlow" style="padding-right: 20px;"> {{lesson.lessonName}} </span>
						 </h3>
						 </a>
						 </span>
					</header>
					</div>
				 	<div class="content" style="height:38px; padding: 0;"> 
						<span class="pull-left custom-ribbon" ng-if=lesson.status=='draft'>
								<b>
									<liferay-ui:message key="draft" />
								</b>
						</span>
						<c:if test='<%=Constant.IS_BADGES_REQUIRE%>'>
						<span class="pull-right" ng-if="lesson.viewCount>=<%=Constant.BEST_LESSON_VIEW_COUNT%> || lesson.appreciateCount>=<%=Constant.BEST_LESSON_APPRECIATE_COUNT%>">
								<img class="pull-right basno-certificate" src="<%=basnoURL%>"/>
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

				

