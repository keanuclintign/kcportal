<%@page import="com.nyu.util.Constant"%>
<%@page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@page import="java.util.Date"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="java.util.Set"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page
	import="com.liferay.portlet.documentlibrary.service.DLFileEntryLocalServiceUtil"%>
<%@page
	import="com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page import="com.nyu.service.LessonLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.model.AssetEntry"%>
<%@page
	import="com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil"%>
<%@page import="java.util.Map"%>
<%@page import="com.liferay.util.portlet.PortletProps"%>
<%@page import="java.util.List"%>
<%@page
	import="com.liferay.portlet.messageboards.service.MBMessageLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil"%>
<%@page import="com.liferay.portlet.messageboards.model.MBMessage"%>
<%@page
	import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="com.liferay.portlet.documentlibrary.model.DLFileEntry"%>
<%@page import="com.nyu.model.Lesson"%>
<%@page import="com.nyu.model.DocumentFile"%>
<%@page import="com.nyu.portlet.lessons.LessonsController"%>
<%@ include file="/WEB-INF/jsp/init.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<% 
request.setAttribute("bestViewCountConstant", Constant.BEST_LESSON_VIEW_COUNT);
request.setAttribute("bestappreciateCountConstant", Constant.BEST_LESSON_APPRECIATE_COUNT);
String basnoURL=(String)request.getServletContext().getAttribute("basno_badge_best_lesson");
if(basnoURL == null){
	basnoURL = "";
}
%>

<portlet:renderURL var="showDocumentURL"
	windowState="<%= WindowState.MAXIMIZED.toString() %>">
	<portlet:param name="action" value="showDocument" />
</portlet:renderURL>

<div class="container">
	<div class="row-fluid">
		<div class="span12">
			<h3>
				You Might Also Like
			</h3>
		</div>
	</div>
</div>
<div id="lessonsController"> 
		<!-- ============== TAB COMPONENT ==================== -->
		<div id="nyYouTab">
			<!-- TAB LINKS -->
			<ul class="nav nav-tabs">
				<li class="active"><a href="#user-interest" id="<portlet:namespace/>latestLessons">Your Interests</a></li>
				<li><a href="#lesson-related" id="<portlet:namespace/>popularLessons">Related Lessons</a></li>
			</ul> <!-- END TAB LINKS -->
			<!-- TAB CONTENT -->
			<div class="tab-content">
				<div id="user-interest" class="tab-pane" style="min-height: 100px;">
					<c:if test="${lessonsByUserInterest.size() > 0}">
						<section class="youmightalsolike section2">
							<div>
									<div id="myCarouselLike" class="carousel slide">
										<div class="carousel-inner">
											<c:set var="loopCount" value="0" scope="page" />
												<c:forEach items="${lessonsByUserInterest}" var="lesson"	varStatus="i">
													<c:if test="${i.count % 4 eq 1 }">
														<c:choose>
															<c:when test="${i.count eq 1 }">
																<div class="item active">
															</c:when>
															<c:otherwise>
																<div class="item">
															</c:otherwise>
														</c:choose>
														<div class="row-fluid">
													</c:if>
														<div class="span3 thumbnail-content">
														<div class="my-flip">
															<div class="back">
																<div class="description">
																	<p>${lesson.description}</p>
																</div>
																<a
																	href="<%=showDocumentURL%>&_<%=Constant.PORTLET_LESSON%>_lessonId=${lesson.lessonId}"
																	class="btn btn-primary">Go to Lesson</a>
															</div>
															<article class="lesson shadow">
																<div class="body">
																	<img class="info-flip-icon nyu-tooltip" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title="Description"
																	src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>info-icon.png" />
																	<header>
																		<a href="<%=showDocumentURL%>&_<%=Constant.PORTLET_LESSON%>_lessonId=${lesson.lessonId}">
																		<h3>
																			<img src='${lesson.documentPath}' class="thumb-dimension" />
																			<span class="category">
																				<c:forEach items="${lesson.categories}" var="category">
																					<span>${category.name}, </span>
																				</c:forEach>
																			</span>
																			<span style="padding-right: 20px;"class="text-overFlow ${lesson.lessonFullName.length() > 53 ?'nyu-tooltip':''}" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title="${lesson.lessonFullName}"> ${lesson.lessonName}</span>
																		</h3>
																		</a>
																	</header>
																	<div class="content">
																		<c:if test="${not empty lesson.userGroupDocumentPath}">
																			<img class="img-circle small-img" src="${lesson.userGroupDocumentPath}">
																			<span class="text-overFlow user-in-card">
																				<span class="${lesson.userGroupName.length()> 17 ?'nyu-tooltip':''}" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title="${lesson.userGroupName}"> ${lesson.userGroupName}</span>
																			</span>
																		</c:if>
																		<c:if test="${empty lesson.userGroupDocumentPath}">
																			<img class="img-circle small-img" src="${lesson.userImage}">
																			<span class="text-overFlow user-in-card">
																				<span class="${lesson.userName.length() > 17 ?'nyu-tooltip':''}" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title="${lesson.userName}"> ${lesson.userName}</span>
																			</span>
																		</c:if>
																		<c:if test='<%=Constant.IS_BADGES_REQUIRE%>'>
																			<c:if test="${lesson.viewCount >= bestViewCountConstant || lesson.appreciateCount>= bestappreciateCountConstant}">		
																			<span class="pull-right">
																					<img class="basno-certificate" src="<%=basnoURL%>"/>
																			</span>
																			</c:if>
																		</c:if>
																	</div>
																</div>
																<footer>
																	<div class="infos">
																		<div class="likes"><span aria-hidden="true" class="${lesson.privacyIcon}"></span>&nbsp;
																			<span class="icon-thumbs-up" aria-hidden='true'></span>&nbsp;${lesson.appreciateCount}<span
																				class='sr-only'>Likes</span>
																		</div>
																		<div class="views">
																			<span class="icon-eye-open" aria-hidden='true'></span>&nbsp;${lesson.viewCount}<span
																				class='sr-only'>views</span>
																		</div>
																		<div class="time">${lesson.uploadedTime}</div>
																	</div>
																</footer>
															</article>
														</div>
														</div>
													<c:if test="${i.count % 4 eq 0 }">
													</div>
													</div>
													</c:if>
												<c:set var="loopCount" value="${loopCount+1}" scope="page" />
												</c:forEach>
												<c:if test="${loopCount%4 ne 0}">
													</div>
													</div>
												</c:if>
										</div><!--/carousel-inner-->
										<c:if test="${lessonsByUserInterest.size() > 3}">
										<a href="#myCarouselLike" data-slide="prev"><button class="previous_a">
												<span class="icon-previous"></span>
											</button></a>
										<a href="#myCarouselLike" data-slide="next"><button class="next_a">
												<span class="icon-next"></span>
											</button></a>
										</c:if>
									</div><!--/myCarouselLike-->
								</div> 
							</section><!--/section-->
						</c:if>
						<c:if test="${!(lessonsByUserInterest.size() > 0)}">
							No lesson found.
						</c:if>
				</div>
				<div id="lesson-related" class="tab-pane" >
					<c:if test="${lessonsByCategoryAndTags.size() > 0}">
						<section class="youmightalsolike section2">
							<div>
									<div id="myCarouselLike2" class="carousel slide">
										<div class="carousel-inner">
											<c:set var="loopCount" value="0" scope="page" />
												<c:forEach items="${lessonsByCategoryAndTags}" var="lesson"	varStatus="i">
													<c:if test="${i.count % 4 eq 1 }">
														<c:choose>
															<c:when test="${i.count eq 1 }">
																<div class="item active">
															</c:when>
															<c:otherwise>
																<div class="item">
															</c:otherwise>
														</c:choose>
														<div class="row-fluid">
													</c:if>
														<div class="span3 thumbnail-content">
														<div class="my-flip">
															<div class="back">
																<div class="description">
																	<p>${lesson.description}</p>
																</div>
																<a
																	href="<%=showDocumentURL%>&_<%=Constant.PORTLET_LESSON%>_lessonId=${lesson.lessonId}"
																	class="btn btn-primary">Go to Lesson</a>
															</div>
															<article class="lesson shadow">
																<div class="body">
																	<img class="info-flip-icon nyu-tooltip" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title="Description"
																	src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>info-icon.png" />
																	<header>
																		<a href="<%=showDocumentURL%>&_<%=Constant.PORTLET_LESSON%>_lessonId=${lesson.lessonId}">
																			<h3>
																			<img src='${lesson.documentPath}' class="thumb-dimension" />
																			<span class="category">
																				<c:forEach items="${lesson.categories}" var="category">
																					<span>${category.name}, </span>
																				</c:forEach>
																			</span>
																				<span style="padding-right: 20px;"class="text-overFlow ${lesson.lessonFullName.length() > 53 ?'nyu-tooltip':''}" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title="${lesson.lessonFullName}"> ${lesson.lessonName}</span>
																			</h3>
																		</a>
																	</header>
																	<div class="content">
																		<c:if test="${not empty lesson.userGroupDocumentPath}">
																			<img class="img-circle small-img" src="${lesson.userGroupDocumentPath}">
																			<span class="text-overFlow user-in-card">
																				<span class="${lesson.userGroupName.length()> 17 ?'nyu-tooltip':''}" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title="${lesson.userGroupName}"> ${lesson.userGroupName}</span>
																			</span>
																		</c:if>
																		<c:if test="${empty lesson.userGroupDocumentPath}">
																			<img class="img-circle small-img" src="${lesson.userImage}">
																			<span class="text-overFlow user-in-card">
																				<span class="${lesson.userName.length() > 17 ?'nyu-tooltip':''}" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title="${lesson.userName}"> ${lesson.userName}</span>
																			</span>
																		</c:if>
																		
																		<c:if test='<%=Constant.IS_BADGES_REQUIRE%>'>	
																			<c:if test="${lesson.viewCount >= bestViewCountConstant || lesson.appreciateCount>= bestappreciateCountConstant}">		
																			<span class="pull-right">
																					<img class="basno-certificate" src="<%=basnoURL%>"/>
																			</span>
																			</c:if>
																		</c:if>
																	</div>
																</div>
																<footer>
																	<div class="infos">
																		<div class="likes"><span aria-hidden="true" class="${lesson.privacyIcon}"></span>&nbsp;
																			<span class="icon-thumbs-up" aria-hidden='true'></span>&nbsp;${lesson.appreciateCount}<span
																				class='sr-only'>Likes</span>
																		</div>
																		<div class="views">
																			<span class="icon-eye-open" aria-hidden='true'></span>&nbsp;${lesson.viewCount}<span
																				class='sr-only'>views</span>
																		</div>
																		<div class="time">${lesson.uploadedTime}</div>
																	</div>
																</footer>
															</article>
														</div>
														</div>
													<c:if test="${i.count % 4 eq 0 }">
													</div>
													</div>
													</c:if>
												<c:set var="loopCount" value="${loopCount+1}" scope="page" />
												</c:forEach>
												<c:if test="${loopCount%4 ne 0}">
													</div>
													</div>
												</c:if>
										</div><!--/carousel-inner-->
										<c:if test="${lessonsByCategoryAndTags.size() > 3}">
										<a href="#myCarouselLike2" data-slide="prev"><button class="previous_a">
												<span class="icon-previous"></span>
											</button></a>
										<a href="#myCarouselLike2" data-slide="next"><button class="next_a">
												<span class="icon-next"></span>
											</button></a>
										</c:if>
									</div><!--/myCarouselLike-->
								</div><!--/span11-->
							</section><!--/section-->
						</c:if>
						<c:if test="${!(lessonsByCategoryAndTags.size() > 0)}">
							No lesson found.
						</c:if>
				</div>
			</div><!-- end tab-content -->
		</div> <!-- end nyYouTab -->
</div>
<script type="text/javascript" src="<%=themeDisplay.getPathThemeJavaScript()%>/jquery/bootstrap.min.js"></script>  
<script>
$(document).ready(function() {
    $('#myCarouselLike').carousel({
    	interval: false
	});
    
    $('#myCarouselLike2').carousel({
    	interval: false
	});
 
    YUI().use('aui-tabview', function(Y) {
		new Y.TabView(
		  {
			srcNode: '#nyYouTab'
		  }
		).render();
	});
 //
    /* $('.tab-content .active').find('.thumbnail-content').each(function(i,val){	    
	    if(i%3 == 0) {  
	      $(this).addClass('no-margin clearfix');
	    }
	}); */
	 
 // On click   
    $(".info-flip-icon").on('click',function(){  
          $(this).closest('article.lesson').stop().animate({
               top: '355px',
               opacity: 0, 
          }, 300); 
    }); 
    
    // On mouseleave  
    $(".my-flip").on( "mouseleave", function(event) {
          $(this).find('article.lesson').stop().animate({
        	  	top: '0px',
                opacity: 1,
          }, 300);
        event.stopPropagation(); 
    });
	
  
	$('.description').perfectScrollbar({
      wheelSpeed: 20,
      wheelPropagation: false
    });
});
</script>
