<%@ include file="/WEB-INF/jsp/init.jsp" %>

<portlet:actionURL var="contactURL">
	<portlet:param name="action" value="contactUs" />
</portlet:actionURL>

<liferay-ui:success key="sucess" message="Email sent successfully." />

<aui:form action="<%=contactURL%>" name="emailForm" onSubmit="event.preventDefault();sendEmailContactus();" method="post" enctype="multipart/form-data" cssClass="contact-form clearfix">
 
		<div class="newMessage">
			<p class="description">Your input is valuable to us. Please send us your suggestions.</p><br/>
				<div class="control-group">
						<aui:input cssClass="field-required newMessageinput" name="subject" label="Subject">							
						<aui:validator name="required" errorMessage="Please enter the subject"/>
						<aui:validator name="maxLength" errorMessage="maximum-75-characters-allowed">75</aui:validator>
						</aui:input>
				</div>
				<div class="control-group">
						<aui:input cssClass="field-required newMessageinput" type="textarea" name="message" label="Message">
						<aui:validator name="required" errorMessage="Please enter the message"></aui:validator>
						<aui:validator name="maxLength" errorMessage="maximum-500-characters-allowed">500</aui:validator>
						</aui:input>
				</div>		
				<div class="control-group">
						<aui:input type="file" name="msgattachedFile" id="msgattachedFile" label="Add Attachment">
						<aui:validator name="acceptFiles">'PDF,TXT,DOCX,XLS,PPTX,JPG,JPEG,PNG'</aui:validator>
						</aui:input>
						<aui:input type="hidden" name="isFileAdded" id="isFileAdded"/>
						<label style="font-size:11px; ">Supported formats: PDF, TXT, DOCX, XLS, PPTX, JPEG, PNG  
						<aui:button cssClass="btn btn-primary pull-right" type="submit" value="send" /></label>
						
				</div> 
	</div>
</aui:form>

<script>
function sendEmailContactus(){
	var file = document.getElementById("<portlet:namespace/>msgattachedFile").value;
	var subject = document.getElementById("<portlet:namespace/>subject").value;
	var message = document.getElementById("<portlet:namespace/>message").value;
	if(file != null && file != ''){
		document.getElementById("<portlet:namespace/>isFileAdded").value = "true";
	}
	if((subject!= null && subject.trim() != '' && subject.trim().length <= 75 ) && (message != null && message.trim() != '' && message.trim().length <= 500)){
		document.getElementById("<portlet:namespace/>emailForm").submit();
	}
}


window.onLoad=(function(){
	var closePopup = '${closePopup}';
	if(closePopup=='true'){
		Liferay.Util.getOpener().closeMainImagePopup('contactPopupId','yes','Email sent successfully.');
	}
})();
</script>






