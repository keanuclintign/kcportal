<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="javax.portlet.PortletSession"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="java.util.ArrayList"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>			<%--	added by asif 	 --%>

<script type="text/javascript" src = "<%=request.getContextPath()%>/js/angular/lessonSection.js"></script>
	

	
<%
String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),layout.isPrivateLayout(),themeDisplay);
String homeUrl=siteFriendlyUrl+Constant.PAGE_HOME;

%>


<portlet:renderURL var="previewEdit">
	<portlet:param name="action" value="editLesson"/>
	<portlet:param name="lessonId" value="${lessonId}"/>
	<portlet:param name="basicLesson" value='<%=GetterUtil.getString(request.getAttribute(Constant.BASIC_LESSON),Constant.NO_BASIC_LESSON)%>'/>
	<portlet:param name="fromPreviewEdit" value="yes" />
</portlet:renderURL>

<portlet:resourceURL var="publishLessonURL" id="publishLesson"/>

<div id="createLesson" class="row">	
<ul id="progressbar">
		<li class="active"><liferay-ui:message key="start" /></li>
		<li class="active"><liferay-ui:message key="overview" /></li>
		<li class="active"><liferay-ui:message key="content" /></li>
		<li class="active"><liferay-ui:message key="preview-and-save" /></li>
</ul>
<div class="progress-content">
	<div class="lesson-preview-save shadow">
		<div id="lessonToggler">
			<h1 class="header-toggler toggler-header-collapsed">
				${lessonName}&nbsp;<i class="icon-chevron-right"></i>
			</h1>
			<div class="content-toggler toggler-content-collapsed">
				<div class="row-fluid">
					<div class="span8">
						<div class="media">
							<img class="media-object pull-left" alt="lesson"
								src="${lessonThumbnail}">
							<div class="media-body">
								<%-- <h4 class="media-heading">${lessonName}</h4> --%>
								<p class="scroll-overFlow" style="max-height: 155px;">${lessonDescription}</p>
								<p> <liferay-ui:message key="tags" />:
									<liferay-ui:asset-tags-summary classPK="${lessonId}" className="<%=Lesson.class.getName() %>"></liferay-ui:asset-tags-summary>
								</p>
							</div>
							<!-- end media-body -->
						</div>
						<!-- end media -->
					</div>
					<!-- end span8 -->
					<div class="span4" style="margin-bottom: 0;">
						<div class="media">
							<c:if test="${empty groupPathDocumentPath}">
							<img class="media-object pull-left img-circle" alt="lesson"
								src="${authorImg}">
							</c:if>
							<c:if test="${!empty groupPathDocumentPath}">
							<img class="media-object pull-left img-circle" alt="lesson" style="height:100px;width:100px;"
								src="${groupPathDocumentPath}">
							</c:if>
								
							<div class="media-body">
								<c:if test="${empty userGroupName }">
										<p>	<a href="#"> ${authorName} </a> ${aboutAuthor}	</p>
								</c:if>
								<c:if test="${not empty userGroupName }">
										<p>	<a href="#"> ${userGroupName} </a></p>
								</c:if>
								<!-- <button class="btn btn-block btn-primary">Follow</button> -->
							</div>
							<!-- end media-body -->
						</div>
						<!-- end media -->
					</div>
					<!-- end span4 -->
				</div>
				<!-- end row-fluid -->
				<div class="row-fluid">
					<footer>
						<!-- <i class="icon-thumbs-up"> </i> <span> 56 </span> &nbsp; &nbsp; <i
							class="icon-eye-open"> </i> <span> 23 </span> &nbsp; &nbsp;
						&nbsp; &nbsp; <i class="icon-calendar"> </i> <span> 1h 23 </span> -->
					</footer>
				</div>
				<!-- end row-fluid -->
			</div>

		</div>
		<!-- end lessonToggler -->
	
		<!-- end row-fluid -->
		<div class="row-fluid">
			<div id="myCarouselSection" class="carousel slide">
				
				<!-- Carousel items -->
				<div class="carousel-inner">
					<c:forEach items="${documentSection}" var="document" varStatus="i">
						<c:set var="count" value="${count + 1}" scope="page"/>
						<c:if test="${count eq 1}">
							<div class="active item order-${count}">
						</c:if>
						<c:if test="${count ne 1}">
							<div class="item order-${count}">
						</c:if>
							<div class='row-fluid'>
								<div class="span6">
								
									<h3>${document.title}</h3>
									
									  <c:choose>
										<c:when test="${(fn:containsIgnoreCase(document.documentPath, 'docs.google.com'))}">
											<p style="height: 270px; width: 100%; text-align: center; border: 1px solid #cccccc;">
												<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>google-docs-img.jpg" style="width: 40%; margin: 18%;"/>
											</p>	
										</c:when>
										<c:otherwise>
											<p>
												<span class="iframe-hidden-data" data-iframeid="player-${count}" data-iframesrc="${document.documentPath}"></span>	
											</p>
										</c:otherwise>
									  </c:choose>
									
								</div>
									<!-- end span6 -->
								<div class="span6">
									<div class="text-justify  scroll-overFlow" style="margin-top: 27px; min-height: 278px;">${document.textContent}</div>
								</div>
							</div>
							<c:if test="${documentSection.size() ne 1}">
								<div class="w80">
									<h3><span>&nbsp;&nbsp;&nbsp;</span><script>document.writeln(unescape(unescape("${document.title}")))</script></h3>
									<span>&nbsp;</span>		
									<c:forEach items="${document.lessonObjective}" var="lessonObj" varStatus="i">
										<span class="label label-inverse">${lessonObj.objective}</span>
									</c:forEach>
									<a href="javascript:void(0)" class="pull-right">${count} of ${documentSection.size()}</a>
								</div>
							</c:if>
							</div>
					</c:forEach>
				</div>
				<c:if test="${documentSection.size() ne 1}">
					<a class="carousel-control left" href="#myCarouselSection" data-slide="prev">&lsaquo;</a>
					<a class="carousel-control right" href="#myCarouselSection" data-slide="next">&rsaquo;</a>
				</c:if>
				<%-- <ol class="unstyled inline">
	                <c:forEach items="${documentSection}" var="document" varStatus="i">
	               	 <c:set var="indexCount" value="${indexCount + 1}" scope="page"/>
						<li  data-target="#myCarouselSection" data-slide-to="${indexCount-1}"
							class="active"><a href="#"> ${indexCount} </a></li>
					</c:forEach>
				</ol>   --%>
			</div>
			 
			<div class="custom-alert section-process-alert">  						
				<div class="message-body" style="top:50%; margin-top:-75px"> 
						<h4 class="message-heading"> <i class="icon-info-sign" style="font-size: 30px;"></i> publishing</h4>
						<div class="content"> 
							<liferay-ui:message key="lesson-is-being-processed" /> 
							<br> <liferay-ui:message key="you-will-receive-notification-message-on-process-completion" />
							
						</div>
				</div>  <!--  end message-body --> 						
			</div> <!--  end custom-alert -->
			
			<div class="custom-alert section-draft-alert">  						
				<div class="message-body" style="top:50%; margin-top:-75px"> 
						<h4 class="message-heading"><i class="icon-info-sign" style="font-size: 30px;"></i> Save As Draft</h4>
						<div class="content"> 
							<liferay-ui:message key="lesson-is-being-saved-as-draft-and-available-in-my-lessons-under-my-stuff" />
						</div>
				</div>  <!--  end message-body --> 						
			</div> <!--  end custom-alert -->
	
			<!--end myCarouselSection -->
		</div>
		
		<div class="text-right">
			<input type="hidden" id="lessonId" value="${lessonId}"/>
			<input type="button" name="previous" class="previous btn btn-default" onclick="javascript:window.location.href='<%=previewEdit%>'" value='<liferay-ui:message key="back" />' /> 
			<button type="button" title="cancel" class="btn btn-default" onclick="cancelLesson('<%=homeUrl%>');"><liferay-ui:message key="cancel" /></button>
			<input type="button" class="btn btn-default" value='<liferay-ui:message key="save-draft" />' id="saveDraftLessonId" /> 
			<c:if test="${documentSection.size() gt 0}">
				<input type="button" class="btn btn-primary" value='<liferay-ui:message key="publish" />' id="publishDialogue"/>
			</c:if>
			<c:if test="${documentSection.size() le 0}">
				 <span class="hide" id='publishDialogue'></span>
				 <span class="btn btn-primary disabled nyu-tooltip" data-title='<liferay-ui:message key="atleast-one-section-required" />'><liferay-ui:message key="publish" /></span>
			</c:if>
		</div>
	</div>
	<!-- end lesson-preview-save -->
	<div id="publishModal"> </div> <!-- end adMediaModal --> 
	<div id="publishModalContent"> 
		<div id="publishTab" class="publish-lesson ny-you-tab"> 
			<!-- TAB LINKS -->
			<ul class="nav nav-tabs"> 
				<li class="active"><a href="#ShareWhere"><liferay-ui:message key="share-where" />?</a></li>			
				<li><a href="#Permissions"><liferay-ui:message key="permissions" /></a></li> 
			</ul> <!-- END TAB LINKS -->
		 
			<!-- TAB CONTENT -->
			<div class="tab-content">	
				<div id="ShareWhere" class="tab-pane">
					<ul class="unstyled">
						<li> <a class="row-fluid active public" data-share='public' href="#"> 
							<span class="span4"> 
								<i class="icon-globe"></i> 
								<span> <liferay-ui:message key="general" /> <BR> <liferay-ui:message key="public" /> </span> 
							</span> 
							<span class="span8"> 
								<liferay-ui:message key="via-social-media-etc" />.
							</span> 
						</a> </li>
						
						<li> <a class="row-fluid nyyou" data-share='nyyou' href="#"> 
							<span class="span4"> 
								<i class="icon-group"></i> 
								<span><liferay-ui:message key="x-community" arguments="<%=Constant.CURRENT_BRAND_NAME%>" /><BR> </span> 
							</span> 
							<span class="span8">
								<liferay-ui:message key="any-alumnus-faculty-staff-or-student" />
							</span> 
						</a> </li>
						
						<li id="privateList">
						<input type='hidden' id="selectedUserGroups" />
						<input type='hidden' id="selectedUsers" />
						 <a class="row-fluid private" data-share='private' href="#"> 
							<span class="span4"> 
								<i class="icon-user"></i> 
								<span> <liferay-ui:message key="private" /> <BR> <liferay-ui:message key="list" />  </span> 
							</span> 
							<span class="span8"> 
								<liferay-ui:message key="via-group-or-by-invitation-only" />
							</span> 
						</a> </li>
					</ul>
					<div id="groupAndInvitation" class="userGroupListController" style="display: none;" ng-controller = "lessonSectionController">
						<div id="previewUserGroupList" style="max-height:70px!important;" class="hide scroll-overFlow">
							<ul class="textboxlistentry-holder clearfix ny-you-category unstyled">
								
							</ul>
						</div>
						<div id="previewUserList" style="max-height:70px!important;" class="hide scroll-overFlow">
							<ul class="textboxlistentry-holder clearfix ny-you-category unstyled">
								
							</ul>
						</div>
						<div class="control-group userGroup">
							<div class="clearfix">
								<span class="pull-left">
									<c:if test="${!empty groupPathDocumentPath || not empty publishedProfile }">
										<input type="radio" checked="true" name="sharingType" id="userGroupRadio" />
									</c:if>
									<c:if test="${empty groupPathDocumentPath && empty publishedProfile}">
										<input type="radio"  name="sharingType" id="userGroupRadio" />
									</c:if>
								</span>
								<span class="pull-left">
									<label for="selectGroup" class="control-label"><strong> <liferay-ui:message key="select-user-groups" /></strong> </label>
								</span>
							</div>
							<div class="content hide">
								<div class="custom-search">  
									<i class="icon-search"></i>
									<input type="text" ng-model="searchuserGroup" name="Search" id="searchuserGroup" size="30" value="" placeholder='<liferay-ui:message key="search-place-holder" />'/> 
								</div>
								<ul class="scroll-overFlow unstyled UserGroup" style="max-height:100px;">
									<li ng-show="filteredUserGroup.length==0"><liferay-ui:message key="no-Groups-found" />.</li>
									<li class="text-left" ng-repeat="object in filteredUserGroup = (userGroupArray | filter:searchuserGroup)">
										<input type="checkbox" data-type="UserGroup" class="checkbox" ng-if="object.ischecked=='true'" checked="checked" value="{{object.userGroupId}}" lesson-section-single-directive/>
										<input type="checkbox" data-type="UserGroup" class="checkbox" ng-if="object.ischecked=='false'" value="{{object.userGroupId}}" lesson-section-single-directive />
										{{object.name}}
									</li>
								</ul>
							</div>
						</div>
						<div class="control-group user">
							<div class="clearfix">
								<span class="pull-left"><input type="radio" name="sharingType" id="userRadio" /></span>
									<span class="pull-left"><label for="selectCollaborators" class="control-label"><strong><liferay-ui:message key="select-users" /></strong></label>
								</span>
							</div>	 
							<div class="content hide">
								<div class="custom-search">  
									<i class="icon-search"></i>
									<input type="text" ng-model="searchuser" name="Search" id="searchuser" size="30" value="" placeholder='<liferay-ui:message key="search-place-holder" />'/> 
								</div>
								<ul class="scroll-overFlow unstyled User" style="max-height:100px;">
									<li ng-show="filteredUser.length==0"><liferay-ui:message key="no-users-found" />.</li>
									<li class="text-left" ng-repeat="object in filteredUser = (userArray | filter:searchuser)">
										<input type="checkbox" data-type="User" class="checkbox" ng-if="object.ischecked=='true'" checked="checked"  value="{{object.userId}}" lesson-section-single-directive />
										<input type="checkbox" data-type="User" class="checkbox" ng-if="object.ischecked=='false'" value="{{object.userId}}" lesson-section-single-directive/>
										{{object.name}}
									</li>
								</ul>
							</div>
						</div>
						<p class="text-right">
							<button  class="btn btn-primary"
								id="groupSelected" ng-click="clearSearch()" ><liferay-ui:message key="ok" /></button>
							<button class="btn" id="groupSelectedCancel" ng-click="clearSearch()"><liferay-ui:message key="cancel" /></button>
						</p>
					</div>
					<!-- end groupAndInvitation -->
				</div>
				<div id="Permissions" class="tab-pane"> 
					<ul class="unstyled">
						<li> <a class="row-fluid active view_reuse" data-permission='view_reuse' href="#"> 
							<span class="span4"> 
								<i class="icon-unlock"></i>
								<span><liferay-ui:message key="view-n-reuse" /></span> 
							</span> 
							<span class="span8">
								<liferay-ui:message key="users-can-view-the-lesson-users-can-take-the-lesson-or-parts-of-the-lesson-and-use-in-their-lessons" />.
							</span> 
						</a> </li>
						
						<li> <a class="row-fluid view_reuse_attribution" data-permission='view_reuse_attribution' href="#"> 
							<span class="span4"> 
								<i class="icon-share-alt"></i>
								<span><liferay-ui:message key="view-reuse-with-attribution" /> </span> 
							</span> 
							<span class="span8">
						<liferay-ui:message key="only-your-chosen-group-s-other-site-visitors-and-x-members-will-not-see-the-lesson" arguments="<%=Constant.CURRENT_BRAND_NAME%>" />
							</span> 
						</a> </li>
						<c:if test="${voilatingSection.size()>0}">
							<li  class='voilating text-center nyu-tooltip' data-title='<liferay-ui:message key="view-only-permission-is-disabled-because-one-of-the-sections-is-reusing-the-content-that-is-view-and-reuse-please-remove-the-section-to-publish-as-view-only-or-publish-the-lesson-with-view-n-reuse-permission" />'  style="border: 1px dashed #999999;color:#999999;padding:5px">
								<div class="row-fluid">
									<span class="span4"> 
										<i class="icon-lock"> </i>
										<span><liferay-ui:message key="view-only" /></span> 
									</span> 
									<span class="span8"><liferay-ui:message key="view-only" /> 
									</span>
								</div>
							</li>
						</c:if>
						<c:if test="${!(voilatingSection.size()>0)}">
							<li> <a class="row-fluid view" data-permission='view' href="#"> 
								<span class="span4"> 
									<i class="icon-lock"> </i>
									<span><liferay-ui:message key="view-only" /></span> 
								</span> 
								<span class="span8"><liferay-ui:message key="view-only" /></span> 
							</a> </li>
						</c:if>
					</ul> 
				</div> <!-- end Permissions -->
			</div> <!-- end tab-content -->
		</div> <!-- end publish lesson -->
		
		<footer class="clearfix"> 
			<a id="publishLessonCancel" class="btn" href="javascript:void(0);"> <liferay-ui:message key="cancel" /> </a>
			<div class="pull-right">			
				<a id="publishLessonNext" class="btn btn-primary" href="javascript:void(0);"> <liferay-ui:message key="next" /> </a>
				<a id="publishLessonBack" class="btn" href="javascript:void(0);" style="display: none;"> <liferay-ui:message key="back" /> </a>
				<a id="publishLessonPublish" class="btn btn-primary" href="javascript:void(0);"  style="display: none;"> <liferay-ui:message key="publish" /></a>
			</div>
		</footer>
	</div> <!-- end publishModalContent -->		
<!-- end span8 offset2 -->
</div>

<script type="text/javascript" src="<%=themeDisplay.getPathThemeJavaScript()%>/jquery/bootstrap.min.js"></script>    
<script>
$('#myCarouselSection').carousel({
	interval: false
});
	// TOGGLER USER INFO
YUI().use('aui-toggler', function(Y) {
	new Y.TogglerDelegate(
		{
			animated: true,
			closeAllOnExpand: true,
			container: '#lessonToggler',
			content: '.content-toggler',
			expanded: false,
			header: '.header-toggler',
			transition: {
			  duration: 0.2,
			  easing: 'cubic-bezier(0, 0.1, 0, 1)'
			}
		}
	);
});

(function(){
	$('#lessonToggler').find('h1').on('click',function(){
		$(this).find('i').toggleClass('icon-chevron-right, icon-chevron-down');
	});
	
	$('#publishLessonPublish').click(function(){
		var share = $('#ShareWhere li a.active').data("share");
		var sharelabel ='';
		var privateType = '';
		var privateValue = ''; 
		if(share == 'private'){
			if($('#groupAndInvitation #userRadio').is(':checked')){
				privateType = 'user';
				privateValue = $('#ShareWhere li #selectedUsers').val();
			}else{
				privateType = 'userGroup';
				privateValue = $('#ShareWhere li #selectedUserGroups').val();
			}
			sharelabel = 'Private List (via group or by invitation only)';
		}else if(share == '<%= Constant.PORTLET_PROP_SITE_NAME_SMALL %>'){
			sharelabel = '<%=Constant.CURRENT_BRAND_NAME%> Community (Any alumnus, faculty, staff or student)';
		}else{
			sharelabel = 'General Public (via social media, etc.)';
		}
		var permission = $('#Permissions li a.active').data("permission");
		AUI().use(
		  		'aui-modal',
		  		function(Y) {
		  			var modal = new Y.Modal(
		  			{
		  				bodyContent: '<p> <Strong><liferay-ui:message key="are-you-sure-you-want-your-lesson-to-be-published-to-the" /> '+sharelabel+'?</Strong></p>', centered: true,
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
		  								var lessonId = $("#lessonId").val();
		  								$('.section-process-alert').show();
		  								$.ajax({
		  									url : '<%=publishLessonURL%>',
		  								  	type : 'GET',
		  								  	async : true,
		  								  	data:{
		  								  		<portlet:namespace/>lessonId:lessonId,
			  								  	<portlet:namespace/>share :share,
		  								  		<portlet:namespace/>privateType :privateType,
		  								  		<portlet:namespace/>privateValue :privateValue,
		  										<portlet:namespace/>permission :permission
		  								  		
		  									  },
		  								  	success: function(data){
		  										setTimeout(function(){
		  											$('.section-process-alert').hide();
		  											window.location.href='<%=homeUrl%>';
		  										}, 2000);
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
	});

	$('#saveDraftLessonId').click(function(){
		
		$('.section-draft-alert').show();
		setTimeout(function(){
			$('.section-draft-alert').hide();
			window.location.href='<%=homeUrl%>';
				
		}, 2000);
		
	});
	
})();



</script>


<script>

function cancelLesson(homeUrl){
	AUI().use(
	  		'aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent: '<p> <Strong><liferay-ui:message key="do-you-want-to-discard-changes" />?</Strong></p>', centered: true,
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
									window.location.href=homeUrl;
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
};

$(function(){
	YUI().use('aui-modal','node-event-simulate','aui-tabview', function(Y) {
	    //TAB for Publish lesson
	    var publishLessonTab = new Y.TabView({ srcNode: '#publishTab' }); 
	    publishLessonTab.render();
	    
	    //MODAL for Publish lesson
	    var modal = new Y.Modal(
	      {
	                    contentBox: '#publishModalContent',
	                    centered: true,                 
	                    destroyOnHide: false,
	                    headerContent: '<h3 class="text-center"><liferay-ui:message key="publish-lesson" /></h3>',  
	                    modal: true,
	                    render: '#publishModal', 
	                    visible: false,
	                    width: 350,
	                    resizable: false
	      }
	    ).render(); 
	    
	    //Reset the modal box
	    Y.one('#publishDialogue').on('click', function() {
	                    modal.show(); 
	                    publishLessonTab.disableTab(1);
	                    Y.one('#publishTab.publish-lesson li:first-child').simulate('click');
	                    Y.one('#publishLessonBack').setStyle('display', 'none'); 
	                    Y.one('#publishLessonPublish').setStyle('display', 'none');  
	                    Y.one('#publishLessonNext').setStyle('display', 'inline-block');
	                    Y.one('#groupAndInvitation').setStyle('display', 'none');
	                    Y.one('#ShareWhere ul.unstyled').setStyle('display', 'inline-block');  
	                    var groupPathDocumentPath='${groupPathDocumentPath}';
	                    var publishedProfile='${publishedProfile}';
	                    if(groupPathDocumentPath.length>0 || publishedProfile.length>0){
	                   	$('#ShareWhere li a.active').removeClass('active');
	                   	$('#privateList a').addClass('active');
	                    }
	    });
	    
	    //Hiding modal box on click of cancel and publish button
	    Y.one('#publishLessonCancel').on('click',function(){
	    	Y.one('#publishTab.publish-lesson li:first-child').simulate('click');
	    	modal.hide();  
	    }); 
	    Y.one('#publishLessonPublish').on('click',function(){ modal.hide(); });      
	    
	    //On Click of back button hidding back and publish button with share where? tab
	    Y.one('#publishLessonBack').on('click',function(){ 
	                    this.setStyle('display', 'none');
	                    Y.one('#publishTab.publish-lesson li:first-child').simulate('click');
	                    Y.one('#publishLessonPublish').setStyle('display', 'none'); 
	                    Y.one('#publishLessonNext').setStyle('display', 'inline-block');
	    });
	    
	    //On Click of next button showing back and publish button with permission tab
	    Y.one('#publishLessonNext').on('click',function(){ 
	                    publishLessonTab.enableTab(1);
	                    this.setStyle('display', 'none');
	                    Y.one('#publishTab.publish-lesson li:last-child').simulate('click');
	                    Y.one('#publishLessonPublish').setStyle('display', 'inline-block');
	                    Y.one('#publishLessonBack').setStyle('display', 'inline-block'); 
	    }); 
	    
	    //On Click of Share Where? TAB button hiding back and publish button
	    Y.one('#publishTab.publish-lesson li:first-child').on('click',function(){ 
	                    Y.one('#publishLessonBack').setStyle('display', 'none'); 
	                    Y.one('#publishLessonPublish').setStyle('display', 'none'); 
	                    Y.one('#publishLessonNext').setStyle('display', 'inline-block');
	    });           
	    
	    //On Click of Share Where? TAB content showing permission tab 
	    Y.all('#ShareWhere li.permission-tab a').on('click',function(){ 
	                    Y.one('#publishLessonNext').setStyle('display', 'none'); 
	                    Y.one('#publishTab.publish-lesson li:last-child').simulate('click');
	                    Y.one('#publishLessonPublish').setStyle('display', 'inline-block');
	                    Y.one('#publishLessonBack').setStyle('display', 'inline-block'); 
	    }); 
	    
	}); 

	$('#privateList a').on('click', function(){
	    $(this).closest('ul.unstyled').hide();
	    $('#groupAndInvitation').show();
	    $('#publishLessonNext').hide();  
	    return false;
	}); 

	$('#ShareWhere li a').on('click', function(){ 
		$('#ShareWhere li a.active').removeClass('active');
		$(this).addClass('active');	
	});

	$('#Permissions li a').on('click', function(){ 
		$('#Permissions li a.active').removeClass('active');
		$(this).addClass('active');	
	});

	$('#groupSelected').on('click',function(){
		var userGroupId = '';
		var userId = '';
		if($('#groupAndInvitation #userGroupRadio').is(':checked')){
			$('#groupAndInvitation .userGroup input.checkbox').each(function(i){
				if($(this)[0].checked){
					if(userGroupId == ''){
						userGroupId =$(this).val();
					}else{
						userGroupId = userGroupId+','+$(this).val();
					}
				}
			});
			if(userGroupId.trim() == ''){
				<portlet:namespace/>customAlert('please select user Group');
			}else{
				$('#ShareWhere li a.active').removeClass('active');
				$('#ShareWhere li a.private').addClass('active');
				$('#publishLessonNext').show(); 
				$('#ShareWhere li #selectedUserGroups').val(userGroupId);
				$('#groupAndInvitation').hide().prev().show(); 
			}
		}else if($('#groupAndInvitation #userRadio').is(':checked')){
			$('#groupAndInvitation .user input.checkbox').each(function(i){
				if($(this)[0].checked){
					if(userId == ''){
						userId =$(this).val();
					}else{
						userId = userId+','+$(this).val();
					}
				}
			});
			if(userId.trim() == ''){
				<portlet:namespace/>customAlert('please select user');
			}else{
				$('#ShareWhere li a.active').removeClass('active');
				$('#ShareWhere li a.private').addClass('active');
				$('#publishLessonNext').show();
				$('#ShareWhere li #selectedUsers').val(userId);
				$('#groupAndInvitation').hide().prev().show(); 
			}
		}else{
			<portlet:namespace/>customAlert('<liferay-ui:message key="please-select-sharing-category" />');
		}
	});

	$('#groupSelectedCancel').on('click',function(){
		$('#ShareWhere li a.active').removeClass('active');
		$('#ShareWhere li a.public').addClass('active');
		$('#publishLessonNext').show();
		$('#groupAndInvitation').hide().prev().show();
	});

	$('#groupAndInvitation #userRadio').on('click',function(){
		$('#groupAndInvitation .userGroup .content').addClass('hide');
		$('#groupAndInvitation #previewUserGroupList').addClass('hide');
		$('#groupAndInvitation #previewUserList').removeClass('hide');
		$('#groupAndInvitation .user .content').removeClass('hide');
	});

	$('#groupAndInvitation #userGroupRadio').on('click',function(){
		$('#groupAndInvitation .userGroup .content').removeClass('hide');
		$('#groupAndInvitation #previewUserGroupList').removeClass('hide');
		$('#groupAndInvitation #previewUserList').addClass('hide');
		$('#groupAndInvitation .user .content').addClass('hide');
	});

	var userGroupArray =${userGroupArray};
	var lessonPrivacy = '${privacy}';
	var lessonPermission = '${permission}';
	var publishWithId = '${hiddenUserGroupIds}';
	if(publishWithId != null && publishWithId != ''){
		$('#ShareWhere li #selectedUserGroups').val('${hiddenUserGroupIds}');
	}
	if(lessonPrivacy != null && lessonPrivacy != ''){
		if(lessonPrivacy == 'private'){
			$('#ShareWhere li a.active').removeClass('active');
			$('#ShareWhere li a.private').addClass('active');
			$('#ShareWhere li #selectedUserGroups').val('${hiddenUserGroupIds}');
			$('#groupAndInvitation #userGroupRadio').attr('checked','checked');
			$('#groupAndInvitation .userGroup .content').removeClass('hide');
			$('#groupAndInvitation #previewUserGroupList').removeClass('hide');
			$('#groupAndInvitation #previewUserList').addClass('hide');
		}else if(lessonPrivacy == 'user'){
			$('#ShareWhere li a.active').removeClass('active');
			$('#ShareWhere li a.private').addClass('active');
			$('#ShareWhere li #selectedUsers').val('${hiddenUserIds}');
			$('#groupAndInvitation #userRadio').attr('checked','checked');
			$('#groupAndInvitation .user .content').removeClass('hide');
			$('#groupAndInvitation #previewUserGroupList').addClass('hide');
			$('#groupAndInvitation #previewUserList').removeClass('hide');
		}else if(lessonPrivacy == 'NYOU'){
			$('#ShareWhere li a.active').removeClass('active');
			$('#ShareWhere li a.nyyou').addClass('active');
		}else{
			$('#ShareWhere li a.active').removeClass('active');
			$('#ShareWhere li a.public').addClass('active');
		}
	}
	if(lessonPermission != null && lessonPermission != ''){
		if(lessonPermission == 'view_reuse'){
			$('#Permissions li a.active').removeClass('active');
			$('#Permissions li a.view_reuse').addClass('active');
		}else if(lessonPermission == 'view_reuse_attribution'){
			$('#Permissions li a.active').removeClass('active');
			$('#Permissions li a.view_reuse_attribution').addClass('active');	
		}else if(lessonPermission == 'view'){
			$('#Permissions li a.active').removeClass('active');
			$('#Permissions li a.view').addClass('active');
			if($('#Permissions li').hasClass('voilating')){
				$('#Permissions li a.active').removeClass('active');
				$('#Permissions li a.view_reuse').addClass('active');
			}
		}
	}
	var e = $('.userGroupListController');
	var scope = angular.element(e).scope();
	scope.userGroupArray = userGroupArray;
	scope.userArray = ${userArray};
	scope.$apply(function() {});
	});

	function <portlet:namespace/>customAlert(data){
		AUI().use('aui-modal',
			function(Y) {
				var modal = new Y.Modal(
				{
				bodyContent: '<p> <Strong>'+data+'</Strong></p>', centered: true,
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
	}
	//CARUOSEL LOADING ONE FRAME AT TIME SCRIPT<START>
	var ShowDocumentCarousel =null;
	
	$(function(){
		ShowDocumentCarousel = new carouselIframeLoader(1,${documentSection.size()},${documentSection.size()},"height: 277px; width: 100%; border:0;");
		ShowDocumentCarousel.createIframeInActiveItem($('.item.active'));
	});

	$('.carousel-control.right').click(function(){
		ShowDocumentCarousel.rightClick();
	});
	
	$('.carousel-control.left').click(function(){
		ShowDocumentCarousel.leftClick();
	});
	
	$('.carousel-indicators li').click(function(){
		ShowDocumentCarousel.indicatorsClick($(this)); 
	});
	
	//CARUOSEL LOADING ONE FRAME AT TIME SCRIPT<END>
	
	
</script>


