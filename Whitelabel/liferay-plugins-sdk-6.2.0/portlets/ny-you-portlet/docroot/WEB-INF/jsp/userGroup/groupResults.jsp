<%@page import="javax.portlet.WindowState"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.liferay.portal.model.LayoutSet"%>
<%@page import="com.liferay.portal.service.LayoutSetLocalServiceUtil"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.liferay.portal.service.UserGroupLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.model.UserGroup"%>
<%@ include file="/WEB-INF/jsp/init.jsp"%>
<%
	List<UserGroup> usergroups = themeDisplay.getUser().getUserGroups();
	List<Long> usergroupids = new ArrayList<Long>();

	for (UserGroup usergroup : usergroups) {
		usergroupids.add(usergroup.getUserGroupId());
	}
%>
<%
String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),
		layout.isPrivateLayout(),themeDisplay);

String groupsUrl=siteFriendlyUrl+Constant.PAGE_GROUP;


String portletID = Constant.PORTLET_GROUP;
long targetPlID = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_GROUP).getPlid();
PortletURL userGroupUrl=PortletURLFactoryUtil.create(request, portletID, targetPlID, PortletRequest.RENDER_PHASE);
userGroupUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.LESSON_URL);
userGroupUrl.setWindowState(WindowState.MAXIMIZED);



%>
<portlet:resourceURL var='subscriberURL' id='subscriber' />
<portlet:renderURL var="groupUrl">
	<portlet:param name="action" value="groupUrl" />
</portlet:renderURL>
<div id="groupLatest">
	<div class="row-fluid">
		<p ng-show="filteredItems.length==0"><b><liferay-ui:message key="no-groups-found" /></b></p>
		<div class="thumbnail-lessons span4" ng-repeat="group in filteredItems = (groups | filter:categoryId | filter:searchPageWise | filter:tagId | limitTo:limit)" style="position: relative" ng-class="($index % 3 == 0) ? 'no-margin clearfix' : ''" ng-cloak my-group-repeat-directive>
			<div class="my-flip">
				<div class="back">
					<div class="description ps-container">
						<p>{{group.description}}</p>
					</div>
					<a class="btn btn-primary" href="<%=userGroupUrl%>&_<%=Constant.PORTLET_GROUP%>_userGroupId={{group.groupId}}"><liferay-ui:message key="go-to-group" /></a>
				</div> <!--  end back -->
				
				<article class="lesson shadow">
					<div class="stack">
						<div class="stack">
									<div class="body">
										<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>info-icon.png" class="info-flip-icon nyu-tooltip" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title='<liferay-ui:message key="description" />'>
										<header>
											<a  href="<%=userGroupUrl%>&_<%=Constant.PORTLET_GROUP%>_userGroupId={{group.groupId}}">
											<h3>
												<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>group_icon_top.png"
												class="group-icon-top"> <img class="thumb-dimension"
												ng-src="{{group.documentPath}}"> 
												
													<span class="category">
														<span ng-repeat="category in group.categories" my-inside-directive>{{category.name}}, </span>
													</span>
													<span class="text-overFlow" style="padding-right: 20px;">  
														<span ng-class="(group.groupName.length >47) ? 'nyu-tooltip' : ''" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)" data-title={{group.groupLongName}}> <liferay-ui:message key="group" />: {{group.groupName}} </span>
													</span>
											</h3>
											</a>
										</header>
										<div class="content">
											<img class="img-circle small-img" ng-src="{{group.userImage}}">
											<span class="text-overFlow user-in-card">
												<span data-title={{group.userName}} ng-class="(group.userName.length >17) ? 'nyu-tooltip' : ''" onmouseover="tooltipOver(this)" onmouseleave="tooltipOut(this)"> {{group.userName}} </span>
											</span>
										</div>
									</div> 
							<footer>
								<div class="infos">
									<div>
										<span aria-hidden="true" class="icon-thumbs-up"></span>
										&nbsp;{{group.appreciateCount}}<span class="sr-only"><liferay-ui:message key="likes" /></span>
									</div>
									<div>
										<img width="22px" src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyGroups.png">
										{{group.memberSize}}<span class="sr-only"><liferay-ui:message key="members" /></span>
									</div>
									<div class="showOrHide">
										<div class="action-group">  
											<button 
												ng-click="subscriber('<%=subscriberURL.toString()%>',group.groupId,group.groupPrivacy,group.authorId == group.userID,'<portlet:namespace/>')"
												class="group-{{group.groupId}} {{group.classes}} pull-right hidden-desktop" data-sub="{{group.dataSub}}">{{group.label}}
											</button>
										</div>
										<a href="#" class="hidden-desktop mobile-quick-menu"> <img style="float: right;" src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>menu-7-icon-24.png"> </a>
										<button ng-click="subscriber('<%=subscriberURL.toString()%>',group.groupId,group.groupPrivacy,group.authorId == group.userID,'<portlet:namespace/>')"
											class="group-{{group.groupId}} {{group.classes}} pull-right visible-desktop" data-sub="{{group.dataSub}}">{{group.label}}
										</button>
									</div>
									<div class="showOrHide-manage">
										<div class="action-group">  
											<a href="<%=groupUrl%>&_<%=Constant.PORTLET_USERGROUP%>_userGroupId={{group.groupId}}" 
											class="btn btn-primary pull-right" style="margin-top: -3px;"> <liferay-ui:message key="manage" /> </a>
										</div>
										<a href="#" class="hidden-desktop mobile-quick-menu"> <img style="float: right;" src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>menu-7-icon-24.png"> </a>
										<a href="<%=groupUrl%>&_<%=Constant.PORTLET_USERGROUP%>_userGroupId={{group.groupId}}" 
										class="btn btn-primary pull-right visible-desktop" style="margin-top: -3px;"> <liferay-ui:message key="manage" /> </a>
									</div>
								</div>
							</footer>
						</div>
						<!-- end stack -->
					</div>
					<!--  end stack  -->
				</article> <!-- end lesson -->
			</div> <!-- end my-flip -->
		</div>
		<!-- end span4 -->
	</div>
	<!-- end row-fluid -->
</div>
<!-- end groupLatest -->
