<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.liferay.portlet.asset.model.AssetVocabulary"%>
<%@page import="com.liferay.portlet.asset.model.AssetCategory"%>
<%@page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@page import="com.nyu.util.Constant"%>
<%@page import="com.liferay.portlet.asset.service.AssetVocabularyLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

<%
List<AssetCategory> categories = null;
List<AssetVocabulary> vocabularies = null;
vocabularies = AssetVocabularyLocalServiceUtil.getGroupVocabularies(themeDisplay.getScopeGroupId(), Constant.CATEGORY_VOCABULARY, 0, 1, null);
if(vocabularies!=null && vocabularies.size()>0){
	categories = AssetCategoryLocalServiceUtil.getVocabularyRootCategories(vocabularies.get(0).getVocabularyId(), 0, vocabularies.get(0).getCategories().size(), null);
}

String categoryJsonArray = StringEscapeUtils.escapeJavaScript(JSONFactoryUtil.looseSerialize(categories));
request.setAttribute(Constant.COMMON_STRING_CONSTANT_CATEGORIES, categories);
%>
<div id="<portlet:namespace/>categoriesDisplayContent" class="hidden">
<ul class="unstyled scroll-overFlow" style="max-height: 185px;">
	<c:forEach items="${categories}" var="category">
		<li>	
			<c:set var="validateCategoryName" value="${category.name}" scope="page"/>
			<%
				String validateCategoryName = GetterUtil.getString(pageContext.getAttribute("validateCategoryName"),"");
			    validateCategoryName = StringEscapeUtils.escapeHtml(validateCategoryName);
			%>
			<input type="checkbox"  class="categoryIsSelected <portlet:namespace/>cat-${category.categoryId}"  name="<%=validateCategoryName%>" value="${category.categoryId}"/>${category.name}
		</li>
	</c:forEach>
</ul>
</div>

<div id="<portlet:namespace/>categoriesContent"></div>

<script>
YUI().use(
		  'aui-modal',
		  function(Y) {
		    var modal = new Y.Modal(
		      {
		        bodyContent: $('#<portlet:namespace/>categoriesDisplayContent').html(),
		        centered: true,
		        headerContent: '<h3><strong><liferay-ui:message key="categories" /></strong></h3>',
		        modal: true,
		        render: '#<portlet:namespace/>categoriesContent',
		        resizable:false,
		        width: 350,
		        visible: false
		      }
		    ).render();
		    modal.addToolbar(
		      [
				{
			    label: '<liferay-ui:message key="ok" />',
			    on: {
			      click: function() {
			    	  var selectedCateItems = '';
			    	  var selectedCategoryIds = '';
			    	  $('#<portlet:namespace/>categoriesContent .categoryIsSelected').each(function(i){
			        	  if($(this).is(':checked')){
			        		  selectedCateItems = selectedCateItems + "<li class='textboxlistentry'>"+$(this).attr('name')+"</li>";
			        		  if(selectedCategoryIds == ''){
			        			  selectedCategoryIds = $(this).val();
			        		  }else{
			        			  selectedCategoryIds = selectedCategoryIds+','+$(this).val();
			        		  }
			        	  }
			          });
			    	  $("#<portlet:namespace/>categoriesItems").html(selectedCateItems);
			    	  $("#<portlet:namespace/>categoriesSelectedIds").val(selectedCategoryIds);
			    	  modal.hide();
			      }
			    }
			  },
		        {
		          label: '<liferay-ui:message key="cancel" />',
		          on: {
		            click: function() {
		              modal.hide();
		            }
		          }
		        }
		      ]
		    );
		    Y.one('#<portlet:namespace/>categoriesSelector').on(
		         'click',
	  		  function() {
	        	 var selectedIds = $("#<portlet:namespace/>categoriesSelectedIds").val();
	        	 var categoryIds =selectedIds.split(",");
	        	 var selectedCateItems ='';
	        	 $('#<portlet:namespace/>categoriesContent .categoryIsSelected').each(function(i){
	        		$(this)[0].checked = false;
		        	if(categoryIds.indexOf($(this).val()) > -1){
		        		$(this)[0].checked = true;
		        		selectedCateItems = selectedCateItems + "<li class='textboxlistentry <portlet:namespace/>cat-"+$(this).val()+"'>"+$(this).attr('name')+"&nbsp;<i onclick='<portlet:namespace/>removeCatSelection("+$(this).val()+")' style='color:#d21212;cursor:pointer' class='icon icon-remove'></i></li>";
		        	}  
		         });
	        	 $("#<portlet:namespace/>categoriesContent .modal-header ul").remove();
	        	 $("#<portlet:namespace/>categoriesContent .modal-header").append('<ul class="textboxlistentry-holder clearfix ny-you-category unstyled">'+selectedCateItems+'</ul>');
	        	 <portlet:namespace/>dynamicCategoryHeader();
		       modal.show();
		     }
		   );
		  }
		);
$(function(){
	var existingItems='${categoryIds}';
	if(existingItems.length > 0){
		$("#<portlet:namespace/>categoriesItems").html("<li class='<portlet:namespace/>remove-loading-icon' style='color:#57068c'><img src='${renderRequest.getContextPath()}/images/nyuloading.gif' width='18px'> Loading ...</li>");
	}
	var selectedCateItems = '';
	var selectedIds = $("#<portlet:namespace/>categoriesSelectedIds").val();
	var categoryIds =selectedIds.split(",");
	var cataJSONarray = JSON.parse("<%= categoryJsonArray%>");
	
	$.each(cataJSONarray, function(key, value) {
		if(categoryIds.indexOf(""+value.categoryId+"") > -1){
			
			selectedCateItems = selectedCateItems + "<li class='textboxlistentry'>"+value.name+"</li>";
		}
	});
	
	$("#<portlet:namespace/>categoriesItems").empty();
	$("#<portlet:namespace/>categoriesItems").html(selectedCateItems);
});


$("body").on("change", "#<portlet:namespace/>categoriesContent .categoryIsSelected", function(e){
	var selectedCateItems ='';
	$('#<portlet:namespace/>categoriesContent .categoryIsSelected').each(function(i){
  	  if($(this).is(':checked')){
  		  selectedCateItems = selectedCateItems + "<li class='textboxlistentry <portlet:namespace/>cat-"+$(this).val()+"'>"+$(this).attr('name')+"&nbsp;<i onclick='<portlet:namespace/>removeCatSelection("+$(this).val()+")' style='color:#d21212;cursor:pointer' class='icon icon-remove'></i></li>";
  	  }
    });
	$("#<portlet:namespace/>categoriesContent .modal-header ul").remove();
    $("#<portlet:namespace/>categoriesContent .modal-header").append('<ul class="textboxlistentry-holder clearfix ny-you-category unstyled">'+selectedCateItems+'</ul>');
    <portlet:namespace/>dynamicCategoryHeader();
});

function <portlet:namespace/>dynamicCategoryHeader(){
	var existingCategories = $("#<portlet:namespace/>categoriesContent .modal-header ul li").length;
    if(existingCategories > 0){
    	$("#<portlet:namespace/>categoriesContent .modal-header h3").html("<strong><liferay-ui:message key='existing-categories' /></strong>");
    }else{
    	$("#<portlet:namespace/>categoriesContent .modal-header h3").html("<strong><liferay-ui:message key='categories' /></strong>");
    }
}

function <portlet:namespace/>removeCatSelection(id){
	var catId = '.<portlet:namespace/>cat-'+id;
	$("#<portlet:namespace/>categoriesContent .modal-header ul "+catId).remove();
	$("#<portlet:namespace/>categoriesContent .categoryIsSelected"+catId)[0].checked = false;
	<portlet:namespace/>dynamicCategoryHeader();
}
</script>