			<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
			<%@include file="myActivity.jsp" %>
			<%@include file="myAnnouncement.jsp" %>
			
			
			<h1> <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>MyPoints.png">
				<liferay-ui:message key="my-points" />
			</h1>
			<div class="right-section"> 			
				<div> 	
					<div class="span7 points-container">
						<div class="blue pull-left">	
							<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>Rank.png"/>
							<p> <liferay-ui:message key="rank" /></p>
						</div> <!-- end blue -->			
						<div class="pull-left dark-grey">	 
							<p style="color: #005580;">${Rank} </p>
						</div> <!-- end grey -->
					</div> <!-- end span4 -->
				</div> <!-- end row --> 
				
				<div> 	
					<div class="span10 points-container">	
						<div class="purple pull-left">
							<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>Participation.png"/>
							<p> <liferay-ui:message key="participation" /> </p>
						</div> <!-- end purple -->
						<div class="pull-left dark-grey">	 
							<p style="color: #5d0e8b;"> ${participationPoints} <span>
								<liferay-ui:message key="current-score" /> 
							</span></p>
						</div> <!-- end grey -->
						<div class="pull-left grey">	 
							<p style="color: #5d0e8b;"> ${participationTotalPoints} <span>
								<liferay-ui:message key="total-score" /> 
							</span></p>
						</div> <!-- end grey -->
					</div> <!-- end span6 -->	 
				</div> <!-- end row --> 
				
				<div> 	
					<div class="span12 points-container">	
						<div class="orange pull-left points-container">
							<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>Contribution.png"/>
							<p> 
								<liferay-ui:message key="contribution" /> 
							</p>
						</div> <!-- end orange -->
						<div class="pull-left dark-grey">	
							<p style="color: #eb8b25;">${countributionPoints} <span>
								<liferay-ui:message key="current-score" /> </span></p>
						</div> <!-- end grey -->
						<div class="pull-left grey">	
							<p style="color: #eb8b25;">${countributionTotalPoints} <span>
								<liferay-ui:message key="total-score" />
							</span>
							</p>
						</div> <!-- end grey -->
					</div> <!-- end span2 -->	 
				</div> <!-- end row --> 
			</div> <!-- end right-section --> 