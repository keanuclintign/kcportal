<%@page import="com.nyu.model.impl.BasnoImpl"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.nyu.service.BasnoLocalServiceUtil"%>
<%@page import="com.nyu.model.Basno"%>
<%@page import="com.liferay.portal.kernel.util.ListUtil"%>
<%@page import="com.liferay.portal.kernel.servlet.SessionErrors"%>
<%@taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

<%List<Basno> badges=BasnoLocalServiceUtil.getBasnos(-1,-1);
long basnoBagdeId=ParamUtil.getLong(request, Constant.BADGE_ID);
Basno basnoBadge=new BasnoImpl();

%>

<liferay-ui:error key="DuplicateBadgeId" message="duplicate-badgeId" />
<%
%>

<% if(basnoBagdeId>0l && !SessionErrors.contains(portletSession,Constant.DUPLICATE_BADGE_ID)){
	basnoBadge=BasnoLocalServiceUtil.getBasno(basnoBagdeId);%>
	<legend class="fieldset-legend"> <span class="legend"> <liferay-ui:message key="edit-badge" /> </span> </legend>
<% }else {%> 
	<legend class="fieldset-legend"> <span class="legend"> <liferay-ui:message key="create-new-badge" /> </span> </legend>
<%} %>

<portlet:resourceURL var="saveBadgeURL" id="saveBadgeURL">
	<%if(basnoBagdeId>0l && !SessionErrors.contains(portletSession,Constant.DUPLICATE_BADGE_ID)){%>
		<portlet:param name="badgeId" value="<%=String.valueOf(basnoBagdeId) %>"/>
		<portlet:param name="editbadge" value="editbadge"/>
	<%}%>
</portlet:resourceURL>

<aui:form >
<%if(basnoBagdeId>0l && !SessionErrors.contains(portletSession,Constant.DUPLICATE_BADGE_ID)){ %>
<label><liferay-ui:message key="badge-id" />   <%=basnoBagdeId%></label>

<%}	else { %>
<aui:input type="text" 	name="badgeId" 	label="badge-id">
	<aui:validator name="required"/>
	<aui:validator name="digits"/>
	<aui:validator name="max">1000000000000000000</aui:validator>
</aui:input>
<%} %>
<aui:input type="text" name="badgeName" label="badge-name" value="<%=basnoBadge.getBadgeName()%>">
	<aui:validator name="required"/>
	<aui:validator name="maxLength">75</aui:validator>
</aui:input>
<aui:input type="text"	 name="targetPoints"	label="target-points" value="<%=String.valueOf(basnoBadge.getTargetPoints()==0?\"\":basnoBadge.getTargetPoints())%>">
	<aui:validator name="required"/>
	<aui:validator name="digits"/>
	<aui:validator name="max">1000000000000000000</aui:validator>
</aui:input>
<aui:input type="textarea" 	name="description" 	label="description" value="<%=basnoBadge.getDescription()%>">
	<aui:validator name="maxLength" errorMessage="Please-enter-description-below-thousands-characters" >1000</aui:validator>
</aui:input>
<aui:button onclick="saveBadge()" value="small-case-submit"/>
</aui:form> 
<%SessionErrors.clear(portletSession); %>
<script>
function saveBadge(){
var badgeId=$("#<portlet:namespace/>badgeId").val();
var badgeName=$("#<portlet:namespace/>badgeName").val();
var targetPoints=$("#<portlet:namespace/>targetPoints").val();
var  description=$("#<portlet:namespace/>description").val();

/*VALIDATION START*/
var validationSuccess = true;
var onlyDigits = ['#<portlet:namespace/>badgeId','#<portlet:namespace/>targetPoints'];

if($('#<portlet:namespace/>badgeName').val().trim() == ''){
	$('#<portlet:namespace/>badgeName').focus().blur();
	validationSuccess = false;
	
}else if($('#<portlet:namespace/>badgeName').val().trim().length > 75){
	$('#<portlet:namespace/>badgeName').focus().blur();
	validationSuccess = false;
}
	
for(i=0 ;i < onlyDigits.length;i++){
	var curElement = $(onlyDigits[i]).val();
	if(curElement != null && (curElement.trim() == '' || isNaN(curElement.trim()))){
		$(onlyDigits[i]).focus().blur();
		validationSuccess = false;
	}else if(curElement != null && parseInt(curElement) >1000000000000000000){
		$(onlyDigits[i]).focus().blur();
		validationSuccess = false;
	}
}

if(description.trim().length > 1000){
	$("#<portlet:namespace/>description").focus().blur();
	validationSuccess = false;	
}

if(!validationSuccess){
	return validationSuccess;
}
/*VALIDATION ENDS*/

$.ajax({
    url:'<%=saveBadgeURL.toString() %>',
    type: 'POST',
    data:{
    	<portlet:namespace/>badgeId:badgeId,
    	<portlet:namespace/>badgeName:badgeName,
    	<portlet:namespace/>targetPoints:targetPoints,
    	<portlet:namespace/>description:description
    },
    success: function(data){
    	$("#<portlet:namespace/>content").html(data);
     }
    
});

}
</script>