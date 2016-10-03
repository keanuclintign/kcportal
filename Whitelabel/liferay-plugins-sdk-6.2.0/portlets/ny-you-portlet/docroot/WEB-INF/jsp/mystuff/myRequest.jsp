<%@ page import="com.nyu.util.Constant" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<div id="requestController" ng-controller="requestLessonsController">

<h1> 
	<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME%>/acceptRequest.png" width="24px"> 
	<liferay-ui:message key="my-requests" />
 </h1>
 <div class="ny-you-tab" id="myRequestTab">
  <ul class="nav nav-tabs">
    <li ><a href="#tab-1">
    	<liferay-ui:message key="group-name-requests" />
    </a></li>
    <li class="active"><a href="#tab-3">
    	<liferay-ui:message key="my-requests" />
    </a></li>
  </ul>

  <div class="tab-content">
    <div id="tab-1" class="tab-pane">
      <jsp:include page="keyword.jsp"></jsp:include>
    </div>
    <div id="tab-3" class="tab-pane">
      <jsp:include page="request.jsp"></jsp:include>
    </div>
 </div>

</div> 
</div>
		
