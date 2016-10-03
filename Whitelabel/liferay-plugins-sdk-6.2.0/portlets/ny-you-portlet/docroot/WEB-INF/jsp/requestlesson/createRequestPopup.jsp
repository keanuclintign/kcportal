<%@page import="javax.ws.rs.Consumes"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>			<%--	added by asif 	 --%>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui" %>
<%
request.setAttribute("singleSelect",Constant.COMMON_STRING_CONSTANT_TRUE); //category selector will be a radio button
%>

<!-- start create-request -->


<aui:form id="fm" name="fm" cssClass="requestForm" style="margin-bottom: 0;">
	<div class="input-request request-progress">
		<div class="request-body">
			<div style="margin-top:">
				<aui:input id="name" name="name"  label="ask-for-something"  cssClass="input-block-level">
					<aui:validator name="required"/> 
					<aui:validator name="minLength">4</aui:validator> 
					<aui:validator name="maxLength">100</aui:validator>
				</aui:input>	
			</div>
			
			
			<div id="requestType">
				<label style="margin-bottom: 15px;" id="responseLabel">
					<liferay-ui:message key="how-do-you-want-the-response" />?
				</label>
				<!--=============== A Collaborator ===============-->
				<p> <input type="checkbox" name="<portlet:namespace/>answerType" class="optionToAnswer" value="<%=Constant.REQUEST_COLLOBORATION%>">
					<strong style="color: #FF5C26;"> 
						<liferay-ui:message key="a-collaborator" />
					</strong></input>
				<a href="#" class="nyu-tooltip" title='<liferay-ui:message key="select-this-option-to-seek-a-collaborator" />'> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></a></p> 
				<ul id="collaborator" class="unstyled"> 
						<li class="clearfix"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-user-group.gif" class="pull-right" style="width: 36px;"/>  
						<span class="pull-left">
							<liferay-ui:message key="i-would-like-a-certified-french-speaker-to-work-with-me-to-create-a-3-part-french-class" />. 
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-user-group.gif" class="pull-right" style="width: 36px;"/>
						<span class="pull-left">
							<liferay-ui:message key="i-am-creating-a-lesson-and-would-like-a-digital-animator-to-animate-my-content" />. 
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-user-group.gif" class="pull-right" style="width: 36px;"/>
						<span class="pull-left">
							<liferay-ui:message key="i-am-looking-for-an-editor-to-edit-my-novel" />. 
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-user-group.gif" class="pull-right" style="width: 36px;"/>
						<span class="pull-left">
							<liferay-ui:message key="would-someone-be-interested-in-working-with-me-to-create-an-lsat-training-guide" />? 
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-user-group.gif" class="pull-right" style="width: 36px;"/>
						<span class="pull-left">
							<liferay-ui:message key="i-am-looking-for-someone-to-work-with-to-create-a-lesson-on-karate-basics" />.
						</span></li>
				</ul> 
				
				<!--=============== Text Answer ===============-->		
				<p> <input type="checkBox" name="<portlet:namespace/>answerType"  class="optionToAnswer"  value="<%=Constant.REQUEST_INFORMATION%>" ><strong style="color: #D9A300;"> Information</strong></input>
				<a href="#" class="nyu-tooltip" title='<liferay-ui:message key="elect-this-option-to-seek-an-information-on-some-topic" />'> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></a></p> 
				<ul id="requestInfo" class="unstyled"> 
						<li class="clearfix"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-group-chat.gif" class="pull-right" style="width: 36px;"/>  
						<span class="pull-left"> 
							<liferay-ui:message key="what-s-the-best-restaurant-in-soho" />? 
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-group-chat.gif" class="pull-right" style="width: 36px;"/>
						<span class="pull-left">
							<liferay-ui:message key="is-bobst-library-open-24-hours" />? 
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-group-chat.gif" class="pull-right" style="width: 36px;"/>
						<span class="pull-left">
							<liferay-ui:message key="what-s-the-address-for-x-accounts-payable" arguments="<%=Constant.CURRENT_BRAND_NAME%>" />?
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-group-chat.gif" class="pull-right" style="width: 36px;"/>
						<span class="pull-left">
							<liferay-ui:message key="what-is-the-quickest-way-to-get-to-jfk-airport-using-public-transportation-from-washington-square" />? 
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-group-chat.gif" class="pull-right" style="width: 36px;"/>
						<span class="pull-left">
							<liferay-ui:message key="what-date-does-daylight-savings-time-begin-in-2015" />? 
						</span></li>
				</ul>
				
				<!--=============== A Lesson ===============-->		
				<p> <input type="checkBox" name="<portlet:namespace/>answerType"  class="optionToAnswer"  value="<%=Constant.REQUEST_LESSON%>"><strong style="color: #8A8A7B;">
					<liferay-ui:message key="a-lesson" />
				</strong></input>
				<a href="#" class="nyu-tooltip" title='<liferay-ui:message key="select-this-option-to-seek-a-lesson-as-an-answer" />'> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></a> </p> 
				<ul id="requestLesson" class="unstyled"> 
						<li class="clearfix"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-lesson.gif" class="pull-right" style="width: 36px;"/>  
						<span class="pull-left"> 
							<liferay-ui:message key="can-someone-please-show-me-how-to-dance-the-tango" />?
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-lesson.gif" class="pull-right" style="width: 36px;"/>
						<span class="pull-left">
							<liferay-ui:message key="please-describe-how-global-warming-works" />.
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-lesson.gif" class="pull-right" style="width: 36px;"/>
						<span class="pull-left">
							<liferay-ui:message key="can-someone-show-me-how-to-draw-a-human-face" />? 
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-lesson.gif" class="pull-right" style="width: 36px;"/>
						<span class="pull-left">
							<liferay-ui:message key="can-someone-create-a-lesson-on-how-to-cook-spaghetti-bolognese" />? 
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-lesson.gif" class="pull-right" style="width: 36px;"/>
						<span class="pull-left">
							<liferay-ui:message key="please-show-me-how-to-create-a-resume" />. 
						</span></li>
				
				</ul>
				
				<!--=============== An Opinion ===============-->			
				<p> <input type="checkBox" name="<portlet:namespace/>answerType"  class="optionToAnswer"  value="<%=Constant.REQUEST_OPINION%>" ><strong style="color: #8A8AFF;"><liferay-ui:message key="an-opinion" /></strong></input>
				<a href="#" class="nyu-tooltip" title='<liferay-ui:message key="select-this-option-to-seek-an-opinion-for-a-topic" />'> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></a> </p> 
				<ul id="requestOpinion" class="unstyled"> 
						<li class="clearfix"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-slate.gif" class="pull-right" style="width: 24px;"/>  
						<span class="pull-left"> 
							<liferay-ui:message key="do-you-think-the-us-budget-is-fairly-balanced-yes-no-maybe" />. 
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-slate.gif" class="pull-right" style="width: 24px;"/>
						<span class="pull-left">
							<liferay-ui:message key="which-is-your-favorite-restaurant-otto-babbo-butter-basta-pasta" />.
						</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-slate.gif" class="pull-right" style="width: 24px;"/>
						<span class="pull-left">
							<liferay-ui:message key="do-you-think-nasa-s-budget-should-be-increased-decreased-or-kept-as-is-yes-no" /> 
						</span></li>
						<!-- <li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-slate.gif" class="pull-right" style="width: 24px;"/>
						<span class="pull-left">Is Google Hangout better than Skype for video conferencing (yes or no)?</span></li>
						<li class="clearfix hidden"> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-slate.gif" class="pull-right" style="width: 24px;"/>
						<span class="pull-left">What browser is best to play MP4s: Chrome, Explorer, Firefox, or Safari? </span></li> -->
						


						
						<li class="clearfix hidden">
							<label class="nyu-tooltip" title='<liferay-ui:message key="edit-the-possible-answers-to-your-poll-separate-answers-with-a-comma" />'>
								<liferay-ui:message key="enter-poll-choices" /> 
							<img src="<%= Constant.COMMON_THEME_IMAGE_PATH %>portlet/help.png"/></label>
							 <aui:input type="textarea" id="opnionSurveyOption" name="opnionSurveyLink" label=""  placeholder="e-g-yes-no-maybe" 
								cssClass="input-block-level">
								<aui:validator name="custom" errorMessage="options-cannot-contain-duplicates">
									function (val, fieldNode, ruleValue) {
									var res = val.split(",");
									var checkDuplicateOpinions = [];
									for(var i=0;i < res.length; i++){
										if(checkDuplicateOpinions.indexOf(res[i].toLowerCase().trim()) == -1) {
											checkDuplicateOpinions.push(res[i].toLowerCase().trim());
										} 
									}
									return (checkDuplicateOpinions.length == res.length);
									}
								</aui:validator>
								<aui:validator name="custom" errorMessage="please-enter-atleast-two-options">
									function (val, fieldNode, ruleValue) {
										var result = true;
										if(val.trim().length > 0){
											var res = val.split(",");
											var formattedOpinions = [];
											for(var i=0;i < res.length; i++){
											if(res[i].trim().length > 0) {
												formattedOpinions.push(res[i]);
											}
											result =  formattedOpinions.length >= 2; 
										}
											
										}
									return result;
									}
								</aui:validator>
								<aui:validator name="custom" errorMessage="please-remove-extra-commas(,)">
									function (val, fieldNode, ruleValue) {
										var result = true;
										if(val.trim().length > 0){
											var res = val.split(",");
											if(res.length <= 2 && res[0].trim().length > 0){
												return true;
											}
											var formattedOpinions = [];
											for(var i=0;i < res.length; i++){
											if(res[i].trim().length > 0) {
												formattedOpinions.push(res[i]);
											}
											result =  formattedOpinions.length == res.length; 
										}
											
										}
									return result;
									}
								</aui:validator>
								<aui:validator name="custom" errorMessage="please-enter-less-than-6-options">
									function (val, fieldNode, ruleValue) {
										var result = validateOptionCount();
									return result;
									}
								</aui:validator>
								</aui:input>
							<!--  <p id="surveyLinkErrorId" style="display:none; color:red;"></p> -->
						</li>
						
				</ul>	
				<p id="checkBoxErrorId" style="display:none; color:#ff0000;"></p>	
			</div>
		</div> <!--  end request-body  -->	
			<footer>
				<a class="btn request-cancel" href="javascript:void(0)">
					<liferay-ui:message key="cancel" /> 
				</a> 
				<a class="btn btn-primary pull-right new-step" id="next" href="javascript:void(0)"> 
					<liferay-ui:message key="next" /> 
				</a>
			</footer> 
	</div> <!-- input-request request-progress -->
 
	<!--  ============= Existing Request =============== -->
	<div id="existingRequest" class="existing-request request-progress" style="display: none;">
		<h3 style="padding: 15px 15px 0 15px; line-height: normal; margin: 0;">
			<liferay-ui:message key="check-for-existing-requests" />
		</h3>
		<ul class="unstyled request-body scroll-overFlow" id="content">
			
		</ul> <!-- end unstyled -->
		
		<!-- ==== Request Details ==== -->
		<div id="requestDetail" style="display:none; padding: 15px;">
			<p class="text-right"><a class="btn" id="backToExistingRequest"> <i class="icon-hand-left"></i> 
				<liferay-ui:message key="back" />
			</a> </p>		     
			<div class="media shadow" style="border-radius: 0px; padding: 10px;">  
				<img src="" class="pull-right request-type-img"/> 
				<div class="media-body"> 
					<h5 class="media-heading"> <a class="request-name" href="#"> </a><!-- Request name  --></h5>
					<p> <span  style="margin-right: 15px;" class="request-user-name"> <!-- Nawaz Ali --></span>  
						<span class="request-create-date"><!--  12-02-2014e --> </span> 
					</p>
					<p> <span  style="margin-right: 15px;"> <i class="icon-thumbs-up appreciateAnswer"></i> 
							<span class="request-appreciate"><!-- 256 --> </span>
						</span>
						<span class="label label-success request-answered" style="display: none;"> 
							<liferay-ui:message key="answered" /> 
						</span>
						<span class="label label-default request-not-answered" style="display: none;">
							<liferay-ui:message key="no-answer-yet" />
						</span>
					</p> 
				</div> <!--  end media-body -->
			</div> <!-- end media -->	 	
		</div> <!--  end requestDetail -->
		<footer>
			<a class="btn request-cancel" href="#">
				<liferay-ui:message key="cancel" /> 
			</a>		
			<div class="pull-right">
				<a class="prev-step btn" href="#">
					<liferay-ui:message key="previous" /> 
				</a>
			 	<a class="btn btn-primary new-step" href="#"> 
			 		<liferay-ui:message key="this-is-a-new-request" /> 
			 	</a>
			</div>
		</footer>
	</div> <!--  end existing-request request-progress --> 

	<!--  ============= New Request =============== -->
	<div class="existing-request request-progress" style="display: none;">
		<div class="request-body">
			<%@include file="/WEB-INF/jsp/common/includeCategory.jsp"%>
			<%@include file="/WEB-INF/jsp/common/includeTag.jsp"%>
			<aui:input type="radio" name="sendTo" cssClass="sendTo" value="0" label='everyone-can-see-this-request' checked="true"/> 
			<aui:input type="radio" name="sendTo" cssClass="sendTo" value="1" label='send-to-a-group' /> 
	
			<div id="checkGroup" style="padding-left: 20px; display:none;" >
				<aui:field-wrapper>
					<aui:fieldset>
						<c:if test="${empty groups}">
								<p> <b class="text-info">
									<liferay-ui:message key="no-groups-found" />.
								</b> </p> 
						</c:if>
							<aui:select name="usergroups"  id="usergroups" required="true" label=""  cssClass="checkbox-check scroll-overFlow ">
							<aui:option  label='cselect' value=""/>
							<c:forEach items="${groups}" var="group" varStatus="i">
							<c:set var="groupId" value="${group.groupId}" scope="page" />
							  <aui:option id="${group.userGroupId}"  value="${group.userGroupId}">${group.name}</aui:option>
							  </c:forEach>
							</aui:select>
							<!-- <p id="selectGroupErrorId" style="display:none; color:#b50303;"></p>	 -->
					</aui:fieldset>
				</aui:field-wrapper>
			</div> 
			<div>
			</div>  
		</div>
		
		<footer>
			<a class="btn request-cancel" href="#">
				<liferay-ui:message key="cancel" /> 
			</a>		
			<div class="pull-right"><a class="prev-step btn" href="#">
				<liferay-ui:message key="previous" /> 
			</a> 
			<a class="btn btn-primary" href="#" id="createRequest" > 
				<liferay-ui:message key="request" /> 
			</a></div>
		</footer>
	</div> <!--  end existing-request request-progress --> 
</aui:form>

<%@include file="/WEB-INF/jsp/common/categoriesSelector.jsp"%>
<%@include file="/WEB-INF/jsp/common/tagsSelector.jsp"%>


<script>	
		
		var req_Information="<%=Constant.REQUEST_INFORMATION%>";
		var req_Lesson="<%=Constant.REQUEST_LESSON%>";
		var req_Collaborator="<%=Constant.REQUEST_COLLOBORATION%>";
		var req_Opinion="<%=Constant.REQUEST_OPINION%>";
		
		$('.optionToAnswer').on('click',function(){
		
		 $("#checkBoxErrorId").css('display','none');
		 $("#responseLabel").css('color','#000000');
		 var checkBox = $(this);
		 $("#<portlet:namespace/>opnionSurveyOption").val("");
		 if (checkBox.is(":checked")) { 
			 checkBox.closest('#requestType').find('p').hide();
			 checkBox.parent().show();
			 checkBox.closest('#requestType').find('ul').hide();  
			 checkBox.closest('p').next().show().find('li').removeClass('hidden');
			
			 var requestType=$('.optionToAnswer:checked').val();
			 if(requestType==req_Information){
				 $("#changeTitle").text('<liferay-ui:message key="seek-your-information" />');
			 }else if(requestType==req_Lesson){
				 $("#changeTitle").text('<liferay-ui:message key="seek-your-lesson" />');
			 }else 	if(requestType==req_Collaborator){
				 $("#changeTitle").text('<liferay-ui:message key="seek-your-collaborator" />');
			 }else	if(requestType==req_Opinion){
				 $("#changeTitle").text('<liferay-ui:message key="seek-your-opinion" />');
			 }else {	
				 $("#changeTitle").text('<liferay-ui:message key="make-a-request" />');
			 }
			
		 } else{ 
			 $("#checkBoxErrorId").css('display','none');
			 $("#changeTitle").text('<liferay-ui:message key="make-a-request" />');
			 checkBox.closest('#requestType').find('p').show(); 
			 checkBox.closest('#requestType').find('ul').show(); 
			 checkBox.closest('p').next().show().find('li:first-child').nextAll().addClass('hidden');
		 }
	
	});
 
	
	$("body").on("change", "#<portlet:namespace/>categoriesContent .categoryIsSelected", function(e){
		$('#<portlet:namespace/>categoriesContent .categoryIsSelected').each(function(i){
    		$(this)[0].checked = false;
        });
		$(this)[0].checked = true;
		var selectedCateItems ="<li class='textboxlistentry'>"+$(this).attr('name')+"</li>";
		$("#<portlet:namespace/>categoriesContent .modal-header ul").remove();
	    $("#<portlet:namespace/>categoriesContent .modal-header").append('<ul class="textboxlistentry-holder clearfix ny-you-category unstyled">'+selectedCateItems+'</ul>');
	});
	
	
	
	function qualtricPopupWindow(uri) {
	    var w = 800;
	    var h = 500;
	    var d = new Date();
		var n = d.getTime();
	    var left = (screen.width/2)-(w/2);
	    var top = (screen.height/2)-(h/2);
	    var url = uri;
	    return window.open(url, '_blank', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width='+w+', height='+h+', top='+top+', left='+left);
	}
	
	
</script>


