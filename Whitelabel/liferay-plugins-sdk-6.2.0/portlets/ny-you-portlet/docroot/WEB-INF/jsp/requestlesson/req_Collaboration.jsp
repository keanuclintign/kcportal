<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portlet.documentlibrary.model.DLFileEntry"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page import="com.liferay.portlet.documentlibrary.service.DLFileEntryLocalServiceUtil"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.nyu.service.AnswerRequestLocalServiceUtil"%>
<%@page import="com.nyu.model.AnswerRequest"%>
<%@page import="com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="java.util.List"%>
<%@page import="com.nyu.model.RequestLesson"%>
<%@page import="com.nyu.service.RequestLessonLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="java.net.URLEncoder"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/requestLessons.js?<%=new Date().getTime()%>"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/main.js?<%=new Date().getTime()%>"></script>	
<portlet:resourceURL id="deleteLinkedLesson" var="deleteLinkedLessonURL"/>


<%
long requestLessonId=GetterUtil.getLong(((String)request.getAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID))); 

//String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),layout.isPrivateLayout(),themeDisplay);
//String createLessonUrl=siteFriendlyUrl+"/nyu-lessons?collaborationRequestId="+requestLessonId;

PortletURL createLessonUrl = PortletURLFactoryUtil.create(request, Constant.PORTLET_CREATE_LESSON, themeDisplay.getPlid(), PortletRequest.RENDER_PHASE);
createLessonUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, "");
createLessonUrl.setParameter(Constant.COLLABORATION_REQUEST_ID, request.getAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID).toString());
createLessonUrl.setWindowState(LiferayWindowState.MAXIMIZED);

String portletId = Constant.PORTLET_LESSON;
long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_LESSON_BROWSE).getPlid();
PortletURL showDocumentURL=PortletURLFactoryUtil.create(request, portletId, targetPlId, PortletRequest.RENDER_PHASE);
showDocumentURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);

PortletURL editUrl = PortletURLFactoryUtil.create(request, Constant.PORTLET_CREATE_LESSON, themeDisplay.getPlid(), PortletRequest.RENDER_PHASE);
editUrl.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_STRING_CONSTANT_EDIT_LESSON);
editUrl.setWindowState(LiferayWindowState.MAXIMIZED);

RequestLesson reqLesson = RequestLessonLocalServiceUtil.getRequestLesson(requestLessonId);


String facebookEmbedUrl=PortalUtil.getPortalURL(request)+"/web";
facebookEmbedUrl += themeDisplay.getScopeGroup().getFriendlyURL()+Constant.PAGE_HOME+"/-/homepage"+Constant.PAGE_LESSON_BROWSE+"/"+requestLessonId;

String embedurl=PortalUtil.getPortalURL(request)+"/group";
embedurl += themeDisplay.getScopeGroup().getFriendlyURL()+Constant.PAGE_REQUEST_LESSON+"/-/request/details/"+requestLessonId;
String FBShareUrl = URLEncoder.encode(embedurl, Constant.UTF_EIGHT);
String ShareUrl = URLEncoder.encode(embedurl, Constant.UTF_EIGHT);

%>

<portlet:renderURL var="showEmailURL" windowState="pop_up">
	<portlet:param name="action" value="email" />
	<portlet:param name="emailReqLessonId" value='<%=String.valueOf(requestLessonId)%>' />
	<portlet:param name="subject" value='<%=reqLesson.getName()%>' />
</portlet:renderURL>


<c:set var="FBShareUrl" value="<%=FBShareUrl%>"/>
<c:set var="ShareUrl" value="<%=ShareUrl%>"/>
<c:set var="EhowEmailURL" value="<%=showEmailURL%>"/>
<c:set var="EmbedUrl" value="<%=embedurl %>"/>
<portlet:resourceURL id="saveAnswer" var="saveAnswerURL" />
<portlet:resourceURL id="checkAnswer" var="checkAnswerURL"/>
<portlet:resourceURL id="addComment" var="addCommentURL" />
<portlet:resourceURL id="addAnswerComment" var="addAnswerCommentURL" />
<portlet:resourceURL id="appreciateAnswer" var="appreciateAnswerURL">
<portlet:resourceURL id="unAppreciateRequest" var="unAppreciateRequestURL"/>
<portlet:resourceURL id="unAppreciateAnswer" var="unAppreciateAnswerURL"/>
<portlet:param name="requestLessonId" value="<%=String.valueOf(requestLessonId)%>"/>
</portlet:resourceURL>
<portlet:resourceURL id="appreciateRequest" var="appreciateRequestURL"/>
<portlet:resourceURL id="unAppreciateRequest" var="unAppreciateRequestURL"/>
<portlet:resourceURL var="collaborateLinkToLesson" id="collaborateLinkToLesson"/>
<portlet:resourceURL id="deleteComments" var="deleteCommentsURL"/>
<div class="container" id="answerRequestController" ng-controller="requestLessonsController">
	<div class="row-fluid">
		<%@include file="navigation.jsp" %>
		<div class="span9" id="requestForInfo">
			<div class="request-raised">
			
				<header ng-show="requestLesson.categories.length!=0"> 
				<h3>
				<i class="icon-folder-close"> </i>
				<span ng-repeat="category in requestLesson.categories" ng-cloak>{{category.name}} 
				</span> 
				</h3>
				</header>
				
				<div class="request-content" ng-cloak>
					<p>{{requestLesson.name}}
					<span style="display:none;" id="requestId">{{requestLesson.requestLessonId}}</span>
					<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-user-group.gif" class="pull-right">
					</p>
					<p> 
						{{requestLesson.userName}}&nbsp; &nbsp;
						<span> {{requestLesson.createDate}} </span> &nbsp; &nbsp;  &nbsp; &nbsp;
						<span>  <i class="icon-thumbs-up appreciateAnswer"></i> {{requestLesson.appreciatedCount}} </span> &nbsp; &nbsp;
						<span ng-if="answers.length!=0" class="label label-success">
							 <liferay-ui:message key="answered" /> 
						</span> 
						<span ng-if="answers.length==0" class="label label-default">
							 <liferay-ui:message key="no-answer-yet" />
						</span>
						 
					</p>
				</div> <!-- end request-content -->
				<footer>
				<a href="javascript:void(0);" id="share-button" class="dropdown" onclick="myEmailPopup('${EhowEmailURL}')">
					<span class="icon-share" aria-hidden="true"></span>&nbsp;&nbsp;<liferay-ui:message key="share-via-email" />&nbsp;&nbsp;&nbsp;</a>
					
					<span ng-if="requestLesson.userId==authorId">
						<i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="you-cannot-appreciate-your-own-request" />'> </i>
					</span>
					
					<span ng-if="requestLesson.hasAppreciated &&  requestLesson.userId!=authorId">
					<a clas="appreciateAnswer"  ng-click="unAppreciateRequest('<%=unAppreciateRequestURL.toString()%>',requestLesson.requestLessonId)">
				    <i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="already-appreciated" />'> </i>
				    </a>
				    </span>
				   
				    <span ng-if="!requestLesson.hasAppreciated && requestLesson.userId!=authorId">
				    <a clas="appreciateAnswer"  ng-click="appreciateRequest('<%=appreciateRequestURL.toString()%>',requestLesson.requestLessonId)">
				    <i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="appreciate-this" />'></i></a>
				  	</span> &nbsp; &nbsp;
				  	
					<!-- <i class="icon-star"></i> &nbsp; &nbsp; -->
					
					<span ng-cloak> {{comments.length}} </span> 
					<a href="javascript:void(0)" class="add-comment">
						<span ng-if="comments.length > 1"> <liferay-ui:message key="comments" /> </span>
						<span ng-if="comments.length <= 1"> <liferay-ui:message key="comment" /> </span>
					</a> 
					<div class="show-hide-comments" style="display:none;">
						<div class="control-group"> 
							<label class="sr-only" for="inputComment"> 
								<liferay-ui:message key="comments" /> 
							</label> 
							<div class="controls"> 
								<textarea name="inputComment" id="inputComment" class="input-block-level" rows="5"></textarea>
							</div>
							<button id="addComment" class="btn"> 
								<liferay-ui:message key="add-comment" /> 
							</button>
						</div>
						<!-- ADD COMENTS -->
						<ul class="group-list unstyled">
							<li class="group-list-item" ng-repeat="comment in comments">
							
								<p ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right:20px;">
								<a class="cursor-pointer " ng-click="deleteComment('<%=deleteCommentsURL %>',requestLesson.requestLessonId,'0',comment.commentId)">
								<i class="icon-trash"></i>
								</a>
								</p>
							
								<div class="media"> 
									<img ng-src="{{comment.documentPath}}" style="width: 64px; height: 64px;" alt="" class="media-object pull-left"> 
									<div class="media-body"> 
										<p>{{comment.description}}</p>
										<a href="#">{{comment.userName}} </a> &nbsp; &nbsp; {{comment.createDate}}
									</div> <!-- end media-body -->
								</div> <!-- end media -->
							</li> <!-- end group-list-item --> 
							
						</ul> <!-- end group-list-item -->
					</div> <!-- end show-hide-comments -->
				</footer>
			</div> <!-- end request-raised -->
			
			<div ng-if="requestLesson.createdBy!=userId" class="row-fluid">
				<div class="span4">
					<liferay-ui:message key="looking-to-collaborate-on-a-lesson" />?  
				</div>
				<div class="span8">
					<button class="btn btn-primary" id="linkToLesson"> 
						<liferay-ui:message key="link-to-a-lesson" /> 
					</button>
					<span> <liferay-ui:message key="or" /> </span>
					<button class="btn btn-primary" id="createLesson"> 
						<liferay-ui:message key="create-a-lesson-s" /> 
					</button>
				</div>
			</div>
			<div class="row-fluid">
				<div class="span12">
				<h1>
					<liferay-ui:message key="linked-lessons" />
				</h1>
					<span ng-if="answers.length==0" ng-cloak> 
						<liferay-ui:message key="no-lessons-are-linked" />. 
					</span> 
				<ul class="unstyled">	
					<li class="answered-request" ng-repeat="answer in answers"> 				         
						<div class="request-content" >
							<p ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right: 2px; position: relative; z-index: 1;">
								<a title='<liferay-ui:message key="delete-answer" />' class="nyu-tooltip cursor-pointer" ng-click="deleteLinkedLesson('<%=deleteLinkedLessonURL %>',answer.answerRequestId,answer.collaborationId,requestLesson.requestLessonId)">
									<i class="icon-trash"></i>
								</a>
							</p>
						
							<p ng-cloak><i style="font-size: 24px; position: relative; top: 5px;" class="fa fa-chevron-circle-right"></i>
								<a ng-if="answer.lessonStatus=='published'" href="<%=showDocumentURL%>&_<%=Constant.PORTLET_LESSON%>_lessonId={{answer.lessonId}}">
									{{answer.lessonName}}</a>
									
								<a ng-if="answer.lessonStatus=='draft'" href="<%=editUrl%>&_<%=Constant.PORTLET_CREATE_LESSON%>_lessonId={{answer.lessonId}}">
									{{answer.lessonName}}
								</a>
							</p>
							<!-- <p><a href="#" class="btn btn-link"> {{answers.lessonName}} </a></p> -->
							<p ng-cloak> 
								<liferay-ui:message key="answered-by" /> &nbsp; &nbsp;{{answer.answeredBy}} &nbsp; &nbsp;	
								<span>{{answer.duration}}</span> 
							</p>
						</div> <!-- end request-content -->
					</li> <!--  end answered-request -->
				</ul>	
					
				</div> <!-- end span12 -->
			</div>
			
			<div class="custom-alert lesson-linked-success-alert" style="z-index: 100;">  						
				<div class="message-body" style="top:50%; margin-top:-75px"> 
					<h4 class="message-heading"><i class="icon-info-sign" style="font-size: 30px;"></i></h4>
					<div class="content"> 
						<liferay-ui:message key="lesson-linked-successfully" />
					</div>
				</div>  <!--  end message-body --> 						
			</div> <!--  end custom-alert -->
			
	</div> <!-- end rowfluid -->
	
	<%@include file="createRequest.jsp" %>
		
</div> <!-- end container -->

<div id="addRequestPopUp"> </div>

<div id="linkToLessonModal"> </div>
<div id="linkLessonModalContent" ng-cloak>  
<p class="alert-danger alert" style="display:none; margin:0 15px" id="linkedLessonError"></p>
	<ul class="unstyled group-list scroll-overFlow" >
		
	<li><p>
		<liferay-ui:message key="choose-a-lesson-from-your-draft-and-published-lessons" />
	</p></li>
	<li class="group-list-item" ng-repeat="lesson in colloborationLessonJson" >
		<div class="media">
			<img class="pull-left media-object img-polaroid" ng-src="{{lesson.thumbnailPath}}"> 
			<div class="media-body">
				<b> 
					<span ng-if="lesson.categories.length==0">	&nbsp;</span>
				 	<span ng-if="lesson.categories.length>0">{{lesson.categories}}</span>
				</b>
				<h3 class="media-heading text-info"> {{lesson.lessonName}}</h3> 
				<p>{{lesson.lessonDescription}}</p>
			</div>
		</div>
		<div class="text-center">
		<a href="#" class="btn btn-primary link-to-this-lesson" ng-click="collaborateLinkToLesson(lesson.lessonId,requestLesson.requestLessonId,'<%=collaborateLinkToLesson%>')"> 
			<liferay-ui:message key="link-to-this-lesson" /> 
		</a> </div>
	</li>
	</ul>
</div>

<script>
var linkToLessonModal;
	(function(){
		
		$('.add-comment').on('click',function(){
			text = $(this).find('span').text().trim();
			$(this).find('span').text(text=='Hide Comments'?'Comments':text=='Hide Comment'?'Comment':text=='Comment'?'Hide Comment':text=='Comments'?'Hide Comments':'Comments');
			$(this).siblings('.show-hide-comments').fadeToggle();
			$(this).siblings('.show-request-answer').fadeOut();
		});
		
		
		$('#addComment').on('click',function(){ 
			var body=$("#inputComment").val();
			if(body == null || body.trim().length==0){
				showValidationAlert('<liferay-ui:message key="please-enter-the-comment" />');
			}else if(body.trim().length > 500){
				showValidationAlert('<liferay-ui:message key="Please-enter-comments-below-500-characters" />');
				
			}else{
			  $.ajax({
			        url:'<%=addCommentURL%>',
			        type: 'GET',
			        datatype:'html',
			        data:{
			        	"<portlet:namespace />body": body,
			        	"<portlet:namespace />requestLessonId":'<%=requestLessonId%>'
			        },
			        success: function(data){
			        	var e = $('#answerRequestController');
			    		var scope = angular.element(e).scope();
			    		scope.$apply(function() {
			    			scope.comments=JSON.parse(data);
			    			$("#inputComment").val("");
			    		});  	
			    		
			         }
			      });
			}
			
		});
		
		  
		// MODAL FOR BROWSE LESSON LINK
			YUI().use('aui-modal', function(Y) {
	  			
				linkToLessonModal = new Y.Modal(
				  {
					contentBox: '#linkLessonModalContent', 
					centered: true,		
					destroyOnHide: false,
					headerContent: '<h4><liferay-ui:message key="link-to-a-lesson" /></h4>',  
					modal: true,
					render: '#linkToLessonModal', 
					visible: false,
					width: 450
				  }
				).render(); 
				
				linkToLessonModal.addToolbar([{
					label: '<liferay-ui:message key="cancel" />',
					on: {	
						click: function() { linkToLessonModal.hide(); }	
					}
				}]);
				
				
				Y.all('#linkToLesson').on('click', function() {
					$("#linkLessonModalContent").show();
					linkToLessonModal.show();
					Y.one('#linkToLessonModal .yui3-widget-mask').removeClass('hide');
					Y.one('#linkedLessonError').empty();
					Y.one('#linkedLessonError').hide();
				});
				
				
				
			});
	})();
	
	
	$(document).ready(function(){
		var e = $('#answerRequestController');
		var scope = angular.element(e).scope();
		$("#linkLessonModalContent").hide();
		scope.$apply(function() {
			
			scope.requestLesson=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_JSON)%>));
			scope.tagsrequest=scope.requestLesson;
			scope.answers=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_JSON)%>));
			scope.comments=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_COMMENTS_JSON)%>));
			scope.answerComments=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_COMMENTS_JSON)%>));
			scope.colloborationLessonJson=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_COLLABORATION_LESSON_JSON)%>));
			scope.authorId='<%=PortalUtil.getUser(request).getUserId()%>';
			scope.userId='<%=PortalUtil.getUser(request).getUserId()%>';
			
		});  
		
		$('#createLesson').click(function(){
			window.location.href='<%=createLessonUrl%>';
		});
	})
	
</script>

<script>

	AUI().use('node', 'node-focusmanager', function (A) {
			
			var doc = A.one(document),
			toggler = A.one('#share-button'),
			dropdown = A.one('#share-btn-menu');
			
			toggler.on('click', function(e) {
				dropdown.toggleClass('show');
				e.preventDefault();
				e.stopPropagation();
			});
			
			doc.on('click', function() {
				dropdown.removeClass('show');
			});
		});

	function myEmailPopup(url) {
		Liferay.Util.openWindow(
			{
				dialog: {
					width: 600,
					height:500,
					align: Liferay.Util.Window.ALIGN_CENTER,
					cache: false,
					destroyOnClose:true,
					destroyOnHide:true,
					modal: true
				},
				
				title: '<liferay-ui:message key="share-via-email" />',
				id: 'myEmailPopupId',				
				uri: url
			}
		);
	}

	</script>
	
	<script>

	function embedUrl(url) {
		
		AUI().use(
		  		'aui-modal',
		  		function(Y) {
		  			var modal = new Y.Modal(
		  			{
		  				bodyContent: '<b>'+url+'</b>',
		  				centered: true,
		  				headerContent:'<strong><liferay-ui:message key="copy-this-url" /></strong>', 
		  				modal: true,
		  				render: '#embedUrl',
		  				width: 750,
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
		  			}
		  		).render();
		  	  	});
	}

</script>