
<%@page import="javax.portlet.ResourceURL"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="com.liferay.portal.security.permission.PermissionChecker"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%String request_portlet_Id = Constant.PORTLET_REQUEST_LESSON;
long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_REQUEST_LESSON).getPlid();
PortletURL requestDetailURL=PortletURLFactoryUtil.create(request, request_portlet_Id, targetPlId, PortletRequest.RENDER_PHASE);
requestDetailURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.REQUEST_DETAILS);

ResourceURL deleteRequestURL=PortletURLFactoryUtil.create(request, request_portlet_Id, targetPlId, PortletRequest.RESOURCE_PHASE);
deleteRequestURL.setResourceID("deleteRequest");
deleteRequestURL.setParameter(Constant.COMMON_STRING_CONSTANT_USER_ID,String.valueOf(PortalUtil.getUserId(request)));

%>


<div id="allRequests" class="tab-pane">
	<div id="requestForInfo">
		<p ng-show="allJsonRequests.length==0">
			<liferay-ui:message key="no-requests-found" />.
		</p>
			<div ng-repeat="request in allJsonRequests | offset: currentPage*itemsPerPage | limitTo: itemsPerPage">
			<span ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId)%>'
				class="pull-right"
				style="padding-right: 20px; position: relative; z-index: 1;"">
				<a class="cursor-pointer nyu-tooltip"
				ng-click="deleteRequest('<%=deleteRequestURL%>',request.requestLessonId)"
				title='<liferay-ui:message key="delete-request" />'> <i class="icon-trash"></i>
			</a>
			</span>
			<blockquote class="row">
					<div class="span9">
						<p><a href="<%=requestDetailURL%>&_<%=Constant.PORTLET_REQUEST_LESSON%>_requestLessonId={{request.requestLessonId}}">
						{{request.name}}</a></p> 
						<BR><p class="signature">     
							{{request.userName}}   &nbsp; &nbsp;
							{{request.crateDate}} &nbsp; &nbsp;
							<i class="icon-thumbs-up"> </i> {{request.appreciatedCount}} &nbsp; &nbsp;
							<span ng-if=request.answerCount!=0 class="label label-success">
							 {{request.answerCount}} 
							 	<liferay-ui:message key="answers" /> 
							</span>
							<span ng-if=request.answerCount==0 class="label label-default">
							 	<liferay-ui:message key="no-answer-yet" /> 
							</span>
						</p>
					</div> 
						
						<div class="span3 text-center hidden-phone" ng-if=request.answerType=='req_Lesson'> 
							<p><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-lesson.gif">
							<small>
								<liferay-ui:message key="request-for-lesson" />
							</small></p>
						</div>
						
						<div class="span3 text-center hidden-phone" ng-if=request.answerType=='req_Information'> 
							<p><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-group-chat.gif"/>
							<small>
								<liferay-ui:message key="request-for-information" />
							</small></p>
						</div>
						
						<div class="span3 text-center hidden-phone" ng-if=request.answerType=='req_Opinion'> 
							<p><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-slate.gif"/>
							<small>
								<liferay-ui:message key="request-for-opinion" />
							</small></p>
						</div>
						
						<div class="span3 text-center hidden-phone" ng-if=request.answerType=='req_Collaborator'> 
							<p><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-user-group.gif"/>
							<small>
								<liferay-ui:message key="request-for-collaboration" />
							</small></p>
						</div>
					
				</blockquote>   
				
		</div>
	</div>	<!-- end requestForInfo -->	
</div> <!-- end allRequest-->
<div class="pagination pull-right" ng-if="items.length>0" ng-cloak>
        <ul >
          <li ng-class="prevPageDisabled()">
            <a href ng-click="prevPage()">
            	« <liferay-ui:message key="prev" />
            </a>
          </li>
          <li ng-class="nextPageDisabled()">
            <a href ng-click="nextPage()">
            	<liferay-ui:message key="next" /> »
            </a>
          </li>
        </ul>
</div>

					