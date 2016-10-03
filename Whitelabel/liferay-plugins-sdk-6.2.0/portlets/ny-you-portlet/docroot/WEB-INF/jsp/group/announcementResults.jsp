
<div class="ny-you-message" id="groupsController" ng-controller="GroupsController">
	<h3 class="message-heading" style="line-height:normal;"><liferay-ui:message key="group-announcement" /></h3>
	<div class="message-body shadow"> 
		<ul class="unstyled scroll-overFlow" >
		 
			<li ng-repeat="announcement in groupAnnouncements">
			 
			    <a class="cursor-pointer pull-right nyu-tooltip" ng-if="announcement.userId==userId" ng-click="deleteAnnouncement(announcement.entryId,'<%=deleteAnnouncementURL%>')" 
			    title='<liferay-ui:message key="delete-announcement" />'><i class="icon-trash"></i></a>
				  
				<h3 class="" style="line-height:normal;">{{announcement.title}} <liferay-ui:message key="from" /> <b>{{announcement.userGroupName}}</b>
					   <span style="padding-left:20px;" class="muted"><b><liferay-ui:message key="posted-on" /> : </b>{{announcement.createdDate}}</span>
				</h3>				
				<p class=" entry-content entry-type-general"> 
		  			<liferay-ui:message key="by" />   &nbsp; &nbsp; <img  class="img-circle" width="45" height="45" ng-src={{announcement.userImage}}>
		  			<strong class="entry-scope">{{announcement.userName}}</strong> 
		  			<span style="padding-left:4%; font-style:italic;" text-to-html-converter>{{announcement.content}}</span>
				</p>
			</li>
			<li ng-if="groupAnnouncements.length==0">
				<liferay-ui:message key="no-announcement-found" />.
			</li>
			
		
		</ul> 
	</div>
</div>