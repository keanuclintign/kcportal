<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>


<portlet:resourceURL var='insertCommentsURL' id='saveComment' />
<portlet:resourceURL var='moreCommentsURL' id='nextComments' />
<portlet:resourceURL var='deleteCommentURL' id='deleteComment'/>
<section>
		<h2 id='comment_header'>Comments</h2>
		<form action="${insertCommentsURL}" method="post" name="comments">
		<div class="portlet-msg-success" style="display:none; margin-bottom: 0px; width: 500px;" id="commentSuccessMsg">Comment posted successfully</div>
			<%-- <input type="hidden" name="<portlet:namespace/>classPK" value='<%=(String)request.getAttribute("classPK") %>' /> --%>
			<div class="row-fluid">
				<textarea id="<portlet:namespace/>userComments" name="<portlet:namespace/>userComments" aria-labelledby="comment_header" class="input-xxlarge" rows="4"></textarea>
			</div>
			<div class="row-fluid">
				<button type="button" onclick="saveComments()" class="btn btn-default">
					Post comment
				</button>
			</div>
		</form> 
		
	<div class="delete-msg alert alert-success" style="display:none; margin-bottom:0px; width:500px" id="commentSuccessMsg">Comment deleted successfully</div>
	<div id="showmaincomments"  class="row-fluid comment  ">
	
	 <% 
	 
	 	long classPK = Long.parseLong((String)request.getAttribute(Constant.COMMON_STRING_CONSTANT_CLASS_PK));
	 	boolean role=request.isUserInRole(Constant.CAPITAL_ADMINISTRATOR);
	 
	 	DynamicQuery dynamicQuery2 = DynamicQueryFactoryUtil.forClass(MBMessage.class);
		dynamicQuery2.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_CLASS_PK).eq(classPK));
		dynamicQuery2.add(PropertyFactoryUtil.forName(Constant.THREAD_ID).eq(0l));
		
		List<MBMessage> reverseList = MBMessageLocalServiceUtil.dynamicQuery(dynamicQuery2);
		List<MBMessage> commentsList =  new ArrayList<MBMessage>();	
				
		for(int i=reverseList.size()-1;i>=0;i--)
		{
			commentsList.add(reverseList.get(i));
			
		}
		
		int commentsListSize = 0;
		int defaultMaxComments = Integer.parseInt(PortletProps.get("default.comment.count"));
		int numberOfCommentsOnclick = Integer.parseInt(PortletProps.get("comment.count.value"));
		int count = 1;
		
		for(MBMessage mbMessage:commentsList){
			User mbMessageAuthor = CommonUtil.getAuthor(mbMessage.getUserId());
			if(commentsListSize < defaultMaxComments){
	 %>
			<div class="row-fluid comment show-comments">
				<div class="comment-name clearfix">
					<h2 class="pull-left" style=""><%= mbMessage.getUserName() %></h2>
					<%if(role){ %>
					<a id="moreCommentsBtn" class="btn btn-default white pull-right" onclick="deleteComment('<%=mbMessage.getMessageId()%>')">
                      <span class="icon-pen trash vertical-align "></span>
                	 </a>
                 	<%} %>               
				</div>
				 <p><%= mbMessage.getBody() %></p> 
			</div>
			
	<%		
				commentsListSize++;
				count++;
			}
			
		}
		
		if(commentsList.size()>defaultMaxComments){
	%>
	
	
		<div id="moreCommentsBtn1" >
				<button id="moreCommentsBtn" class="btn btn-default" onclick="loadNextComments()">
                        	More Comments
                 </button>
		</div>
	<% } %>
	   <div id="moreCommentsBtn1" style="display:none" >
				<button id="moreCommentsBtn" class="btn btn-default" onclick="loadNextComments()">
                        	More Comments
                 </button>
		</div> 

</section>
		
<script type="text/javascript">

	var numberOfCommentsOnload = 0;

	var defaultMaxComments = "<%= defaultMaxComments %>";
	var commentListSize = "<%= commentsList.size() %>";
	var numberOfCommentsOnclick = "<%= numberOfCommentsOnclick %>";
	
	function loadNextComments(){
		var moreCommentsURL = "<%= moreCommentsURL %>";
		var classPK = "<%= classPK %>";
		/* alert("url"+moreCommentsURL);
		alert("classPk"+classPK);
		alert("defaultMaxcomments"+defaultMaxComments);
		alert("commentListSize"+commentListSize);
		alert("numberOfCommentsOnclick"+numberOfCommentsOnclick); */
		if(numberOfCommentsOnload == 0) {
			numberOfCommentsOnload = numberOfCommentsOnload + parseInt(defaultMaxComments);
		} else { 
			numberOfCommentsOnload = numberOfCommentsOnload + parseInt(numberOfCommentsOnclick);
		}
		
	    $.ajax({
	        url: moreCommentsURL ,
	        type: 'GET',
	        datatype:'json',
	        data:{
	        	<portlet:namespace/>defaultMaxComments:defaultMaxComments,
	        	<portlet:namespace/>classPK:classPK,
	        	<portlet:namespace/>numberOfCommentsOnload:numberOfCommentsOnload,
	        	<portlet:namespace/>numberOfCommentsOnclick:numberOfCommentsOnclick
	        },
	        success: function(data){

	            $(".support").last().append(data);
	            if(commentListSize-numberOfCommentsOnload<=parseInt(numberOfCommentsOnclick)){
	            	$( "#moreCommentsBtn1" ).hide();
	            }
	        	
	        }
	    });
	}

	function saveComments(){
		$(".delete-msg").hide();
		var insertCommentsURL ="<%= insertCommentsURL %>";
		var classPK = "<%= classPK %>";
		var userComment=$("#<portlet:namespace/>userComments").val();
		if(userComment.trim() == ''){
			AUI().use('aui-modal',
  					function(Y) {
  						var modal = new Y.Modal(
  						{
  						bodyContent: '<p> <Strong>Please Provide Comments.</Strong></p>', centered: true,
  						headerContent: null, 
  						modal: true,
  						cssClass:'popup_alert',
  						width: 350,
  						zIndex: 999,
  						resizable: false,
  						toolbars: {
  						footer: [
  									{
				  						label: 'Ok',
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
			return false;
		}
		else{
		$.ajax({
	        url: insertCommentsURL ,
	        type: 'POST',
	        datatype:'html',
	        data:{
	        	<portlet:namespace/>defaultMaxComments:defaultMaxComments,
	        	<portlet:namespace/>classPK:classPK,
	        	<portlet:namespace/>userComments:userComment,
	             },
	        success: function(data){
	        	document.getElementById("commentSuccessMsg").style.display="block";
				if(data.indexOf("<Strong>")>0)
				{
					var splitDataVal=data.indexOf("sizeofinsertComment:");
					commentListSize =data.substring(splitDataVal+20,data.length); 
					data=data.substring(0,splitDataVal);
					$("#showmaincomments").removeClass("comment");
					$(".comment").remove();
					$(".support").html(data);	
					$("#<portlet:namespace/>userComments").val(" ");
				}
				if(data.indexOf("<span style='display:none'>ShowMoreButton<span>")>0)
					{
					$( "#moreCommentsBtn1" ).show();
					 defaultMaxComments = "<%= defaultMaxComments %>";
					 numberOfCommentsOnload = 0;
					 numberOfCommentsOnclick = "<%= numberOfCommentsOnclick %>";
					}
	        	
	        }
	    });
		}
	}
	
	function deleteComment(messageId){
		var classPK = "<%= classPK %>";
		document.getElementById("commentSuccessMsg").style.display="none";
		$(".delete-msg").hide();
		$(".delete-msg").show();
		$.ajax({
	        url:'<%=deleteCommentURL%>',
	        type: 'POST',
	        datatype:'html',
	        data:{
	        	<portlet:namespace/>defaultMaxComments:defaultMaxComments,
	        	<portlet:namespace/>messageId:messageId,
	        	<portlet:namespace/>classPK:classPK,
	             },
	        success: function(data){
	        	
				if(data.indexOf("<Strong>")>0)
				{
					
					var splitDataVal=data.indexOf("sizeofinsertComment:");
					commentListSize =data.substring(splitDataVal+20,data.length); 
					data=data.substring(0,splitDataVal);
					$("#showmaincomments").removeClass("comment");
					$(".comment").remove();
					$(".support").html(data);	
					$("#<portlet:namespace/>userComments").val(" ");
				}
				if(data.indexOf("<span style='display:none'>ShowMoreButton<span>")>0)
					{
					
					$( "#moreCommentsBtn1").show();
					 defaultMaxComments = "<%= defaultMaxComments %>";
					 numberOfCommentsOnload = 0;
					 numberOfCommentsOnclick = "<%= numberOfCommentsOnclick %>";
					}
				 if(data.indexOf("<Strong>")<0){
						 $("#showmaincomments").removeClass("comment");
						$(".comment").remove();
						$(".support").html(" ");	
						$("#<portlet:namespace/>userComments").val(" ");
		             }
		            
 				
	        	}
	           
	    });
		
		
		
	}
	
	</script>
	
	<script type="text/javascript">
	$( document ).ready(function() {
		$(".comment").last().addClass("support");
		$(".support").removeClass("comment");	
	});
	</script>
