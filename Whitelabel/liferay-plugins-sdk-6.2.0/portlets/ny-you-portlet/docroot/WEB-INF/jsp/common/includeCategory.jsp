
	
<%@page import="com.nyu.util.Constant"%>
<div class="control-group" style="position: relative;">
	<label class="control-label" for="thumbnail"> <liferay-ui:message key="categories" />
	<a class="nyu-tooltip" href="#" title='<liferay-ui:message key="you-can-choose-from-the-list" />'>
	<img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></a>
	</label>
	<div class="tagselector-content ny-you-category-wrapper">
		<aui:input  type="hidden" id="categoriesSelectedIds" name="categoriesSelectedIds" value="${categoryIds}"/> 
		<ul id="<portlet:namespace/>categoriesItems" class="textboxlistentry-holder clearfix ny-you-category unstyled">
		</ul>
	</div>
	<span id="<portlet:namespace/>categoriesSelector" class="btn"><i class="icon-search"></i><liferay-ui:message key="select" /></span>
</div> 