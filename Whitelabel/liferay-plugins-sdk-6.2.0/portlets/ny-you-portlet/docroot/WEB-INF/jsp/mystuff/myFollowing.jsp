<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="java.util.*" %>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portal.theme.ThemeDisplay"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<portlet:defineObjects />
<liferay-theme:defineObjects />
		
<h1> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>Followings.png">
	<liferay-ui:message key="following" /> 
 </h1>
<div class="right-section">


	<c:set var="intcount" value="0" scope="page" />
	<c:set var="loopCount" value="0" scope="page" />
	<c:if test="${empty myFollowingUserList}">
		<div class="row" id="noFollowing"><p> 
			<liferay-ui:message key="no-following-found" />. 
		</p> </div>
	</c:if>
	<c:forEach items="${myFollowingUserList}" var="myFollowingUser" varStatus="i">
	<c:set var="count" value="${count + 1}" scope="page"/>
	<c:set var="intcount" value="${count}" scope="page" />
	<c:set var="loopCount" value="${loopCount+1}" scope="page" />
	<c:set var="authorId">${myFollowingUser.userId2}</c:set>
	<c:set var="uploadedTime" value="${myFollowingUser.createDate}" scope="page" />
	<%--<c:set var="createDate">${myFollowingUser.createDate}</c:set>
	<c:set var="description" value="${lesson.description}" scope="page" />
	<c:set var="uploadedTime" value="${lesson.uploadedTime}" scope="page" />	 --%>
	<%
	String portletId = Constant.PORTLET_CONTRIBUTOR;
	long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(),Constant.PAGE_CONTRIBUTOR).getPlid();
	PortletURL userDetailsUrl=PortletURLFactoryUtil.create(request, portletId, targetPlId, PortletRequest.RENDER_PHASE);
	userDetailsUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, "lessonAndRequests");
	userDetailsUrl.setParameter(Constant.FROM, "myFollowing");
	
	long authorId = Long.parseLong((String) pageContext.getAttribute(Constant.AUTHOR_ID));
	int appreciateCount=CommonUtil.getAuthorAppreciateCount(authorId);
	int viewCount=CommonUtil.getAuthorViewCount(authorId);
	long uploadedTime = (Long)pageContext.getAttribute(Constant.USER_GROUP_UPLOAD_TIMES_VAR);
/* 	String portletId = "lessons_WAR_nyyouportlet";
	long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), StringPool.FORWARD_SLASH+Constant.BROWSE).getPlid();
	PortletURL showAuthorLessonURL=PortletURLFactoryUtil.create(renderRequest, portletId, targetPlId, PortletRequest.RENDER_PHASE);
    showAuthorLessonURL.setParameter("action", "authorLessons");
    showAuthorLessonURL.setWindowState(WindowState.MAXIMIZED);
    String portletNamespace = StringPool.UNDERLINE + portletId + StringPool.UNDERLINE; */
    User author = CommonUtil.getAuthor(authorId);
    String authorImg=author.getPortraitURL(themeDisplay);
    String author_info =(String)UserLocalServiceUtil.getUser(authorId).getExpandoBridge().getAttribute(Constant.EXPANDO_FIELD_AUTHOR_INFO);
	if(author_info != null && author_info.length() >143){
		author_info = author_info.substring(0, 140)+Constant.COMMON_STRING_CONSTANT_THREE_DOTS;
	}
   %>
	
	<c:if test="${i.count % 3 eq 1 }">
	<div class="row-fluid">
	</c:if>
		<div class="span4">	
			<article class="lesson shadow"> 
				<div class="clearfix follwer-details">
					<div class="span3"> 
					
					<img src="<%=authorImg%>" class="img-circle" width="100"></div>
					<div class="content span9">
					<h4 class="media-heading"><a href="#">
							<a href="<%=userDetailsUrl%>&_<%=Constant.PORTLET_CONTRIBUTOR%>_userId=<%=authorId%>"><%=UserLocalServiceUtil.getUser(authorId).getFirstName()%> <%=UserLocalServiceUtil.getUser(authorId).getLastName()%> </a></h4>
							<p><%=author_info%></p> 
					</div>
				</div>
				<footer>
					<div class="infos">
						<div class="likes"><span aria-hidden="true" class="icon-thumbs-up"></span>
							&nbsp;<%=appreciateCount %><span class="sr-only">
								<liferay-ui:message key="likes" />
							</span>
						</div>
						<div class="views"><span class="icon-eye-open" aria-hidden="true"></span>
							&nbsp;<%=viewCount %><span class="sr-only">
								<liferay-ui:message key="views" />
							</span>
						</div>
						<div class="time"><%= CommonUtil.getDatesDuration(uploadedTime, 0) %></div>
					</div>
				</footer>
			</article>
		</div> <!-- end span6 -->
		<c:if test="${i.count % 3 eq 0}">
		<c:if test="${loopCount ge 3}">
			</div>
		</c:if>
	</c:if>
	</c:forEach>
</div> <!-- end right-section -->




