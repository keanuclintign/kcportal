<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>		<%--	added by asif 	 --%>

<%@page import="com.nyu.util.Constant"%>
<%@page import="com.liferay.portlet.asset.service.AssetTagLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.model.AssetTag"%>
<%@page import="com.liferay.portlet.asset.model.AssetVocabulary"%>
<%@page import="com.liferay.portlet.asset.model.AssetCategory"%>
<%@page import="java.util.Set"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.nyu.model.Lesson"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<script src='<%=themeDisplay.getPathThemeJavaScript()%>/jquery/jquery-1.11.0.min.js' type="text/javascript"></script> 
<portlet:actionURL var="processAddLessonUrl" name="processAddLesson">
	<portlet:param name="action" value="processAddLessonToGroup" />
	<portlet:param name="userGroupId" value="${userGroupId}" />
	<portlet:param name="tagId" value="${tagId}" />
	<portlet:param name="categoryId" value="${categoryId}" />
</portlet:actionURL>

<portlet:renderURL var="categoryAddLessons" windowState="pop_up">
	<portlet:param name="action" value="categoryAddLessons"/>
	<portlet:param name="userGroupId" value="${userGroupId}"/>
	<portlet:param name="categoryId" value="*categoryId*"/>
</portlet:renderURL>
<portlet:renderURL var="tagAddLessons" windowState="pop_up">
	<portlet:param name="action" value="tagAddLessons"/>
	<portlet:param name="userGroupId" value="${userGroupId}"/>
	<portlet:param name="tagId" value="*tagId*"/>
</portlet:renderURL>


<%
List<AssetCategory> categories = null;
	List<AssetVocabulary> vocabularies = null;
	List<AssetTag> tags=null;
	vocabularies = AssetVocabularyLocalServiceUtil.getGroupVocabularies(scopeGroupId, Constant.SITE_NAME, 0, 1, null);
	if(vocabularies!=null && vocabularies.size()>0){
		categories = AssetCategoryLocalServiceUtil.getVocabularyRootCategories(vocabularies.get(0).getVocabularyId(), 0, vocabularies.get(0).getCategories().size(), null);
		tags=AssetTagLocalServiceUtil.getGroupTags(scopeGroupId);
	}%>
<div style="padding:15px;">		
<div class="filter-form span6">
	<div class="span3">
		<label class="pull-left" for="Category"> <liferay-ui:message key="category" /> </label>
		<select  id="latestcatDDId" onchange="filterByCategory(this.value,'<%=categoryAddLessons %>');">
			<option value="0"><liferay-ui:message key="all" /></option>
				<%	
					if(categories!=null && categories.size() > 0){
					    for(AssetCategory category : categories){ 
				%>    	
					<option value='<%=category.getCategoryId()%>'><%=category.getName().length() > 25? category.getName().substring(0, 25)+Constant.COMMON_STRING_CONSTANT_THREE_DOTS:category.getName()%></option>
			   <%	}
				  }	%>
		</select>
	</div>
	<div class="span3">
		<label class="pull-left" for="Tag"><liferay-ui:message key="tag" /></label>
		<select id="latestTagDDId"  onchange="filterByTags(this.value,'<%=tagAddLessons%>');">
			<option value="0"><liferay-ui:message key="all" /></option>
				<%if(tags.size() > 0){
				    for(AssetTag tag : tags){ 
				%>      	
					<option value='<%=tag.getTagId()%>'><%=tag.getName().length() > 25? tag.getName().substring(0, 25)+Constant.COMMON_STRING_CONSTANT_THREE_DOTS:tag.getName()%></option>
			   <%	}
				  }	%>
		</select>	
	</div>
</div>
<%
List<Lesson> authorLessons=(List<Lesson>)request.getAttribute("authorLessons");
Set<Long> userGroupLessonsIds=(Set<Long>)request.getAttribute("userGroupLessonsIds");
long classNameId=ClassNameLocalServiceUtil.getClassNameId(Lesson.class.getName());
if(authorLessons!=null && authorLessons.size()>0){%>
	<aui:form action="<%=processAddLessonUrl%>">
	<div style="overflow-x:hidden;overflow-y:auto;;max-height:250px" id="groupRelatedLessons">
	<ul id="groupLessons">
<%for(Lesson lesson:authorLessons){
	String documentPath = CommonUtil.getDocumentPath(lesson.getLessonId(),classNameId,themeDisplay);
	if(documentPath==null || documentPath.equals(""))
		documentPath=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER ;
%>
		<li>
			<span>
				<aui:input type="checkbox" checked="<%=userGroupLessonsIds.contains(lesson.getLessonId())%>" label="" value="<%=lesson.getLessonId()%>" name="lessonIds"/>
			</span>
			<span>
				<img src="<%=documentPath%>" width="100px" height="100px">
			</span>
			<span>
				<%=lesson.getLessonName()%>
			</span>
		</li>
	
<%}%>
</ul>
</div>
<div class="clearfix" style="margin-top: 10%;"> 
	<aui:button type="submit" disabled="<%=authorLessons.size()>0?false:true%>" value="ok" style="width: 49%;" cssClass="pull-left"/>
	<aui:button type="button" onclick="closeAddlesson()" value="cancel" style="width: 49%;" cssClass="pull-right" />
</div>
</aui:form>

<%}else{%>
		<b><liferay-ui:message key="no-lessons-found" />.</b>
<%} %>
</div>
<script>
function closeAddlesson(withSuccessMsg)
{
 Liferay.Util.getOpener().<portlet:namespace />closeAddLessonPopup('AddLessons',withSuccessMsg);
}

$(window).load(function(){
	$('.tabbable-content').hide();
});



function filterByCategory(catId,catUrl){
	var url=catUrl.replace('*categoryId*',catId);
	window.location.href=url;
}



function filterByTags(tagId,tagUrl){
	var url=tagUrl.replace('*tagId*',tagId);
	window.location.href=url;
}

$(function(){
	var tagId='<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_TAG_ID)==null?Constant.COMMON_STRING_ZERO:(String)request.getAttribute(Constant.COMMON_STRING_CONSTANT_TAG_ID)%>';
	var categoryId='<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_CATEGORY_ID)==null?Constant.COMMON_STRING_ZERO:(String)request.getAttribute(Constant.COMMON_STRING_CONSTANT_CATEGORY_ID)%>';
	if(tagId>0){
		$("#latestTagDDId").val(tagId);
	}
	if(categoryId>0){
		$("#latestcatDDId").val(categoryId);
	}
});

window.onLoad=(function(){
	var closePopup = '${closePopup}';
	if(closePopup=='true'){
		closeAddlesson('yes');
	}
})();
</script>
