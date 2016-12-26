<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="java.text.SimpleDateFormat"%>
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
<%@page import="java.util.Calendar"%>
<%@page import="com.liferay.portlet.expando.model.ExpandoColumn"%>
<%@page import="com.liferay.util.portlet.PortletProps, com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@include file="/WEB-INF/jsp/init.jsp"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.service.ListTypeServiceUtil"%>
<%@page import="com.liferay.portal.model.ListType"%>
<%@page import="com.liferay.portal.model.Contact"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.util.PortletKeys"%>
<%@page import="java.io.Serializable"%>
<%@page import="java.util.Date"%>
<%@page import="com.liferay.portlet.expando.model.ExpandoColumnConstants"%>
<%@page import=" com.liferay.portlet.journal.model.JournalArticle"%>
<%@page import=" com.liferay.portlet.journal.service.JournalArticleLocalServiceUtil"%>
<%@page import=" com.liferay.portlet.journal.service.JournalArticleResourceLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.model.AssetEntry"%>
<%@page import="com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil"%>
<%@page import="com.liferay.portlet.journal.model.JournalArticleResource"%>
<script src='<%=themeDisplay.getPathThemeJavaScript()%>/jquery/jquery-1.11.0.min.js' type="text/javascript"></script>
<portlet:resourceURL var="deleteImageURL" id="deleteImageURL" /> 

<portlet:renderURL var="uploadImage" windowState="pop_up">
	<portlet:param name="action" value="uploadImage" />
</portlet:renderURL>
<portlet:actionURL var="userProfileURL">
	<portlet:param name="action" value="userProfile" />
</portlet:actionURL>

<%
	user = (User)request.getAttribute(Constant.COMMON_LOGGED_IN_USER);
%>

<%
List<ListType> prefixList =ListTypeServiceUtil.getListTypes(Contact.class.getName() + ".prefix");

List<ListType> suffixList =ListTypeServiceUtil.getListTypes(Contact.class.getName() + ".suffix");

String title = StringPool.SPACE;
String suffix = StringPool.SPACE;

if(user.getContact().getPrefixId()!= 0)
title = ListTypeServiceUtil.getListType(user.getContact().getPrefixId()).getName();
	
if(user.getContact().getSuffixId()!= 0)
suffix = ListTypeServiceUtil.getListType(user.getContact().getSuffixId()).getName();

Date birthDay = user.getContact().getBirthday();

SimpleDateFormat formatter = new SimpleDateFormat(Constant.COMMON_MM_DD_YYYY_DATE_FORMAT);
String formattedBirthDay=null;
if(Validator.isNotNull(birthDay) && !(birthDay.equals(""))){
	formattedBirthDay=new SimpleDateFormat(Constant.COMMON_MM_DD_YYYY_DATE_FORMAT).format(birthDay);
}else{
	birthDay = new Date();
}

%>
<span id="successMessage">
<liferay-ui:success key="sucess" message="system-successfully-saved-the-information" />
</span>

<aui:form method="post" name="userProfileForm" action="<%=userProfileURL%>" onSubmit="event.preventDefault();validateUserDetailsForm()">

	<c:set var="fieldsForNyu" value='<%= Constant.IS_FOR_VENDOR %>' />
	
	<aui:model-context bean="<%=request.getAttribute(\"loggedInUser\")%>"
		model="<%=User.class%>" />
		
	<div class="container">
		<div class="row-fluid">
		
		
			<div class="form-group span6">
			<h3><liferay-ui:message key="details" /></h3>
				<aui:input type="text" name="screenName" id="screenName"
					maxlength="40" value="${loggedInUser.screenName}"
					label="Username" readonly="readonly"/>
				<aui:input type="text" name="emailAddress" id="emailAddressId"
					value="${loggedInUser.emailAddress}" label="email-address" >
					<aui:validator name="email"/>
					<aui:validator name="required"/>
					<aui:validator name="maxLength">75</aui:validator>
				</aui:input>

				<aui:select name="prefixList" label="title" style="width: 80px;">
					<aui:option value=" "><liferay-ui:message key="small-select" /></aui:option>
					<%
						for (ListType title1 : prefixList) {
					    	boolean selected=false;
					    	if(title.equalsIgnoreCase(ListTypeServiceUtil.getListType(title1.getListTypeId()).getName()))
					    		selected=true;
					    	else
					    		selected=false;
					%>
					<aui:option
						value="<%=ListTypeServiceUtil.getListType(title1.getListTypeId()).getListTypeId()%>"
						selected="<%=selected%>">
						<liferay-ui:message
							key="<%=ListTypeServiceUtil.getListType(title1.getListTypeId()).getName()%>" />
					</aui:option>
					<%
						}
					%>
				</aui:select>
				
				<aui:input type="text" name="firstName" id="firstNameId"
					value="${loggedInUser.firstName}" label="first-name">
					<aui:validator name="required"/>
					<aui:validator name="maxLength">75</aui:validator>
 				</aui:input>	
				<aui:input type="text" name="middleName" id="middleNameId"
					value="${loggedInUser.middleName}" label="middle-name">
					<aui:validator name="maxLength">75</aui:validator>
				</aui:input>
				<aui:input type="text" name="lastName" id="lastNameId"
					value="${loggedInUser.lastName}" label="last-name">
					<aui:validator name="maxLength">75</aui:validator>
				</aui:input>	

				<aui:select name="suffixList" label="suffix" style="width: 80px;">
					<aui:option value=" " label="small-select" />
					<%
						for (ListType suffix1 : suffixList) {
					    	boolean selected=false;
					    	if(suffix.equalsIgnoreCase(ListTypeServiceUtil.getListType(suffix1.getListTypeId()).getName()))
					    		selected=true;
					    	else
					    		selected=false;
					%>
					<aui:option
						value="<%=ListTypeServiceUtil.getListType(suffix1.getListTypeId()).getListTypeId()%>"
						selected="<%=selected%>">
						<liferay-ui:message
							key="<%=ListTypeServiceUtil.getListType(suffix1.getListTypeId()).getName()%>" />
					</aui:option>
					<%
						}
					%>
				</aui:select>


				<div class="user-custom-fields">
 					<liferay-ui:custom-attribute classPK="<%=user != null ? user.getUserId() : 0%>" name="anonymous-user" className="<%=User.class.getName()%>" editable="<%=true%>" label="false" />
					
					<div class="control-group">
						<liferay-ui:custom-attribute classPK="<%=user != null ? user.getUserId() : 0%>" name="author-info" className="<%=User.class.getName()%>" editable="<%=true%>" label="true">
						</liferay-ui:custom-attribute>
						<span class="about-me-error help-inline hide">Please enter no more than 500 characters. </span>
					</div>	
										
					<%-- 	condition by asif		--%> 
					<c:if test="${ fieldsForNyu }">
						<div>
							<span style="float: left;margin-right: 10px;line-height: 30px;"><liferay-ui:message key="nyu-alumni-student" /></span>
							 <span>
								<aui:select name="nyuAlumni" label="">
								  	<aui:option value="true" label="yes" />
									<aui:option value="false" label="no"/>					 
								</aui:select>
							</span> 
						</div>
						
						<div id="toggle-alumni">
							<liferay-ui:custom-attribute classPK="<%=user != null ? user.getUserId() : 0%>" name="nyu-school" className="<%=User.class.getName()%>" editable="<%=true%>" label="true" />	
							<liferay-ui:custom-attribute classPK="<%=user != null ? user.getUserId() : 0%>" name="year-of-passing" className="<%=User.class.getName()%>" editable="<%=true%>" label="true" />
						</div>
					</c:if>
				</div>
				
				<label><liferay-ui:message key="birth-day" /></label>
				 <div style="position: relative; width: 252px;" class="clearfix">
				 
					<c:set value="<%=new SimpleDateFormat(\"MM\").format(birthDay)%>" var="userMM" /> 
					<c:set value="<%=new SimpleDateFormat(\"dd\").format(birthDay)%>" var="userDD" /> 
					<c:set value="<%=new SimpleDateFormat(\"yyyy\").format(birthDay)%>" var="userYY" /> 
					
					<span class="span4">
						<aui:select name="bdMonth" label="" cssClass="bdSelector" onChange="showNoOfDays(this.value);">
							<aui:option value="01">Jan</aui:option>
							<aui:option value="02">Feb</aui:option>
							<aui:option value="03">Mar</aui:option>
							<aui:option value="04">Apr</aui:option>
							<aui:option value="05">May</aui:option>
							<aui:option value="06">Jun</aui:option>
							<aui:option value="07">Jul</aui:option>
							<aui:option value="08">Aug</aui:option>
							<aui:option value="09">Sept</aui:option>
							<aui:option value="10">Oct</aui:option>
							<aui:option value="11">Nov</aui:option>
							<aui:option value="12">Dec</aui:option>
						</aui:select>
					</span>
					<span class="span4">
						<aui:select name="bdDay" label="" cssClass="bdSelector">
							<c:forEach begin="1" end="31" var="i">
								<c:if test="${i eq userDD}">
									<aui:option value="0${i}" selected="true">${i}</aui:option>		
								</c:if> 
								<c:if test="${i ne userDD}">
									<aui:option value="0${i}">${i}</aui:option>		
								</c:if>
							</c:forEach>
						</aui:select>
					</span>
					<span class="span4">   
						<c:set value="<%=new SimpleDateFormat(\"yyyy\").format(new Date())%>" var="yearlimit" /> 
						<aui:select name="bdYear" label="" cssClass="bdSelector">
							<c:forEach begin="1905" end="${yearlimit}" var="i">
								<c:if test="${i eq userYY}">
									<aui:option value="${i}" selected="true">${i}</aui:option>		
								</c:if> 
								<c:if test="${i ne userYY}">
									<aui:option value="${i}">${i}</aui:option>		
								</c:if>
							</c:forEach>
						</aui:select>
					</span>
				 </div> 
				<div class="span12 no-margin">
					<span class="span5">
						<aui:select name="gender" id="gender" label="gender">
							<aui:option label="male" value="male" />
							<aui:option label="female" value="female" />
							
							<c:if test="${genderValue eq 'male' || genderValue eq 'female' || genderValue eq 'ntd'}">
								<aui:option label="customize"  value="Customise"/>
							</c:if>
							<c:if test="${genderValue ne 'male' && genderValue ne 'female' && genderValue ne 'ntd'}">
								<aui:option label="customize" value="${genderValue}"/>
							</c:if> 
							<aui:option label="prefer-not-to-disclose"  value="ntd"/>
						</aui:select>
					</span>
					<span class ="span6" id="selectGroup" style="display:none">
						<aui:input type="text" style="margin-top:25px;" name="customGender" placeholder="enter-text-here" label="" value="${customisedGenderValue}">
						</aui:input>
						<p id="enterGenderErrorId" style="display:none; color:red; margin-top:-14px;"></p>
					</span>
				</div>


			</div>

			<div class="form-group span6">

				
				<img src="<%=user.getPortraitURL(themeDisplay)%>" id="userImageId" style="margin-bottom: 5px;" class="img-polaroid"></img></br>
				<span class="btn btn-default" onclick="uploadImage('<%=uploadImage%>','Upload Image')"><liferay-ui:message key="change" /></span>
				<span class="btn btn-default" id="deleteButtonId" onclick="deleteUserImage()"><liferay-ui:message key="delete" /></span>
				
				</br></br>
					<%-- <liferay-ui:input-date yearParam="year" monthParam="month" dayParam="day"  
				    yearValue="<%=year%>" monthValue="<%=month %>" 
				    dayValue="<%=day%>" name="birthday"/> --%>
				 <%-- <div style="position: relative; width: 252px;" class="clearfix">
				    <aui:input type="text" name="birthdayDate" label="Birthday" value="<%=formattedBirthDay%>" inlineField="test" cssClass="pull-left birthDayInputClick">	
				    <aui:validator name="date"></aui:validator>			    
				   	<i class="fa fa-calendar birthdayDateDisplay" style="font-size: 28px; position: absolute; cursor:pointer; top: 25px; right : 0; margin-left: 10px;" id="birthdayDateDisplay"></i>
				   	</aui:input>
				 </div> --%>
				
				<!-- new fields introduced by microexcel -->
				<div class="span12 no-margin">
					<liferay-ui:custom-attribute classPK="<%=user != null ? user.getUserId() : 0%>" name="marital-status" className="<%=User.class.getName()%>" editable="<%=true%>" label="true" />
				</div>
				<div class="span12 no-margin">
					<liferay-ui:custom-attribute classPK="<%=user != null ? user.getUserId() : 0%>" name="race" className="<%=User.class.getName()%>" editable="<%=true%>" label="true" />
				</div>
				<div class="span12 no-margin">
					<liferay-ui:custom-attribute classPK="<%=user != null ? user.getUserId() : 0%>" name="annual-household-income-range" className="<%=User.class.getName()%>" editable="<%=true%>" label="true" />
				</div>
				<div class="span12 no-margin">
					<liferay-ui:custom-attribute classPK="<%=user != null ? user.getUserId() : 0%>" name="have-health-insurance?" className="<%=User.class.getName()%>" editable="<%=true%>" label="true" />
				</div>
				<div class="span12 no-margin">
					<liferay-ui:custom-attribute classPK="<%=user != null ? user.getUserId() : 0%>" name="highest-level-of-education-completed" className="<%=User.class.getName()%>" editable="<%=true%>" label="true" />
				</div>
				<div class="span12 no-margin">
					<liferay-ui:custom-attribute classPK="<%=user != null ? user.getUserId() : 0%>" name="zipcode" className="<%=User.class.getName()%>" editable="<%=true%>" label="true" />
				</div>
				<!-- end -->

				<aui:input type="text" name="userProfileJobTitle" id="jobTitleId"
					value="<%=user.getContact().getJobTitle() %>" label="job-title" >
					<aui:validator name="maxLength">75</aui:validator>
				</aui:input>

				<div>
					<h3><liferay-ui:message key="interests" /></h3>
					<label for=""><liferay-ui:message key="categories" /></label>
					<aui:field-wrapper>
						<aui:fieldset>
							<aui:input type="assetCategories" id="categories"
								name="categories" label="categories"></aui:input>
						</aui:fieldset>
						</br>
						<aui:fieldset cssClass="onlyTags">
							<aui:input id="tags" name="tags" type="assetTags" label="tags" />
						</aui:fieldset>
					</aui:field-wrapper>
				</div>
				<c:if test="${isEmailDigestEnabled}">
					<div>
						<span>
							<aui:input type="checkbox" checked="${emailDigestStatus}" name="subscribeEmailDigest" id="subscribeEmailDigest"  label="" />
						</span>
						<span>
							<liferay-ui:message key="subscribe-to-email-digest" />
						</span>
					</div>
					<div id="toggle-notify">
						<span style="float: left;margin-right: 10px;line-height: 30px;"><liferay-ui:message key="notify-me-if-i-m-inactive-for" /></span>
						<span>
							<aui:select name="emailDigestInactive" label="">
								<c:forEach var="i" begin="1" end="10">
									 <c:if test="${i eq notifyEmaildigest }">
									  	<aui:option value="${i}" selected="true">
									  		${i} <c:if test="${i <= 1}">
												<liferay-ui:message key="day" />
											</c:if> <c:if test="${i > 1}">
												<liferay-ui:message key="days" />
											</c:if>
									  	</aui:option>
									 </c:if>
									 <c:if test="${i ne notifyEmaildigest }">
										<aui:option value="${i}">
											${i} <c:if test="${i <= 1}">
												<liferay-ui:message key="day" />
											</c:if> <c:if test="${i > 1}">
												<liferay-ui:message key="days" />
											</c:if>
										</aui:option>					 
									 </c:if> 
								</c:forEach>
							</aui:select>
						</span>
					</div>
				</c:if>
				<aui:button type="submit" value="save"
						class="btn btn-primary btn-large" name="saveButton" />
				<!-- <div>
				<h5><Strong>*You have Accepted Terms of Use Agreement.</Strong></h5>
				</div> -->
			</div>
			
			<!-- end span6 -->
		</div>
	</div>
	
	
</aui:form>


<script type="text/javascript">
	/* document.getElementById('<portlet:namespace/>fileUpload').addEventListener(
			'change', <portlet:namespace />handleFileSelect, false);

	function <portlet:namespace />handleFileSelect(e) {
		var reader = new FileReader();
		reader.onload = function(event) {
			var img = new Image();
			img.onload = function() {

			}
			img.src = event.target.result;
			$('#myImage').attr("src", img.src);
		}
		reader.readAsDataURL(e.target.files[0]);
		uploadFunction();
	}

	function uploadFunction(event) {
		// returns the 2d context object
		alert("test");

		AUI().use('aui-image-cropper', function(Y) {
			new Y.ImageCropper({
				resizable : false,
				srcNode : '#myImage',
				x : 50,
				y : 50
			}).render();
		});

	} */
	var monthNumbers;
	var birthDateMonth;
	
	AUI().ready('aui-node',function(A) {
	
	monthNumbers = ["31", "28", "31", "30", "31","30", "31", "31", "30", "31","30", "31"];
	birthDateMonth = '${userMM}';
	$('#<portlet:namespace/>bdMonth').val(birthDateMonth);
    showNoOfDays(birthDateMonth);
		
	var genderValue = '${genderValue}';
	$('#<portlet:namespace/>gender').val(genderValue);
    
    if(genderValue.toLowerCase() != "male" && genderValue.toLowerCase() != "female" && genderValue.toLowerCase() != "ntd"){
		$('#selectGroup').show();
	}
    
	$('#<portlet:namespace/>gender').on('change',function(){
		if($(this).val().toLowerCase() != "male" && $(this).val().toLowerCase() != "female" && $(this).val().toLowerCase() != "ntd"){
			$('#selectGroup').show();
		}else{
			$('#selectGroup').hide(); 
		}
	});
		<c:if test="${ fieldsForNyu }">	//ON LOAD SETTING VALUES TO ALUMNI	
			document.getElementById("toggle-alumni").style.display= "none";
			A.one('#<portlet:namespace/>nyuAlumni').val("${alumniStatus}");
			var alumniStatus ='${alumniStatus}';
		    if(alumniStatus == 'true') {
			       document.getElementById("toggle-alumni").style.display= "block";
			}
		   
			A.one('#<portlet:namespace/>nyuAlumni').on('change', function(event) {
			    var checkBoxStatus = A.one('#<portlet:namespace/>nyuAlumni');
			    if(checkBoxStatus.val() == 'true') {
			       document.getElementById("toggle-alumni").style.display= "block";
			    }
		        else { 
		        	document.getElementById("toggle-alumni").style.display= "none";
		        }
			  });
			
		</c:if>		
		<c:if test="${isEmailDigestEnabled}">
		    document.getElementById("toggle-notify").style.display= "none";
			var defaultStatus = A.one('#<portlet:namespace/>subscribeEmailDigest');
		    if(defaultStatus.val() == 'true') {
		       document.getElementById("toggle-notify").style.display= "block";
		    }
		    
			A.one('#<portlet:namespace/>subscribeEmailDigestCheckbox').on('click', function(event) {
			    var checkBoxStatus = A.one('#<portlet:namespace/>subscribeEmailDigest');
			    if(checkBoxStatus.val() == 'true') {
			       document.getElementById("toggle-notify").style.display= "block";
			    }
		        else { 
		        	document.getElementById("toggle-notify").style.display= "none";
		        }
			});
		</c:if>
		
	});
	function deleteUserImage() {
		var deleteImageURL = "<%=deleteImageURL%>";
		$.ajax({
	        url:deleteImageURL,
	        type: 'GET',
	        datatype:'html',
	        success: function(data){
	        	$("#userImageId").attr("src",data);
	    	}
	      });
	}

	function uploadImage(url, windowTitle) {
		var modal = Liferay.Util.openWindow({
			dialog : {
				width : 730,
				height: 450,
				align : Liferay.Util.Window.ALIGN_CENTER,
				cache : false,
				resizable:false,
				modal : true
			},

			title : windowTitle,
			id : 'uploadImagepopup',
			uri : url
		});
		
	}
	Liferay.provide(window,
		    '<portlet:namespace/>closeUploadImagePopup',
		        function(popupIdToClose,imgsrc,withSuccessMsg) {
		    	if(imgsrc != null && imgsrc != '')
		    		$("#userImageId").attr("src",imgsrc);
		    	Liferay.Util.getOpener().closeMainImagePopup(popupIdToClose);
		    	if(withSuccessMsg != null && withSuccessMsg == 'yes'){
		    		closePopupForAllWithSuccessMsg('<liferay-ui:message key="profile-picture-saved-successfully" />');
		    	}
		        },
		        ['liferay-util-window']
		    );
	 
	/*  AUI().use(
			  'aui-datepicker',
			  function(Y) {
			   var birthDatePicker = new Y.DatePicker(
			      {
			        trigger: '#<portlet:namespace />birthdayDate',
			        mask: '%m/%d/%Y',
			        popover: {
			          zIndex: 1
			        },
			        on: {
			          selectionChange: function(event) {
			        	  var dateToday = new Date();
			        	  var date = new Date(event.newSelection);
			        	  if (date < dateToday) {
			        	  $('#<portlet:namespace />birthdayDate').val((("0" + (date.getMonth() + 1)).slice(-2)) + '/' + (("0" + (date.getDate())).slice(-2)) + '/' +  date.getFullYear());
			        	  }
			          }
			        }
			      }
			    );
			    
			     Y.all('.birthdayDateDisplay').on('click', function(event) {
			    	$("#<portlet:namespace />birthdayDate").trigger("focus");
			    	$("#<portlet:namespace />birthdayDate").data("buttonclick","yes");
			    	$("#<portlet:namespace />birthdayDate").trigger("click");
				});
			    
			     Y.all('.birthDayInputClick').on('click',function(event){
			    	var check = $("#<portlet:namespace />birthdayDate").data('buttonclick');
			    	$("#<portlet:namespace />birthdayDate").trigger("focus");
			    	$("#<portlet:namespace />birthdayDate").data('buttonclick','no');
			    	if(check == null || check =='' || check =='no'){
			    		birthDatePicker.hide();
			    		throw "Manually throwing Error(Ignore This)";
			    	}
			    	
			    });
			  }
			); */
	 
	 
	  function validateUserDetailsForm(){
		  $("#successMessage").hide();
			var noErrors = true;
			var customizedgender = $("#<portlet:namespace/>customGender").val();
			var genderDropDown = $("#<portlet:namespace/>gender").val();
			var aboutMe = $(".user-custom-fields").find('input[name=<portlet:namespace/>ExpandoAttribute--author-info--]').val();
			var specialRegex =/[a-z0-9 ]$/gi;			
			if(aboutMe.trim().length>500){
				$(".about-me-error").removeClass('hide').parent().addClass('error');
				noErrors = false;
				return noErrors;
			}
			if((genderDropDown != 'male' && genderDropDown != 'female' && genderDropDown != 'ntd') && customizedgender.trim()==''){
				$("#enterGenderErrorId").html('<liferay-ui:message key="please-enter-the-customized-gender-here" />').show();
				noErrors = false; 
				return noErrors;
			}else if((genderDropDown != 'male' && genderDropDown != 'female' && genderDropDown != 'ntd') && customizedgender.trim().length > 75){
				$("#enterGenderErrorId").html('<liferay-ui:message key="maximum-75-characters-allowed" />').show();
				noErrors = false; 
				return noErrors;
			}else if((genderDropDown != 'male' && genderDropDown != 'female' && genderDropDown != 'ntd') && (!specialRegex.test(customizedgender)))
			{	$("#enterGenderErrorId").html('No Special characters Allowed.').show();
				noErrors = false; 
				return noErrors;
			}
			if(noErrors){
				$(".about-me-error").addClass('hide').parent().removeClass('error');
				$("#enterGenderErrorId").hide();
				$("#<portlet:namespace/>userProfileForm").submit();
			}
			return noErrors;
			
		}  
				
		$(".user-custom-fields").find('input[name=<portlet:namespace/>ExpandoAttribute--author-info--]').blur(function(){
			var aboutMe = $(this).val();
			if(aboutMe.trim().length>500){
				$(".about-me-error").removeClass('hide').parent().addClass('error');
			}else{
				$(".about-me-error").addClass('hide').parent().removeClass('error');
			}
		});
		
		
	  function showNoOfDays(month){
		  var no_of_Days = monthNumbers[month-1];
		  $("#<portlet:namespace/>bdDay option").show();
		  $("#<portlet:namespace/>bdDay option").each(function(i){
			  if(!(i <= no_of_Days-1)){
			  	$( this ).hide();
			  }	
		  });		  
	  }
</script>




