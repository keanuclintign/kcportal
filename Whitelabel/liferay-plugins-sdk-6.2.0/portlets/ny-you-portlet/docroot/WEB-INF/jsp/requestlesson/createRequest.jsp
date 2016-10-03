
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.service.UserGroupLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.liferay.portal.model.UserGroup"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.service.GroupLocalServiceUtil"%>
<%@page import="com.nyu.service.RequestLessonLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.OrderFactoryUtil"%>

<%@taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui"%>
<%@page import="com.nyu.model.RequestLesson"%>
<%@ include file="/WEB-INF/jsp/init.jsp"%>

<portlet:renderURL var="redirectURL" />
<portlet:renderURL var="requestDetailURL" windowState="MAXIMIZED">
	<portlet:param name="action" value="requestDetails"/>
</portlet:renderURL>
<script type="text/javascript"	src="<%=request.getContextPath()%>/js/angular/requestLessons.js?">
</script>


<portlet:resourceURL id="createRequest" var="createRequestURL" />
<portlet:resourceURL id="existingRequest" var="existingRequestURL" />


<div id="popOverBodyCotentRequest" style="display:none;">
	<%@include file="createRequestPopup.jsp"%>
</div>
<!-- end start create-new-request -->

<div class="custom-alert section-draft-alert">  						
				<div class="message-body" style="top:50%; margin-top:-75px"> 
						<h4 class="message-heading"><i class="icon-info-sign" style="font-size: 30px;"></i></h4>
						<div class="content"> <b>
							<liferay-ui:message key="request-created-successfully" />.
						</b></div>
				</div>  <!--  end message-body --> 						
</div> <!--  end custom-alert -->




<!-- end popOverBodyCotentRequest -->
<script>
	
	var showPopOver = <%=request.getParameter("showPopOver")!=null ? true : false%>;
	var words="<%= Constant.PORTLET_PROP_LIFERAY_SITE_EXISTING_REQUEST_SEARCH_WORD.trim().toLowerCase()%>";
	var restricted_searchWords=words.split(",");
	
	$('.sendTo').on('change',function(){
		$('#checkGroup').show(); 
		if($(this).val()==0){
			$('.checkbox-check').prop('selectedIndex',0);
			$('#checkGroup').hide(); 
		}		
	});
	

// EXISTING REQUEST
      var  matcheddata;                      
      $('#next').click(function(event){
    	 $("#checkBoxErrorId").hide();	
    	 var name=$("#_requestlesson_WAR_nyyouportlet_name").val().trim();
    	  if( name.length>=4 && name.length<=100 && $('.optionToAnswer').is(":checked") ) {
    		 
    		  		name=name.replace(/[^a-zA-Z ]/g, "").split(" ");
    		    	$("#checkBoxErrorId").hide();	
    		    	if(validateOptions() && validateOptionCount()){
	          		 	$(this).closest('.request-progress').hide().next().fadeIn();
						event.preventDefault();
						$.ajax({
							url:'<%=existingRequestURL%>',
							type: 'GET',
							datatype:'html',
							data:{
							<portlet:namespace/>name:$("#_requestlesson_WAR_nyyouportlet_name").val(),
							<portlet:namespace/>answerType:$('.optionToAnswer:checked').val()
						},
						success: function(data){
								matcheddata=JSON.parse(data);
								$("#content li").remove();
		              	        if(matcheddata.length>0){
		              	        	for(i=0;i<matcheddata.length;i++){
		              	        		var url="<%=requestDetailURL%>&_requestlesson_WAR_nyyouportlet_requestLessonId="+matcheddata[i].requestId;
			              	       		
		              	        		if(matcheddata[i].requestType==req_Collaborator){
		              	        			$("#content").append("<li><a onClick=<portlet:namespace/>requestDetails('"+matcheddata[i].requestId+"') href=javascript:void(0);>"+matcheddata[i].name+'</a><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-user-group.gif"'+" style='width: 18px; margin-left: 20px;'></li>");
										}else if(matcheddata[i].requestType==req_Information){
											$("#content").append("<li><a onClick=<portlet:namespace/>requestDetails('"+matcheddata[i].requestId+"') href=javascript:void(0);>"+matcheddata[i].name+'</a><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-group-chat.gif"'+" style='width: 18px; margin-left: 20px;'></li>");
										}else if(matcheddata[i].requestType==req_Lesson){
											$("#content").append("<li><a onClick=<portlet:namespace/>requestDetails('"+matcheddata[i].requestId+"') href=javascript:void(0);>"+matcheddata[i].name+'</a><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-lesson.gif"'+" style='width: 18px; margin-left: 20px;'></li>");
										}else if(matcheddata[i].requestType==req_Opinion){
											$("#content").append("<li><a onClick=<portlet:namespace/>requestDetails('"+matcheddata[i].requestId+"') href=javascript:void(0);>"+matcheddata[i].name+'</a><img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-slate.gif"'+" style='width: 18px; margin-left: 20px;'></li>");
										}
		            	        	}
		              	        	for(var i=0;i<name.length;i++){
		              	        		var searchWord=name[i].toLowerCase();
		              	        		var index=Number(restricted_searchWords.indexOf(searchWord));
		              	        		if(searchWord.length>2 && index==-1){
		              	        			var pattren=new RegExp(name[i],"gi");
				              	        	$("#content li a").each(function(){
				              	        		$(this).html($(this).html().replace(pattren,"<strong>"+name[i]+"</strong>"));
				              	        	});
		              	        		}
		              	        	}
		              	        } 
		              	        else{
		              	        	$("#content").append('<li><liferay-ui:message key="no-request-match" /></li>');
		              	        }
	              	       }
	              	     
	                 	}); 
	                 	 return "true"; 
	                 	 
    		    	}else{
    		    		$("#<portlet:namespace/>opnionSurveyOption").focus();
    					$("#<portlet:namespace/>opnionSurveyOption").blur();
    					$("#<portlet:namespace/>opnionSurveyOption").focus();
    					return "false";    		    	
   					}
    		   
		  }else if($("#_requestlesson_WAR_nyyouportlet_name").val().trim().length<4 && !$('.optionToAnswer').is(":checked")){
				$("#responseLabel").css('color','#ff0000');
    		  	$("#checkBoxErrorId").html('<liferay-ui:message key="please-select-the-response-type" />');
				$("#checkBoxErrorId").show();
				$("#<portlet:namespace/>name").focus();
				$("#<portlet:namespace/>name").blur();
				$("#<portlet:namespace/>name").focus();
				return "false";
    	  } else if(!$('.optionToAnswer').is(":checked")){
    		  	$("#responseLabel").css('color','#ff0000');
    		  	$("#checkBoxErrorId").html('<liferay-ui:message key="please-select-the-response-type" />');
				$("#checkBoxErrorId").show();
				return "false"; 
    	  }else{
    		 	$("#responseLabel").css('color','#000000');
				$("#checkBoxErrorId").hide();
				$("#<portlet:namespace/>name").focus();
				$("#<portlet:namespace/>name").blur();
				$("#<portlet:namespace/>name").focus();
				return "false";
    	  }
    	  
      
              	        
      });
      
      
      $('.new-step').click(function(event){
    	  
    	  if( $("#_requestlesson_WAR_nyyouportlet_name").val().trim().length>=4 && $("#_requestlesson_WAR_nyyouportlet_name").val().trim().length<=100 && $('.optionToAnswer').is(":checked") ){
    		  if($('.optionToAnswer:checked').val()==req_Opinion){
    		  		if(validateOptions() && validateOptionCount()){
    		  			$(this).closest('.request-progress').hide().next().fadeIn();
      					event.preventDefault();
    		  		}
    		  	}else{
    		  		$(this).closest('.request-progress').hide().next().fadeIn();
    				event.preventDefault();
    		  	}
    	  }
      });
      
      $('.prev-step').click(function(event){
    	 
    	  
                      $(this).closest('.request-progress').hide().prev().fadeIn();
                      event.preventDefault();
      });
                                
     


// CREATE NEW REQUEST POPOVER
               

  		
        YUI().use('widget-anim','aui-modal', function(Y) { 
			resourceFileModal = new Y.Modal(
	  		      {
	  		        contentBox: '#popOverBodyCotentRequest',
	  		        centered: true,		
	  		        destroyOnHide: false,
	  		        headerContent: '<h3 id="changeTitle"> <liferay-ui:message key="make-a-request" /> </h3>',  
	  				modal: true,
	  		        render: '#addRequestPopUp', 
	  				visible: false,
	  		        width: 380,
	  		      	zIndex: 999,
	  		        resizable:false
	  		      }
	  		    ).render();
	  		    
	  		    Y.one('#makeRequest').on('click', function() {
	  		    	$("#popOverBodyCotentRequest").show();
	  		    	$("#responseLabel").css('color','#000000');
	  		    	$('#checkGroup').hide(); 
	  		    	$("#checkBoxErrorId").hide();	
	  		    	$("#_requestlesson_WAR_nyyouportlet_name").focus();
	  		    	$(".form.requestForm")[0].reset();
	  		    	$("#changeTitle").text('<liferay-ui:message key="make-a-request" />');
	  				resourceFileModal.show();   				
	  		    });
	  		    
	  		  	Y.one('#createRequest').on('click', function() {
	  		  		
	  		  			if($('.sendTo:checked').val()==1){
		  		  			var groupId=$("#<portlet:namespace/>usergroups option:selected").val();
							if(groupId.length==0){
								$("#<portlet:namespace/>usergroups").focus();
								$("#<portlet:namespace/>usergroups").blur();
								$("#<portlet:namespace/>usergroups").focus();
								return false;
							}else{
							
								resourceFileModal.hide();
								submitRequest();
								$(".form.requestForm")[0].reset();
							}
	  		  			}else{
			  		  			resourceFileModal.hide();
								submitRequest();
								$(".form.requestForm")[0].reset();
	  		  			}
			    });
	  		  	
			    Y.all('.request-cancel').on('click', function(event) {
			    	$(".form.requestForm")[0].reset();
					resourceFileModal.hide();
			    });
             
         
});
                    		
   // EXISTING REQUEST
   
		
function submitRequest(){
	
	$.ajax({
	        url:'<%=createRequestURL%>',
      		data: $('#_requestlesson_WAR_nyyouportlet_fm').serialize(),
			type: 'POST',
			cache: false,
      		success: function(data){
      			$('.section-draft-alert').show();
      	
  				setTimeout(function(){
	  			$('.section-draft-alert').hide();
	  			window.location.href='<%=requestDetailURL%>&_requestlesson_WAR_nyyouportlet_requestLessonId='+data;
	      	    		}, 2000);
			}
		});
}

        $(document).ready(function() {	
    		
				$("#backToExistingRequest").on('click',function(){
					$(this).closest("#requestDetail").hide().prev().show();
					$("#existingRequest footer").show();
					$("#existingRequest >h3").show();
				})
				
				$(".form.requestForm")[0].reset();
				// RESET STEP ON CLOSE POPOVER 
				$('.btn.close, .request-cancel').on('click', function(event) {
					$(this).closest('#popOverBodyCotentRequest').find('.request-progress').hide().end().find('.request-progress:first').show();
					event.preventDefault();
				});
    		
   		
				$('#makeRequest').on('click', function() { 
				   var request = $('.requestForm');
				   var requestType = $('#requestType');
				   optionCounter=3;
				   //Reseting Screen
				   request.find('.request-progress').hide();
				   request.find('.input-request.request-progress').show();
				   
				 //Reseting Request Type
				   requestType.find('p').show(); 
				   requestType.find('ul').show(); 
				   requestType.find('p').next().show().find('li:first-child').nextAll().addClass('hidden');
				});
    		 
    		
    	});
	
	function validateOptions(){
		 var requestType=$('.optionToAnswer:checked').val();
		 if(requestType==req_Opinion){
			 var options=$("#<portlet:namespace/>opnionSurveyOption").val();
			 if(options.length>0){
				 var res = options.split(",");
				
					 if(res.length<2){
						 return false;
					 }else{
						 var flag=true;
						 var checkDuplicateOpinions = [];
						 for(var i=0;i<res.length;i++){
							if(checkDuplicateOpinions.indexOf(res[i].toLowerCase().trim()) == -1) {
								checkDuplicateOpinions.push(res[i].toLowerCase().trim());
							} 
							if(res[i].trim().length==0){
								flag=false;
								break;
							}
						 }
						 if(flag==true){
							if(checkDuplicateOpinions.length != res.length){
								return false;
							}
							return true;
						 }
						else
							return false;
					 }
			 }else{
				 return true;
			 }
			 
	 	}else{
			 return true;
		 }
	
	
	} 
	function validateOptionCount(){
		 var requestType=$('.optionToAnswer:checked').val();
		 if(requestType==req_Opinion){
			 var options=$("#<portlet:namespace/>opnionSurveyOption").val();
			 if(options.length>0){
				 var res = options.split(",");
					 if(res.length>5){
						 return false;
					 }else{
						 return true;
					 }
			 }else{
				 return true;
			 }
		 }else{
			 return true;
		 }
		
	}
	function <portlet:namespace/>requestDetails(requestId){ 
		$('#requestDetail .request-answered').hide();
		$('#requestDetail .request-not-answered').hide();
		$("#existingRequest ul").hide();
		$("#existingRequest footer").hide();
		$("#existingRequest >h3").hide();
		for(var i in matcheddata){
			
			if(matcheddata[i].requestId==requestId){
				
				var url="<%=requestDetailURL%>&_requestlesson_WAR_nyyouportlet_requestLessonId="+matcheddata[i].requestId;	
				
				$("#requestDetail .request-name").html(matcheddata[i].name);
				if(matcheddata[i].answerType == req_Information){
					$('.request-type-img').attr('src','<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-group-chat.gif');
				}else if(matcheddata[i].answerType == req_Lesson){
					$('.request-type-img').attr('src','<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-lesson.gif');
				}else if(matcheddata[i].answerType == req_Collaborator ){
					$('.request-type-img').attr('src','<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-user-group.gif');
				}else {
					$('.request-type-img').attr('src','<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>icon-slate.gif');
				}
				
				$("#requestDetail .request-user-name").html(matcheddata[i].userName);
				$("#requestDetail .request-name").attr('href',url);
				$("#requestDetail .request-create-date").html(matcheddata[i].createDate);
				$("#requestDetail .request-appreciate").html(matcheddata[i].appreciatedCount);
				
				if(matcheddata[i].answerCount != 0){
					$('#requestDetail .request-answered').show();
				}else { 
					$('#requestDetail .request-not-answered').show();
				}
				$("#requestDetail").show();
				
				break;
			}
		}
		
	}
	
	
</script>

