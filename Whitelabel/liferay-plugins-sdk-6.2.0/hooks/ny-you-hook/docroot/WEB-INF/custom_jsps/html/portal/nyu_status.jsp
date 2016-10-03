

<%@page import="com.liferay.portal.util.PortalUtil"%>
<style>
	a {
		color:"#e11e4e";
		text-decoration:none;
	}
	a:hover {
		text-decoration:underline;
	}
	h1 {
		margin:0 0 70px 0;
		padding:0;
		font: 28px "arial black", "arial", "helvetica", sans-serif;
		color: #23241E;
	}
	.main {
		width:930px;
		margin:88px auto 0;
		font:normal 13px/18px verdana,arial,helvetica,sans-serif;
		color:#959595;
	}
	.portlet-topper, .search_box {
		display:none !important;
	}
	#footer {
		display:none;
	}
</style>

<div class="main">
	<h1>There was a problem reaching the page you are looking for.</h1>

	<p>Please try <a href='<%=themeDisplay.getPortalURL()%>'>login</a> again.</p>
	<p>OR</p>
	<p>Please contact the Service Administrator.</p>
</div>
