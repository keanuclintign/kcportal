
<%@page import="com.nyu.util.Constant"%>
<%@page import="org.apache.el.util.Validation"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.liferay.portal.kernel.dao.orm.OrderFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.util.WebKeys"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portlet.announcements.model.AnnouncementsFlag"%>
<%@page import="com.liferay.portlet.announcements.service.AnnouncementsFlagLocalServiceUtil"%>
<%@page import="com.liferay.portlet.announcements.model.AnnouncementsFlagConstants"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.liferay.portal.theme.ThemeDisplay"%>
<%@page import="com.liferay.portal.service.UserGroupLocalServiceUtil"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.liferay.portlet.announcements.service.AnnouncementsEntryLocalServiceUtil"%>
<%@page import="java.util.Date"%>
<%@page import="com.liferay.portlet.announcements.model.AnnouncementsEntry"%>
<%@page import="com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil"%>
<%@page import="com.liferay.portal.model.UserGroup"%>

<portlet:resourceURL id="deleteAnnouncement" var="deleteAnnouncementURL"/> 
<portlet:renderURL var="redirectURL" />

<% 

	List<AnnouncementsEntry> announcementEntries=(List<AnnouncementsEntry>)request.getAttribute(Constant.ANNOUNCEMENT_ENTRIES);
	long userId=PortalUtil.getUserId(request);
%>


<div class="ny-you-message">
		<h3 class="message-heading" style="line-height:normal;">
			<liferay-ui:message key="group-announcement" />
		</h3>
		<div class="message-body shadow"> 
			<ul class="unstyled scroll-overFlow" >
			 
			<% if(Validator.isNotNull(announcementEntries) && announcementEntries.size()>0){
				for(AnnouncementsEntry entry:announcementEntries){
			%>
				<li>
				
				 <%if(entry.getUserId()==userId){ %>
				    <a class="nyu-tooltip cursor-pointer pull-right" onClick="deleteAnnouncement('<%=entry.getEntryId()%>')" 
				    title='<liferay-ui:message key="delete-announcement" />'><i class="icon-trash"></i></a>
				 <%} %> 
				 
				 
				  
				<h3 class="" style="line-height:normal;"><%=entry.getTitle() %> 
					<liferay-ui:message key="from" /> 
				<b><%=UserGroupLocalServiceUtil.getUserGroup(entry.getClassPK()).getName()%></b>
					   <span style="padding-left:20px;" class="muted"><b>
					   		<liferay-ui:message key="posted-on" /> : 
					   	</b><%=new SimpleDateFormat("MM/dd/yyyy").format(entry.getCreateDate()) %></span>
				</h3>				
				<p class=" entry-content entry-type-general"> 
		  			<liferay-ui:message key="by" />   
		  		&nbsp; &nbsp; <img  class="img-circle" width="45" height="45" src="<%=UserLocalServiceUtil.getUser(entry.getUserId()).getPortraitURL(themeDisplay) %>">
		  		<strong class="entry-scope"><%=entry.getUserName()%></strong> 
		  		<span style="padding-left:4%; font-style:italic;"><%=entry.getContent() %></span>
				</p>
				</li>
			<%
				}
			}else{
			%>
				<liferay-ui:message key="no-announcement-found" />.
			<%} %>
			</ul> 
		</div>
</div>
<script>
function deleteAnnouncement(entryId){
	AUI().use(
	  		'aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent: '<p> <Strong><liferay-ui:message key="are-you-sure-you-want-to-remove-this-announcement" /></Strong></p>', 
	  				centered: true,
	  				headerContent: null, 
	  				modal: true,
	  				width: 350,
	  				zIndex: 999,
	  				resizable: false,
	  				toolbars: {
	  					footer: [
	  					{
	  						label: '<liferay-ui:message key="yes" />',
	  						on: {
	  							click: function() {
	  								modal.hide();
	  								 $.ajax({
	  								    url:'<%=deleteAnnouncementURL%>',
	  								    type: 'GET',
	  								    datatype:'html',
	  								    data:{
	  								    	"<portlet:namespace />entryId": entryId,
	  								    },
	  								    success: function(data){
	  								    	
	  								    	window.location.href='<%=redirectURL%>';
	  								     }
	  								});  
	  							
	  							}
	  						}
	  					},
	  					{
	  						label: '<liferay-ui:message key="no" />',
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

</script>
	