<%@page import="com.nyu.util.Constant"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>


<div class="span3">
	<a class=" box-grey" href="/group<%=themeDisplay.getScopeGroup().getFriendlyURL()%><%=Constant.PAGE_CREATE_LESSON%>">
		<nav class="box-create">
			<p class="create-lession"> 
				<span class="backgroundicon-create color background-left">
					<liferay-ui:message key="create" />
				</span> 
			
				<ul>
					<li><span>
						<liferay-ui:message key="create-a-lesson" />
					</span></li>
					<li><span>
						<liferay-ui:message key="curate-existing-content" />
					</span></li>
					<li><span>
						<liferay-ui:message key="import-content" />
					</span></li>
				</ul>
			</p>
		</nav>
	</a>
</div>