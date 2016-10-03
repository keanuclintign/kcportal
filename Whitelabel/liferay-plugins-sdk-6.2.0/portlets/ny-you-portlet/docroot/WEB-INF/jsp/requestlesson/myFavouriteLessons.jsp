<%@page import="com.liferay.portlet.asset.service.AssetTagLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@page import="com.nyu.util.Constant"%>
<%@page import="com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.model.AssetTag"%>
<%@page import="com.liferay.portlet.asset.model.AssetVocabulary"%>
<%@page import="com.liferay.portlet.asset.model.AssetCategory"%>
<%@page import="java.util.Set"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.nyu.model.Lesson"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>		<%--	added by asif 	 --%>

<script src='<%=themeDisplay.getPathThemeJavaScript()%>/jquery/jquery-1.11.0.min.js' type="text/javascript"></script> 
<portlet:actionURL var="processRequestMyFavLessonUrl" name="processRequestMyFavLesson">
	<portlet:param name="action" value="processAddMyFavLessonToRequest" />
	<portlet:param name="tagId" value="${tagId}" />
	<portlet:param name="categoryId" value="${categoryId}" />
</portlet:actionURL>

<portlet:renderURL var="categoryAddMyFavLessons" windowState="pop_up">
	<portlet:param name="action" value="categoryAddMyFavLessons"/>
	<portlet:param name="categoryId" value="*categoryId*"/>
</portlet:renderURL>
<portlet:renderURL var="tagAddMyFavLessons" windowState="pop_up">
	<portlet:param name="action" value="tagAddMyFavLessons"/>
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
<div class="filter-form span6">
	<div class="span3">
		<label class="pull-left" for="Category"> Category </label>
		<select  id="latestcatDDId" onchange="filterByCategory(this.value,'<%=categoryAddMyFavLessons %>');">
			<option value="0"><liferay-ui:message key="all" /></option>
				<%	
					if(categories!=null && categories.size() > 0){
					    for(AssetCategory category : categories){ 
				%>    	
					<option value='<%=category.getCategoryId()%>'><%=category.getName() %></option>
			   <%	}
				  }	%>
		</select>
	</div>
	<div class="span3">
		<label class="pull-left" for="Tag"> 
			<liferay-ui:message key="tag" />  
		</label>
		<select id="latestTagDDId"  onchange="filterByTags(this.value,'<%=tagAddMyFavLessons%>');">
			<option value="0"><liferay-ui:message key="all" /></option>
				<%if(tags.size() > 0){
				    for(AssetTag tag : tags){ 
				%>      	
					<option value='<%=tag.getTagId()%>'><%=tag.getName()%></option>
			   <%	}
				  }	%>
		</select>	
	</div>
</div>
<%
	List<Lesson> allLessons=(List<Lesson>)request.getAttribute("allLessons");
	long classNameId=ClassNameLocalServiceUtil.getClassNameId(Lesson.class.getName());
	if(allLessons!=null && allLessons.size()>0){
%>
<%-- <aui:form action="<%=processFeaturedLessonUrl%>"> --%>
<div style="overflow-x:hidden;overflow-y:auto;;max-height:250px">
<ul id="groupLessons">
<%
for(Lesson lesson:allLessons){
	String documentPath = CommonUtil.getDocumentPath(lesson.getLessonId(),classNameId,themeDisplay);
	if(documentPath==null || documentPath.equals(""))
		documentPath=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.LESSON_CARD_PLACEHOLDER ;
%>
	
		<li>
			<span>
				<aui:input type="checkbox" label="" value="<%=lesson.getLessonId()%>" name="lessonIds"/>
			</span>
			<span>
				<img src="<%=documentPath%>" width="100px" height="100px">
			</span>
			<span>
				<%=lesson.getLessonName()%>
			</span>
		</li>
	
<%} %>
	
</ul>
</div>
<div class="clearfix" style="margin-top: 10%;"> 
	<aui:button type="submit" onclick="addMyFavouritelesson()" value="add-remove" style="width: 49%;" cssClass="pull-left"/>
	<aui:button type="button" onclick="closeAddlesson()" value="small-close" style="width: 49%;" cssClass="pull-right" />
</div>
<%-- </aui:form> --%>

<%}else{%>
		<b><liferay-ui:message key="no-lessons-found" />.</b>
<%} %>
<script>
function closeAddlesson()
{
 Liferay.Util.getOpener().<portlet:namespace />closeAddLessonPopup('AddLessons');
}

function addMyFavouritelesson(){
	alert('<liferay-ui:message key="inside-addmyfavouritelesson" />' );
	 var val = [];
     $(':checkbox:checked').each(function(i){
       val[i] = $(this).val();
     });
	alert(val);
	Liferay.Util.getOpener().<portlet:namespace/>myFavouriteLessonIds(val);
}

$(window).load(function(){
	$('.tabbable-content').hide();
	var tagId='<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_TAG_ID)==null?Constant.COMMON_STRING_ZERO:(String)request.getAttribute(Constant.COMMON_STRING_CONSTANT_TAG_ID)%>';
	var categoryId='<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_CATEGORY_ID)==null?Constant.COMMON_STRING_ZERO:(String)request.getAttribute(Constant.COMMON_STRING_CONSTANT_CATEGORY_ID)%>';
	if(tagId>0){
		$("#latestTagDDId").val(tagId);
	}
	if(categoryId>0){
		$("#latestcatDDId").val(categoryId);
	}
})




function filterByCategory(catId,catUrl){
	var url=catUrl.replace('*categoryId*',catId);
	window.location.href=url;
}



function filterByTags(tagId,tagUrl){
	var url=tagUrl.replace('*tagId*',tagId);
	window.location.href=url;
}


</script>
