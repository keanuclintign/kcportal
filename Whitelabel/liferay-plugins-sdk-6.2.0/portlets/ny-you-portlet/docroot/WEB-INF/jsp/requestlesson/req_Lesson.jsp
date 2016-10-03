<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
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
	
	
<%
long requestLessonId=GetterUtil.getLong(((String)request.getAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID))); 

String portletId = Constant.PORTLET_LESSON;
long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(),Constant.PAGE_LESSON_BROWSE).getPlid();
PortletURL showDocumentURL=PortletURLFactoryUtil.create(request, portletId, targetPlId, PortletRequest.RENDER_PHASE);
showDocumentURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);

RequestLesson reqLesson = RequestLessonLocalServiceUtil.getRequestLesson(requestLessonId);


String facebookEmbedUrl=PortalUtil.getPortalURL(request)+"/web";
facebookEmbedUrl += themeDisplay.getScopeGroup().getFriendlyURL()+Constant.PAGE_HOME+"/-/homepage"+Constant.PAGE_LESSON_BROWSE+"/"+requestLessonId;

String embedurl=PortalUtil.getPortalURL(request)+"/group";
embedurl += themeDisplay.getScopeGroup().getFriendlyURL()+Constant.PAGE_REQUEST_LESSON+"/-/request/details/"+requestLessonId;
String FBShareUrl = URLEncoder.encode(embedurl, Constant.UTF_EIGHT);
String ShareUrl = URLEncoder.encode(embedurl, Constant.UTF_EIGHT);
%>

<portlet:renderURL var="myLessonsURL" windowState="pop_up">
	<portlet:param name="action" value="addmyLessons" />
</portlet:renderURL> 

<portlet:renderURL var="myFavouriteLessonsURL" windowState="pop_up">
	<portlet:param name="action" value="addmyFavouriteLessons" />
</portlet:renderURL> 

<portlet:renderURL var="showEmailURL" windowState="pop_up">
	<portlet:param name="action" value="email" />
	<portlet:param name="emailReqLessonId" value='<%=String.valueOf(requestLessonId)%>' />
	<portlet:param name="subject" value='<%=reqLesson.getName() %>' />
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
<portlet:param name="requestLessonId" value="<%=String.valueOf(requestLessonId)%>"/>
</portlet:resourceURL>
<portlet:resourceURL id="appreciateRequest" var="appreciateRequestURL"/>
<portlet:resourceURL id="unAppreciateRequest" var="unAppreciateRequestURL"/>
<portlet:resourceURL id="unAppreciateAnswer" var="unAppreciateAnswerURL"/>
<portlet:resourceURL id="deleteComments" var="deleteCommentsURL"/>
<portlet:resourceURL id="deleteAnswer" var="deleteAnswerURL"/>
<style>
 .morecontent span {
display: none;
}
</style>


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
					<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-lesson.gif" class="pull-right">
					</p>
					<p> 
						{{requestLesson.userName}} 	&nbsp; &nbsp;
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
				<footer class="clearfix">
					<!-- <i class="icon-random"></i> &nbsp; &nbsp; -->
					
					<a href="javascript:void(0);" id="share-button" class="dropdown" onclick="myEmailPopup('${EhowEmailURL}')">
					<span class="icon-share" aria-hidden="true"></span>&nbsp;&nbsp;<liferay-ui:message key="share-via-email" />&nbsp;&nbsp;&nbsp;</a>
					<%-- <li class="dropdown ">
						<a href="javascript:void(0)" id="share-button"> <i class="icon-random"> </i>  Share </a>
						<ul id="share-btn-menu" class="dropdown-menu" aria-labelledby="share-menu" role="menu">
							<li><a href="http://www.facebook.com/sharer/sharer.php?u=${ShareUrl}&title={{requestLesson.name}}" onclick="javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;" class="icon-facebook">&nbsp;&nbsp;FaceBook</a></li>
							<li><a href="https://plus.google.com/share?url=${ShareUrl}" onclick="javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;" class="icon-google-plus">&nbsp;&nbsp;Google</a></li>
							<li><a href="http://www.linkedin.com/shareArticle?mini=true&url=${ShareUrl}&title={{requestLesson.name}}&source=http://google.com" onclick="javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;" class="icon-linkedin">&nbsp;&nbsp;Linkedin</a></li>
							<li><a href="http://twitter.com/home?status={{requestLesson.name}}+${ShareUrl}" onclick="javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;" class="icon-twitter">&nbsp;&nbsp;Twitter</a></li>
							<li><a href="javascript:void(0);" class="dropdown-toggle" onclick="myEmailPopup('${EhowEmailURL}')"><span class="icon-share" aria-hidden="true"></span>&nbsp;&nbsp;Email</a></li>
							<li><a href="javascript:void(0);" class="dropdown-toggle" onclick="embedUrl('${EmbedUrl}')"><span class="icon-chevron-left" aria-hidden='true'></span><span class="icon-chevron-right" aria-hidden='true'></span>&nbsp;Embed This</a></li>
						</ul>
						<ul id="share-btn-menu" class="dropdown-menu" aria-labelledby="share-menu" role="menu">
							<li><a class="icon-facebook" title="Work in progress">&nbsp;&nbsp;FaceBook</a></li>
							<li><a class="icon-google-plus" title="Work in progress">&nbsp;&nbsp;Google</a></li>
							<li><a class="icon-linkedin" title="Work in progress">&nbsp;&nbsp;Linkedin</a></li>
							<li><a href="http://twitter.com/home?status={{requestLesson.name}}+${ShareUrl}" onclick="javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;" class="icon-twitter">&nbsp;&nbsp;Twitter</a></li>
							<li><a href="javascript:void(0);" class="dropdown-toggle" onclick="myEmailPopup('${EhowEmailURL}')"><span class="icon-share" aria-hidden="true"></span>&nbsp;&nbsp;Email</a></li>
						</ul>
					</li> --%>
				
					
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
					  		
					<input type="button" value='<liferay-ui:message key="answer-this-request" />'  ng-show="requestLesson.userId!=authorId" class="btn btn-primary pull-right" id="answerRequest"> 
					
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
							
								<p ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right: 20px; position: relative; z-index: 1;">
								<a title='<liferay-ui:message key="delete-comment" />' class="nyu-tooltip cursor-pointer " ng-click="deleteComment('<%=deleteCommentsURL %>',requestLesson.requestLessonId,'0',comment.commentId)">
								<i class="icon-trash"></i>
								</a>
								</p>
								
								<div class="media"> 
									<img ng-src="{{comment.documentPath}}" style="width: 64px; height: 64px;" alt="" class="media-object pull-left"> 
									<div class="media-body"> 
										<p>{{comment.description}}</p>
										<a href="javascript:void(0);">{{comment.userName}} </a> &nbsp; &nbsp; {{comment.createDate}}
									</div> <!-- end media-body -->
								</div> <!-- end media -->
							</li> <!-- end group-list-item --> 
							
						</ul> <!-- end group-list-item -->
					</div> <!-- end show-hide-comments -->
					
					<!-- SAVE AND CANCEL ANSWER -->
					<div class="control-group show-request-answer"> 
						<div class="controls"> 
							<h3> 
								<liferay-ui:message key="answer-this-request" /> 
							</h3> 
							<liferay-ui:input-editor name="discussionMessage" initMethod="" skipEditorLoading="false"
										 toolbarSet="edit-in-place"  ></liferay-ui:input-editor>
						</div>
						
						<div class="controls"> 
							<h3 class="text-info"> 
								<liferay-ui:message key="link-to-a-lesson" /> 
							</h3>
							<a href="javascript:void(0);" class="btn btn-primary"
								onclick="<portlet:namespace/>myLessons('<%=myLessonsURL.toString()%>','My Lessons')">
									<liferay-ui:message key="browse-my-lessons" />
								</a>
							<%-- <span> Or </span>
							<a href="javascript:void(0);" class="btn btn-primary"
								onclick="<portlet:namespace/>myFavouriteLessons('<%=myFavouriteLessonsURL.toString()%>','My Favourite Lessons')">Grab From Favourites</a> --%>
						</div>
						<div class="controls text-right">
						<input type="hidden" name="selectedMyLessonIds" class="selected-myLesson-ids" value="" id="myLessonIds"/>
						<input type="hidden" name="selectedMyFavLessonIds" class="selected-myFavLesson-ids" value="" id="myFavLessonIds"/>
							<button id="saveAnswer" class="btn btn-primary"> 
								<liferay-ui:message key="submit" />
							</button>
							<button id="cancelAnswer" class="btn"> 
								<liferay-ui:message key="cancel" /> 
							</button>
						</div>
					</div>						
				</footer>
			</div> <!-- end request-raised -->
	 
	<div id="nyYouTab" class="request-answer">
		<h4 style="position: absolute; left: 0px;" ng-cloak> <i class="icon-user"></i> <span ng-cloak>{{answers.length}}</span> 
			<span ng-if="answers.length > 1"> <liferay-ui:message key="answers" /> </span>
			<span ng-if="answers.length <= 1"> <liferay-ui:message key="answer" /> </span>
		</h4>
		<!-- TAB LINKS -->
		<ul class="nav nav-tabs"> 
			<li class="active"><a href="#Latest">
				<liferay-ui:message key="latest" />
			</a></li> 
			<li ><a href="#popular">
				<liferay-ui:message key="popular" />
			</a></li>			
		</ul> <!-- END TAB LINKS -->
	 
		<!-- TAB CONTENT -->
		<div class="tab-content" >	
			<div id="Latest" class="tab-pane">
				<p ng-show="answers.length==0">
					<liferay-ui:message key="no-answers-found" />.
				</p>
				<div class="answered-request"  ng-repeat="answer in answers " my-answer-comment-directive> 
					<div class="request-content" >
					
						<p ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right: 20px; position: relative; z-index: 1;">
						<a title='<liferay-ui:message key="delete-answer" />' class="nyu-tooltip cursor-pointer " ng-click="deleteAnswer('<%=deleteAnswerURL %>',requestLesson.requestLessonId,answer.answerId)">
						<i class="icon-trash"></i>
						</a>
						</p>
					
						<p class="more change-to-html" style="word-break: break-all; word-wrap: break-word;">{{answer.description}}</p>				
						<p>
						<i style="font-size: 24px; position: relative; top: 5px;" class="fa fa-chevron-circle-right"></i>
						<a href="<%=showDocumentURL%>&_<%=Constant.PORTLET_LESSON%>_lessonId={{answer.lessonId}}">{{answer.lessonName}}</a>
						</p>
						<p> <liferay-ui:message key="answered" /> &nbsp; &nbsp;{{answer.createDate}}&nbsp; &nbsp; <liferay-ui:message key="by" />
							{{answer.userName}}&nbsp; &nbsp; &nbsp; &nbsp;  
							<i class="icon-thumbs-up"> </i> {{answer.appreciatedCount}}
							<label class="pull-right" ng-if=answer.checked>
							
								<span ng-if=authorId==requestLesson.userId>
								<input type="checkbox" style="margin: 0px;" name="checkAnswer"  class="myQuestionAnswer" checked="true" value="{{answer.answerId}}" >
									<liferay-ui:message key="this-answers-my-question" />
								</span>
								
								<span ng-if=authorId!=requestLesson.userId>
								<input type="checkbox" style="margin: 0px;" name="checkAnswer"  class="myQuestionAnswer" checked="true" value="{{answer.answerId}}" disabled="true" >
								<liferay-ui:message key="this-answers-my-question" />
								</span>
								
							</label>
							
							<label class="pull-right" ng-if=!answer.checked>
								<span ng-if=authorId==requestLesson.userId>
								<input type="checkbox" style="margin: 0px;"  name="checkAnswer"  class="myQuestionAnswer"  value="{{answer.answerId}}" >
								<liferay-ui:message key="this-answers-my-question" />
								</span>
								<span ng-if=authorId!=requestLesson.userId>
								<input type="checkbox" style="margin: 0px;"  name="checkAnswer"  class="myQuestionAnswer"  value="{{answer.answerId}}" disabled="true">
								<liferay-ui:message key="this-answers-my-question" />
								</span>
								
							</label>
						</p>
					</div> <!-- end request-content -->
					<footer>
						<span ng-if="answer.userId==authorId">
						<i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="you-cannot-appreciate-your-own-answer" />'> </i>
						</span>
						
						<span ng-if="answer.hasAppreciated &&  answer.userId!=authorId">
						<a clas="appreciateAnswer"  ng-click="unAppreciateAnswer('<%=unAppreciateAnswerURL.toString()%>',answer.answerId,'<%=Constant.REQUEST_LESSON%>')" >
					    <i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="already-appreciated" />'> </i>
					    </a>
					    </span>
					    
					    <span ng-if="!answer.hasAppreciated && answer.userId!=authorId">
					    <a clas="appreciateAnswer"  ng-click="appreciateAnswer('<%=appreciateAnswerURL.toString()%>',answer.answerId)" >
					    <i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="appreciate-this" />'></i></a>
					    </span>&nbsp; &nbsp;
					    
						<span>{{filterComments.length}}</span> <a href="javascript:void(0)" class="add-comment" > 
							<span ng-if="filterComments.length > 1"> <liferay-ui:message key="comments" /> </span>
							<span ng-if="filterComments.length <= 1"> <liferay-ui:message key="comment" /> </span>
						</a>
						<div class="show-hide-comments" style="display:none;">
						<div class="control-group"> 
							<label class="sr-only" for="inputComment"> 
								<liferay-ui:message key="comments" />
							</label> 
							<div class="controls"> 
								<textarea name="inputComment"  class="input-block-level inputAnswerComment" rows="5"></textarea>
							</div>
							<button id="addAnswerComment" class="btn" ng-click="addAnswerComments($event,'<%=addAnswerCommentURL.toString()%>',answer.answerId)"> 
								<liferay-ui:message key="add-comment" />
							</button>
						</div>
						<!-- ADD COMENTS -->
						<ul class="group-list unstyled">
								
							<li class="group-list-item" ng-repeat="comment in filterComments=(answerComments | filter:{answerId:answer.answerId})">
								
								<p ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right: 20px; position: relative; z-index: 1;">
								<a title='<liferay-ui:message key="delete-comment" />' class="nyu-tooltip cursor-pointer " ng-click="deleteComment('<%=deleteCommentsURL %>',requestLesson.requestLessonId,comment.commentId,'0')">
								<i class="icon-trash"></i>
								</a>
								</p>	
								
								
								<div class="media"> 
									<img ng-src="{{comment.documentPath}}" style="width: 64px; height: 64px;" alt="" class="media-object pull-left"> 
									<div class="media-body"> 
										<p>{{comment.description}}</p>
										<a href="javascript:void(0);">{{comment.userName}} </a> &nbsp; &nbsp; {{comment.createDate}}
									</div> <!-- end media-body -->
								</div> <!-- end media -->
							</li> <!-- end group-list-item --> 
							
						</ul> <!-- end group-list-item -->
					</div> <!-- end show-hide-comments -->
					</footer>
				</div> <!-- end answered-request -->
				
				
				
			</div> <!-- end popular -->
		<div id="popular " class="tab-pane ">
			<p ng-show="answers.length==0"><liferay-ui:message key="no-answers-found" />.</p>
			<div class="answered-request "  ng-repeat="answer in answers | orderBy:'-appreciatedCount'" my-answer-comment-directive> 
				         
					<div class="request-content" >
					
						<p ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right: 20px; position: relative; z-index: 1;">
						<a title='<liferay-ui:message key="delete-answer" />' class="nyu-tooltip cursor-pointer " ng-click="deleteAnswer('<%=deleteAnswerURL %>',requestLesson.requestLessonId,answer.answerId)">
						<i class="icon-trash"></i>
						</a>
						</p>
						
						<p class="more change-to-html" style="word-break: break-all; word-wrap: break-word;">{{answer.description}}</p>
						<p>
						<i style="font-size: 24px; position: relative; top: 5px;" class="fa fa-chevron-circle-right"></i>
						<a href="<%=showDocumentURL%>&_<%=Constant.PORTLET_LESSON%>_lessonId={{answer.lessonId}}">{{answer.lessonName}}</a></p>
						<p> <liferay-ui:message key="answered" />&nbsp; &nbsp; {{answer.createDate}}&nbsp; &nbsp; <liferay-ui:message key="by" />
							{{answer.userName}}&nbsp; &nbsp; &nbsp; &nbsp; 
							<i class="icon-thumbs-up"> </i> {{answer.appreciatedCount}}
							<label class="pull-right" ng-if=answer.checked>
								<span ng-if=authorId==requestLesson.userId>
								<input type="checkbox" style="margin: 0px;" name="checkAnswer"  class="myQuestionAnswer" checked="true" value="{{answer.answerId}}" >
								<liferay-ui:message key="this-answers-my-question" />
								</span>
								
								<span ng-if=authorId!=requestLesson.userId>
								<input type="checkbox" style="margin: 0px;" name="checkAnswer"  class="myQuestionAnswer" checked="true" value="{{answer.answerId}}" disabled="true" >
								<liferay-ui:message key="this-answers-my-question" />
								</span>
								
							</label>
							
							<label class="pull-right" ng-if=!answer.checked>
								<span ng-if=authorId==requestLesson.userId>
								<input type="checkbox" style="margin: 0px;"  name="checkAnswer"  class="myQuestionAnswer"  value="{{answer.answerId}}" >
								<liferay-ui:message key="this-answers-my-question" />
								</span>
								<span ng-if=authorId!=requestLesson.userId>
								<input type="checkbox" style="margin: 0px;"  name="checkAnswer"  class="myQuestionAnswer"  value="{{answer.answerId}}" disabled="true">
								<liferay-ui:message key="this-answers-my-question" />
								</span>
								
							</label>
						</p>
					</div> <!-- end request-content -->
					<footer>
						
						<span ng-if="answer.userId==authorId">
						<i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="you-cannot-appreciate-your-own-answer" />'> </i>
						</span>
						
						<span ng-if="answer.hasAppreciated &&  answer.userId!=authorId">
						<a clas="appreciateAnswer"  ng-click="unAppreciateAnswer('<%=unAppreciateAnswerURL.toString()%>',answer.answerId,'<%=Constant.REQUEST_LESSON%>')" >
					    <i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="already-appreciated" />'> </i>
					    </a>
					    </span>
					    
					    <span ng-if="!answer.hasAppreciated && answer.userId!=authorId">
					    <a clas="appreciateAnswer"  ng-click="appreciateAnswer('<%=appreciateAnswerURL.toString()%>',answer.answerId)" >
					    <i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="appreciate-this" />'></i></a>
					    </span>&nbsp; &nbsp;
					    
						<span>{{filterComments.length}}</span><a href="javascript:void(0)" class="add-comment" > 
							<span ng-if="filterComments.length > 1"> <liferay-ui:message key="comments" /> </span>
							<span ng-if="filterComments.length <= 1"> <liferay-ui:message key="comment" /> </span>
						</a>
						<div class="show-hide-comments" style="display:none;">
						<div class="control-group"> 
							<label class="sr-only" for="inputComment"> 
								<liferay-ui:message key="comments" />
							</label> 
							<div class="controls"> 
								<textarea name="inputComment"  class="input-block-level inputAnswerComment" rows="5"></textarea>
							</div>
							<button id="addAnswerComment" class="btn" ng-click="addAnswerComments($event,'<%=addAnswerCommentURL.toString()%>',answer.answerId)"> 
								<liferay-ui:message key="add-comment" />
							</button>
						</div>
						<!-- ADD COMENTS -->
						<ul class="group-list unstyled">
								
							<li class="group-list-item" ng-repeat="comment in filterComments=(answerComments | filter:{answerId:answer.answerId})">
								
								<p ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right: 20px; position: relative; z-index: 1;">
								<a title='<liferay-ui:message key="delete-comment" />' class="cursor-pointer nyu-tooltip" ng-click="deleteComment('<%=deleteCommentsURL %>',requestLesson.requestLessonId,comment.commentId,'0')">
								<i class="icon-trash"></i>
								</a>
								</p>	
								
								<div class="media"> 
									<img ng-src="{{comment.documentPath}}" style="width: 64px; height: 64px;" alt="" class="media-object pull-left"> 
									<div class="media-body"> 
										<p>{{comment.description}}</p>
										<a href="javascript:void(0);">{{comment.userName}} </a> &nbsp; &nbsp; {{comment.createDate}}
									</div> <!-- end media-body -->
								</div> <!-- end media -->
							</li> <!-- end group-list-item --> 
							
						</ul> <!-- end group-list-item -->
					</div> <!-- end show-hide-comments -->
					</footer>
				</div> <!-- end answered-request -->
			</div>
		</div> <!-- end requestforInfo -->
	</div> <!-- end rowfluid -->
	<%@include file="createRequest.jsp" %>
</div> <!-- end container -->

<div id="addRequestPopUp"> </div>
<script>


	(function(){
		$('#requestForInfo').on('click','.add-comment',function(){  
			// CHANDING COMMENT TEXT
			 $('#answerRequest').removeAttr('disabled'); 	
			 text = $(this).find('span').text().trim();
			$(this).find('span').text(text=='Hide Comments'?'Comments':text=='Hide Comment'?'Comment':text=='Comment'?'Hide Comment':text=='Comments'?'Hide Comments':'Comments');
			
			// TOGGLE EFFECT FOR ALL ANWSER
			if($(this).siblings('.show-hide-comments').css('display') != 'block'){
				$('.anwser-active').fadeOut('fast').removeClass('anwser-active');
				$(this).siblings('.show-hide-comments').addClass('anwser-active').fadeIn('slow');
			} 
			else {
				$('.anwser-active').fadeOut('fast').removeClass('anwser-active');
			}
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
		
		
		
		// ANSWER REQUEST	 
				$('#answerRequest').on('click',function(){   
					$(this).next().hide();
					$(this).siblings('.show-request-answer').fadeToggle(); 
					$(this).attr("disabled", "disabled"); 
				});
				
		// SAVE ANSWER	
		
				$("#saveAnswer").on('click',function(){
					var answer=window.<portlet:namespace />discussionMessage.getHTML();
					var answerLength = $("#cke_<portlet:namespace />discussionMessage").find("iframe").contents().find("body").text().trim();
					if(answerLength.length <= 0){
						if(answer.toLowerCase().indexOf('<iframe') != -1){
							answerLength = answer;
						}
					}
					if(answer == null || answerLength.trim().length==0){
						 showValidationAlert('<liferay-ui:message key="please-enter-the-answer" />');
							
					 }else if(answerLength.trim().length > 1000) {
						 showValidationAlert('<liferay-ui:message key="Please-enter-description-below-thousands-characters" />');
						 
					 }else{
						$(this).closest('.show-request-answer').hide();
						var myLessonIds = $("#myLessonIds").val();
						var myFavLessonIds = $("#myFavLessonIds").val();
					  	$.ajax({
					        url:'<%=saveAnswerURL%>',
					        type: 'POST',
					        datatype:'html',
					        data:{
					        	"<portlet:namespace />answer": answer,
					        	"<portlet:namespace />myLessonIds": myLessonIds,
					        	"<portlet:namespace />myFavLessonIds": myFavLessonIds,
					        	"<portlet:namespace />requestLessonId":'<%=requestLessonId%>'
					        },
					        success: function(data){
					        	
					        	var e = $('#answerRequestController');
					    		var scope = angular.element(e).scope();
					    		scope.$apply(function() {
					    			scope.answers=JSON.parse(data);
					    			window.<portlet:namespace />discussionMessage.setHTML('');
					    			showSuccessAlert('<liferay-ui:message key="your-answer-posted-successfully" />');
					    			$("#myLessonIds").val("");
					    		});  	
					    		
					         }
					      });
					  
					}
					$('#answerRequest').removeAttr('disabled'); 	
					  $(this).closest('.show-hide-comments').hide();
					 
				});
				
				
		// CANCEL ANSWER			
				$("#cancelAnswer").on('click',function(){ 
					window.<portlet:namespace />discussionMessage.setHTML('');
					$('#answerRequest').removeAttr('disabled'); 	
					$(this).closest('.show-request-answer').hide();
				});
				
		// END ANSWER REQUEST		
				
		
		YUI().use('aui-tabview', function(Y) {
			new Y.TabView(
			  {
				srcNode: '#nyYouTab'
			  }
			).render();
			
			var creatGroupPopover = new Y.TabView(
			  {
				srcNode: '#nyYouCreateGroupTab',
				stacked: true
			  }
			).render();  
		});
		
		
		
	
		
	})();
	
	
	
	$(document).ready(function(){
		
		var e = $('#answerRequestController');
		var scope = angular.element(e).scope();
		scope.$apply(function() {
			scope.requestLesson=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_JSON)%>));
			scope.tagsrequest=scope.requestLesson;
			scope.answers=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_JSON)%>));
			scope.comments=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_COMMENTS_JSON)%>));
			scope.answerComments=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_COMMENTS_JSON)%>));
			scope.authorId='<%=PortalUtil.getUser(request).getUserId()%>'; 
			
		});  
		
	$("#nyYouTab").on('change','.myQuestionAnswer',function(){
		
		var e = $('#answerRequestController');
			var scope = angular.element(e).scope();
			
			 $.ajax({
			        url:'<%=checkAnswerURL%>',
			        type: 'GET',
			        datatype:'html',
			        data:{
			        	"<portlet:namespace />isChecked":$(this).is(":Checked"),
			        	"<portlet:namespace />answerId":$(this).val(),
			        	"<portlet:namespace />requestId":'<%=requestLessonId%>'
			        },
			        success: function(data){
			        	var json=JSON.parse(data);
			        	scope.$apply(function() {
			        		scope.answers=JSON.parse(data);
			        		
			        	});
			    		
			         }
			      });
			});
		});


	function <portlet:namespace/>myLessons(url, windowTitle) {
			Liferay.Util.openWindow({
				dialog : {
					width : 500,
					height:650,
					align : Liferay.Util.Window.ALIGN_CENTER,
					cache : false,
					modal : true,
					resizable: false
				},

				title : windowTitle,
				id : 'AddLessons',
				uri : url
			});

		}
		
		Liferay.provide(window,
			    '<portlet:namespace/>closeAddLessonPopup',
			        function(popupIdToClose,withSuccessMsg) {
			            var popupDialog = Liferay.Util.Window.getById(popupIdToClose);
			            popupDialog.destroy();
			            if(withSuccessMsg != null && withSuccessMsg == 'yes'){
			            	closePopupForAllWithSuccessMsg('<liferay-ui:message key="lesson-linked-successfully" />');
			            }
			        },
			        ['liferay-util-window']
			    );
		
		
		
		function <portlet:namespace/>myLessonIds(myLessonIds){
			$('.selected-myLesson-ids').val(myLessonIds);
		}
		
		
		function <portlet:namespace/>myFavouriteLessonIds(myFavLessonIds){
			$('.selected-myFavLesson-ids').val(myFavLessonIds);
		}
		
		
		function <portlet:namespace/>myFavouriteLessons(url, windowTitle) {
			Liferay.Util.openWindow({
				dialog : {
					width : 350,
					height: 570,
					align : Liferay.Util.Window.ALIGN_CENTER,
					cache : false,
					modal : true,
					resizable: false
				},

				title : windowTitle,
				id : 'AddLessons',
				uri : url
			});

		}
		
		Liferay.provide(window,
			    '<portlet:namespace/>closeAddLessonPopup',
			        function(popupIdToClose,withSuccessMsg) {
			            var popupDialog = Liferay.Util.Window.getById(popupIdToClose);
			            popupDialog.destroy();
			            if(withSuccessMsg != null && withSuccessMsg == 'yes'){
			            	closePopupForAllWithSuccessMsg('<liferay-ui:message key="lesson-linked-successfully" />');
			            }
			        },
			        ['liferay-util-window']
			    );
		
	
		
	
</script>

<script>
	$(function(){
		// SHOW MORE/LESS CONTENT
		var showChar = 100, showtxt = "more", hidetxt = "less";
		 
		 $('.more').each(function() {
		 	var content = $(this).text();
			 if (content.length > showChar) {
			 	var con = content.substr(0, showChar);
			 	var hcon = content.substr(showChar, content.length - showChar);
			 	var txt= con +  '<span class="dots">...</span><span class="morecontent"><span>' + hcon + '</span>&nbsp;&nbsp;<a href="" class="moretxt">' + showtxt + '</a></span>';
			 	$(this).html(txt);
		 	}
		 });
		 
		 $(".moretxt").click(function() {
			 if ($(this).hasClass("sample")) {
			 $(this).removeClass("sample");
			 $(this).text(showtxt);
			 }
			 else {
				 $(this).addClass("sample");
				 $(this).text(hidetxt);
			 }
			 $(this).parent().prev().toggle();
			 $(this).prev().toggle();
			 return false;
		 })			
	})();
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

