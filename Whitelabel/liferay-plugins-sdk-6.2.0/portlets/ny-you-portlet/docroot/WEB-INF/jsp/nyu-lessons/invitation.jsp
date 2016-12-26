<%@ include file="/WEB-INF/jsp/init.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/request-lesson.js"></script>
<portlet:resourceURL var='invitationURL' id='sendInvitation' />
<style>
	.yui3-skin-sam .yui3-aclist-content{max-height: 243px; overflow: auto; width: 217px;}
	.yui3-skin-sam .yui3-aclist-content .yui3-aclist-list{margin-left:6px;}
</style>
<form>
	<div class="control-group">
		<label for="userName" class="control-label"> User Name </label>
		<div class="">
			<input type="text" id="userInput" name="userName" class="pull-left" autocomplete="off" >
			<button class="btn btn-warning hidden" id="#closeIcon" >
				<i class="icon-remove"></i>
			</button>
			<input type="hidden" id="userId" name="userId"/>
			<button class="btn btn-primary" onClick="sendInvitation()">Invite</button>
		</div>
	</div>
</form>

<script>

var userDetails = ${userListJson};
AUI().use('autocomplete-list','aui-base','aui-io-request','autocomplete-filters','autocomplete-highlighters',function (A) {
        	 var autoComplete = new A.AutoCompleteList(

        			 {

        			 allowBrowserAutocomplete: 'true',
        			 
        			 inputNode: '#userInput',

        			 resultTextLocator: 'userName',

        			 render: 'true',

        			 resultFilters:['phraseMatch'],
   		
        			 source:userDetails
        			 
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
			showValidationAlert('Please enter the user name.');
		}
		else{
			showValidationAlert('Please enter the  valid user name.');
		} 
	 }else{
			$.ajax({
		        url:"<%=invitationURL%>",
		        type: 'GET',
		        datatype:'html',
		        data:{
		        	<portlet:namespace/>userId:$("#userId").val(),
		        	<portlet:namespace/>mailId:$("#userInput").val(),
		        	<portlet:namespace/>userGroupId:"263"
		        },
	        success: function(){
	        	 $("#userId").val("");	
	        	 $("#userInput").val("");
	        	 $("#userInput").attr("disabled",false);
	        	 $(".btn.btn-warning").addClass("hidden");
	        	 showSuccessAlert(" Invitation Sent Sucessfully.");
	    	}
        
      		});
	 }
	
}



           
           
 </script>         
        