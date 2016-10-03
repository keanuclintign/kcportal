<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="javax.portlet.ResourceURL"%>
<%@page import="com.liferay.portal.kernel.json.JSONFactoryUtil"%>
<%@page import="com.liferay.portlet.asset.model.AssetTag"%>
<%@page import="com.liferay.portlet.asset.service.AssetTagLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

<%
List<AssetTag> tags = null;
tags = AssetTagLocalServiceUtil.getGroupTags(themeDisplay.getScopeGroupId());
String tagsArray = StringEscapeUtils.escapeJavaScript(JSONFactoryUtil.looseSerialize(tags));
request.setAttribute(Constant.COMMON_STRING_CONSTANT_TAGS, tags);
%>
<liferay-portlet:resourceURL id="addAssetTag" portletName="<%=Constant.PORTLET_CREATE_LESSON%>" var="addTagUrl"></liferay-portlet:resourceURL> 
<div id="<portlet:namespace/>tagsDisplayContent" class="hidden">
<ul class="unstyled scroll-overFlow" style="max-height: 185px;">
	<c:forEach items="${tags}" var="tag">
		<li>	
			<input type="checkbox" class="tagsIsSelected <portlet:namespace/>tag-${tag.tagId}" name="${tag.name}" value="${tag.tagId}"/>${tag.name}
		</li>
	</c:forEach>
</ul>
</div>
<div id="<portlet:namespace/>addTagDisplayContent" class="hidden">
	<div style='padding:10px 0;display:none' class='addTagContent pull-left'>
		<p>
			<input class='addTagText add-tag-input' name='test'/>
			<span class='addNewTagBtn btn'  onclick='<portlet:namespace/>saveNewTag(this)'><liferay-ui:message key="save" /></span>
		</p>	
	</div>
	<div style='padding:10px 0' class='addTagMessage pull-left'>
		<p class="tag-added-success-msg alert alert-success text-center" style="display:none"><liferay-ui:message key="new-tag-added-and-Selected" />.</p>
		<p class="tag-exist-msg alert alert-warning text-center" style="display:none"><liferay-ui:message key="already-exist-and-selected" />.</p>
	</div>
</div>

<div id="<portlet:namespace/>tagsContent"></div>

<script>
YUI().use(
		  'aui-modal',
		  function(Y) {
		    var modal = new Y.Modal(
		      {
		        bodyContent: $('#<portlet:namespace/>tagsDisplayContent').html(),
		        centered: true,
		        headerContent: '<h3><strong><liferay-ui:message key="tags" /></strong></h3>',
		        modal: true,
		        render: '#<portlet:namespace/>tagsContent',
		        resizable:false,
		        width: 350, 
		        visible: false
		      }
		    ).render();
		    modal.addToolbar(
		      [
		       {
		          label: '<liferay-ui:message key="add-new-tag" />',
		          on: {
		            click: function() {
		              $("#<portlet:namespace/>tagsContent .modal-footer .addTagContent").toggle();
		              <portlet:namespace/>bindTagData();
		            }
		          }
		        },
				{
			    label: '<liferay-ui:message key="ok" />',
			    on: {
			      click: function() {
			    	  var selectedTagItems = '';
			    	  var selectedTagNames = '';
			    	  $('#<portlet:namespace/>tagsContent .tagsIsSelected').each(function(i){
			        	  if($(this).is(':checked')){
			        		  selectedTagItems = selectedTagItems + "<li class='textboxlistentry'>"+$(this).attr('name')+"</li>";
			        		  if(selectedTagNames == ''){
			        			  selectedTagNames = $(this).attr('name');
			        		  }else{
			        			  selectedTagNames = selectedTagNames+','+$(this).attr('name');
			        		  }
			        	  }
			          });
			    	  $("#<portlet:namespace/>tagsItems").html(selectedTagItems);
			    	  $("#<portlet:namespace/>tagsSelectedNames").val(selectedTagNames);
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
		    Y.one('#<portlet:namespace/>tagsSelector').on(
		         'click',
	  		  function() {
		         var selectedTagItems = '';
	        	 var selectedNames = $("#<portlet:namespace/>tagsSelectedNames").val();
	        	 var tagNames =selectedNames.split(",");
	        	 $('#<portlet:namespace/>tagsContent .tagsIsSelected').each(function(i){
	        		$(this)[0].checked = false;
		        	if(tagNames.indexOf($(this).attr('name')) > -1){
		        		$(this)[0].checked = true;
		        		selectedTagItems = selectedTagItems + "<li class='textboxlistentry <portlet:namespace/>tag-"+$(this).val()+"'>"+$(this).attr('name')+"&nbsp;<i onclick='<portlet:namespace/>removeTagSelection("+$(this).val()+")' style='color:#d21212;cursor:pointer' class='icon icon-remove'></i></li>";
		        	}  
		         });
		       modal.show();
		       $("#<portlet:namespace/>tagsContent .modal-header ul").remove();
		       $("#<portlet:namespace/>tagsContent .modal-header").append('<ul class="textboxlistentry-holder clearfix ny-you-category unstyled">'+selectedTagItems+'</ul>');
		       <portlet:namespace/>dynamicTagHeader();
		       $("#<portlet:namespace/>tagsContent .modal-footer .addTagContent,#<portlet:namespace/>tagsContent .modal-footer .addTagMessage").remove();
		       $("#<portlet:namespace/>tagsContent .modal-footer").append($("#<portlet:namespace/>addTagDisplayContent").html());
		       $("#<portlet:namespace/>tagsContent .modal-footer button").first().addClass( "pull-left" );
		     }
		   );
		  }
		);
$(function(){
	var existingItems='${tagNames}';
	if(existingItems.length > 0){
		$("#<portlet:namespace/>tagsItems").html("<li class='<portlet:namespace/>remove-loading-icon' style='color:#57068c'><img src='${renderRequest.getContextPath()}/images/nyuloading.gif' width='18px'> Loading...</li>");
	}
	
	var selectedTagItems = '';
	var selectedNames = $("#<portlet:namespace/>tagsSelectedNames").val();
	var tagNames =selectedNames.split(",");
	var tagJSONarray = JSON.parse("<%= tagsArray%>");
	$.each(tagJSONarray, function(key, value) {
		if(tagNames.indexOf(""+value.name+"") > -1){
			
			selectedTagItems = selectedTagItems + "<li class='textboxlistentry'>"+value.name+"</li>";
		}
	});
	$("#<portlet:namespace/>tagsItems").empty();
	$("#<portlet:namespace/>tagsItems").html(selectedTagItems);
});

function <portlet:namespace/>saveNewTag(id){
	var curValue = $(id).parent().find('.addTagText').val();
	if(curValue.trim()==''){
		$("#<portlet:namespace/>tagsContent .tag-exist-msg").html("<liferay-ui:message key='please-enter-text'/>").show().delay( 2000 ).fadeOut(800);
		return false;
	}
	if(curValue.trim().length > 75){
		$("#<portlet:namespace/>tagsContent .tag-exist-msg").html("<liferay-ui:message key='maximum-75-characters-allowed' />").show().delay( 2000 ).fadeOut(800);
		return false;
	}
	if(/^[a-zA-Z0-9- .!]*$/.test(curValue.trim()) == false) {
		$("#<portlet:namespace/>tagsContent .tag-exist-msg").html("<liferay-ui:message key='x-contains-unsupported-characters' arguments='Tag name' />").show().delay( 2000 ).fadeOut(800);
		return false;
	}
	
	var isNewTag = true;
	$('#<portlet:namespace/>tagsContent .tagsIsSelected').each(function(i){
 		if(curValue == $(this).attr('name')){
 			$(this)[0].checked = true;
 			isNewTag = false;
 		}  
    });
	if(isNewTag){
		$.ajax({
	        url:'<%=addTagUrl%>',
	        type: 'GET',
	        async: false,
	        data:{
	        	_nyulessons_WAR_nyyouportlet_tagName: curValue,
	        },
	        success: function(data){
	        	$('#<portlet:namespace/>tagsContent .modal-body ul').prepend("<li><input type='checkbox' checked='true' class='tagsIsSelected <portlet:namespace/>tag-"+data+"' name='"+curValue+"' value='"+data+"'/>"+curValue+"</li>");
	        	$(id).parent().find('.addTagText').val('');
	        	var selectedTagItems ='';
	        		$('#<portlet:namespace/>tagsContent .tagsIsSelected').each(function(i){
	        	  	  if($(this).is(':checked')){
	        	  		  selectedTagItems = selectedTagItems + "<li class='textboxlistentry <portlet:namespace/>tag-"+$(this).val()+"'>"+$(this).attr('name')+"&nbsp;<i onclick='<portlet:namespace/>removeTagSelection("+$(this).val()+")' style='color:#d21212;cursor:pointer' class='icon icon-remove'></i></li>";
	        	  	  }
	        	    });
	        		$("#<portlet:namespace/>tagsContent .modal-header ul").remove();
	        	    $("#<portlet:namespace/>tagsContent .modal-header").append('<ul class="textboxlistentry-holder clearfix ny-you-category unstyled">'+selectedTagItems+'</ul>');
	        	    <portlet:namespace/>dynamicTagHeader();
	        	$('#<portlet:namespace/>tagsContent .modal-body').animate({scrollTop:0},"fast")
	        	$("#<portlet:namespace/>tagsContent .tag-added-success-msg").show().delay( 2000 ).fadeOut(800);
	        	$("#<portlet:namespace/>tagsContent .modal-footer .addTagContent").hide();
	        	
	     	}
	    });
	}else{
    	$(id).parent().find('.addTagText').val('');
    	var selectedTagItems ='';
 		$('#<portlet:namespace/>tagsContent .tagsIsSelected').each(function(i){
 	  	  if($(this).is(':checked')){
 	  		  selectedTagItems = selectedTagItems + "<li class='textboxlistentry <portlet:namespace/>tag-"+$(this).val()+"'>"+$(this).attr('name')+"&nbsp;<i onclick='<portlet:namespace/>removeTagSelection("+$(this).val()+")' style='color:#d21212;cursor:pointer' class='icon icon-remove'></i></li>";
 	  	  }
 	    });
 		$("#<portlet:namespace/>tagsContent .modal-header ul").remove();
 	    $("#<portlet:namespace/>tagsContent .modal-header").append('<ul class="textboxlistentry-holder clearfix ny-you-category unstyled">'+selectedTagItems+'</ul>');
 	  	<portlet:namespace/>dynamicTagHeader();
    	$("#<portlet:namespace/>tagsContent .tag-exist-msg").html("<liferay-ui:message key='already-exist-and-selected'/>.").show().delay( 2000 ).fadeOut(800);
    	$("#<portlet:namespace/>tagsContent .modal-footer .addTagContent").hide();
	}	
}

function <portlet:namespace/>bindTagData(){
var tagsArray = JSON.parse("<%=tagsArray%>");
AUI().use('autocomplete-list','aui-base','aui-io-request','autocomplete-filters','autocomplete-highlighters',function (A) {
        	 var autoComplete = new A.AutoCompleteList(

        			 {

        			 allowBrowserAutocomplete: 'true',
        			 
        			 inputNode: '#<portlet:namespace/>tagsContent .addTagText',

        			 resultTextLocator: 'name',

        			 render: 'true',

        			 resultHighlighter: 'phraseMatch',

        			 resultFilters:['phraseMatch'],
   		
        			 source:tagsArray,

        			 });


	        		 autoComplete.on('select', function(e)  {
	        			 var yes=false;
	        			 $('#<portlet:namespace/>tagsContent .tagsIsSelected').each(function(i){
	     	        		if(e.result.raw.name == $(this).attr('name')){
	     		        		$(this)[0].checked = true;
	     		        		var selectedTagItems ='';
	     		        		$('#<portlet:namespace/>tagsContent .tagsIsSelected').each(function(i){
	     		        	  	  if($(this).is(':checked')){
	     		        	  		  selectedTagItems = selectedTagItems + "<li class='textboxlistentry <portlet:namespace/>tag-"+$(this).val()+"'>"+$(this).attr('name')+"&nbsp;<i onclick='<portlet:namespace/>removeTagSelection("+$(this).val()+")' style='color:#d21212;cursor:pointer' class='icon icon-remove'></i></li>"
	     		        	  	  }
	     		        	    });
	     		        		$("#<portlet:namespace/>tagsContent .modal-header ul").remove();
	     		        	    $("#<portlet:namespace/>tagsContent .modal-header").append('<ul class="textboxlistentry-holder clearfix ny-you-category unstyled">'+selectedTagItems+'</ul>');
	     		        	   	<portlet:namespace/>dynamicTagHeader();
	     		        	    $('#<portlet:namespace/>tagsContent .addTagText').val('');
	     		           		$("#<portlet:namespace/>tagsContent .tag-exist-msg").show().delay( 2000 ).fadeOut(800);
	     		           		$("#<portlet:namespace/>tagsContent .modal-footer .addTagContent").hide();
	     	        		}  
	     		         });
        			 });
});
}

$("body").on("change", "#<portlet:namespace/>tagsContent .tagsIsSelected", function(e){
	var selectedTagItems ='';
	$('#<portlet:namespace/>tagsContent .tagsIsSelected').each(function(i){
  	  if($(this).is(':checked')){
  		  selectedTagItems = selectedTagItems + "<li class='textboxlistentry <portlet:namespace/>tag-"+$(this).val()+"'>"+$(this).attr('name')+"&nbsp;<i onclick='<portlet:namespace/>removeTagSelection("+$(this).val()+")' style='color:#d21212;cursor:pointer' class='icon icon-remove'></i></li>";
  	  }
    });
	$("#<portlet:namespace/>tagsContent .modal-header ul").remove();
    $("#<portlet:namespace/>tagsContent .modal-header").append('<ul class="textboxlistentry-holder clearfix ny-you-category unstyled">'+selectedTagItems+'</ul>');
    <portlet:namespace/>dynamicTagHeader();
});

function <portlet:namespace/>dynamicTagHeader(){
	var existingTags = $("#<portlet:namespace/>tagsContent .modal-header ul li").length;
    if(existingTags > 0){
    	$("#<portlet:namespace/>tagsContent .modal-header h3").html("<strong><liferay-ui:message key='existing-tags' /></strong>");
    }else{
    	$("#<portlet:namespace/>tagsContent .modal-header h3").html("<strong><liferay-ui:message key='tags' /></strong>");
    }
}

function <portlet:namespace/>removeTagSelection(id){
	var tagId = '.<portlet:namespace/>tag-'+id;
	$("#<portlet:namespace/>tagsContent .modal-header ul "+tagId).remove();
	$("#<portlet:namespace/>tagsContent .tagsIsSelected"+tagId)[0].checked = false;
	<portlet:namespace/>dynamicTagHeader();
}
</script>