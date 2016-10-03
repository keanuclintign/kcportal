
<%@page import="com.nyu.util.Constant"%>
<div id="citations">
<c:forEach items="${documentSection}" var="document" varStatus="i">
	<c:set var="citationCount" value="${citationCount + 1}" scope="page"/>
	<c:if test="${citationCount eq 1}">
		<h6 id="citation-${citationCount}" style="text-align: center;">
	</c:if>
	<c:if test="${citationCount ne 1}">
		<h6 id="citation-${citationCount}" style="text-align: center;display:none">
	</c:if>
	<c:choose>
		<c:when test="${(fn:containsIgnoreCase(document.resourceTitle, '.docx')) || (fn:containsIgnoreCase(document.resourceTitle, '.doc')) 
		||(fn:containsIgnoreCase(document.resourceTitle, '.txt')) || (fn:containsIgnoreCase(document.resourceTitle, '.xls'))
		|| (fn:containsIgnoreCase(document.resourceTitle, '.xlsx'))|| (fn:containsIgnoreCase(document.resourceTitle, '.pdf'))
		|| (fn:containsIgnoreCase(document.resourceTitle, '.pptx'))|| (fn:containsIgnoreCase(document.resourceTitle, '.ppt'))}">
			
				"${authorName}".${citationLessonName}."<script>document.writeln(unescape('${document.title}'))</script>".Document."<%= Constant.PORTLET_PROP_CAPITAL_ONLY_VENDOR_NAME %>".${citationDate}.${lastViewDate}
			
		</c:when>
		<c:when test="${(fn:containsIgnoreCase(document.documentPath, 'youtube'))}">
				"${authorName}".${citationLessonName}."<script>document.writeln(unescape('${document.title}'))</script>".Online Video Clip."Youtube".${citationDate}.${lastViewDate}
		</c:when>
		<c:when test="${(fn:containsIgnoreCase(document.documentPath, 'vimeo'))}">
				"${authorName}".${citationLessonName}."<script>document.writeln(unescape('${document.title}'))</script>".Online Video Clip."Vimeo".${citationDate}.${lastViewDate}
		</c:when>
		<c:when test="${(fn:containsIgnoreCase(document.documentPath, 'versal.com'))}">
				"${authorName}".${citationLessonName}."<script>document.writeln(unescape('${document.title}'))</script>".Online Video Clip."Versal.com".${citationDate}.${lastViewDate}
		</c:when>
		<c:when test="${(fn:containsIgnoreCase(document.documentPath, '/engage/'))}">
				"${authorName}".${citationLessonName}."<script>document.writeln(unescape('${document.title}'))</script>".Ngage Video Clip."<%= Constant.PORTLET_PROP_CAPITAL_ONLY_VENDOR_NAME %>".${citationDate}.${lastViewDate}
		</c:when>
		<c:otherwise>
				"${authorName}".${citationLessonName}."<script>document.writeln(unescape('${document.title}'))</script>".Embed Section."<%= Constant.PORTLET_PROP_CAPITAL_ONLY_VENDOR_NAME %>".${citationDate}.${lastViewDate}
		</c:otherwise>
	</c:choose>
	</h6>
</c:forEach>
</div>