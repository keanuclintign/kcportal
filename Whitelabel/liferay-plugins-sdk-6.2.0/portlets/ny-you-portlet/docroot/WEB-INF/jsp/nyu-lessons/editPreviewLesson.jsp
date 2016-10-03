
<%@page import="com.nyu.util.Constant"%>
<div id="PreviewAndPublish" class="tab-pane">
	<div class="progress-content">
		<div class="lesson-preview-save">
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
									<p>
										Tags:
										 <liferay-ui:asset-tags-summary classPK="${lessonId}"
											className="<%=Lesson.class.getName() %>"></liferay-ui:asset-tags-summary>
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
									<img class="media-object pull-left img-circle" alt="lesson" style="height:100px;width:100px"
									src="${groupPathDocumentPath}">
							</c:if>
								<div class="media-body">
									<c:if test="${empty userGroupName }">
										<p>
											<a href="#"> ${authorName} </a> ${aboutAuthor}
										</p>
									</c:if>
									<c:if test="${not empty userGroupName }">
										<p>
											<a href="#"> ${userGroupName} </a> 
										</p>
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
					</div> <!-- end row-fluid -->
				</div> <!--  end toggler-content  -->
	
			</div> <!-- end lessonToggler -->
		
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
												<p style="height: 270px; width: 100%; text-align: center; border: 1px solid rgb(204, 204, 204);">
													<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>google-docs-img.jpg" style="width: 40%; margin: 14%;"/>
												</p>
											</c:when>
											<c:otherwise>
												<p style="height: 270px; width: 100%; border:0;">
													<span class="iframe-hidden-data" data-iframeid="player-${count}" data-iframesrc="${document.documentPath}"></span>	
												</p>
											</c:otherwise>
										  </c:choose>	
								</div>
									<!-- end span6 -->
								<div class="span6 scroll-overFlow" style="min-height: 277px; margin-top:25px;">
									${document.textContent}
								</div>
							</div>
							
							<c:if test="${documentSection.size() ne 1}">
							<div class="w80">
								<h3><span>&nbsp;&nbsp;&nbsp;</span><script>document.writeln(unescape(unescape("${document.title}")));</script></h3>
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
			</div>
			</div>
							
			</div> <!--end lesson-preview-save -->
				 <!-- <button type="button" title="cancel" class="btn btn-default" onclick="cancelLesson('');">
						Cancel</button> -->
				<div class="pull-right">
					<!-- <input type="button" class="btn btn-default" value="Save Draft" onclick="saveAsDraftInEdit()" /> -->
					 <input type="button" class="btn btn-default" onclick="cancelLesson('<%=homeUrl%>')" value='<liferay-ui:message key="cancel" />' />
					 <c:if test="${documentSection.size() gt 0}">
						 <c:if test = "${isCoAuthor}">
						 	<span class="hide" id='publishDialogue'></span>
						 	<input	type="button" class="btn btn-primary" value='<liferay-ui:message key="publish" />' id='coAuthorLessonPublish'/>
						 </c:if>
						 <c:if test="${!isCoAuthor}">
						 	<span class="hide" id='coAuthorLessonPublish'></span>
						 	<input	type="button" class="btn btn-primary" value='<liferay-ui:message key="publish" />' id='publishDialogue'/>
						 </c:if>
					 </c:if>
					 <c:if test="${documentSection.size() le 0}">
						 <span class="hide" id='publishDialogue'></span>
						 <span class="hide" id='coAuthorLessonPublish'></span>
						 <span class="btn btn-primary disabled nyu-tooltip" data-title='<liferay-ui:message key="atleast-one-section-required" />'><liferay-ui:message key="publish" /></span>
					 </c:if>
				</div>
				<br/>
	</div> <!--  end progress-content  -->
	<div class="custom-alert section-process-alert">  						
				<div class="message-body"> 
						<h4 class="message-heading"><i class="icon-info-sign" style="font-size: 30px;"></i> Republishing  </h4>
						<div class="content"> 
							<liferay-ui:message key="lesson-is-being-processed" /> 
							<br> <liferay-ui:message key="you-will-receive-notification-message-on-process-completion" />
						</div>
				</div>  <!--  end message-body --> 						
	</div> 
	<div class="custom-alert section-saveasdraft-alert">  						
				<div class="message-body"> 
						<h4 class="message-heading"><i class="icon-info-sign" style="font-size: 30px;"></i> Save As Draft </h4>
						<div class="content"> 
							<liferay-ui:message key="lesson-is-being-saved-as-draft-and-available-in-my-lessons-under-my-stuff" /><br>
						</div>
				</div>  <!--  end message-body --> 						
	</div> 
	<!-- Published Dialogue --> 
<div id="publishModal"> </div> <!-- end adMediaModal --> 
<div id="publishModalContent"> 
	<div id="publishTab" class="publish-lesson"> 
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
							<span><liferay-ui:message key="x-community" arguments="<%=Constant.CURRENT_BRAND_NAME%>"  /><BR> </span> 
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
							<input type="radio" name="sharingType" id="userGroupRadio" />
						</span>
						<span class="pull-left">
							<label for="selectGroup" class="control-label"><strong> Select User Groups</strong> </label>
						</span>
						</div>
						<div class="content hide">
							<div class="custom-search">  
								<i class="icon-search"></i>
								<input type="text" ng-model="searchuserGroup" name="Search" id="searchuserGroup" size="30" value="" placeholder="Search ..."/> 
							</div>
							<ul class="scroll-overFlow unstyled UserGroup" style="max-height:100px;">
								<li ng-show="filteredUserGroup.length==0">No Groups found.</li>
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
								<span class="pull-left"><label for="selectCollaborators" class="control-label"><strong>Select Users</strong></label>
							</span>
						</div>	 
						<div class="content hide">
							<div class="custom-search">  
								<i class="icon-search"></i>
								<input type="text" ng-model="searchuser" name="Search" id="searchuser" size="30" value="" placeholder="Search ..."/> 
							</div>
							<ul class="scroll-overFlow unstyled User" style="max-height:100px;">
								<li ng-show="filteredUser.length==0">No Users found.</li>
								<li class="text-left" ng-repeat="object in filteredUser = (userArray | filter:searchuser)">
									<input type="checkbox" data-type="User" class="checkbox" ng-if="object.ischecked=='true'" checked="checked"  value="{{object.userId}}" lesson-section-single-directive/>
									<input type="checkbox" data-type="User" class="checkbox" ng-if="object.ischecked=='false'" value="{{object.userId}}" lesson-section-single-directive />
									{{object.name}}
								</li>
							</ul>
						</div>
					</div>
					<p class="text-right">
						<button  class="btn btn-primary"
							id="groupSelected" ng-click="clearSearch()">Ok</button>
						<button class="btn" id="groupSelectedCancel" ng-click="clearSearch()">Cancel</button>
					</p>
				</div>
				<!-- end groupAndInvitation -->
			</div>
			<div id="Permissions" class="tab-pane"> 
				<ul class="unstyled">
					<li> <a class="row-fluid active view_reuse" data-permission='view_reuse' href="#"> 
						<span class="span4"> 
							<i class="icon-unlock"></i>
							<span> <liferay-ui:message key="view-n-reuse" /> </span> 
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
							<li  class='voilating text-center nyu-tooltip' data-title='"View Only" Permission is disabled because one of the sections is reusing the Content that is "View and Reuse". Please remove the section to publish as "View Only" or Publish the lesson with "View & Reuse" permission'  style="border: 1px dashed #999999;color:#999999;padding:5px">
								<div class="row-fluid">
									<span class="span4"> 
										<i class="icon-lock"> </i>
										<span><liferay-ui:message key="view-only" /></span> 
									</span> 
									<span class="span8"> <liferay-ui:message key="view-only" />  
									</span>
								</div>
							</li>
						</c:if>
						<c:if test="${!(voilatingSection.size()>0)}">
							<li> <a class="row-fluid view" data-permission='view' href="#"> 
								<span class="span4"> 
									<i class="icon-lock"> </i>
									<span><liferay-ui:message key="view-only" /> </span> 
								</span> 
								<span class="span8"> <liferay-ui:message key="view-only" /> </span> 
							</a> </li>
						</c:if>
				</ul> 
			</div> <!-- end Permissions -->
		</div> <!-- end tab-content -->
	</div> <!-- end publish lesson -->
	
	<footer class="clearfix"> 
		<a id="publishLessonCancel" class="btn" href="javascript:void(0);"> Cancel </a>
		<div class="pull-right">			
			<a id="publishLessonNext" class="btn btn-primary" href="javascript:void(0);"> Next </a>
			<a id="publishLessonBack" class="btn" href="javascript:void(0);" style="display: none;"> Back </a>
			<a id="publishLessonPublish" class="btn btn-primary" href="javascript:void(0);"  style="display: none;"> Publish </a>
		</div>
	</footer>
</div> <!-- end publishModalContent -->
</div> <!-- end PreviewAndPublish -->