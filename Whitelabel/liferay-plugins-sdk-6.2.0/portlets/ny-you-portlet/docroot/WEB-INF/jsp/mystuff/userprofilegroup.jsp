<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.liferay.portal.service.UserGroupLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.UserGroup"%>
<%@page import="com.liferay.portal.service.LayoutSetLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.LayoutSet"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>


<h2> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyGroups.png">  My Groups </h2>
<liferay-portlet:renderURL var="showGroupURL" portletName="nyu_home_WAR_nyyouportlet" windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
<portlet:param name="action" value="groupUrl"/>
</liferay-portlet:renderURL>
		
<div id="groupLatest" class="right-section"> 			

	<c:if test="${empty userGroups}">
	 
	<p> No groups found. </p> 
	</c:if>
	<c:set var="intcount" value="0" scope="page" />
	<c:set var="loopCount" value="0" scope="page" />
	<c:forEach items="${userGroups}" var="usergroup" varStatus="i">
		<c:set var="count" value="${count + 1}" scope="page"/>
		<c:set var="intcount" value="${count}" scope="page" />
		<c:set var="loopCount" value="${loopCount+1}" scope="page" />
		<c:set var="usergroupId" value="${usergroup.userGroupId}" scope="page" />
		<c:set var="groupId" value="${usergroup.groupId}" scope="page" />
		<%
		long usergroupId = GetterUtil.getLong(pageContext.getAttribute("usergroupId"));
		long groupId = GetterUtil.getLong(pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_GROUP_ID));
		UserGroup usergroup=UserGroupLocalServiceUtil.getUserGroup(usergroupId);
		User managedBy=UserLocalServiceUtil.getUser(usergroup.getUserId());
		int membersSize=UserLocalServiceUtil.getUserGroupUsers(usergroupId).size();
		String appreciatedUserIds =usergroup.getExpandoBridge().getAttribute(Constant.APPRECIATE).toString();
		int appreciatedCount = CommonUtil.getAppreciatedCount(appreciatedUserIds);
		int viewCountgroup =GetterUtil.getInteger(usergroup.getExpandoBridge().getAttribute("view-count").toString());
		
		String logo=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER;
		LayoutSet publicLS=LayoutSetLocalServiceUtil.getLayoutSet(groupId, false);
		if(publicLS.getLogo())
		{
			logo=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+publicLS.getLogoId();	
		}
		LayoutSet privateLS=LayoutSetLocalServiceUtil.getLayoutSet(groupId, true);
		if(privateLS.getLogo())
		{
			logo=Constant.IMAGE_LAYOUT_SET_LOGO_IMG_ID+privateLS.getLogoId();	
		}
	
		%>
	
		<%-- <div class="span4 thumbnail-content">
				<div class="my-flip">
					<div class="back">
						<div class="description ps-container">
						<c:set var="description" value="${usergroup.description}"
								scope="page" />
						<c:if test="${fn:length(description) ge 400}">
								<p><%=pageContext.getAttribute("description").toString().substring(0,400) %>...</p>
							</c:if> 
							<c:if test="${fn:length(description) le 400}">
								<p><%=pageContext.getAttribute("description").toString()%></p>
							</c:if>
						</div>
						<a href="javascript:void(0)" onclick="groupsDetailLoader('<%=usergroupId%>')" class="btn btn-primary"> Go to Group</a>
					</div>
					<!-- end back -->

					<article class="lesson">
						<div class="stack">
							<div class="stack">
								<div class="body">
									<header>
										<h3> 
								<img class="group-icon-top" src="<%=themeDisplay.getPathThemeImages()+ Constant.PORTLET_PROP_PATH_VENDOR %>group_icon_top.png">
								<a  href="javascript:void(0)" onclick="groupsDetailLoader('<%=usergroupId%>')" style="background-image: url('<%=logo%>');background-size: 100% 173px; padding-top: 189px;">
									<span class="category">
								  
								 	</span>
									Group: ${usergroup.name}
								</a>
								</h3>
									</header>
								</div>
								<!-- end body -->
								<div class="content">
									<img src="<%=managedBy.getPortraitURL(themeDisplay)%>"
										class="img-circle" width="40" /> <span><%=managedBy.getFirstName()%>
										<%=managedBy.getLastName()%></span>
								</div>
								<!-- end content -->
								<footer>
									<div class="infos">
										<div >
											<span class="icon-thumbs-up" aria-hidden="true"></span>
											<%=appreciatedCount%>&nbsp;
											<span class="sr-only">Likes</span>
										</div>
										<div class="views">
											<span aria-hidden="true" class="icon-eye-open"></span> <%=viewCountgroup%>&nbsp;
											<span class="sr-only">views</span>
										</div>
										<div>
											<img width="22px"
												src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyGroups.png"><%=membersSize%><span
												class="sr-only">Members</span>
										</div>

									</div>
									<!-- end infos -->
								</footer>
							</div>
							<!-- end stack -->
						</div>
						<!-- end stack -->
					</article>
					<!-- end lesson -->
				</div>
				<!-- end my-flip -->
			</div>
			<!-- end span4 --> --%>
	
	<div class="span4 thumbnail-content">
					<article class="lesson shadow"> 
						<div class="stack">	
							<div class="stack">							
								<div class="group-flip">
									<div class="back">
										<div class="description ps-container">
										<c:set var="description" value="${usergroup.description}"
												scope="page" />
										<c:if test="${fn:length(description) ge 400}">
												<p><%=pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_DESCRIPTION).toString().substring(0,400) %>...</p>
											</c:if> 
											<c:if test="${fn:length(description) le 400}">
												<p><%=pageContext.getAttribute(Constant.COMMON_STRING_CONSTANT_DESCRIPTION).toString()%></p>
											</c:if>
										</div>
										<a href="javascript:void(0)" onclick="groupsDetailLoader('<%=usergroupId%>')" class="btn btn-primary"> Go to Group</a>
									</div> <!-- end back -->
									<div class="front">
										<div class="body">
											<header>
												<h3> 
													<img class="group-icon-top" src="<%=themeDisplay.getPathThemeImages()+ Constant.PORTLET_PROP_PATH_VENDOR %>group_icon_top.png">
													<a  href="javascript:void(0)" onclick="groupsDetailLoader('<%=usergroupId%>')" style="background-image: url('<%=logo%>');background-size: 100% 173px; padding-top: 189px;">
														<span class="category">
													  
													 	</span>
														${usergroup.name}
													</a>
												</h3>
											</header>
										</div>
										<!-- end body -->
										<div class="content">
											<img src="<%=managedBy.getPortraitURL(themeDisplay)%>"
												class="img-circle" width="40" /> <span><%=managedBy.getFirstName()%>
												<%=managedBy.getLastName()%></span>
										</div> <!-- end content -->
									</div> <!-- end front -->
								</div> <!--  end my-flip -->
								<footer>
									<div class="infos">
											<div >
											<span class="icon-thumbs-up" aria-hidden="true"></span>
											<%=appreciatedCount%>&nbsp;
											<span class="sr-only">Likes</span>
										</div>
									
										<div>
											<img width="22px"
												src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyGroups.png"><%=membersSize%><span
												class="sr-only">Members</span>
										</div>

									</div>
									<!-- end infos -->
								</footer>  
							</div> <!--  end stack  -->
						</div> <!--  end stack  -->
					</article> <!-- end lesson --> 
			</div> <!-- end span4 -->
	
	
	
	
	
	
	</c:forEach>
	
	
	</div> <!-- end right-section -->
<script>
	$(document).ready(function(){ 
		$('#myStuff').find('.thumbnail-content').each(function(i,val){	    
		    if(i%3 == 0) {  
		      $(this).addClass('no-margin clearfix');
		    }
		});
		
		// Flip front-back
		$("#groupLatest .span4").hover(function(event){
			$(this).find('.front').stop().animate({
				top: '355px',
				opacity: 0, 
			}, 300, function(){
				$(this).find('.front').css('height','0px');
			});
			event.stopPropagation();
		},function(event){
			$(this).find('.front').stop().animate({
				top: '0px',
				opacity: 1,
			}, 300, function(){
				$(this).find('.front').css('height','316px');
			});
			event.stopPropagation();
		});
		
		
	  
		$('.description').perfectScrollbar({
          wheelSpeed: 20,
          wheelPropagation: false
        });  
		
	}); 
	
	function groupsDetailLoader(userGroupId){

		$("#groups").html($("#divLoading").html());
		$.ajax({
		      url:'<%=showGroupURL%>',
		      type: 'GET',
		      datatype:'html',
		      data:{
		      	_nyu_home_WAR_nyyouportlet_groupId:userGroupId
		      		},
				success: function(data){
				$('#<portlet:namespace/>content #<portlet:namespace/>userprofilegroupContent').html(data.replace("class=\"container\"",""));
				
			}
	   });
		
	} 
</script>