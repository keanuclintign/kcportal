<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="com.nyu.service.RequestLessonLocalServiceUtil"%>
<%@page import="com.nyu.model.RequestLesson"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="com.sun.jersey.api.JResponse.AJResponseBuilder"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<% System.out.println("/requestlesson/email.jsp done"); %>

<% 
	    String rlPortletId = Constant.PORTLET_REQUEST_LESSON;
		long rlTargetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_REQUEST_LESSON).getPlid();
		PortletURL showRequestLessonURL = PortletURLFactoryUtil.create(renderRequest, rlPortletId, rlTargetPlId, PortletRequest.RENDER_PHASE);
		showRequestLessonURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.REQUEST_DETAILS);
		showRequestLessonURL.setParameter(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID,request.getAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID).toString());
%>

<c:set var="lessonId">requestLessonId</c:set>


<portlet:resourceURL var="sendEmail" id="sendEmailAction" />

<%-- <portlet:resourceURL var="autoEmailUrl" id="emailAutoComp"/> --%>

<aui:form id="myForm" name="myForm" onSubmit="sentEmail();event.preventDefault();" action="<%=sendEmail%>" autocomplete="off">
<div class="container ">
	<div class="row-fluid">
		<div class="span12 newMessage">
			<div class="control-group">
				<div class="controls">
				<aui:input name="toAddress" id="toAddress" autoFocus="true" label="recipients" cssClass="field-required newMessageinput">
				<aui:validator name="required" errorMessage="please-enter-the-recipients"/>
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

			 <aui:input name="url" type="hidden" value='<%=showRequestLessonURL%>'/> 

			<div class="control-group">
				<div class="controls">
				<aui:input cssClass="field-required newMessageinput" id="subject" name="subject" label='subject' value='<%=request.getParameter("subject") %>'>
				<aui:validator name="required" errorMessage="please-enter-the-subject"/>
				<aui:validator name="maxLength" errorMessage="maximum-100-characters-allowed">100</aui:validator>
				</aui:input>
				</div>
			</div>

			<div class="control-group">
				<div class="controls">
				<aui:input cssClass="field-required newMessageinput"  name="message" type="textarea" label='message'>
				<aui:validator name="required" errorMessage="please-enter-the-message"></aui:validator>
				<aui:validator name="maxLength" errorMessage="maximum-500-characters-allowed">500</aui:validator>
				</aui:input>
				</div>
			</div>

			<div class="controls text-right">
				<aui:button type="submit"  class="btn btn-primary btn-large"  value="send"></aui:button></div>
		</div>
	</div>
</div>
</aui:form>

 <aui:script>
 var arr=${emailAddress};
     AUI().use(
         'autocomplete-list',
         function (A) {
             
             var testData=arr;
            
           var auto= new A.AutoCompleteList(
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
 function sentEmail(){
	var EmailURL = "<%=sendEmail%>";
	
     AUI().use(function (A) {
             
            var testData;
            var toAddress=A.one("#<portlet:namespace />toAddress").get('value');
            var subject=A.one("#<portlet:namespace />subject").get('value');
            var message=A.one("#<portlet:namespace />message").get('value');
            var url=A.one("#<portlet:namespace />url").get('value');
            var check=/^[a-zA-Z0-9!@#$%\^\s\;&*)+=._-]*$/.test(toAddress);
            if(!check)
            {
            		AUI().use('aui-modal',
  					function(Y) {
  						var modal = new Y.Modal(
  						{
  						bodyContent: '<p> <Strong><liferay-ui:message key="use-only-semicolon-semicolon-as-email-separator" /></Strong></p>', centered: true,
  						headerContent: null, 
  						modal: true,
  						cssClass:'popup_alert',
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
					},
					
				on: {
					success:function(){
					var data=this.get('responseData');
					if(data.indexOf('success')>0)
					{
					AUI().use('aui-modal',
  					function(Y) {
  						var modal = new Y.Modal(
  						{
  						bodyContent: '<p> <Strong><liferay-ui:message key="requestlesson-shared-successfully" /></Strong></p>', centered: true,
  						headerContent: null, 
  						modal: true,
  						cssClass:'popup_alert',
  						width: 350,
  						zIndex: 999,
  						resizable: false,
  						toolbars: {
  						footer: [
  									{
				  						label: '<liferay-ui:message key="ok" />',
				  						on: {
				  							click: function() {
				  								A.one('#<portlet:namespace />toAddress').val('');
				  								A.one('#<portlet:namespace />subject').val("<%=request.getParameter(Constant.REQUEST_LESSON_SUBJECT_JSP) %>");
				  								A.one('#<portlet:namespace />message').val('');
				  								modal.hide();
				  							}
				  						}
  									}
  								]
  								}
  						}).render();
  	  				});
					
					}
					}}
				});
				myAjaxRequest.start();
			}
            );
           }
</aui:script>
 
 
