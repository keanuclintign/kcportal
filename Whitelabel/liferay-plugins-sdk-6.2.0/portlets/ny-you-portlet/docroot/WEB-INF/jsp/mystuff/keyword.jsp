<%@page import="com.nyu.util.Constant"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="javax.portlet.PortletURL"%>
<portlet:resourceURL var="processKeywordRequestUrl" id="processKeywordRequest" />
<portlet:resourceURL var="processKeywordRequestStatusUrl" id="processKeywordRequestStatus" />
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<div class="my-stuff-request">
	
	<h1>
		<liferay-ui:message key="approval-requests" />
	</h1>
	<div id="keyword-request-content" class="scroll-overFlow" style="max-height:315px;">
		<c:if test="${empty keywordsCollaborations}">
			<b>
				<liferay-ui:message key="no-request-found-for-approval" />.
			</b>
		</c:if>
		<c:forEach items="${keywordsCollaborations}" var="keywordsCollaboration">
		<div class="keyword-request-items answered-request">
			<div class="request-content">
				<p>${keywordsCollaboration.userName} 
					<liferay-ui:message key="has-requested-to-use-reserved-group-keyword-phrase" />
					"${keywordsCollaboration.keywordName}"</p>
			</div>
			<footer class="clearfix"> 
				<span> <i class="icon-calendar"> </i>
					<fmt:formatDate pattern="MM/dd/yyyy" value="${keywordsCollaboration.createdDate}" />
				</span>
				<span class="pull-right group-btn"><span class="btn btn-primary" onclick="keywordRequestProcess('<%=Constant.KEYWORD_STATUS_ACCEPTED%>','${keywordsCollaboration.id}',this)">
					<liferay-ui:message key="approve" />
				</span><span style="margin-left:5px"class="btn" onclick="keywordRequestProcess('<%=Constant.KEYWORD_STATUS_DECLINED%>','${keywordsCollaboration.id}',this)">
					<liferay-ui:message key="decline" />
				</span></span>
			</footer>
		</div>
		</c:forEach>
	</div>
	<hr/>
	<h1>
		<liferay-ui:message key="requests-status" />
	</h1>		
	<div id="keyword-request-status-content" class="scroll-overFlow" style="max-height:315px">
		<c:if test="${empty keywordsRequestStatus}">
			<b>
				<liferay-ui:message key="no-request-found-for-approval" />.
			</b>
		</c:if>
		<c:forEach items="${keywordsRequestStatus}" var="RequestStatus">
		<div class="keyword-request-status-items answered-request">
			<div class="request-content">
				<p>
					<liferay-ui:message key="your-request-has-been" />
						 "${RequestStatus.status}" 
					<liferay-ui:message key="to-use-reserved-group-keyword-phrase" />
						"${RequestStatus.keywordName}"
				</p>
			</div>
			<footer class="clearfix"> 
				<span> <i class="icon-calendar"> </i><fmt:formatDate pattern="MM/dd/yyyy" value="${RequestStatus.modifiedDate}" /></span>
				<span class="pull-right group-btn"><span class="btn btn-primary" onclick="keywordRequestStatusProcess('read','${RequestStatus.id}',this)">
					<liferay-ui:message key="close" />
				</span></span>
			</footer>
		</div>
		</c:forEach>
	</div>
</div>

<script>
function keywordRequestProcess(action,id,currentItem){
	$.ajax({
        url:'<%=processKeywordRequestUrl.toString() %>',
        type: 'POST',
        data:{
        	 <portlet:namespace/>id:id, 
      		 <portlet:namespace/>action:action,
        },
        success: function(data){
        	$(currentItem).closest('.keyword-request-items').remove();
        	if($('#keyword-request-content .keyword-request-items').length<1){
        		$("#keyword-request-content").html("<b><liferay-ui:message key="no-request-found-for-approval" /></b>");
        	}
         }
        
    });
}

function keywordRequestStatusProcess(action,id,currentItem){
	$.ajax({
        url:'<%=processKeywordRequestStatusUrl.toString() %>',
        type: 'POST',
        data:{
        	 <portlet:namespace/>id:id, 
      		 <portlet:namespace/>action:action,
        },
        success: function(data){
        	$(currentItem).closest('.keyword-request-status-items').remove();
        	if($('#keyword-request-status-content .keyword-request-status-items').length<1){
        		$("#keyword-request-status-content").html("<b><liferay-ui:message key="no-request-status-found" /></b>");
        	}
         }
        
    });
}
</script>