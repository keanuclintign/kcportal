<%@ include file="/WEB-INF/jsp/init.jsp" %>

<portlet:resourceURL var='invitationURL' id='sendInvitation' />

<div id="invitation"> 
<h3><liferay-ui:message key="invite-more-people" /></h3>
</div>
<form>
  <label for="userInput"><liferay-ui:message key="user-name" /></label>
  <input type="text" id="userInput" name="userName" class="" autocomplete="off">
  <button  class="btn btn-warning hidden" id="#closeIcon" style="margin-bottom: 10px;"> <i class="icon-remove"></i></button>
  <input type="hidden" id="userId" name="userId"/>
  <p><button class="btn btn-primary" onClick="sendInvitation()"><liferay-ui:message key="invite" /></button></p>
</form>




<script>

var userDetails =JSON.parse(JSON.stringify(<%=request.getAttribute("userGroupJson")%>));
AUI().use('autocomplete-list','aui-base','aui-io-request','autocomplete-filters','autocomplete-highlighters',function (A) {
        	 var autoComplete = new A.AutoCompleteList(

        			 {

        			 allowBrowserAutocomplete: 'true',
        			 
        			 inputNode: '#userInput',

        			 resultTextLocator: 'userName',

        			 render: 'true',

        			 resultHighlighter: 'phraseMatch',

        			 resultFilters:['phraseMatch'],
   		
        			 source:userDetails,
        			

        			 });


	        		 autoComplete.on('select', function(e)  {
	        			A.one("#userId").val(e.result.raw.userId);
	        			A.one("#userInput").attr("disabled",true);
	        			A.one(".btn.btn-warning").removeClass("hidden");
        			 });
	        		 A.one(".btn.btn-warning").on('click',function(){
	        			 A.one("#userId").val("");
	        			 A.one("#userInput").attr("disabled",false);
	        			 A.one("#userInput").val("");
	        			 A.one(".btn.btn-warning").addClass("hidden");
	        		 });
        			 

});
     
    
     
     
     
function sendInvitation(){
	if($("#userInput").val().length==0){
		
		if($("#userInput").val().length==0){
			 message='<p> <Strong ><liferay-ui:message key="please-enter-the-user-name" />.<p> <Strong>';
		}
		else{
			message='<p> <Strong ><liferay-ui:message key="please-enter-the-valid-user-name" />.<p> <Strong>';
		}
	
		 AUI().use(
 		  		'aui-modal',
 		  		function(Y) {
 		  			var modal = new Y.Modal(
 		  			{
 		  				bodyContent:message,
 		  				centered: true,
 		  				headerContent: null, 
 		  				modal: true,
 		  				render: '#members',
 		  				width: 300,
 		  				zIndex: 999,
 		  				resizable: false,
 		  				toolbars: {
 		  					footer: [
 		  					{
 		  						label: '<liferay-ui:message key="close" />',
 		  						on: {
 		  							click: function() {
 		  								modal.hide();
 		  							}
 		  						}
 		  					}
 		  					
 		  					]
 		  				}
 		  			}
 		  		).render();
 		  	  	});
	}
	else{
	$.ajax({
        url:"<%=invitationURL%>",
        type: 'GET',
        datatype:'html',
        data:{
        	<portlet:namespace/>userId:$("#userId").val(),
        	<portlet:namespace/>mailId:$("#userInput").val(),
        	<portlet:namespace/>userGroupId:"<%=userGroupId%>"
        },
        success: function(){
        	 $("#userId").val("");	
        	 $("#userInput").val("");
        	 $("#userInput").attr("disabled",false);
        	 $(".btn.btn-warning").addClass("hidden");
        	 AUI().use(
        		  		'aui-modal',
        		  		function(Y) {
        		  			var modal = new Y.Modal(
        		  			{
        		  				bodyContent:'<p> <Strong><liferay-ui:message key="invitation-sent-sucessfully" />.<p> <Strong>',
        		  				centered: true,
        		  				headerContent: null, 
        		  				modal: true,
        		  				render: '#members',
        		  				width: 350,
        		  				zIndex: 999,
        		  				resizable: false,
        		  				toolbars: {
        		  					footer: [
        		  					{
        		  						label: '<liferay-ui:message key="ok" />',
        		  						on: {
        		  							click: function() {
        		  								modal.hide();
        		  							}
        		  						}
        		  					}
        		  					
        		  					]
        		  				}
        		  			}
        		  		).render();
        		  	  	});
    	}
        
      });
	}
	
}



           
           
 </script>         
        