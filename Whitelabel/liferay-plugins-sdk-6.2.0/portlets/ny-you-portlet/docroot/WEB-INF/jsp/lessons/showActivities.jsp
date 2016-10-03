<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.nyu.util.Constant"%>
<%@page import="com.liferay.portlet.social.model.SocialRelationConstants"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@ taglib uri="/WEB-INF/tld/liferay-portlet-ext.tld" prefix="liferay"%>

<div class="container">
	<div class="row-fluid">
		<div class="span12">
			<h3><b>Activities</b></h3>
		</div>
	</div>
</div>

<% Map<User,String> whoViewedList = (Map<User,String>)request.getAttribute(Constant.LESSON_VIEWED_AUTHORS_MAP); %>
<% Map<Map<User,SocialActivity>, SocialActivityFeedEntry> peopleUfollowList 
		= (Map<Map<User,SocialActivity>, SocialActivityFeedEntry>)request.getAttribute("authActivityFeedMap"); %>


<section class="user-activity section2">
	
			<div class="container">
			  <h3>Who Else Viewed This Lesson?</h3>  
			  <%if(whoViewedList != null && whoViewedList.size() > 0) {%>    
				<div id="whoViewedCarousel" class="carousel slide">
			          <!-- Carousel items -->
			         <div class="carousel-inner">
			                <c:set var="wvloopCount" value="0" scope="page" />
			                 <c:forEach items="${lessonViewedAuthorsMap}" var="entry" varStatus="i">
									<c:set var="wvloopCount" value="${i.count}" scope="page"/>
									<c:set var="viewedAuthor" value="${entry.key}" scope="page"/>
									<c:set var="authorId">${viewedAuthor.userId}</c:set>
									<c:set var="isAnonymous"><%=CommonUtil.isAnonymous((User)pageContext.getAttribute("viewedAuthor"))%></c:set>								
									<c:set var="time" value="${entry.value}"/>
				              			<c:if test="${i.count % 3 eq 1 }">
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
										
									<div class="span4 shadow clearfix">
										<div class="user-list-item" >
											<c:if test="${isAnonymous}">
											  	<img class="img-circle" style="height: 80px; width: 80px;" src="<%=Constant.ANONYMOUS_PIC%>">
											</c:if>
											<c:if test="${!isAnonymous}">
												<img class="img-circle" style="height: 80px; width: 80px;" src="<%=((User)pageContext.getAttribute("viewedAuthor")).getPortraitURL(themeDisplay)%>">											 	
											</c:if>
											<div class="pull-right">	
												<%long authorId = Long.parseLong((String) pageContext.getAttribute(Constant.AUTHOR_ID));%>
												<c:if test="${isAnonymous}">
													<strong>
														<%=Constant.ANONYMOUS_NAME%>
													</strong>
												</c:if>
												<c:if test="${!isAnonymous}">
													<strong>
														${viewedAuthor.getFirstName()} ${viewedAuthor.getLastName()}														
													</strong>
												</c:if>
												<p class="time" style="padding-top: 10px;" >
													${time}
												</p> 
											</div>
										</div>
									</div>
									<c:if test="${i.count % 3 eq 0 }">
												</div><!--/item-->
											</div><!--/row-fluid-->
										</c:if>	
										
								</c:forEach>
								
									<c:if test="${wvloopCount % 3 ne 0}">
											</div><!--/item-->
										</div><!--/row-fluid-->
									</c:if>	
				                 
			            </div><!--/carousel-inner-->
		                <%if(whoViewedList.size() > 3){ %> 
		                	<a href="#whoViewedCarousel" data-slide="prev"><button class="uc_previous_a"><span class="icon-previous"></span></button></a>
                			<a href="#whoViewedCarousel" data-slide="next"><button class="uc_next_a"><span class="icon-next"></span></button></a>
			     		<%} %>
			     </div><!--/whoViewedCarousel-->
			   <%} else { %>
			   		<span style="margin-left:76px;">No authors viewed this lesson. You are the first to view this lesson !!!</span> 
			   <%} %>
			</div><!-- container -->
	
			<div class="container">
				<h3>People You're Following</h3>
				<%if(peopleUfollowList != null && peopleUfollowList.size() > 0) {%>
				 <div id="peopleUfollowCarousel" class="carousel slide">
			          <!-- Carousel items -->
			         <div class="carousel-inner">
			                <c:set var="pufloopCount" value="0" scope="page" />
			                 
			                 <c:forEach items="${authActivityFeedMap}" var="entry" varStatus="i">
								<c:set var="pufloopCount" value="${i.count}" scope="page"/>
								<c:set var="followingUserMap" value="${entry.key}" scope="page"/>
								
								<c:if test="${i.count % 3 eq 1 }">
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
								
									<c:if test="${not empty entry.value}">
										<c:set var="feedActivity" value="${entry.value}"/>
									</c:if>
	
									<c:set var="followingAuthor" value='<%=((Map<User,SocialActivity>)pageContext.getAttribute("followingUserMap")).keySet().toArray()[0]%>' scope="page"/>
									
									<c:set var="authorActivity" value='<%=((Map<User,SocialActivity>)pageContext.getAttribute("followingUserMap")).get(pageContext.getAttribute("followingAuthor"))%>' scope="page"/>
									<div class="span4 shadow clearfix">
										<div class="user-list-item" >
											
											
											
											  <img class="img-circle" style="height: 80px; width: 80px;" src="<%=((User)pageContext.getAttribute("followingAuthor")).getPortraitURL(themeDisplay)%>">
											
											<div class="pull-right">	
											<strong>
											${followingAuthor.getFirstName()} ${followingAuthor.getLastName()}
											</strong>	
											<c:if test="${not empty entry.value}">	
												
												<c:if test="${fn:length(feedActivity.getTitle()) ge 40}">
													<p style="padding-top: 10px;">
													<c:set var="feedtitle" value="${feedActivity.getTitle()}" scope="page" />
														<%=pageContext.getAttribute("feedtitle").toString().substring(0,40)%>....
													</p>
												</c:if> 
												<c:if test="${fn:length(feedActivity.getTitle()) lt 40}">
													<p style="padding-top: 10px;">
													${feedActivity.getTitle()}</p>
												</c:if>
																								
												<p class="time">
													${feedActivity.getBody()}
												</p>
												
											</c:if>
											
											</div>
																		
										</div>
									</div>
			                	
								<c:if test="${i.count % 3 eq 0 }">
										</div><!--/item-->
									</div><!--/row-fluid-->
								</c:if>	
						
							</c:forEach>
							
								<c:if test="${pufloopCount % 3 ne 0}">
										</div><!--/item-->
									</div><!--/row-fluid-->
								</c:if>	
				                 
			            </div><!--/carousel-inner-->
		                <%if(peopleUfollowList.size() > 3){ %>
		                	<a href="#peopleUfollowCarousel" data-slide="prev"><button class="uc_previous_a"><span class="icon-previous"></span></button></a>
	                		<a href="#peopleUfollowCarousel" data-slide="next"><button class="uc_next_a"><span class="icon-next"></span></button></a>
	                	<%} %>
			     </div><!--/whoViewedCarousel-->
			   <%} else { %>
			   		<span style="margin-left:76px;">
			   				Currently you are not following any authors. <%-- To follow authors click 
			   				<a href= "<liferay:renderURL portletName='lessons_WAR_nyyouportlet' portletMode='view' windowState='maximized'>
								<liferay:param name='type' value='<%= String.valueOf(SocialRelationConstants.TYPE_UNI_FOLLOWER) %>'/>
								<liferay:param name='action' value='showFollowing' /></liferay:renderURL>">here.</a>  --%>
			   		
			   		</span>
			   <%} %>
			</div><!-- container -->
</section>
