<%@page import="com.liferay.portal.kernel.servlet.SessionMessages"%>
<%@page import="com.nyu.model.Keywords"%>
<%@page import="com.nyu.model.impl.KeywordsImpl"%>
<%@page import="com.nyu.service.KeywordsLocalServiceUtil"%>
<%@page import="com.nyu.model.impl.BasnoImpl"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.liferay.portal.kernel.util.ListUtil"%>
<%@page import="com.liferay.portal.kernel.servlet.SessionErrors"%>
<%@taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

<%List<Keywords> badges=KeywordsLocalServiceUtil.getKeywordses(-1,-1);
long keywordId=ParamUtil.getLong(request, Constant.KEYWORD_ID);
Keywords keyword=new KeywordsImpl();

String message=(String)SessionMessages.get(portletSession,Constant.ERROR);
%>

<% if(keywordId>0l){
	keyword=KeywordsLocalServiceUtil.getKeywords(keywordId);%>
	<legend class="fieldset-legend"> <span class="legend"> <liferay-ui:message key="edit-keyword" /> </span> </legend>
<% }else {%> 
	<legend class="fieldset-legend"> <span class="legend"> <liferay-ui:message key="create-new-keyword" /> </span> </legend>
<%} %>

<portlet:resourceURL var="saveKeywordURL" id="saveKeyword">
</portlet:resourceURL>
<% if(message!=null){
	keyword.setKeyword(ParamUtil.getString(request, Constant.KEYWORD));
	keyword.setDescription(ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_DESCRIPTION));
%>
	<div class="alert alert-danger"><%=message%></div>
<%} %>
<aui:form >
	<aui:input type="hidden" name="keywordId" value="<%=keywordId%>" label=""></aui:input>
	<aui:input type="text" name="keyword" label="keyword" value="<%=keyword.getKeyword()%>">
		<aui:validator name="required" />
		<aui:validator name="maxLength" errorMessage="keyword-should-not-exceed-more-than-seven-five-characters" >75</aui:validator>
		<aui:validator name="minLength" errorMessage="keyword-should-have-minimum-four-characters" >4</aui:validator>
	</aui:input>
	
	<aui:input type="textarea" 	name="description" 	label="description" value="<%=keyword.getDescription()%>">
		<aui:validator name="maxLength" errorMessage="Please-enter-description-below-thousands-characters" >1000</aui:validator>
	</aui:input>
<aui:button onclick="saveKeyword()" value="small-case-submit"/>
</aui:form> 
<%SessionErrors.clear(portletSession); %>
<script>
function saveKeyword(){
var keywordId=$("#<portlet:namespace/>keywordId").val();
var keyword=$("#<portlet:namespace/>keyword").val();
var description=$("#<portlet:namespace/>description").val();
if(keyword.trim().length <= 3  || keyword.trim().length > 75){
	$("#<portlet:namespace/>keyword").focus().blur();;
	return false;	
}
if(description.trim().length > 1000){
	$("#<portlet:namespace/>description").focus().blur();;
	return false;	
}

$.ajax({
    url:'<%=saveKeywordURL.toString() %>',
    type: 'POST',
    data:{
    	<portlet:namespace/>keywordId:keywordId,
    	<portlet:namespace/>keyword:keyword,
    	<portlet:namespace/>description:description
    },
    success: function(data){
    	$("#<portlet:namespace/>content").html(data);
     }
    
});

}
</script>