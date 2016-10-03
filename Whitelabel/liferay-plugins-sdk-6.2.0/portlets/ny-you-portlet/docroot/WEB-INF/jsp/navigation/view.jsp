<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%@page import="com.liferay.portal.model.Layout"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="org.springframework.beans.support.PagedListHolder"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<portlet:defineObjects />
<liferay-theme:defineObjects />
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/navigation.js"></script>
	

<%String siteFriendlyUrl=PortalUtil.getGroupFriendlyURL(themeDisplay.getScopeGroup(),layout.isPrivateLayout(),themeDisplay);
String browseUrl=siteFriendlyUrl+Constant.PAGE_LESSON_BROWSE;
String homeUrl=siteFriendlyUrl+Constant.PAGE_HOME;
String createLessonUrl=siteFriendlyUrl+Constant.PAGE_CREATE_LESSON;
String requestLessonUrl=siteFriendlyUrl+Constant.PAGE_REQUEST_LESSON;
List<Layout> layoutList=LayoutLocalServiceUtil.getLayouts(PortalUtil.getScopeGroupId(request),true);
%>

<aside id="navigation">
		
	<ul class="nav nav-pills nav-stacked">
		<%for(Layout navigationLayout:layoutList){	
			if(!navigationLayout.getHidden()){
				if(navigationLayout.getName(locale).equalsIgnoreCase(layout.getName(locale))) {%>
					<li class="active"><a href="<%=siteFriendlyUrl+navigationLayout.getFriendlyURL()%>"><%=navigationLayout.getName(locale)%></a></li>
				<%} else {%>
					<li><a href="<%=siteFriendlyUrl+navigationLayout.getFriendlyURL()%>"><%=navigationLayout.getName(locale)%></a></li>
				<%} %>	
				
		<% } 
		}%>
	</ul>
	<BR><BR>
	<%if(layout.getFriendlyURL().equalsIgnoreCase(Constant.PAGE_HOME) || layout.getFriendlyURL().equalsIgnoreCase(Constant.PAGE_GROUP)){%>
		<section id="tagAffix" class="hidden-phone">
			
			<div id="tags">
				<div id="tagController" ng-controller="TagController">
					<h1 style="line-height: normal;"><liferay-ui:message key="tags" />	
						<span ng-show="cloudTags.length > 0">
							<a href="javascript:void(0)" ng-click="filterByCloudTag(0)" class="btn btn-default pull-right"> <liferay-ui:message key="reset" /> </a>
						</span>
					</h1>
					<br>
					<ul class="ul-height-cal">
						<li ng-repeat="tag in cloudTags | unique:'id'" class="tag{{$index%5+1}}" ng-cloak>
							<a href="javascript:void(0)" ng-click="filterByCloudTag(tag.id)">{{tag.name}},</a>
						</li> 
						
					</ul>  
				</div>
			</div> 			
			<BR>
			<div id="searchContent" class="custom-search">  
				<i class="icon-search"></i>
				<input type="text" ng-model="searchPageWise" name="Search" id="searchPageWise" size="30" value="" placeholder='<liferay-ui:message key="search-place-holder" />'/> 
			</div>
			<BR>
		</section>
	<%} %>
</aside>
                                   
<script>
	$(function(){
		// Sticky top 
		if($('#tagAffix').offset() != null){
	        var tagFixedTop = $('#tagAffix').offset().top; 
	        $(window).scroll(function(){
	                        var windowTop = $(window).scrollTop();
	                        if(tagFixedTop < windowTop){
	                            $('#tagAffix').removeClass('static').addClass('fixed');
	                            $('#tagAffix.fixed').width($('.aui #navigation').width());
	                        }
	                        else{
	                        	$('#tagAffix').removeClass('fixed').addClass('static');
	                        }
	        });
		}
		
	});
</script>
