<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.nyu.service.BasnoLocalServiceUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp"%>
<%@page import="com.nyu.model.UserBadges"%>
<%@page import="com.liferay.util.portlet.PortletProps"%>
<%@page import="java.util.List"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %> 

<portlet:resourceURL var="claimBadgeURL" id="claimBadge">
</portlet:resourceURL>


<%
  List<UserBadges> allUserBadges = (List<UserBadges>)request.getAttribute(Constant.ALL_USER_BADGES);
%>

			<h1> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyBadges.png">
				 <liferay-ui:message key="my-badges" /> 
			</h1> 
			
			<div class="right-section clearfix"> 	 
				   
					<%
						if(allUserBadges!=null && allUserBadges.size()>0){
							String ubId = "";
							for(UserBadges ub : allUserBadges){
								
								ubId = ub.getBadgeUrl().substring(ub.getBadgeUrl().lastIndexOf("/")+1, ub.getBadgeUrl().lastIndexOf(StringPool.UNDERLINE));
					%>
						<div class="span4 thumbnail-content">	
							<article class="my-badges"> 
								<img src="<%=ub.getBadgeUrl()%>">
								<hr/>
								<p> <b><%=BasnoLocalServiceUtil.getBasno(ub.getBadgeId()).getBadgeName()%> </b></p>
								<div class="span12">
									<span>
										<a href="https://plus.google.com/share?url=http://basno.com/store/<%=ubId%>.og.png" 
													onclick="javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;">
											<img style="width: 20px; border-radius: 30%;"  src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>googleShare.png" alt='<liferay-ui:message key="share-on-google" />'/>
										</a>
									</span>
									<span>
										
									<a onclick="javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;" class="ss-icon ss-social-regular" rel="me" href="http://twitter.com/home?status=I won this Badge+http://basno.com/store/<%=ubId%>.og.png"><img style="width: 22px; border-radius: 30%;" src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>twitterShare.png" alt='<liferay-ui:message key="share-on-twitter" />'/></a>
									
									</span>
									<span>
										<a onclick="javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;" class="ss-icon ss-social-regular" rel="me" href="http://www.linkedin.com/shareArticle?mini=true&url=http://basno.com/store/<%=ubId%>.og.png&title=I won this Badge&source=http://basno.com"><img style="width: 22px; border-radius: 30%;"   src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>linkedinShare.png" alt='<liferay-ui:message key="share-on-linked-In" />'/></a>
									</span>
									<span>
										<a onclick="javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;" class="ss-icon ss-social-regular" rel="me" href="http://www.facebook.com/sharer/sharer.php?u=http://basno.com/store/<%=ubId%>.og.png&title=I won this Badge"><img style="width: 22px; border-radius: 30%;"  src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>facebookShare.png" alt='<liferay-ui:message key="share-on-facebook" />'/></a>
									</span>
													
								</div>
									
							</article>
						</div>
					
					<%	 }
							
					   }else{
					%>
						<p><liferay-ui:message key="no-badges-claimed" />.</p>
						
					<%} %>
					 
			</div> <!-- end right-section -->
			 
				<a href="#" class="clearfix" id="collectToggleBadge" style="text-decoration: none;">
					<h3 class="alert clearfix"> 
						<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyBadges.png"> 
						<liferay-ui:message key="collect-my-badge" />  
						<i class="pull-right icon-chevron-down"></i>
					</h3>
				</a> 	 
			<div class="right-section"> 	 
					<%if(request.getAttribute(Constant.BASGES_LIST)!=null && ((List<String>)request.getAttribute(Constant.BASGES_LIST)).size()>0 ){ 
						long conPoints = request.getAttribute(Constant.CONTRIBUTION_POINTS)!=null? (Long)request.getAttribute(Constant.CONTRIBUTION_POINTS) : 0;
						long parPoints = request.getAttribute(Constant.PARTICIPATION_POINTS)!=null? (Long)request.getAttribute(Constant.PARTICIPATION_POINTS) : 0;
						String bId = ""; 
						List<String> badges = (List<String>)request.getAttribute(Constant.BASGES_LIST);
						for(String badgeUrl : badges){
							bId = badgeUrl.substring(badgeUrl.lastIndexOf("/")+1, badgeUrl.lastIndexOf(StringPool.UNDERLINE));
					%>
						<div class="span4 thumbnail-content">	
							<article class="my-badges"> 
								<img src="<%=badgeUrl%>">
								<hr/>
								 
								<%
									long bagdeId=Long.valueOf(bId);
									long targetPoints=BasnoLocalServiceUtil.getBasno(bagdeId).getTargetPoints();
								%>
									<p class="text-overFlow"> <b><%=BasnoLocalServiceUtil.getBasno(Long.valueOf(bId)).getBadgeName()%> </b> </p>
									<p class="clearfix"> <span class="pull-left text-warning">  
										<liferay-ui:message key="target" />
										<%=targetPoints%> </span>
									<span class="pull-right text-success">  
										<liferay-ui:message key="achieved" /> 
									<%=conPoints+parPoints%> </span> </p>
									
									<%if((conPoints+parPoints) >= targetPoints){%>
										<button class="btn btn-primary" onclick="claimBadge('<%=bId%>','<%=badgeUrl%>','<%=claimBadgeURL.toString()%>')" >
											<liferay-ui:message key="claim" />
										</button>
									<%}else{ %>
										<button class="btn btn-primary" disabled="disabled">
											<liferay-ui:message key="claim" />
										</button>
									<%}%>
							
							</article>	
						</div> <!-- end span4 -->	 
					
					<%}
						} else{%>
						
							<p><liferay-ui:message key="no-badges-found" />. </p>
					<%} %>
					 
			</div> <!-- end right-section -->
			
<script>

	$(document).ready(function(){
		
		// TOGGLE EFFECT FOR COLLECT MY BADGE
		
		$('#collectToggleBadge').next().hide();
		
		$('#collectToggleBadge').on('click',function(evt){
		  evt.preventDefault();
		  $(this).next().toggle();
		  
		  if( $(this).find('i.pull-right') ) {
		      $(this).find('i.pull-right').toggleClass('icon-chevron-up icon-chevron-down');
		  } 
		     
		}); 
		
		$('#myStuff').find('.thumbnail-content').each(function(i,val){	    
		    if(i%3 == 0) {  
		      $(this).addClass('no-margin clearfix');
		    }
		});
		
		
		
	});
	
	function displayClaim(badgeId, contributionPoint){
		if( (badgeId == '<%= Constant.PORTLET_PROP_VENDOR_BASNO_APP_BADGE_ID%>' 
				&& contributionPoint == '<%= Constant.PORTLET_PROP_VENDOR_BASNO_APP_BADGE_TARGET %>')
				|| (badgeId == '<%= Constant.PORTLET_PROP_VENDOR_BASNO_APP_BADGE_ID_FOUR_FOUR %>' 
					&& contributionPoint == '<%= Constant.PORTLET_PROP_VENDOR_BASNO_APP_BADGE_YEAR_TARGET %>')){
			
			alert("displayClaim: "+badgeId +StringPool.SPACE+contributionPoint);
			
			$("#"+badgeId+"_claimBadge").attr("disabled", true);
		}
	}
	
	function claimBadge(badgeId, badgeUrl, claimUrl){
		$("#<portlet:namespace/>content .makeActive").hide();
		$("#<portlet:namespace/>content #<portlet:namespace/>mybadgesContent").show();
		$("#<portlet:namespace/>content #<portlet:namespace/>mybadgesContent").html($("#divLoading").html());
		$.ajax({
	        url:claimUrl,
	        type: 'POST',
	        data:{
	        	"<portlet:namespace />badgeId": badgeId,
				"<portlet:namespace />badgeUrl": badgeUrl
	        },
	        success: function(data){
	        	$("#<portlet:namespace/>content #<portlet:namespace/>mybadgesContent .divLoadingclass").remove();
	        	$("#<portlet:namespace/>content #<portlet:namespace/>mybadgesContent").html(data);
	         }
	        
	    });
	}
</script>