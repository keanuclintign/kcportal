<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portlet.messageboards.model.MBMessage"%>
<%@ include file="/WEB-INF/jsp/init.jsp"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>			<%--	added by asif 	09-10-2015 --%>
<%
List<List<MBMessage>> lessonSubDiscussionList = (List<List<MBMessage>>)request.getAttribute(Constant.LESSON_SUB_DISCUSSION_LIST);
%>
<div id="lesson-discuss-accordin">
<%
	for(List<MBMessage> lessonDiscussionList:lessonSubDiscussionList){%>
		<h4 class="header toggler-header-collapsed <%=lessonDiscussionList.get(0).getMessageId()%>-class"><span><%=lessonDiscussionList.get(0).getSubject()%></span>
		<span class="icon-caret pull-right"></span>
		<c:if test="${hasAdminRights}">
			<span style="margin:7px 10px 0 0" title='<liferay-ui:message key="delete-discussion" />' onclick="event.stopPropagation();<portlet:namespace/>deleteDiscussion('<%=lessonDiscussionList.get(0).getMessageId()%>','true')" class="icon-trash nyu-tooltip btn pull-right visible-desktop"></span>
		</c:if>
		</h4>
		<div  class="discussion-content <%=lessonDiscussionList.get(0).getMessageId()%>-class">
		<%
		for(MBMessage message:lessonDiscussionList){
			User LDuser = CommonUtil.getAuthor(message.getUserId());
			String replyTo = "";
			SimpleDateFormat SDF=new SimpleDateFormat("MM/dd/yy hh:mm a");
			if(message.getParentMessageId()>0){
				User parentUser = CommonUtil.getAuthor(MBMessageLocalServiceUtil.getMessage(message.getParentMessageId()).getUserId());
				replyTo = LanguageUtil.get(pageContext, "as-a-reply-to")+" <b>"+parentUser.getFullName()+"</b>";
			}
			String authorImg=LDuser.getPortraitURL(themeDisplay);
		%>
			
				<div class="row-fluid lesson-thread <%=message.getMessageId()%>-class">
					<div class=" span2 discussion-user text-center">
						<img src="<%=authorImg%>" class="img-circle small-img">
						<p><B class="word-wrap"><%=LDuser.getFullName()%></B></p>
					</div>
					<div class="span10 discussion-Message">
						<b><%=message.getSubject()%></b>
						<div>
							<span><%=SDF.format(message.getCreateDate())%>,<%=replyTo%></span>
							<span class="pull-right">
								<span class="btn" onclick="openReplyDiscussion(this,'<%=message.getMessageId()%>')"><liferay-ui:message key="reply" /></span>
								<c:if test="${hasAdminRights}">
									<span  onclick="<portlet:namespace/>deleteDiscussion('<%=message.getMessageId()%>','false')" class="btn btn-default"><liferay-ui:message key="delete" /></span>
								</c:if>
							</span>
						</div>
						<hr/>	
						<%=message.getBody()%>
						<div style="display:none" class="textareaClass" id="textareaDiv<%=message.getMessageId()%>">
							<textarea  name="textarea<%=message.getMessageId()%>" id="textarea<%=message.getMessageId()%>">
							
							</textarea>
							<span class="btn" onclick="saveReplyDiscussion('<%=message.getClassPK()%>','<%=message.getMessageId()%>')"><liferay-ui:message key="submit" /></span>
							<span class="btn cancel-discussion" onclick="javascript:$(this).parent().hide()"><liferay-ui:message key="cancel" /></span>
						</div>
							
						<div class="discussion-ratings pull-right span12 clearfix">
							<liferay-ui:ratings
									className="<%= MBMessage.class.getName() %>"
									classPK="<%= message.getMessageId() %>"
									type="thumbs"
									
								/>
						</div>
					</div>
					
				</div>
			
	<%	}%>
	</div>
	<% }%>
</div>
<%
if(lessonSubDiscussionList.size()<=0){
%>
<p>
	<liferay-ui:message key="no-discussions-found" />.
</p>
<%}
%>

