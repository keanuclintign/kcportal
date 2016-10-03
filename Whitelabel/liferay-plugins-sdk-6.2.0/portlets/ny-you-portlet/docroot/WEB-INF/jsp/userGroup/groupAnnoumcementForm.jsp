<%@page import="java.util.Calendar"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="java.util.Date"%>
<portlet:resourceURL id="sendAnnouncement" var="sendAnnouncementURL"></portlet:resourceURL>
<% 
Calendar currentDate=Calendar.getInstance();
%>
<c:set var="usergroupId" value="${usergroup.userGroupId}" scope="page" />
<div id="annoucementForm">
	<div style="padding: 15px" >
		 <aui:form> 
			 <div class="">
			    <div id="success-message" class="alert-success" style="display:none">
			    	<liferay-ui:message key="announcement-sent-successfully" />.
			    </div>
				<aui:input type="text" name="title" id="title" label="title" cssClass="input-block-level">
						<aui:validator name="required" errorMessage="please-enter-the-title"/>
						<aui:validator name="maxLength" errorMessage="maximum-75-characters-allowed">75</aui:validator>
				</aui:input>
				
				<label id="descriptionLabel"> <liferay-ui:message key="description-required" /></label> 
				
				<div style="display:none">
				<liferay-ui:input-editor  resizable="false" initMethod="" skipEditorLoading="false"
				toolbarSet="edit-in-place" ></liferay-ui:input-editor>
				</div>
				
				<textarea id="announcement-message"> </textarea>
				<p id="descriptionErrorId" style="display:none; color:#ff0000;"></p> 
				
				<div id="expirLabel">
					<span><liferay-ui:message key="announcement-expiration" /></span> 
					<aui:input type="radio" name="announcementExpire" cssClass="announcementExpires" value="1" label="yes "/> 
					<aui:input type="radio" name="announcementExpire" cssClass="announcementExpires" value="0" label="no" checked="true" /> 
				</div>
				
				<span id="announcementExpiration">
					<liferay-ui:input-date  name="expiry"  yearParam="year" monthParam="month" dayParam="day"
				    yearValue="<%=currentDate.get(Calendar.YEAR) %>" monthValue="<%=currentDate.get(Calendar.MONTH)%>" 
				    dayValue="<%=currentDate.get(Calendar.DAY_OF_MONTH)%>" />	
				    	
					<p id="experyDateErrorId" style="display:none; color:#ff0000;"></p> 
				</span>
				
				
				
			</div> <!-- end scroll-overFlow -->
			<div style="margin-top: 10px;">
			  	<span class="btn btn-primary" id="send">
			  		<liferay-ui:message key="send" />
			  	</span>
			  	<span class="btn btn-primary" id="cancel"><liferay-ui:message key="cancel" /></span>
			 </div> 
		 </aui:form>
	</div>
	</div>
	<div id="addAnnouncementPopUp">
	</div>
	
	<script>
	
	
	$(document).ready(function(){
		
		var showPopOver = $('.announcementExpires:checked').val();
		if(showPopOver!=1){
			$('#announcementExpiration').hide();	
		}
		$('.announcementExpires').on('change',function(){
			if($(this).val()==1){
				$('#announcementExpiration').show();
			}else{
				$('#announcementExpiration').hide(); 
			}
		});
		
	});
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
	
	
	
	
	try{

	YUI().use('aui-modal',function(Y) {
		
			    var modal = new Y.Modal(
			      {
			        contentBox: '#annoucementForm',
			        centered: true,
			        destroyOnHide: false,
			        headerContent: '<h3><liferay-ui:message key="announcement" /></h3>',
			        modal: true,
			        render: '#addAnnouncementPopUp',
			        visible: false,
			        width: 380
			      }
			    ).render();

			   try{
			    Y.one('#makeAnnouncement').on('click', function() {
					try{
						CKEDITOR.replace('announcement-message',{
							height:130,
							width: '99.5%',
							toolbar:'simple',
							customConfig: ''
						});
					}catch(err)
					{}
					
					$("#success-message").hide();
					CKEDITOR.instances['announcement-message'].setData('');
					//popoverAnim.set('visible', !popoverAnim.get('visible'));
					$("#expirLabel").css('color','#000000');
					$("#descriptionLabel").css('color','#000000');
					$("#experyDateErrorId").hide();
					$("#descriptionErrorId").hide();
			        modal.show();
		      	});
			   }catch(err){
				  
			   }
			    
			    Y.one('#cancel').on('click', function() {
		        	$("#<portlet:namespace/>title").val("dummy").focus().blur().val("");
		        	$("#<portlet:namespace/>expiry").val("<%=currentDate.get(Calendar.MONTH)+1%>/<%=currentDate.get(Calendar.DAY_OF_MONTH)%>/<%=currentDate.get(Calendar.YEAR) %>");
		        	$('#announcementExpiration').hide();
		        	$("input[name='<portlet:namespace/>announcementExpire']").removeAttr('checked');
		        	$("input[name='<portlet:namespace/>announcementExpire'][value='0']").prop("checked",true);
		        	modal.hide();
		        });
			     
		        Y.all('#send').on('click', function() {
		        	 
		        	var announcenemetExperyLabel=$('.announcementExpires:checked').val();
		        	var experyDate=true;
		        	var expiryDateValidate = true;
		        	
		        	$("#experyDateErrorId").hide();
		        	if(announcenemetExperyLabel==1){
		        	
		        	var month=parseInt($("#<portlet:namespace/>month").val())+1;
		        	var date=$("#<portlet:namespace/>year").val()+"/"+month+"/"+$("#<portlet:namespace/>day").val();
		        	var selectedExpeiryDate=new Date(date);
		        	var now=new Date();
		        	var month=parseInt(now.getMonth())+1;
		        	var currentDate=new Date(now.getFullYear()+"/"+month +"/"+now.getDate());
		        	
		        	if(selectedExpeiryDate.getTime()<currentDate.getTime() || selectedExpeiryDate.getTime()==currentDate.getTime())
	   					experyDate=false;
		   			
		        	}
		           	if(announcenemetExperyLabel==1 && $("#<portlet:namespace/>expiry").val().trim() == "" ){
		           		$("#experyDateErrorId").html('<liferay-ui:message key="date-cannot-be-empty"/>');
		           		$("#experyDateErrorId").show();
		           		expiryDateValidate = false;
		           	}
		       		var title=$("#<portlet:namespace/>title").val();
			  		var description=CKEDITOR.instances['announcement-message'].getData();
			  		var descriptionLength = $("#cke_announcement-message").find("iframe").contents().find("body").text().trim();
			  		
			  		if(title.trim().length > 75){
			  			$("#<portlet:namespace/>title").focus().blur().focus();
			  			return false;
			  		}
			  		if(title.length>0 && descriptionLength.length>0 && experyDate && expiryDateValidate ){
						  $.ajax({
						    url:'<%=sendAnnouncementURL%>',
						    type: 'POST',
						    datatype:'html',
						    data:{
						    	"<portlet:namespace />title": title,
						    	"<portlet:namespace />description":description,
						    	"<portlet:namespace />userGroupId":'${usergroupId}',
						    	"<portlet:namespace />dateAndTime":date
						    },
						    success: function(data){
						    	$("#<portlet:namespace/>title").val("");
						    	CKEDITOR.instances['announcement-message'].setData('');
						    	$("#success-message").show();
						    	$("#expirLabel").css('color','#000000');
						    	$("#descriptionLabel").css('color','#000000');
					  			$("#experyDateErrorId").hide();
					  			$("#descriptionErrorId").hide();
					  			if('${mystuffRedirectUrl}' != ''){
					  				window.location.href = '${mystuffRedirectUrl}'; 
					  			}else{
					  				var e = $('#groupsController');
					  				scope = angular.element(e).scope();
					  				scope.$apply(function() {
					  					scope.groupAnnouncements=JSON.parse(data);
					  			   	});
					  				modal.hide();
					  			}
						     }
						});   
			  		}else if(title.length==0  && descriptionLength.length==0){
						$("#descriptionLabel").css('color','#ff0000');
			  			$("#descriptionErrorId").html('<liferay-ui:message key="please-enter-the-description" />');
						$("#descriptionErrorId").show();
						
			  			$("#<portlet:namespace/>title").focus();
			  			$("#<portlet:namespace/>title").blur();
			  			$("#<portlet:namespace/>title").focus();
						return "false";
		    	  
			  		}else if(title.length==0){
			  			if(descriptionLength.length>0){
				  			$("#descriptionLabel").css('color','#000000');
				  			$("#descriptionErrorId").hide();
			  			}
			  			
			  			$("#<portlet:namespace/>title").focus();
			  			$("#<portlet:namespace/>title").blur();
			  			$("#<portlet:namespace/>title").focus();
						return "false";
			  			
			  		}else if(descriptionLength.length==0){
			  			$("#descriptionLabel").css('color','#ff0000');
			  			$("#descriptionErrorId").html('<liferay-ui:message key="please-enter-the-description" />');
						$("#descriptionErrorId").show();
			  			
			  		}else if(!expiryDateValidate){
			  			$("#experyDateErrorId").html('<liferay-ui:message key="date-cannot-be-empty"/>');
			  		}else if(!experyDate){
			  			$("#experyDateErrorId").html('<liferay-ui:message key="please-enter-date-greater-than-the-current-date" />');
			  			$("#descriptionErrorId").hide();
			  			$("#descriptionLabel").css('color','#000000');
			  			$("#experyDateErrorId").show();
			  		} 
				  });    
			    
  });
}catch(err){
	(err);
}
	
	
	
	
     </script>	  