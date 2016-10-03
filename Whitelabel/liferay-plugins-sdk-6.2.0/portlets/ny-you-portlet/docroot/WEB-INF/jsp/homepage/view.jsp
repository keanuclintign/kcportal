<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="javax.portlet.WindowState"%>
<%@page import="com.nyu.model.Lesson"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/angular/lessons.js"></script>

<portlet:defineObjects />
<liferay-theme:defineObjects />
<portlet:resourceURL var='scrollLoadUrl' id='scrollLoad' />
 
<div id="divLoading" style="display:none;">
	<div class="divLoadingclass span12" align="center" style="margin-top: -37px;"><img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt="" /> <label style="color:#8131AF;">loading...</label></div>
</div>
 <liferay-portlet:runtime portletName="56"></liferay-portlet:runtime>
 <section class="container">
	<div class="row-fluid">
		<h2 class="title-learn backgroundicon-learn color background-left">DISCOVER</h2>
	<div class="row-fluid" id="public-content">
	<%-- <c:if test="${empty lessons}">
		<p> <b class="text-info">No lessons found.</b></p> 
	</c:if> --%>
	<%@ include file="/WEB-INF/jsp/homepage/middleHome.jsp" %>
	</div>
	</div>
</section>



<%-- <script>
var	count=<%=Integer.parseInt(Constant.PORTLET_PROP_SHOW_LESSONS_COUNT_VALUE)%>;

AUI().use('node-scroll-info',function(Y){ 
    var body = Y.one('body'); 
    body.plug(Y.Plugin.ScrollInfo); 
    body.scrollInfo.on('scrollToBottom', function(){
    	scrollLoad();
    	
    }); 
 });


var scrollLoadSent=false;
var scrollLoadEmpty=false;
function scrollLoad(){
	
	var scrollLoadURL = "<%=scrollLoadUrl%>";
	if(!scrollLoadSent && !scrollLoadEmpty)
	{
	$("#public-content").append($("#divLoading").html());
	scrollLoadSent=true;
	$.ajax({
        url:scrollLoadURL,
        type: 'GET',
        datatype:'html',
        data:{
        	<portlet:namespace/>count:count,
        	
        },
        success: function(data){
        	
        	if(data.trim().length<10)
        	{
        		scrollLoadEmpty=true;
        	}
        	$("#public-content .divLoadingclass ").remove();
        	$("#public-content").append(data);
        	count=count+<%=Integer.parseInt(Constant.PORTLET_PROP_SHOW_MORE_LESSONS_COUNT)%>;
         },
        complete: function() {
            scrollLoadSent=false;
        },
        
    });
	}
}

</script> --%>

<script>
$(document).ready(function(){
	var AllLessonData=<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_ALL_LESSONS)%>;	   
	var e = $('#lessonsController');
	scope = angular.element(e).scope();
	scope.$apply(function() {
	scope.items=[];
	scope.counter=0;
	scope.lessons =JSON.parse(AllLessonData.getLessons);		    	
	scope.load();
	});
});

</script>