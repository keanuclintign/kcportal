
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="javax.portlet.PortletSession"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>			<%--	added by asif 	 --%>
	
<% 
String userGroupId=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID);
PortletURL backURL = PortletURLFactoryUtil.create(request, Constant.PORTLET_GROUP, themeDisplay.getPlid(), PortletRequest.RENDER_PHASE);
backURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.LESSON_URL);
backURL.setWindowState(LiferayWindowState.MAXIMIZED);
backURL.setParameter(Constant.COMMON_STRING_CONSTANT_USER_GROUP_ID,userGroupId);
%>

<portlet:renderURL var="createAdvanceLessonURL">
	<portlet:param name="action" value="createAdvanceLesson" />
	<portlet:param name="collaborationRequestId"
		value='<%=request.getAttribute(Constant.COLLABORATION_REQUEST_ID)!=null ? request.getAttribute(Constant.COLLABORATION_REQUEST_ID).toString() : null %>' />
	<c:if test="${not empty userGroupId}">
		<portlet:param name="userGroupId" value="${userGroupId}"/>
	</c:if>
</portlet:renderURL>

<%-- <portlet:renderURL var="createBasicLessonURL" >
	<portlet:param name="action" value="createBasicLesson" />
</portlet:renderURL> --%>

<portlet:actionURL var="createBasicLessonURL">
	<portlet:param name="action" value="createBasicLesson" />
	<portlet:param name="collaborationRequestId"
		value='<%=request.getAttribute(Constant.COLLABORATION_REQUEST_ID)!=null ? request.getAttribute(Constant.COLLABORATION_REQUEST_ID).toString() : null %>' />
	<c:if test="${not empty userGroupId}">
		<portlet:param name="userGroupId" value="${userGroupId}"/>
	</c:if>
</portlet:actionURL>



<div id="createLesson" class="row">
	<!-- progressbar -->
	<ul id="progressbar">
		<li class="active"><liferay-ui:message key="start" /></li>
		<li><liferay-ui:message key="overview" /></li>
		<li><liferay-ui:message key="content" /></li>
		<li><liferay-ui:message key="preview-and-save" /></li>
	</ul>
	<!-- content divs -->
	<div class="progress-content">
		<div class="shadow lesson-start">
			<h1><liferay-ui:message key="what-do-you-want-to-create" />?</h1>
			<ul>
				<li id="basicLesson"><a	href='javascript:void(0)' onClick="goToLessonType('<%=createBasicLessonURL.toString() %>')" class="row-fluid">
						<span class="span4"> <i class="icon-file"> </i> <span>
								<liferay-ui:message key="basic-lesson" /> </span>
					</span> <span class="span8">1. <liferay-ui:message key="describe-the-lesson" /><BR> 
					2. <liferay-ui:message key="add-content" /><BR> 
					3. <liferay-ui:message key="save-drafts-to-my-stuff-and-or-Publish" />
					</span>
				</a></li>
			<li id="basicLesson"><a	 href='javascript:void(0)' onClick="goToLessonType('<%=createAdvanceLessonURL.toString() %>')" class="row-fluid">
						<span class="span4"> <i class="icon-book"> </i> <span>
								<liferay-ui:message key="advanced-lesson" /> </span>
					</span> <span class="span8">1. <liferay-ui:message key="describe-the-lesson" /><BR> 
					2. <liferay-ui:message key="add-content-and-organize-into-sections" /><BR> 
					3. <liferay-ui:message key="save-drafts-to-my-stuff-and-or-Publish" />
					</span>
				</a></li>
				<%-- <li id="advancedLesson">			
					<a '<%=createAdvanceLessonURL.toString() %>' class="row-fluid"> 
						<span class="span4">
							<i class="icon-book"></i> 
							<span> Advanced Lesson </span>
						</span>
						<span class="span8"> 1. Describe the lesson<BR>
						2. Add Content and Organise into Sections <BR> 
						3. Save Drafts to My Stuff and/or Publish </span>
					</a>
				</li>  --%>
				<li id="newCourse" class="nyu-tooltip" title='<liferay-ui:message key="work-in-progess" />'>
					<div class="row-fluid"
						style="border: 1px dashed #999999; box-sizing: border-box; color: #999999; display: block; margin: 0 0 20px; padding: 15px 20px; text-align: left;">
						<span class="span4"> <i class="icon-stop"></i> <span>
								<liferay-ui:message key="build-a-track" /> </span>
						</span> <span class="span8"> 1. <liferay-ui:message key="combine-lessons-together-into-a-track" /><BR> 
						2. <liferay-ui:message key="add-quizzes-and-analytics" /><BR> 
						3. <liferay-ui:message key="share-with-the-x-community" arguments="<%=Constant.CURRENT_BRAND_NAME%>" />
						</span>
					</div> <!-- <a href="#" class="row-fluid"> 
						<span class="span4">
							<i class="icon-stop"></i>
							<span> Build a Track </span>
						</span>
						<span class="span8"> Combine lessons together into a track<BR>
						Add quizzes and analytics<BR>
						Share with the VENDOR community  </span>
					</a> -->
				</li>
			</ul>
		</div>
		<!-- end  shadow -->
	</div>
	<!-- end span9 offset1 -->
</div>

<c:if test="${not empty userGroupId}">

<div id="lessonModal"></div>
<div id="lessonModelContent">
	<div style="padding: 15px;">
		<p>
			<img src="<%=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.GROUP_CARD_PLACEHOLDER%>">
		</p>
		<label class="radio"> 
				<input type="radio" checked="true" name="publishwith-profile" value="<%=Constant.PUBLISH_WITH_USERPROFILE%>" class="publishProfileType"><liferay-ui:message key="publish-with-user-profile" />
		</label> 
		<label class="radio"> 
				<input type="radio"  name="publishwith-profile"  value="<%=Constant.PUBLISH_WITH_GROUPPROFILE %>" class="publishProfileType"> <liferay-ui:message key="publish-with-group-profile" />
		</label>
	</div>
</div>

</c:if>



<script> 
var publishWithProfile;
$(document).ready(function() {
		
		var userGroupId='${userGroupId}';
		if(userGroupId>0){
        YUI().use('aui-modal', function(Y) {
	           var modal = new Y.Modal(
	             {
	                  contentBox: '#lessonModelContent',
	                  centered: true,
	                  destroyOnHide: false,
	                  headerContent: '<h3> <liferay-ui:message key="x-private-group" arguments="<%=Constant.CURRENT_BRAND_NAME%>" /> </h3>',
	                  modal: true,
	                  zIndex: 999,
	                  render: '#lessonModal', 
	                  visible: true,
	                  width: 350
	             }
	           ).render();  
	           modal.addToolbar([
	              {
	                label: '<liferay-ui:message key="cancel" />',
	                on: {
	                      click: function() {
	                        modal.hide();  
	                    	window.location.href="<%=backURL%>";
	                      }
	                }
	              },
	              {
	                label: '<liferay-ui:message key="ok" />',
	                on: {
	                      click: function() {
	                    	  publishWithProfile=$(".publishProfileType:checked").val(); 
	                    	  modal.hide();  
	                     }
	                }
	              }
	           ]); 
        });
		}
     	
});

function goToLessonType(lessonTypeURL){
	window.location.href=lessonTypeURL+"&_nyulessons_WAR_nyyouportlet_publishWithProfile="+publishWithProfile;
}

</script>

