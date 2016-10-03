<%@page import="com.nyu.model.LessonObjectives"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="com.liferay.util.portlet.PortletProps"%>
<script type="text/javascript"
	src = "<%=request.getContextPath()%>/js/angular/lessonSection.js"></script>
<portlet:resourceURL var="uuidURL" id="generateDocUUID">
</portlet:resourceURL>

<portlet:resourceURL var="SaveLessonSections" id="SaveLessonSections">
	<portlet:param name="update" value="edit" />
	<portlet:param name="fromPreviewEdit" value ="yes" />
</portlet:resourceURL>

<portlet:renderURL var="previewAdvanceLesson" >
	<portlet:param name="action" value="viewAdvanceLesson" />
	<portlet:param name="lessonId" value='<%=request.getParameter("lessonId") %>' />
	<portlet:param name="basicLesson" value='<%=GetterUtil.getString(request.getAttribute(Constant.BASIC_LESSON),Constant.NO_BASIC_LESSON)%>' />
</portlet:renderURL>

<portlet:renderURL var="createAdvanceLessonURL" >
	<portlet:param name="action" value="createAdvanceLesson" />
	<portlet:param name="fromPreviewEdit" value='yes' />
	<portlet:param name="lessonId" value='<%=request.getParameter("lessonId") %>' />
	<portlet:param name="basicLesson" value='<%=GetterUtil.getString(request.getAttribute(Constant.BASIC_LESSON),Constant.NO_BASIC_LESSON)%>' />
</portlet:renderURL>

<c:set var="fromPreviewEdit" value="yes" />
<c:set var="previewLessonUrl" value="<%=previewAdvanceLesson%>" />
<c:set var="createAdvanceLessonURL" value="<%=createAdvanceLessonURL%>" />
<c:set var="shadowClass" value="shadow" />

<% 
Lesson lesson = null;
long requestId = 0;
List<LessonObjectives> lessonObjectives = null;
int objectiveCount = 1;
if(request.getAttribute(Constant.LESSON)!=null){
	lesson = (Lesson)request.getAttribute(Constant.LESSON);
	lessonObjectives = (List<LessonObjectives>)request.getAttribute(Constant.LESSON_OBJECTIVES);
	objectiveCount = lessonObjectives.size();
	requestId = lesson.getRequestLessonId();
}
String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),layout.isPrivateLayout(),themeDisplay);
String homeUrl=siteFriendlyUrl+Constant.PAGE_HOME;
%>
<div id="lesson-section-content" style="display:none" ng-controller = "lessonSectionController">
	<%@ include file="/WEB-INF/jsp/nyu-lessons/lessonSectionTemplate.jsp" %>
</div>

<div id="createLesson" class="row">
	<!-- progressbar -->
	<ul id="progressbar">
		<li class="active"><liferay-ui:message key="start" /></li>
		<li class="active"><liferay-ui:message key="overview" /></li>
		<li class="active"><liferay-ui:message key="content" /></li>
		<li><liferay-ui:message key="preview-and-save" /></li>
	</ul>
	<%@ include file="editContentSection.jsp" %>
	<%@ include file="/WEB-INF/jsp/nyu-lessons/media.jsp" %>
 </div> <!--  end createLesson  --> 
<script>

var fromPreviewEdit = 'yes';
// ONLOAD PAGE SECTION TEMPLATE
var AllJsonNyuLessonObjectives=<%=request.getAttribute(Constant.JSON_VENDOR_LESSON_OBJECTIVES)%>; 
$(function(){
	var content = $('#lesson-section-content');
	var scope = angular.element(content).scope();
    scope.nyuLessonObjectives = JSON.parse(AllJsonNyuLessonObjectives.jsonNyuLessonObjectives);
	scope.$apply(function() {
   	});
});
</script>

<%@ include file="commonScript.jsp" %>