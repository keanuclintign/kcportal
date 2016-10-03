<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>			<%--		added asif			 --%>

<%@ include file="/WEB-INF/jsp/init.jsp" %>
<portlet:resourceURL var="addBadgeURL" id="addBadgeURL">
</portlet:resourceURL>
<portlet:resourceURL var="manageBadgeURL" id="manageBadgeURL">
</portlet:resourceURL>
 <portlet:resourceURL var="manageCategoriesURL" id="manageCategoriesURL">
</portlet:resourceURL> 
<portlet:resourceURL var="manageTagsURL" id="manageTagsURL">
</portlet:resourceURL> 
<portlet:resourceURL var="manageKeywordsURL" id="manageKeywords"></portlet:resourceURL>
<portlet:resourceURL var="addKeywordURL" id="addKeyword">
</portlet:resourceURL>
<portlet:resourceURL var="deleteKeywordURL" id="deleteKeyword">
</portlet:resourceURL>

<portlet:resourceURL var="userAcceptanceOfTOUUrl" id="userAcceptanceOfTOU"/>

<portlet:resourceURL var="documentStatusUrl" id="document_status"/>

<portlet:resourceURL var="emailDigestUrl" id="emailDigest"/>

<portlet:resourceURL var="emailDigestProcessUrl" id="emailDigestProcess"/>

<%if(GetterUtil.getBoolean(request.getAttribute("hasPermission"),false)){%>
<div class="container">
	<div id="myStuff" class="clearfix my-configuration">
		<div class="span3">
			<div class="left-section">
				<ul id="userMenu">
				<c:if test="<%=Constant.IS_BADGES_REQUIRE%>">
					<li> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyBadges.png"> <a id="<portlet:namespace/>manageBadges" href="javascript:void(0)"> <liferay-ui:message key="manage-badges" /> </a> </li>
				</c:if>	
					<li> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyGroups.png"> <a id="<portlet:namespace/>manageKeywords" href="javascript:void(0)"> <liferay-ui:message key="manage-group-names" /> </a> </li>
					<li> <i class="icon-th-list" style="font-size: 24px;"> </i>  <a id="<portlet:namespace/>manageCategories" href="javascript:void(0)"> <liferay-ui:message key="manage-categories" /> </a> </li>
					<li> <i class="icon-tags" style="font-size: 24px;"> </i> <a id="<portlet:namespace/>manageTags" href="javascript:void(0)"> <liferay-ui:message key="manage-tags" /> </a> </li>
					<li> <i class="fa fa-file-text" style="font-size: 25px;"></i><a id="<portlet:namespace/>userAcceptanceOfTOU" href="javascript:void(0)">&nbsp;&nbsp;&nbsp;<liferay-ui:message key="user-acceptance-of-tou" /> </a> </li>
					<li> <i class="fa  fa-cloud-upload" style="font-size: 24px;"></i><a id="<portlet:namespace/>documentStatus" href="javascript:void(0)">&nbsp;&nbsp;<liferay-ui:message key="uploaded-content-status" /> </a> </li>
					<li> <i class="fa fa-envelope" style="font-size: 24px;"></i><a id="<portlet:namespace/>emailDigest" href="javascript:void(0)">&nbsp;&nbsp;<liferay-ui:message key="email-digest"/> </a> </li>
				</ul>
			</div> <!-- end left-section -->
		</div> <!-- end span3 -->
		
		<div class="span9">	
			<div id='<portlet:namespace/>content' class="right-section">
				<jsp:include page="details.jsp"></jsp:include>
			</div>
		</div> <!-- end span9 -->
	</div> <!-- end row-fluid -->
</div> <!-- end container -->


<script>
$("#<portlet:namespace/>emailDigest").click(function(){
	 $.ajax({
       url:'<%=emailDigestUrl.toString() %>',
       type: 'GET',
       data:{
       },
       success: function(data){
       	$("#<portlet:namespace/>content").html(data);
        }
       
   }); 
});


 $("#<portlet:namespace/>documentStatus").click(function(){
	 $("#<portlet:namespace/>content").html("");
	 $.ajax({
        url:'<%=documentStatusUrl.toString() %>',
        type: 'GET',
        data:{
        },
        success: function(data){
        	$("#<portlet:namespace/>content").html(data);
         }
        
    }); 
});
 
$("#<portlet:namespace/>userAcceptanceOfTOU").click(function(){
	 $("#<portlet:namespace/>content").html("");
	 $.ajax({
        url:'<%=userAcceptanceOfTOUUrl.toString() %>',
        type: 'GET',
        data:{
        },
        success: function(data){
        	$("#<portlet:namespace/>content").html(data);
         }
        
    }); 
}); 
 
 $("#<portlet:namespace/>manageCategories").click(function(){
	 $.ajax({
        url:'<%=manageCategoriesURL.toString() %>',
        type: 'GET',
        data:{
        },
        success: function(data){
        	$("#<portlet:namespace/>content").html(data);
         }
        
    }); 
});
 
 $("#<portlet:namespace/>manageTags").click(function(){
		 $.ajax({
	        url:'<%=manageTagsURL.toString() %>',
	        type: 'GET',
	        data:{
	        },
	        success: function(data){
	        	$("#<portlet:namespace/>content").html(data);
	         }
	        
	    }); 
	});


$("#<portlet:namespace/>manageBadges").click(function(){
	
	$.ajax({
        url:'<%=manageBadgeURL.toString() %>',
        type: 'GET',
        data:{
        	<%-- <portlet:namespace/>count:count, --%>
        },
        success: function(data){
        	
        	$("#<portlet:namespace/>content").html(data);
         }
        
    });
});



function addBadge(){
	$.ajax({
        url:'<%=addBadgeURL.toString() %>',
        type: 'GET',
        data:{
        	<%-- <portlet:namespace/>count:count, --%>
        },
        success: function(data){
        	$("#<portlet:namespace/>content").html(data);
         }
        
    });
}
function editBadge(badgeId){
	$.ajax({
        url:'<%=addBadgeURL.toString() %>',
        type: 'GET',
        data:{
        	<portlet:namespace/>badgeId:badgeId
        },
        success: function(data){
        	$("#<portlet:namespace/>content").html(data);
         }
        
    });
}

$("#<portlet:namespace/>manageKeywords").click(function(){
	
	$.ajax({
        url:'<%=manageKeywordsURL.toString() %>',
        type: 'GET',
        data:{
        	<%-- <portlet:namespace/>count:count, --%>
        },
        success: function(data){
        	
        	$("#<portlet:namespace/>content").html(data);
         }
        
    });
});

function addKeyword(){
	$.ajax({
        url:'<%=addKeywordURL.toString() %>',
        type: 'GET',
        data:{
        	<%-- <portlet:namespace/>count:count, --%>
        },
        success: function(data){
        	$("#<portlet:namespace/>content").html(data);
         }
        
    });
}

function editKeyword(keywordId){
	$.ajax({
        url:'<%=addKeywordURL.toString() %>',
        type: 'GET',
        data:{
        	<portlet:namespace/>keywordId:keywordId
        },
        success: function(data){
        	$("#<portlet:namespace/>content").html(data);
         }
        
    });
}

function deleteKeyword(keywordId){
	$.ajax({
        url:'<%=deleteKeywordURL.toString() %>',
        type: 'GET',
        data:{
        	<portlet:namespace/>keywordId:keywordId
        },
        success: function(data){
        	$("#<portlet:namespace/>content").html(data);
         }
        
    });
}


AUI().use(
		  'aui-datepicker',
		  function(Y) {
		    new Y.DatePicker(
		      {
		        trigger: '.datepicker',
		        popover: {
		          zIndex: 1
		        },
		        on: {
		          selectionChange: function(event) {
		            //console.log(event.newSelection)
		          }
		        }
		      }
		    );
		  }
		);

$(function(){
	 $("#<portlet:namespace/>eventType").val('${eventType}');
	 $("#<portlet:namespace/>status").val('${status}');
});


//Email Digest Processing
$(document).on('change','#emailDigestCheckBox',function(){
	var isEnable = $(this).is(':checked');
	$.ajax({
	       url:'<%=emailDigestProcessUrl.toString() %>',
	       type: 'GET',
	       data:{
	    	   <portlet:namespace/>isEnable:isEnable,
	       },
	       success: function(data){
	    	   customAlert("Email Digest Configuration Updated.")
	       }
	}); 
});


function <portlet:namespace/>TOUReportWindow(userAcceptanceURL) {
    var w = 800;
    var h = 500;
    var left = (screen.width/2)-(w/2);
    var top = (screen.height/2)-(h/2);
    var url = userAcceptanceURL;
    return window.open(url, '_blank', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width='+w+', height='+h+', top='+top+', left='+left);
}

function <portlet:namespace/>ValidateOnSubmit(form){
	 var canSubmitForm = true;
	 var fromDate = $('#<portlet:namespace/>fromDate').val();
	 var toDate = $('#<portlet:namespace/>toDate').val();

	 $('.fromGtToIssue,.fromDateReqIssue').addClass('hide');
	 
	 if(fromDate.trim() == '' && toDate.trim() == ''){
		 canSubmitForm = true;
	 }else if(fromDate.trim() != '' && toDate.trim() == ''){
		 canSubmitForm = true;
	 }else if(fromDate.trim() == '' && toDate.trim() != ''){
		 $('.fromDateReqIssue').removeClass('hide');
		 canSubmitForm = false;
	 }else if(fromDate.trim() != '' && toDate.trim() != ''){
		
		var fromDateArr = fromDate.split('/');
		var toDateArr = toDate.split('/');
		var fromDateObj = new Date();
		var toDateObj = new Date();
		fromDateObj.setFullYear(fromDateArr[2],fromDateArr[0]-1,fromDateArr[1]);
		toDateObj.setFullYear(toDateArr[2],toDateArr[0]-1,toDateArr[1]);
		
		if(fromDateObj > toDateObj){
			$('.fromGtToIssue').removeClass('hide');
			canSubmitForm = false;			
		} 
	 }
	 
	 if(canSubmitForm){
	 	form.submit();
	 }
}

</script>
<%}else{%>
<h4>You don't have permissions.</h4>
<%}%>

	 
	 