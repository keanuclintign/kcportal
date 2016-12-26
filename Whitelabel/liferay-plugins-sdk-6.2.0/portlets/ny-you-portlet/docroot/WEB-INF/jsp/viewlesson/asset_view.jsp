
<%@page import="javax.portlet.RenderRequest"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>

<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" /> 
<script src="https://code.jquery.com/jquery-2.2.4.min.js" integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44=" crossorigin="anonymous"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.3.2/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/ny-you-portlet/js/main.js"></script>
<style>

#lessonDetails #lessonIntroduction {
    background: #000 none repeat scroll 0 0;
}
.row-fluid.video-text {
    padding: 30px 15px 0;
}
.band {
    background: #434343 none repeat scroll 0 0;
    box-sizing: border-box;
    padding: 15px;
}
.band h3 {
    color: #fff;
    line-height: normal;
    margin: 0;
}

#myCarouselSection li span {
    color: #fff;
    font-size: 18px;
    position: relative;
    top: 20px;
}
.carousel-indicators li {
    text-indent: -1187px !important;
}
.intro-text {
    background: #fff none repeat scroll 0 0;
    font-size: 12px;
    height: 370px;
    line-height: 21px;
    max-height: 370px;
    overflow-x: hidden;
    overflow-y: auto;
    padding: 20px;
	width: 360px !important;
}
</style>

<%
Lesson lesson = null;
long lessonId = 0;
try {
	lesson = (Lesson)request.getAttribute(Constant.LESSON);
	lessonId = lesson.getLessonId();
	
	String lessonThumbnail = CommonUtil.getDocumentPath(lessonId, ClassNameLocalServiceUtil.getClassNameId(Lesson.class.getName()), themeDisplay);
	
	if(Validator.isNull(lessonThumbnail) || lessonThumbnail.equals(StringPool.BLANK)){
		lessonThumbnail = themeDisplay.getPathThemeImages() + StringPool.SLASH + Constant.CURRENT_OWNER + StringPool.SLASH + Constant.LESSON_CARD_PLACEHOLDER;
	}
	
	renderRequest = (RenderRequest)CommonUtil.getDocumentListAndIdsAsArray(renderRequest, lesson); 
	renderRequest.setAttribute(Constant.COMMON_LESSON_THUMBNAIL, lessonThumbnail);
	renderRequest.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_NAME, lesson.getLessonName());
	renderRequest.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lesson.getLessonId());
	renderRequest.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_DESCRIPTION, lesson.getDescription());
} catch (Exception e) {
	e.printStackTrace();
}
%>

<c:set var="isOfficeInEngage" value='<%=Constant.ENABLE_OFFICE_PREVIEW_IN_ENGAGE%>' scope="page" />
<div id="lessonDetails"> 
<section id="lessonIntroduction">
<div id="myCarouselSection" class="carousel slide"> 
<!-- Carousel indicators -->
<div class="lesson-topic">
	<ol class="unstyled carousel-indicators">
		<c:forEach items="${documentSection}" var="document" varStatus="i">
			<c:set var="indexCount" value="${indexCount + 1}" scope="page"/>
			<c:if test="${indexCount eq 1}">
				<li data-target="#myCarouselSection" data-citation="${indexCount}" data-slide-to="${indexCount-1}" style="cursor:pointer;" class="active"> <script>document.writeln(unescape(unescape(unescape("<span>${document.title}</span>"))))</script></li>
			</c:if>
			<c:if  test="${indexCount ne 1}">
				<li data-target="#myCarouselSection" data-citation="${indexCount}"  data-slide-to="${indexCount-1}" style="cursor:pointer;"> <script>document.writeln(unescape(unescape(unescape("<span>${document.title}</span>"))))</script> </li>
			</c:if>
		</c:forEach>
		<span class="arrow-down"> </span>
    </ol>
</div> <!-- end lessonTopic --->
	<!-- Carousel items -->
<div class="carousel-inner">
	<!-- ========== SLIDE START ============-->
	<c:forEach items="${documentSection}" var="document" varStatus="i">
		<c:set var="count" value="${count + 1}" scope="page"/>
		<c:if test="${count eq 1}">
			<div class="active item order-${count}" data-citation="${count}">
		</c:if>
		<c:if test="${count ne 1}">
			<div class="item order-${count}" data-citation="${count}">
		</c:if>
		<c:if test="${count ne documentSection.size()}">
			<span class="carosel-tooltip-next" data-next="${documentSection[count].title}"></span>
		</c:if>
		<c:if test="${count eq documentSection.size()}">
			<span class="carosel-tooltip-next" data-next="${documentSection[0].title}"></span>
		</c:if>
		<c:if test="${count ne documentSection.size()}">
			<c:if test="${count-2 ge 0}">
				<span class="carosel-tooltip-prev" data-prev="${documentSection[count-2].title}"></span>
			</c:if>
			<c:if test="${count-2 lt 0}">
				<span class="carosel-tooltip-prev" data-prev="${documentSection[documentSection.size()-1].title}"></span>
			</c:if>
		</c:if>
		<c:if test="${count eq documentSection.size()}">
			<c:if test="${count-2 ge 0}">
				<span class="carosel-tooltip-prev" data-prev="${documentSection[documentSection.size()-2].title}"></span>
			</c:if>
			<c:if test="${count-2 ge -1}">
				<span class="carosel-tooltip-prev" data-prev="${documentSection[documentSection.size()].title}"></span>
			</c:if>
		</c:if>
	
		<div class="row-fluid video-text">
			<div class="span8"> 
				<c:choose>
					<c:when test="${(!isOfficeInEngage) && ((fn:endsWith(fn:toLowerCase(document.resourceTitle), '.docx')) || (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.doc')) 
					||(fn:endsWith(fn:toLowerCase(document.resourceTitle), '.txt')) || (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.xls'))
					|| (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.xlsx')) || (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.pptx'))|| 
					(fn:endsWith(fn:toLowerCase(document.resourceTitle), '.ppt')))}">
						<c:set var="docResourceId" value="${document.resourceId}" scope="page"/>
							<%
								long docResourceId = GetterUtil.getLong(pageContext.getAttribute("docResourceId"));
								String previewUrl = PortletProps.get("resource.space.preview.url")+docResourceId;
								previewUrl = previewUrl+"&key="+PortletProps.get("resource.space.preview.key");
							%>
							<span class="iframe-hidden-data" data-iframeid="player-${count}" data-iframesrc="<%=previewUrl %>"></span>
					</c:when> 
					<c:when test="${(fn:containsIgnoreCase(document.documentPath, 'youtube'))}">
						<span class="iframe-hidden-data" data-iframeid="player-${count}" data-iframesrc="${document.documentPath}?enablejsapi=1&version=3&playerapiid=ytplayer"></span>
					</c:when>
					<c:when test="${(fn:containsIgnoreCase(document.documentPath, 'vimeo'))}">
						<span class="iframe-hidden-data" data-iframeid="player-${count}" data-iframesrc="${document.documentPath}?api=1"></span>
					</c:when>
					<c:when test="${(fn:containsIgnoreCase(document.documentPath, 'versal.com'))}">
						<p>
						  <video height="370px" width="100%" controls="" name="media"><source src="${document.documentPath}" type="video/mp4"></video>
						</p>
					</c:when>
					<c:otherwise>
							<span class="iframe-hidden-data" data-iframeid="player-${count}" data-iframesrc="${document.documentPath}"></span>
					</c:otherwise>
				</c:choose> 
				<c:if test="${!(fn:containsIgnoreCase(document.documentPath, '/engage/launcher/'))}">
					<span class="exitFullScreenFunctionality hide nyu-tooltip" title='Exit FullScreen'>
						<img src="${renderRequest.getContextPath()}/images/exit_full_screen.png" style="width: 30px;"/>
					</span>
				</c:if>
			</div> <!-- end span8 -->						
			<div id="textContent" class="span4 intro-text" style="position:relative;">
				<div class="custom-alert" style="display: block; background: rgba(255,255,255,0.3)"> 
				</div>
				<p>${document.textContent}</p>
			</div> <!-- end span4 -->
		</div> <!-- end row-fluid -->
		
		<div class="row-fluid band"> 
			<div class="span8"> 	
				<div class="row-fluid">
					<div class="span8" style="margin-left:80px;"> 
						<h3><script>document.writeln(unescape(unescape(unescape(("${document.title}")))))</script></h3>
						<c:forEach items="${document.lessonObjective}" var="lessonObj" varStatus="i">
							<span class="label label-inverse">${lessonObj.objective}</span>
						</c:forEach>
					</div> 
				</div> 
			</div> <!-- end span8 -->						
			
			<div class="span2 text-center" style="position: relative;">
					<c:if test="${documentSection.size() ne 1}">
						<BR><a href="javascript:void(0);" class="text-link pagination"> ${count} of ${documentSection.size()} </a>
					</c:if> 
			</div>
			
		</div>
	</div> <!-- end item -->
	</c:forEach>
	<!-- ========== SLIDE END ============-->
</div>
</section>
<section id="lessonDescription">
	<div class="row-fluid">
		<div class="span8">
			<h4> ${lessonName} &nbsp;
					<span>
						<c:if test="${privacy eq 'public'}">
							<i class="nyu-tooltip icon-globe" style="font-size: 30px;" title = "${lessonPrivacy}" ></i>
						</c:if>
						<c:if test="${privacy eq 'NYOU'}">
							<i class="nyu-tooltip icon-group" style="font-size: 30px;" title = "${lessonPrivacy}"></i>
						</c:if>
						<c:if test="${privacy eq 'private' || privacy eq 'user'}">
							<i class="nyu-tooltip icon-user" style="font-size: 30px;" title = "${lessonPrivacy}"></i>
						</c:if>
						&nbsp;
						<i class="${permissionIcon} nyu-tooltip" style="font-size: 30px;" title = "${permissionTooltip}"></i>
					</span>
			</h4>
			<div class="scroll-overFlow" style="max-height: 220px;">
				<p>${lessonDescription}</p>
			</div>
		</div>
	</div> 
</section>
</div>

<script type="text/javascript">
$(function(){
	$('#myCarouselSection').carousel({
		interval: false
	});
});

var ShowDocumentCarousel = null;
	
$(function(){
	ShowDocumentCarousel = new carouselIframeLoader(1,${documentSection.size()},${documentSection.size()},"height: 370px; width: 100%; border:0;");
	ShowDocumentCarousel.createIframeInActiveItem($('.item.active'));
});

$('.carousel-control.right').click(function(){
	ShowDocumentCarousel.rightClick();
});

$('.carousel-control.left').click(function(){
	ShowDocumentCarousel.leftClick();
});

$('.carousel-indicators li').click(function(){
	ShowDocumentCarousel.indicatorsClick($(this)); 
});
</script>