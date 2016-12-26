<%@page import="com.liferay.portal.kernel.util.StringPool"%>
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
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>		<%--	added by asif 	 --%>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/angular/requestLessons.js?t=<%=System.currentTimeMillis()%>"></script>	
<script type="text/javascript" src="<%=request.getContextPath()%>/js/request-lesson.js?<%=new Date().getTime()%>"></script>

	
<%
long requestLessonId=GetterUtil.getLong(((String)request.getAttribute(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID))); 

RequestLesson reqLesson = RequestLessonLocalServiceUtil.getRequestLesson(requestLessonId);


String facebookEmbedUrl=PortalUtil.getPortalURL(request)+"/web";
facebookEmbedUrl += themeDisplay.getScopeGroup().getFriendlyURL()+Constant.PAGE_HOME+"/-/homepage"+Constant.PAGE_LESSON_BROWSE+"/"+requestLessonId;

String embedurl=PortalUtil.getPortalURL(request)+"/group";
embedurl += themeDisplay.getScopeGroup().getFriendlyURL()+Constant.PAGE_REQUEST_LESSON+"/-/request/details/"+requestLessonId;
String FBShareUrl = URLEncoder.encode(embedurl, Constant.UTF_EIGHT);
String ShareUrl = URLEncoder.encode(embedurl, Constant.UTF_EIGHT);
String link=null;
if(Validator.isNotNull(request.getAttribute(Constant.COMMON_STRING_CONSTANT_OPINION_SURVEY_LINK_II))){
	
	link=(String)request.getAttribute(Constant.COMMON_STRING_CONSTANT_OPINION_SURVEY_LINK_II);
}

%>

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
<portlet:resourceURL id="deleteAnswer" var="deleteAnswerURL"/>
<portlet:resourceURL id="deleteComments" var="deleteCommentsURL"/>
<portlet:resourceURL id="addExternalSurvey" var="addExternalSurveyURL">
  <portlet:param name="requestId" value="<%=String.valueOf(requestLessonId)%>"/> 
</portlet:resourceURL>
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
					<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-slate.gif" class="pull-right">
					</p>
					<p> 
						{{requestLesson.userName}}	&nbsp; &nbsp;
						<span> {{requestLesson.createDate}} </span> &nbsp; &nbsp;  &nbsp; &nbsp;
						<span>  <i class="icon-thumbs-up appreciateAnswer"></i> {{requestLesson.appreciatedCount}} </span> &nbsp; &nbsp;
						<span ng-if="answers.length!=0" class="label label-success">
							 <liferay-ui:message key="answered-by" /> 
						</span> 
						<span ng-if="answers.length==0" class="label label-default">
							 <liferay-ui:message key="no-answer-yet" />
						</span>
					</p>
				</div> <!-- end request-content -->
				<footer class="clearfix" ng-cloak>
				<a href="javascript:void(0);" id="share-button" class="dropdown" onclick="myEmailPopup('${EhowEmailURL}')"><i class="icon-random"> </i> 
					<liferay-ui:message key="share-via-email" />&nbsp;&nbsp;&nbsp;</a>
					
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
					
					<span> {{comments.length}} </span> 
					<a href="javascript:void(0)" class="add-comment">
						<span ng-if="comments.length > 1"> <liferay-ui:message key="comments" /> </span>
						<span ng-if="comments.length <= 1"> <liferay-ui:message key="comment" /> </span>
					</a> 	
					
					<input type="button" value="Give an Opinion"  ng-show="requestLesson.userId!=authorId" class="btn btn-primary pull-right" id="answerRequest"> 
					<a ng-href="{{requestLesson.opinionSurveyLink}}" style="margin-right: 10px;"  
						target="_blank" ng-show="requestLesson.userId!=authorId && requestLesson.opinionSurveyLink.length>0" class="btn btn-primary pull-right">
							<liferay-ui:message key="take-a-survey" />
						</a>
					<div class="show-hide-comments" style="display:none;">
						<div class="control-group"> 
							<label class="sr-only" for="inputComment"> <liferay-ui:message key="comments" /> </label> 
							<div class="controls"> <BR>
								<textarea name="inputComment" id="inputComment" class="input-block-level" rows="5"></textarea>
							</div>
							<button id="addComment" class="btn"> <liferay-ui:message key="add-comment" /> </button>
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
						<form class="bs-docs-example">
							 
							<div class="controls"> 
								<h3> <liferay-ui:message key="give-an-opinion-please-explain" /> </h3>
								<textarea name="inputComment" id="inputAnswer" class="input-block-level" rows="3"></textarea>
							</div>							
							<h3 class="text-info" style="line-height: normal;"> <liferay-ui:message key="survey" /> </h3>
							<p> 
								<label class="radio inline"  ng-repeat="survey in opinionSurvey track by $index" style="margin-left: 0;">
									<input type="radio"  style="margin-right: 0px;" value="{{survey.optionName}}" id="optionsRadio" name="optionsRadios">
									{{survey.optionName}} &nbsp; &nbsp; &nbsp; &nbsp;
								</label>
								
							</p>
							<div class="btn-group">
								<button id="saveAnswer" class="btn btn-primary"> <liferay-ui:message key="save-opinion" /> </button>
								<button id="cancelAnswer" class="btn"> <liferay-ui:message key="cancel" /> </button>
								
								
							</div>
						</form>
					</div>						
				</footer>
			</div> <!-- end request-raised -->
			
			<div class="row-fluid" ng-show=show>
				<div class="span12" id="surveyPolling" ng-cloak>
					<div class="row-fluid"> 
						<ul class="group-list unstyled span6">
						  <li class="group-list-item" style="color: #000000; font-weight:bold;" ng-repeat="survey in opinionSurvey"> {{survey.optionName}}- <span class="lead text-info">{{survey.percentage}}% </span></li>
						</ul>
						<div class="span6" ng-if="opinionSurvey[0].participationSize>0" style="border: 1px solid rgb(187, 187, 187); padding: 10px; margin-top: 15px; width: 420px">
							<canvas id="pie"  class="chart chart-pie" data="data" labels="labels" legend="true"></canvas> 
						</div>
					</div>
					<p>{{opinionSurvey[0].participationSize}} <liferay-ui:message key="people-responded-to-the-poll" />.</p>
				</div>
			</div><!-- end row-fluid -->
			
			<div class="text-center" ng-if="requestLesson.userId==authorId" ng-cloak>
				<c:if test="<%=Constant.IS_SURVEY_REQUIRE%>">
				<button id="AdvanceSurveyModal" ng-show="requestLesson.opinionSurveyLink.length==0" class="btn btn-primary input-xxlarge  btn-large">
					<liferay-ui:message key="build-an-advanced-survey-for-this-request" />
				</button>
				<a ng-href="{{requestLesson.surveyResultLink}}" ng-show="requestLesson.opinionSurveyLink.length>0" target="_blank" class="btn btn-primary input-xxlarge  btn-large" >
					<liferay-ui:message key="view--advanced-survey-results" /> 
				</a>
				</c:if>
			</div>
			
	<div id="nyYouTab" class="request-answer" ng-show=show ng-cloak>
		<h4 style="position: absolute; left: 0px;" ng-cloak> <i class="icon-user"></i> <span>{{answers.length}}</span> 
			<span ng-if="answers.length > 1"> <liferay-ui:message key="answers" /> </span>
			<span ng-if="answers.length <= 1"> <liferay-ui:message key="answer" /> </span>
		 </h4>
		<!-- TAB LINKS -->
		<ul class="nav nav-tabs"> 
			<li class="active"><a href="#Latest"><liferay-ui:message key="latest" />	</a></li>
			<li><a href="#popular">
				<liferay-ui:message key="popular" />
			</a></li>			
		</ul> <!-- END TAB LINKS -->
	 
		<!-- TAB CONTENT -->
		<div class="tab-content" >	
			
			
			
			<div id="Latest" class="tab-pane">
				<p ng-show="answers.length==0"><liferay-ui:message key="no-answers-found" />.</p>
				<div class="answered-request"  ng-repeat="answer in answers "> 
				         
					<div class="request-content" >
						<p ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" sstyle="padding-right: 20px; position: relative; z-index: 1;">
							<a title='<liferay-ui:message key="delete-answer" />' class="nyu-tooltip cursor-pointer " ng-click="deleteAnswer('<%=deleteAnswerURL %>',requestLesson.requestLessonId,answer.answerId,'<%=Constant.REQUEST_OPINION%>')">
						<i class="icon-trash"></i>
						</a>
						</p>
						
						<p class="more change-to-html" style="word-break: break-all; word-wrap: break-word;">{{answer.description}}</p>
						<p> <liferay-ui:message key="answered-by" /> &nbsp; &nbsp;{{answer.createDate}}&nbsp; &nbsp; <liferay-ui:message key="by" />
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
						<a clas="appreciateAnswer"  ng-click="unAppreciateAnswer('<%=unAppreciateAnswerURL.toString()%>',answer.answerId,'<%=Constant.REQUEST_OPINION%>')" >
					    <i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="already-appreciated" />'> </i>
					    </a>
					    </span>
					    
					    <span ng-if="!answer.hasAppreciated && answer.userId!=authorId">
					    <a clas="appreciateAnswer"  ng-click="appreciateAnswer('<%=appreciateAnswerURL.toString()%>',answer.answerId,'req_Opinion')" >
					    <i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="appreciate-this" />'></i></a>
					    </span>&nbsp; &nbsp;
					    
						<span>{{filterComments.length}}</span> 
						<a href="javascript:void(0)" class="add-comment" > 
							<span ng-if="filterComments.length > 1"> <liferay-ui:message key="comments" /> </span>
							<span ng-if="filterComments.length <= 1"> <liferay-ui:message key="comment" /> </span>
						</a>
						<div class="show-hide-comments" style="display:none;">
						<div class="control-group"> 
							<label class="sr-only" for="inputComment"> <liferay-ui:message key="comments" /> </label> 
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
			</div> <!-- end popular -->
		<div id="popular " class="tab-pane ">
			<p ng-show="answers.length==0"><liferay-ui:message key="no-answers-found" />.</p>
			<div class="answered-request "  ng-repeat="answer in answers | orderBy:'-appreciatedCount'"> 
				         
					<div class="request-content" >
					
						<p ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right: 20px; position: relative; z-index: 1;">
						<a title='<liferay-ui:message key="delete-answer" />' class="nyu-tooltip cursor-pointer " ng-click="deleteAnswer('<%=deleteAnswerURL %>',requestLesson.requestLessonId,answer.answerId,'req_Opinion')">
						<i class="icon-trash"></i>
						</a>
						</p>
						
						<p class="more change-to-html" style="word-break: break-all; word-wrap: break-word;">{{answer.description}}</p>
						<p> <liferay-ui:message key="answered-by" />&nbsp; &nbsp; {{answer.createDate}}&nbsp; &nbsp; <liferay-ui:message key="by" />
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
						<i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="you-cannot-appreciate-your-own-answer" />'> </i>	<%--	You cannot appreciate your answer. --%>
						</span>
						
						<span ng-if="answer.hasAppreciated &&  answer.userId!=authorId">
						<a clas="appreciateAnswer"  ng-click="unAppreciateAnswer('<%=unAppreciateAnswerURL.toString()%>',answer.answerId,'req_Opinion')" >
					    <i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="already-appreciated" />'> </i>
					    </a>
					    </span>
					    
					    <span ng-if="!answer.hasAppreciated && answer.userId!=authorId">
					    <a clas="appreciateAnswer"  ng-click="appreciateAnswer('<%=appreciateAnswerURL.toString()%>',answer.answerId,'req_Opinion')" >
					    <i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="appreciate-this" />'></i></a>
					    </span>&nbsp; &nbsp;
					    
						<span>{{filterComments.length}}</span><a href="javascript:void(0)" class="add-comment" > 
							<span ng-if="filterComments.length > 1"> <liferay-ui:message key="comments" /> </span>
							<span ng-if="filterComments.length <= 1"> <liferay-ui:message key="comment" /> </span></a>
						<div class="show-hide-comments" style="display:none;">
						<div class="control-group"> 
							<label class="sr-only" for="inputComment">
							 <liferay-ui:message key="comments" /> </label> 
							<div class="controls"> 
								<textarea name="inputComment" class="input-block-level inputAnswerComment" rows="5"></textarea>
							</div>
							<button id="addAnswerComment" class="btn" ng-click="addAnswerComments($event,'<%=addAnswerCommentURL.toString()%>',answer.answerId)"> 
								<liferay-ui:message key="add-comment" /> 
							</button>
						</div>
						<!-- ADD COMENTS -->
						<ul class="group-list unstyled">
								
							<li class="group-list-item" ng-repeat="comment in filterComments=(answerComments | filter:{answerId:answer.answerId})">
								<div class="media"> 
								
									<p ng-show='<%=permissionChecker.isGroupAdmin(scopeGroupId) %>' class="pull-right" style="padding-right: 20px; position: relative; z-index: 1;">
									<a title='<liferay-ui:message key="delete-comment" />' class="nyu-tooltip cursor-pointer " ng-click="deleteComment('<%=deleteCommentsURL %>',requestLesson.requestLessonId,comment.commentId,'0')">
									<i class="icon-trash"></i>
									</a>
									</p>	
								
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
<div id="surveyLinkContent" style="padding:15px;display:none;"> 
<h5>
	<liferay-ui:message key="please-select-one-of-the-below-links-to-add-an-external-survey" />
</h5>
<form>
    
    <ul>
     <li><a href="https://nyu.qualtrics.com" target="_blank">
     	<liferay-ui:message key="qualtrics" />
     </a></li>
    <li><a href="https://www.surveymonkey.com/home/?ut_source=header"  target="_blank">
    	<liferay-ui:message key="survey-monkey" />
    </a></li>
    </ul>
	<label class="nyu-tooltip" title='<liferay-ui:message key="copy-the-generated-link-from-qualtrics-survey-monkey-and-paste-here" />'>
		<liferay-ui:message key="add-the-survey-link" /> 
	<img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></label>
    <aui:input type="textarea" id="surveyLink" name="opnionSurveyLink" label="" placeholder='paste-the-link-here'  cssClass="input-block-level"/>
	
		<aui:button  id="addExternalSurvey" class="btn btn-primary" value="add-survey"/>

	<!--  <p id="surveyLinkErrorId" style="display:none; color:red;"></p> -->
</form>

</div>

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
			$("#inputAnswer").val("");
			$("#optionsRadio:checked").attr("checked",false);
		}); 
		
		$('#addComment').on('click',function(){ 
			var body=$("#inputComment").val();
			if(body==null || body.trim().length==0){
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
					$(this).next().next().hide();
					$(this).siblings('.show-request-answer').fadeToggle(); 
					$(this).attr("disabled", "disabled"); 
				});
				
		// SAVE ANSWER	
				$("#saveAnswer").on('click',function(){
					var answer=$("#inputAnswer").val();
					var opinion=$("#optionsRadio:checked").val();
					
					// below lines are commented to make comment optional --- microecxel
					 /* if(answer==null || answer.trim().length==0){
						 showValidationAlert('<liferay-ui:message key="please-give-your-opinion" />');
					 }else if(answer.trim().length > 1000) {
						 showValidationAlert('<liferay-ui:message key="Please-enter-description-below-thousands-characters" />');
						 
					 }else  */
					 if(opinion==null){
						 $('#answerRequest').removeAttr('disabled'); 	
						 showValidationAlert('<liferay-ui:message key="please-select-the-survey" />');
					 }else{
						  	$(this).closest('.show-request-answer').hide();
				  			$.ajax({
					        url:'<%=saveAnswerURL%>',
					        type: 'POST',
					        datatype:'html',
					        data:{
					        	"<portlet:namespace />answer": answer,
					        	"<portlet:namespace />requestLessonId":'<%=requestLessonId%>',
			        			"<portlet:namespace />answerType":'req_Opinion',
			        			"<portlet:namespace />opinionSurvey":opinion
					        },
					        success: function(data){
					        	
					        	var e = $('#answerRequestController');
					    		var scope = angular.element(e).scope();
					    		scope.$apply(function() {
					    			var allAnswerData=JSON.parse(data);
					    			scope.answers=allAnswerData.getAnswerJson;
					    			scope.opinionSurvey=JSON.parse(allAnswerData.getOpinionSurvey);
					    			$("#inputAnswer").val("");
					    			$("#optionsRadio:checked").attr("checked",false);
					    			showSuccessAlert('<liferay-ui:message key="your-opinion-posted-successfully" />');
					    			scope.labels=[];
					    			scope.data=[];
					    			for(i in scope.opinionSurvey){
					    				scope.labels.push(scope.opinionSurvey[i].optionName);
					    				scope.data.push(scope.opinionSurvey[i].percentage);
					    			} 
					    		});  	
					    		
					         }
					      });
					 }
				  $('#answerRequest').removeAttr('disabled'); 	
				  $(this).closest('.show-hide-comments').hide();
				  $(this).closest('.show-request-answer').hide();
					   
				});
		// CANCEL ANSWER			
				$("#cancelAnswer").on('click',function(){ 
					$("#inputAnswer").val("");
					$("#optionsRadio:checked").attr("checked",false);
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
			
			var allAnswerData=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_JSON)%>));
			scope.answers=allAnswerData.getAnswerJson;
			
			scope.opinionSurvey=JSON.parse(allAnswerData.getOpinionSurvey);
			scope.comments=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_COMMENTS_JSON)%>));
			scope.show=true;
			scope.answerComments=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_ANSWER_COMMENTS_JSON)%>));
			scope.authorId='<%=PortalUtil.getUser(request).getUserId()%>'; 
			
			scope.labels=[];
			scope.data=[];
			for(i in scope.opinionSurvey){
				scope.labels.push(scope.opinionSurvey[i].optionName);
				scope.data.push(scope.opinionSurvey[i].percentage);
			}  
			
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
		        		scope.answers=json.getAnswerJson;
		        	});
		    		
		         }
		      });
		});
	});
	
	function showGiveOpnion(){
		var e = $('#answerRequestController');
		var scope = angular.element(e).scope();
		scope.$apply(function() {
			scope.show=!scope.show;
		});
		
	}
	
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
		 });	
		 
		 $('#surveyPolling .thumbnail-lessons').each(
					function(i, val) {
						if (i % 3 == 0) {
							$(this).addClass('no-margin clearfix');
						}else{
							$(this).removeClass('no-margin clearfix');
						}
			});

	});
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
<c:if test="<%=Constant.IS_SURVEY_REQUIRE%>">
	YUI().use('aui-modal', function(Y) {
			    var surveyModal = new Y.Modal(
			      {
		    	  	contentBox:'#surveyLinkContent',
			        centered: true,
			        headerContent: '<h3><liferay-ui:message key="add-survey" /></h3>',
			        modal: true,
			        render: '#addRequestPopUp',
			        width: 380,
			        visible: false
			        
			      }
			    ).render();
				if( Y.one('#AdvanceSurveyModal') != null ){
				     Y.one('#AdvanceSurveyModal').on('click', function(){
				    	$("#surveyLinkContent").show();
				    	surveyModal.show();
				    }); 
				}
					 
			    Y.one('#addExternalSurvey').on('click', function() {
			    	var surveyURL=$("#<portlet:namespace/>surveyLink").val().trim()
			    	 if(validate(surveyURL)){
				    	 $.ajax({
					        url:'<%= addExternalSurveyURL%>',
					        type: 'GET',
					        datatype:'html',
					        data:{
					        	"<portlet:namespace />surveyUrl":surveyURL,
					        },
					        success: function(data){
					        	var e = $('#answerRequestController');
					    		var scope = angular.element(e).scope();
					    		scope.$apply(function() {
					    			scope.requestLesson=JSON.parse(data);
					    		});
					         }
					      }); 
			    	 }else{
			    		 showValidationAlert('<liferay-ui:message key="please-enter-a-valid-url" />');
			    		 $("#<portlet:namespace/>surveyLink").val("");
			    	 }
			    	surveyModal.hide();
				});
	}); 
	
</c:if>
function validate(surveyLink){
	var qualtricspattren="<%=Constant.QUALTRICS_URLPATTERN%>";
	var surveyMonkeyPattern="<%=Constant.SURVEYMONKEY_URLPATTERN%>";
	if(surveyLink.indexOf(surveyMonkeyPattern)>-1){
		var surveyLinkSplit=surveyLink.split("/");
		var indexOfCharacter=surveyLink.split("/").length-2;
		
		  if(surveyLinkSplit[indexOfCharacter].length!=1){
			 
			  return false;
		  }else{
			  return true; 
		  }
		
	}else if(surveyLink.indexOf(qualtricspattren)>-1){
		return true; 
	}else{
		
		return false;
	}

}


</script>