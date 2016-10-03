<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@page import="javax.portlet.ResourceURL"%>
<%@page import="com.liferay.portal.kernel.dao.orm.OrderFactoryUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.nyu.service.AuditReportLocalServiceUtil"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.nyu.model.AuditReport"%>
<%@page import="com.liferay.portal.kernel.util.ListUtil"%>
<%@taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

<portlet:actionURL name="auditSearch" var="auditSearch">
<portlet:param name="action" value="auditSearch"/>
</portlet:actionURL>

<div class="container" id="audit-search">
	<div class="row-fluid">
		<form name='<portlet:namespace/>search' action="<%=auditSearch%>" method="post" onsubmit="event.preventDefault();<portlet:namespace/>ValidateOnSubmit(this)">
			<span class="span3">
			<b><liferay-ui:message key="event" />:&nbsp;</b><select id="<portlet:namespace/>eventType" name="<portlet:namespace/>eventType">
					<option value="-1"><liferay-ui:message key="any" /></option>
					<option value="LOGIN"><liferay-ui:message key="login" /></option>
					<option value="LOGOUT"><liferay-ui:message key="logout" /></option>
					<option value="View Lesson"><liferay-ui:message key="view-lesson" /></option>
					<option value="Create Lesson"><liferay-ui:message key="create-lesson" /></option>
					<option value="Update Lesson"><liferay-ui:message key="update-lesson" /></option>
					<option value="Delete Lesson"><liferay-ui:message key="delete-lesson" /></option>
					<option value="Create Group"><liferay-ui:message key="create-group" /></option>
					<option value="Update Group"><liferay-ui:message key="update-group" /></option>
					<option value="Delete Group"><liferay-ui:message key="delete-group" /></option>
					<option value="Create Request"><liferay-ui:message key="create-request" /></option>
					<option value="Delete Request"><liferay-ui:message key="delete-request-no-doubt" /></option>
					<option value="View Request"><liferay-ui:message key="view-request" /></option>
				</select>
			</span>
			<span class="span6">
			 	<span class="span6"><b><liferay-ui:message key="from" />:&nbsp;</b><input style="width:150px;cursor:pointer"  readonly="readonly" placeholder='<liferay-ui:message key="click-here" />' id="<portlet:namespace/>fromDate" class="datepicker" value="${fromDate}"  name="<portlet:namespace/>fromDate"/><span class='btn icon-remove' onclick='javascript:$("#<portlet:namespace/>fromDate").val("")'></span></span>
				<span class="span6"><b><liferay-ui:message key="to" />:&nbsp;</b><input style="width:150px;cursor:pointer" readonly="readonly" placeholder='<liferay-ui:message key="click-here" />' id="<portlet:namespace/>toDate" class="datepicker" value="${toDate}" name="<portlet:namespace/>toDate"/><span class='btn icon-remove' onclick='javascript:$("#<portlet:namespace/>toDate").val("")'></span></span>
			</span>
			<span class="span3">
				<input type="submit" class="btn btn-primary" value='<liferay-ui:message key="search" />'>
				<button class="btn btn-primary  generate-report" onClick="event.preventDefault();<portlet:namespace/>reportPopupWindow();"><liferay-ui:message key="generate-report" /></button>
			</span>
		</form>
	</div>
	<div>
		<div class="row-fluid"><span class="alert alert-danger hide fromGtToIssue">From date is greater than To date.</span></div>
		<div class="row-fluid"><span class="alert alert-danger hide fromDateReqIssue">From date is required.</span></div>
	</div>
</div>
<div class='container'>
<liferay-ui:search-container searchContainer="${searchContainer}"> 
		<liferay-ui:search-container-row modelVar="auditReport" keyProperty="auditEventId" className="com.nyu.model.AuditReport"> 
			<liferay-ui:search-container-column-text name="user-name" >
				 <%=auditReport.getUserName()%>
			</liferay-ui:search-container-column-text>
			<liferay-ui:search-container-column-text name="event-type" href="javascript:void(0);">
				<span class="nyu-tooltip" title="<%=auditReport.getAdditionalInfo()%>"> <%=auditReport.getEventType()%></span>
			</liferay-ui:search-container-column-text> 
			<liferay-ui:search-container-column-text name="event-date" href="javascript:void(0);">
				<span class="nyu-tooltip" title="<%=auditReport.getCreateDate()%>"> <%=CommonUtil.getDatesDuration(auditReport.getCreateDate().getTime(), 0)%></span>
			</liferay-ui:search-container-column-text>
		
		</liferay-ui:search-container-row> 
<liferay-ui:search-iterator /> 
</liferay-ui:search-container> 
</div>


<script>
/* function <portlet:namespace/>DetailReport(auditEventId)
{	
	$.ajax({
	    url:'<portlet:resourceURL id="detailReport" />',
	    type: 'GET',
	    datatype:'html',
	    data:{
	    	<portlet:namespace/>auditEventId:auditEventId
	    },
	    success: function(data){
	    	AUI().use('aui-modal',
  					function(Y) {
  						var modal = new Y.Modal(
  						{
  						bodyContent:data, centered: true,
  						headerContent: '<h2>Detailed report</h2>', 
  						modal: true,
  						cssClass:'popup_alert',
  						width: 400,
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
	     }	    
	});
	
	
}
 */

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
 });
 
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
 
 function <portlet:namespace/>reportPopupWindow() {
	    var w = 800;
	    var h = 500;
	    var left = (screen.width/2)-(w/2);
	    var top = (screen.height/2)-(h/2);
	    var url = '${generateReportURL}';
	    return window.open(url, '_blank', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width='+w+', height='+h+', top='+top+', left='+left);
}
</script>