<%@page import="com.nyu.util.Constant"%>
<script src='<%=themeDisplay.getPathThemeJavaScript()%>/jquery/jquery-1.11.0.min.js' type="text/javascript"></script> 
<script src="<%=themeDisplay.getPathThemeJavaScript()%>/angular/angular.min.js"></script>
<script src="<%=themeDisplay.getPathThemeJavaScript()%>/angular/angular-filter.min.js"></script>
<script src="<%=themeDisplay.getPathThemeJavaScript()%>/jquery/perfect_mouse_scroll.js"></script>
<script src="<%=themeDisplay.getPathThemeJavaScript()%>/jquery/perfect_scrollbar.js"></script>
<script>
		var ngApp = angular.module('<%= Constant.PORTLET_PROP_ONLY_VENDOR_NAME %>', ['angular.filter']);
</script>