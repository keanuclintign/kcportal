<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="com.sun.jersey.api.JResponse.AJResponseBuilder"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<% 
		String site = themeDisplay.getScopeGroup().getFriendlyURL();
		String portletId = Constant.PORTLET_LESSON;
		long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(),Constant.PAGE_LESSON_BROWSE).getPlid();
	    PortletURL showLessonURL = PortletURLFactoryUtil.create(renderRequest, portletId, targetPlId, PortletRequest.RENDER_PHASE);
	    showLessonURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);
	    showLessonURL.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID,request.getAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID).toString());
	    
	    String publicUrl = PortalUtil.getPortalURL(request)+"/widget"+"/web";
	    publicUrl += themeDisplay.getScopeGroup().getFriendlyURL()+"/lesson/-/"+Constant.PORTLET_VIEW_LESSON+"?_"+Constant.PORTLET_VIEW_LESSON+"_lessonId="+request.getAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID).toString();
	    
	    
	    String layoutType = layout.isPrivateLayout()? "/group" : "/web";
	    String portletNamespace = StringPool.UNDERLINE + portletId + StringPool.UNDERLINE;
%>

<c:set var="lessonId">${lessonId}</c:set>


<portlet:resourceURL var="sendEmail" id="sendEmailAction" />

<%-- <portlet:resourceURL var="autoEmailUrl" id="emailAutoComp"/> --%>

<aui:form id="myForm" name="myForm" onSubmit="sentEmail();event.preventDefault();" action="<%=sendEmail%>" autocomplete="off">
<div class="container ">
	<div class="row-fluid">
		<div class="span12 newMessage">
			<div class="control-group">
				<div class="controls">
				<aui:input name="toAddress" id="toAddress" autoFocus="true" label="recipients" cssClass="field-required newMessageinput">
				<aui:validator name="required" errorMessage="Please enter the recipients"/>
				<aui:validator name="custom" errorMessage="please-enter-the-valid-recipients">
					function (val, fieldNode, ruleValue) {
						var validRecipients = false;
						if (val.trim().length > 0) {
							validRecipients = true;
							var emailArray = val.split(";");
							var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
							for(var i=0 ;i < emailArray.length;i++){
								if (emailArray[i].trim()== '' || !re.test(emailArray[i].trim())){
									 validRecipients = false;
								}
							}
						}
						return validRecipients;
					}
				</aui:validator>
				</aui:input>
				</div>
			</div>

			<aui:input name="url" type="hidden" value='<%=showLessonURL%>'/>
			<aui:input name="publicUrl" type="hidden" value='<%=publicUrl%>'/>

			<div class="control-group">
				<div class="controls">
				<aui:input cssClass="field-required newMessageinput" id="subject" name="subject" value='<%=request.getParameter("subject") %>'>
				<aui:validator name="required" errorMessage="Please enter the subject"/>
				<aui:validator name="maxLength" errorMessage="maximum-75-characters-allowed">75</aui:validator>
				</aui:input>
				</div>
			</div>

			<div class="control-group">
				<div class="controls"><aui:input cssClass="field-required newMessageinput"  name="message" type="textarea" >
				<aui:validator name="required" errorMessage="Please enter the message"></aui:validator>
				<aui:validator name="maxLength" errorMessage="maximum-500-characters-allowed">500</aui:validator>
				</aui:input>
				</div>
			</div>

			<div class="controls text-right"><aui:button type="submit"  class="btn btn-primary btn-large"  value="send"></aui:button></div>
		</div>
	</div>
</div>
</aui:form>




<script>
 /* AUI().use(
  'aui-form-validator',
  function(Y) {
    new Y.FormValidator(
      {
        boundingBox: '#<portlet:namespace/>myForm'
      }
    );
  }
); */




</script>
 <%-- <aui:script>
     AUI().use(
         'autocomplete-list',
         function (A) {
             
             var testData;
           var auto= new A.AutoCompleteList(
             {
                allowBrowserAutocomplete: 'true',
                activateFirstItem: 'true',
                inputNode: '#<portlet:namespace/>toAddress',
                queryDelimiter: ';',
                render: 'true',
                source:function(){
					var inputValue=A.one("#<portlet:namespace />toAddress").get('value');
					var myAjaxRequest=A.io.request('<%=autoEmailUrl%>',{
					dataType:'json',	
					method:'POST',
					data:{
						<portlet:namespace />searchEmail:inputValue,
					},
					autoLoad:false,
					sync:true,
				on: {
					success:function(){
					var data=this.get('responseData');
					testData=data;
					}}
				});
				myAjaxRequest.start();
				return testData; }
            });
 
        
});
</aui:script> --%>
 
 <aui:script>
 var arr=${emailAddress};
     AUI().use(
         'autocomplete-list',
         function (A) {
             
             var testData=arr;
            
           var auto = new A.AutoCompleteList(
             {
                allowBrowserAutocomplete: 'true',
                activateFirstItem: 'true',
                inputNode: '#<portlet:namespace/>toAddress',
                queryDelimiter: ';',
                render: 'true',
                sync:true,
                source:function()
                {
	                var inputValue=A.one("#<portlet:namespace />toAddress").get('value');
	               	if(inputValue.indexOf(';')>0)
	               	{
	               		inputValue=inputValue.substring(inputValue.lastIndexOf(';')+1).trim();
	               		
	               	}
	                var arrayLength =testData.length;
	               	var autoValue = [];
					for (var i = 0; i < arrayLength; i++) {
	    				if(testData[i].indexOf(inputValue)>=0)
	    				{
	    					autoValue.push(testData[i]);
	    					
	    				}
	    			}
					return autoValue;
                }
                
 				}).on('select', function(event) {
 					setTimeout(function() {A.one("#<portlet:namespace />toAddress").blur().focus();},10);
        		});
	});
</aui:script>
 <aui:script>
 var <portlet:namespace />wiatTillEmailProcessOver = true;
 function sentEmail(){
 	if(<portlet:namespace />wiatTillEmailProcessOver){
 		<portlet:namespace />wiatTillEmailProcessOver = false;
		var EmailURL = "<%=sendEmail%>";
		   AUI().use(function (A) {
	             
	            var testData;
	            var toAddress=A.one("#<portlet:namespace />toAddress").get('value');
	            var subject=A.one("#<portlet:namespace />subject").get('value');
	            var message=A.one("#<portlet:namespace />message").get('value');
	            var url=A.one("#<portlet:namespace />url").get('value');
	            var publicUrl=A.one("#<portlet:namespace />publicUrl").get('value');
	            
	            var check=/^[a-zA-Z0-9!@#$%\^\s\;&*)+=._-]*$/.test(toAddress);
	            if(!check)
	            {
	            		AUI().use('aui-modal',
	  					function(Y) {
	  						var modal = new Y.Modal(
	  						{
	  						bodyContent: '<p> <Strong>Use Only (\";\") Semicolon  as Email Separator</Strong></p>', centered: true,
	  						headerContent: null, 
	  						modal: true,
	  						cssClass:'popup_alert',
	  						width: 350,
	  						zIndex: 999,
	  						resizable: false,
	  						toolbars: {
	  						footer: [
	  									{
					  						label: 'Ok',
					  						on: {
					  							click: function() {
					  								modal.hide();
					  							}
					  						}
	  									}
	  								]
	  								}
	  						}).render();
	  	  				});
											
	            return "false";
	            }
	               	var myAjaxRequest=A.io.request(EmailURL,{
					dataType:'html',	
					method:'POST',
					data:{
							<portlet:namespace />toAddress:toAddress,
							<portlet:namespace />subject:subject,
							<portlet:namespace />message:message,
							<portlet:namespace />url:url,
							<portlet:namespace />publicUrl:publicUrl
							
						},
						
					on: {
						success:function(){
						var data=this.get('responseData');
						if(data.indexOf('success')>0)
						{
							A.one('#<portlet:namespace />toAddress').val('');
							A.one('#<portlet:namespace />subject').val("<%=request.getParameter(Constant.REQUEST_LESSON_SUBJECT_JSP) %>");
							A.one('#<portlet:namespace />message').val('');
							<portlet:namespace />wiatTillEmailProcessOver = true;
							Liferay.Util.getOpener().closeEmailPopup('myEmailPopupId','yes');
					  	}
						}}
					});
					myAjaxRequest.start();
				}
	            );
           }
           }
</aui:script>
 
 
