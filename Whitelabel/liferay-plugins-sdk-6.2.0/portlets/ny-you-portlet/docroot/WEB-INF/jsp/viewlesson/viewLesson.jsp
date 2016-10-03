<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.nyu.service.LessonLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<c:if test="${fromViewLesson eq 'yes'}">
	<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
</c:if>
<c:set var="inAppropriate"  value="<%=Constant.INAPPROPRIATE %>" scope="page"/>
<c:set var="deletedByUser"  value="<%=Constant.LESSON_DELETED_BY_USER%>" scope="page"/> 
<c:set var="qurantine"  value="<%=Constant.MARKEDAS_QUARANTINE %>" scope="page"/> 
<c:set var="tabName" value='<%=ParamUtil.getString(request,"fromTab")%>' scope="page"/>
<c:set var="isOfficeInEngage" value='<%=Constant.ENABLE_OFFICE_PREVIEW_IN_ENGAGE%>' scope="page"/>

<c:if test="${userPermissionToAccess}">
<portlet:renderURL var="openDocumentPreviewUrl" windowState="pop_up">
	<portlet:param name="action" value="openDocumentPreview"/> 
	<portlet:param name = "resourceId" value="**resourceId**" />
</portlet:renderURL>
<%
long myStuffTargetPlId = themeDisplay.getPlid();
if(layout.isPrivateLayout()){
	myStuffTargetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_MY_SUTFF).getPlid();
}
%>

<liferay-portlet:renderURL var="openPortletURL" plid="<%=myStuffTargetPlId %>" portletName="<%=Constant.PORTLET_MY_SUTFF%>" >
<c:if test="${tabName eq 'qurantineTab'}">
	<liferay-portlet:param name="archivedLessonstabActive" value="qurantineTab"/>
</c:if>
<c:if test="${tabName eq 'archivedLessons'}">
	<liferay-portlet:param name="archivedLessonstabActive" value="inappropriateTab"/>
</c:if>
</liferay-portlet:renderURL>  
<portlet:resourceURL var="makeLessonInappropriateUrl" id="makeLessonInappropriate" />
<portlet:resourceURL var="MarkedAsLessonByAdminURL" id="markedAsLessonByAdmin" />
<portlet:resourceURL var="addToMyFavouriteURL" id="addToMyFavourite" />
<portlet:resourceURL var="removeFromMyFavouriteURL" id="removeFromMyFavourite" /> 
<div id="lessonDetails"> 
	<section id="lessonIntroduction">	
		<div id="myCarouselSection" class="carousel slide"> 
			<!-- Carousel indicators -->
			<div class="lesson-topic">
                <ol class="unstyled carousel-indicators">
	                <c:forEach items="${documentSection}" var="document" varStatus="i">
					<c:set var="indexCount" value="${indexCount + 1}" scope="page"/>
						<c:if test="${indexCount eq 1}">
							<li data-target="#myCarouselSection" data-citation="${indexCount}" data-slide-to="${indexCount-1}" style="cursor:pointer;" class="active">${indexCount}. <script>document.writeln(unescape(unescape(unescape("${document.title}"))))</script></li>
						</c:if>
						<c:if  test="${indexCount ne 1}">
							<li data-target="#myCarouselSection" data-citation="${indexCount}"  data-slide-to="${indexCount-1}" style="cursor:pointer;">${indexCount}. <script>document.writeln(unescape(unescape(unescape("${document.title}"))))</script> </li>
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
								<%-- <c:when test="${(fn:endsWith(fn:toLowerCase(document.resourceTitle), '.jpg')) || (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.jpeg'))
													|| (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.png')) || (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.gif'))}">
													
										<c:set var="docResourceId" value="${document.resourceId}" scope="page"/>
										<%
											long docResourceId = GetterUtil.getLong(pageContext.getAttribute("docResourceId"));
											String previewUrl = Constant.PORTLET_PROP_RESOURCE_SPACE_PREVIEW_URL+docResourceId;
											previewUrl = previewUrl+Constant.AMPERSAND_KEY_EQUAL+Constant.PORTLET_PROP_RESOURCE_SPACE_PREVIEW_KEY;
										%>
										<span class="iframe-hidden-data" data-iframeid="player-${count}" data-iframesrc="<%=previewUrl %>"></span>
										
								</c:when> --%>
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
								<%-- <c:when test="${(fn:containsIgnoreCase(document.documentPath, 'docs.google.com'))}">
									<p>
										<div class="doc-preview">
											<span data-title='<liferay-ui:message key="click-to-preview" />' onclick="openDocumentPreview('${document.documentPath}')" class="nyu-tooltip cursor-pointer">
												<!-- <img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>doc-icon.png" width="96";/> -->
												<img src="<%= Constant.COMMON_THEME_IMAGE_PATH + Constant.VENDOR_NAME + StringPool.SLASH %>google-docs-img.jpg" style="width: 46%;"/>
											</span>
										</div>
									</p>
								</c:when> --%>
								<c:otherwise>
										<span class="iframe-hidden-data" data-iframeid="player-${count}" data-iframesrc="${document.documentPath}"></span>
								</c:otherwise>
							</c:choose> 
							<c:if test="${!(fn:containsIgnoreCase(document.documentPath, '/engage/launcher/'))}">
								<span class="exitFullScreenFunctionality hide nyu-tooltip" title='Exit FullScreen'>
									<img src="${renderRequest.getContextPath()}/images/exit_full_screen.png" style="width: 30px;"/>
								</span>
								<span class="fullScreenFunctionality"> 
									<i class="fa fa-arrows-alt nyu-tooltip" title='FullScreen'></i> 
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
						<div class="span2" style="margin-bottom: 0;">
							<a href="javascript:void(0);" class="btn btn-large lesson-files"><i class="icon-file"> </i> <span class="visible-desktop"> <liferay-ui:message key="lesson-files" /> </span> </a>
						</div> <!-- end span2 --> 
						<div class="span2 text-center" style="position: relative;">
								<c:if test="${documentSection.size() ne 1}">
									<BR><a href="javascript:void(0);" class="text-link pagination"> ${count} of ${documentSection.size()} </a>
								</c:if> 
						</div>
						
					</div>
				</div> <!-- end item -->
				</c:forEach>
				<!-- ========== SLIDE END ============-->
			</div> <!-- end carousel-inner --> 
			
			<!-- =================== AD MEDIA ===================== -->
			<div id="adMediaPopover" style="display: none;">
				<div id="myMediaToggler" class="input-xlarge">
					<h4 class="header toggler-header-collapsed media-files"><liferay-ui:message key="media-files" /><span class="pull-right label label-info">  </span></h4>
					<div class="content toggler-content-collapsed media-files-count">
						<ul class="group-list unstyled">
							<c:forEach items="${documentSection}" var="document" varStatus="i">
								<c:if test="${( ((document.type eq 'embed') || (fn:containsIgnoreCase(document.type,'resource')) || (document.type eq 'resourceSpace') || (document.type eq 'youtube')) && ( (!fn:endsWith(fn:toLowerCase(document.resourceTitle), '.docx'))
											&& (!fn:endsWith(fn:toLowerCase(document.resourceTitle),'.pdf')) && (!fn:endsWith(fn:toLowerCase(document.resourceTitle),'.doc')) && (!fn:endsWith(fn:toLowerCase(document.resourceTitle),'.txt')) 
											&& (!fn:endsWith(fn:toLowerCase(document.resourceTitle),'.pptx')) && (!fn:endsWith(fn:toLowerCase(document.resourceTitle),'.ppt'))
											&& (!fn:endsWith(fn:toLowerCase(document.resourceTitle),'.xlsx')) && (!fn:endsWith(fn:toLowerCase(document.resourceTitle),'.xls')) ))}">
								<li class="group-list-item"> 
									<img src="${document.resourceImgUrl}" width="64px" height="48px"> 
									<span style="width: 70%;"> <script>document.writeln(unescape(unescape(unescape("${document.resourceTitle}"))))</script></span>
								</li>
								</c:if>
							</c:forEach>	
						</ul>
					</div>
					<h4 class="header toggler-header-collapsed presentation-files"><liferay-ui:message key="presentation" /><span class="pull-right label label-info">  </span></h4>
					<div class="content toggler-content-collapsed presentation-files-count">
						<ul class="group-list unstyled">
							<c:forEach items="${documentSection}" var="document" varStatus="i">
								<c:if test="${( ((fn:containsIgnoreCase(document.type,'resource')) || (document.type eq 'resourceSpace'))  && ( (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.pptx'))
											|| (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.ppt'))) )}">
									<li class="group-list-item"> 
										<img src="${document.resourceImgUrl}" width="64px" height="48px"> 
										<span style="width: 70%;">
										<a id="dcTitle_" href="//docs.google.com/gview?url=${document.resourceDownloadUrl}&embedded=true" target="_blank" 
																class="file-name">
										<script>document.writeln(unescape(unescape(unescape("${document.resourceTitle}"))))</script></a> 
										<a href="${document.resourceDownloadUrl}" class="pull-right">
											<img title='<liferay-ui:message key="download" />' src='<%=request.getContextPath() %>/images/download_img.png'>
										</a>
										</span>
									</li>
								</c:if>
							</c:forEach>
						</ul>
					</div>
					<h4 class="header toggler-header-collapsed documents-files"><liferay-ui:message key="documents" /><span class="pull-right label label-info">  </span></h4>
					<div class="content toggler-content-collapsed documents-files-count">
						<ul class="group-list unstyled">
							<c:forEach items="${documentSection}" var="document" varStatus="i">
								<c:if test="${( ((fn:containsIgnoreCase(document.type,'resource')) || (document.type eq 'resourceSpace'))  && ( (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.docx'))
											|| (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.doc')) ||(fn:endsWith(fn:toLowerCase(document.resourceTitle), '.txt')) || (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.xls'))
											 || (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.xlsx'))|| (fn:endsWith(fn:toLowerCase(document.resourceTitle), '.pdf'))) )}">
									
									<c:set var="notFromMp4" value="true"/>
									<c:if test="${(fn:endsWith(fn:toLowerCase(document.resourceTitle), '.txt'))}">
										<c:forEach items="${documentSection}" var="avoidDocument" varStatus="i">
											<c:if test="${(fn:containsIgnoreCase(avoidDocument.resourceTitle, '.mp4')) && (fn:containsIgnoreCase(avoidDocument.docUuid, document.docUuid))}">
											 	<c:set var="notFromMp4" value="false"/>
											</c:if>
										</c:forEach>
									</c:if>
									<c:if test="${notFromMp4}">
										<li class="group-list-item"> 
											<img src="${document.resourceImgUrl}" width="64px" height="48px"> 
											<span style="width: 70%;">
											<a id="dcTitle_" href="//docs.google.com/gview?url=${document.resourceDownloadUrl}&embedded=true" target="_blank"  class="file-name">
												<script>document.writeln(unescape(unescape(unescape("${document.resourceTitle}"))))</script>
											</a> 
											<a href="${document.resourceDownloadUrl}" class="pull-right">
												<img title='<liferay-ui:message key="download" />' src='<%=request.getContextPath() %>/images/download_img.png'>
											</a>
											</span>
										</li>
									</c:if>
								</c:if>
							</c:forEach>
						</ul>
					</div>
				</div> <!-- end myMediaToggler --> 				
				<span class="arrow-down"> </span>
			</div> <!-- end adMediaPopover --> 
			<!-- Carousel nav  -->
			<c:if test="${(not empty documentSection) && (documentSection.size() gt 1)}">
				<a class="carousel-control left nyu-tooltip" data-title="" onmouseover="$(this).attr('data-title',$('.active.item .carosel-tooltip-prev').data('prev'))" data-size="${documentSection.size()}" href="#myCarouselSection" data-slide="prev"><i class="icon-chevron-left"></i></a>
				<a class="carousel-control right nyu-tooltip" data-title="" onmouseover="$(this).attr('data-title',$('.active.item .carosel-tooltip-next').data('next'))" data-size="${documentSection.size()}" href="#myCarouselSection" data-slide="next"><i class="icon-chevron-right"></i></a>
			</c:if>
		</div> <!-- end myCarouselSection -->
	</section> <!-- end lessonIntroduction -->
	
	<section id="lessonDescription">
		<div class="row-fluid">
			<div class="span8">
				
				<c:if test="${!(fromViewLesson eq 'yes')}">
				<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css"> 
				<ul class="nav inline">
					<c:if test="${empty checkMarkedAs}"><!-- marked As -->
					<c:if test="${permission eq 'view_reuse' || permission eq 'view_reuse_attribution'}">
						<li class="dropdown">
							<a href="javascript:void(0)" id="share-button"> <i class="icon-random"> </i>  <liferay-ui:message key="share" /> </a>
							<ul id="share-btn-menu" class="dropdown-menu" aria-labelledby="share-menu" role="menu">
								<li><a href="http://www.facebook.com/sharer/sharer.php?u=${FBShareUrl}&title=${LessonName}" onclick="javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;" class="icon-facebook">&nbsp;&nbsp;FaceBook</a></li>
								<li><a href="https://plus.google.com/share?url=${ShareUrl}" onclick="javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;" class="icon-google-plus">&nbsp;&nbsp;Google</a></li>
								<li><a href="http://www.linkedin.com/shareArticle?mini=true&url=${ShareUrl}&title=${LessonName}&source=http://google.com" onclick="javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;" class="icon-linkedin">&nbsp;&nbsp;Linkedin</a></li>
								<li><a href="http://twitter.com/home?status=${LessonName}+${ShareUrl}" onclick="javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;" class="icon-twitter">&nbsp;&nbsp;Twitter</a></li>
								<li><a href="javascript:void(0);" class="dropdown-toggle" onclick="myEmailPopup('${EhowEmailURL}')"><span class="icon-share" aria-hidden="true"></span>&nbsp;&nbsp;Email</a></li>
								<li><a href="javascript:void(0);" class="dropdown-toggle" onclick="embedUrl('${EmbedUrl}')"><span class="icon-chevron-left" aria-hidden='true'></span><span class="icon-chevron-right" aria-hidden='true'></span>&nbsp;<liferay-ui:message key="embed-this" /></a></li>
							</ul>
						</li>
					</c:if>
					<li class="lesson_appreciate_block">
					<c:if test="${hasappreciated}">
					<a class="appreciateAnswer"  onclick="unAppreciateLesson('${unAppreciateLessonURL}','${appreciateLessonURL}')">
				    	<i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="already-appreciated" />'> </i>
				    </a>
				    </c:if>
					
				   
				    <c:if test="${!hasappreciated}">
				    <a class="appreciateAnswer"  onclick="appreciateLesson('${appreciateLessonURL}','${unAppreciateLessonURL}')">
				    	<i class="icon-thumbs-up appreciateAnswer nyu-tooltip" title='<liferay-ui:message key="appreciate-this" />'></i>
				    </a>
				  	</c:if>
					
					</li>
					<%-- <li>
						<c:if test="${hasappreciated}">
							<span style="color:#747474"> <i class="icon-thumbs-up"> </i> Appreciated </span>
						</c:if>	
						<c:if test="${!hasappreciated}">
							<a href="javascript:void(0)" id="appreciate" onclick='document.getElementById("appreciate").disabled="disabled"'> <i class="icon-thumbs-up"> </i> Appreciate </a>
						</c:if>	
					</li> --%>
					<li>
						<c:if test="${addToMyFavourite}">					
							<a href="javascript:void(0)" id="removeFavourite" style="display:none"> <i class="icon-star"> </i> <liferay-ui:message key="remove-from-favorites" /> </a>
							<a href="javascript:void(0)" id="favourite"> <i class="icon-star"> </i> <liferay-ui:message key="add-to-favorites" /> </a>
						</c:if>
						<c:if test="${!addToMyFavourite}">					
							<a href="javascript:void(0)" id="removeFavourite"> <i class="icon-star"> </i> <liferay-ui:message key="remove-from-favorites" /> </a>
							<a href="javascript:void(0)" id="favourite" style="display:none"> <i class="icon-star"> </i> <liferay-ui:message key="add-to-favorites" /> </a>
						</c:if>
					</li> 
					</c:if><!-- marked As ends -->
					<c:if test="${hasAdminRights}">
						<c:if test="${!empty checkMarkedAs}"><!-- marked As -->
							<li> <a href="javascript:void(0)" onClick="updateMarkedAs('<%=Constant.MARKEDAS_RELEASE%>','Do you want to Release this Lesson with the existing Content?')"> <i class="icon-arrow-up"> </i> <liferay-ui:message key="release" /> </a>  </li>
						</c:if>
					
						<li>
							<c:choose>
								<c:when test="${isLessonOwner}">
									<a href="${editUrl}"> <i class="icon-edit"> </i> <liferay-ui:message key="edit" /> </a> 
								</c:when>
								<c:otherwise>
									<a href="javascript:void(0)" onclick="return coAuthorEditLesson('${editUrl}');"> <i class="icon-edit"> </i> <liferay-ui:message key="edit" /> </a> 
								</c:otherwise>
							</c:choose> 
						</li>
						
						<c:if test="${!empty checkMarkedAs && (checkMarkedAs eq inAppropriate || checkMarkedAs eq deletedByUser)}"><!-- marked As -->
							<li> <a href="javascript:void(0)" onClick="updateMarkedAs('<%=Constant.MARKEDAS_QUARANTINE%>','Do you want to Quarantine this Lesson?')"> <i class="fa fa-life-ring"> </i> <liferay-ui:message key="quarantine" /> </a>  </li>
						</c:if>
						<c:if test="${checkMarkedAs ne inAppropriate && checkMarkedAs ne deletedByUser}"><!-- marked As -->
							<li> <a href="javascript:void(0)" onclick="return removeLesson('${DeleteLessonUrl}');"> <i class="icon-trash"> </i> <liferay-ui:message key="delete" /> </a>  </li>
						</c:if>
					
					</c:if> 
					
					<c:if test="${empty checkMarkedAs}"><!-- marked As -->
						<c:if  test="${permission eq 'view_reuse_attribution'}">
						<li>
							<a href="javascript:void(0)" id="citationPopup" > <span class="icon-chevron-left" style="color: black" aria-hidden='true'></span><span class="icon-chevron-right" aria-hidden='true'></span>&nbsp;<liferay-ui:message key="citation" /></a>
						</li>
						</c:if>
						<c:if test="${!isLessonOwner}">
						<li> 
						<c:set var="markAsRelease" value="<%=Constant.MARKEDAS_RELEASE%>" scope="page" />
						<c:set var="markAsInAppropriate" value="<%=Constant.INAPPROPRIATE%>" scope="page" />
						 <c:if test="${empty markedAs}">
							<a id="LessonInappropriate" href="javascript:void(0)" onclick="makeLessonInappropriate('<%=makeLessonInappropriateUrl%>');"> <span style="color: black" aria-hidden='true'></span><span class="icon-ban-circle" style="color: black" aria-hidden='true'></span>&nbsp;<liferay-ui:message key="mark-as-inappropriate" /></a>
							<span id="inappropriateText" style="display:none">&nbsp;Inappropriate</span>
						</c:if>
						<c:if test="${markedAs eq markAsInAppropriate}">
							<a style="display:none" id="LessonInappropriate" href="javascript:void(0)" onclick="makeLessonInappropriate('<%=makeLessonInappropriateUrl%>');"> <span style="color: black" aria-hidden='true'></span><span class="icon-ban-circle" style="color: black" aria-hidden='true'></span>&nbsp;<liferay-ui:message key="mark-as-inappropriate" /></a>
							<span class="nyu-tooltip" data-title="<liferay-ui:message key='this-lesson-is-marked-inappropriate-by' /> '${markedByUser}'" onmouseover="tooltipOver(this)" id="inappropriateText">&nbsp;Inappropriate</span>
						</c:if> 
						<c:if test="${markedAs eq markAsRelease}">
							<a style="display:block" id="LessonInappropriate" href="javascript:void(0)" onclick="makeLessonInappropriate('<%=makeLessonInappropriateUrl%>');"> <span style="color: black" aria-hidden='true'></span><span class="icon-ban-circle" style="color: black" aria-hidden='true'></span>&nbsp;<liferay-ui:message key="mark-as-inappropriate" /></a>
							<span style="display:none" id="inappropriateText">&nbsp;<liferay-ui:message key="inappropriate" /></span>
						</c:if>
						</li>
						</c:if>
					</c:if><!-- marked As  end-->
				</ul> 
				<hr/>
				
				</c:if>
				<div id="citationDisplayContent" class="hidden">
					<h6 style="text-align: center;">
						"${authorName}".${citationLessonName}."<%= Constant.PORTLET_PROP_CAPITAL_ONLY_VENDOR_NAME %>".${citationDate}.${lastViewDate}
					</h6>
					<h6 style="font-weight:normal;"><liferay-ui:message key="lesson-url" /> :</h6>
					<textarea readonly="readonly" class="alert alert-info"  style="width:100%;cursor:text;resize: none;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;box-sizing:border-box;">${EmbedUrl}</textarea>
				</div>
				<div id="citationContent"></div>
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
			<div class="span4">
			<div class="user-status">
					  <i class="icon-thumbs-up"></i><span class="no_of_appreciatedCount">&nbsp; ${appreciatedCount}  &nbsp; &nbsp; &nbsp;</span>
					  <i class="icon-eye-open"></i> ${viewCount} &nbsp; &nbsp; &nbsp;
					  <i class="icon-calendar"></i> ${lessonDuration}&nbsp; &nbsp; &nbsp;
					  <c:if test="${tagsSize ne 0}">
					  <span class="nyu-tooltip" title = "${tags}">
					  </c:if>
					  <i class="fa fa-tags"></i><liferay-ui:message key="tags" />:<span class="label label-info">${tagsSize}</span>
					</div>
					<%-- <span class="label label-default">javaScrip</span>
					<span class="label label-default">Html5</span>
					<span class="label label-default">Css3</span> 
					<span class="label label-default">Angularjs with jQuery</span>
					<span class="label label-default">sqlLight</span> -->
				</div> --%>
				<hr>
				<div class="media">
				<p><strong> Contributor </strong> </p>
					
					
					<c:if test="${empty groupPathDocumentPath}">
							<img src="${authorImg}" alt="lesson" class="media-object pull-left">
					</c:if>
					<c:if test="${!empty groupPathDocumentPath}">
						<img class="media-object pull-left" alt="lesson" style="width: 100px; height:100px;" src="${groupPathDocumentPath}">
					</c:if>
					<div class="media-body visible-desktop"> 
						<c:if test="${empty userGroupName }">
							<p> <a href="${contributorUrl}">${authorName} </a> ${aboutAuthor} </p>
						</c:if>
						<c:if test="${not empty userGroupName }">
							<p> <a href="${contributorUrl}">${userGroupName} </a> 
						</c:if>
					
						<c:if test="${!(fromViewLesson eq 'yes')}">
							<button type="button" style="display:none" class="btn btn-primary input-large nyu-tooltip" id="followUserId" title='<liferay-ui:message key="click-to-follow" />'><span class='icon-plus' aria-hidden='true'></span> <liferay-ui:message key="follow" /></button>
							<button id="unFollowUserId" class="btn btn-primary input-large nyu-tooltip" style="display: inline-block;" type="button" data-title='<liferay-ui:message key="click-to-unfollow" />'><liferay-ui:message key="following" /></button>
						</c:if> 
					</div> <!-- end media-body --> 
				</div>
				
			</div> <!-- end span4 -->
		</div> 
	</section> <!-- end lessonDescription -->
</div> <!-- end lessonDetails --> 
<c:if test="${(fromViewLesson eq 'yes')}">
<script type="text/javascript" src="<%=themeDisplay.getPathThemeJavaScript()%>/jquery/bootstrap.min.js"></script>    
</c:if>
<script>
$(function(){
	$('#myCarouselSection').carousel({
		interval: false
	});
	
	var mediaCount = $("#adMediaPopover .media-files-count ul li").length;
	var presentationCount = $("#adMediaPopover .presentation-files-count ul li").length;
	var documentCount = $("#adMediaPopover .documents-files-count ul li").length;

	$("#adMediaPopover .media-files span").html(mediaCount);
	$("#adMediaPopover .presentation-files span").html(presentationCount);
	$("#adMediaPopover .documents-files span").html(documentCount);
});
	(function(){
		$('.pagination').click(function(){
			$('#adMediaPopover').fadeOut('fast');
			$('.lesson-topic').fadeToggle();
		});
		
		$('.pagination').on('releaseOut',function(){
			$('.lesson-topic').fadeOut();
		});
		
		$('.lesson-files').click(function(){
			$('.lesson-topic').fadeOut('fast');
			$('#adMediaPopover').fadeToggle();
		});
		
		
		// AD MEDIA TOGGLER
		YUI().use('aui-toggler',function(Y) {
			new Y.TogglerDelegate(
			  {
				animated: true,
				closeAllOnExpand: true,
				container: '#myMediaToggler',
				content: '.content',
				expanded: false,
				header: '.header',
				transition: {
				  duration: 0.2,
				  easing: 'cubic-bezier(0, 0.1, 0, 1)'
				}
			  }
			);
		  }); 
	})();
	
	function openDocumentPreview(resourceId) {
		var url;
		if(resourceId.indexOf("docs.google.com") > -1){
			url = resourceId;
		}else{
			url = "<%=openDocumentPreviewUrl%>".replace("**resourceId**",resourceId);
		}
        Liferay.Util.openWindow(
				{
	                dialog: {
                       width: 780,
                       height:700,
                       align: Liferay.Util.Window.ALIGN_CENTER,
                       cache: false,
                       resizable: false,
                       modal: true
	                },
	                
	                title:'<h1 style="margin:0; line-height: normal;"><b><liferay-ui:message key="preview" /></b></h1>',
                   id: 'PreviewPopupId',                                                      
                   uri: url
  				}
           );
      }
	
	$("#favourite").click(function(){
		$.ajax({
		    url:'<%=addToMyFavouriteURL%>',
		    type: 'GET',
		    datatype:'html',
		    data:{
		    	"<portlet:namespace />lessonId":${lessonId}
		    },
		    success: function(data){
		    	$("#removeFavourite").show();
		    	$("#favourite").hide();
		     }
		});  
	});
	
	$("#removeFavourite").click(function(){
		$.ajax({
		    url:'<%=removeFromMyFavouriteURL%>',
		    type: 'GET',
		    datatype:'html',
		    data:{
		    	"<portlet:namespace />lessonId":${lessonId}
		    },
		    success: function(data){
		    	$("#favourite").show();
		    	$("#removeFavourite").hide();
		     }
		});  
	});
	
	
	/* $(document).ready(function(){
		$("#textContent a").attr("target","_blank").css({"font-weight": "bold", "text-decoration": "underline"});	
	});
	 */
	$('#citationPopup').click(function(){
		
		YUI().use(
		  'aui-modal',
		  function(Y) {
		    var modal = new Y.Modal(
		      {
		        bodyContent: $('#citationDisplayContent').html(),
		        centered: true,
		        headerContent: '<h3><strong><liferay-ui:message key="lesson-citations" /></strong></h3>',
		        modal: true,
		        render: '#citationContent',
		        resizable:false,
		        width: 600
		      }
		    ).render();
		    modal.addToolbar(
    	      [
    	        {
    	          label: '<liferay-ui:message key="close" />',
    	          on: {
    	            click: function() {
    	              modal.hide();
    	            }
    	          }
    	        }
    	      ]
    	    );
		  }
		);
	});
	
	
	function coAuthorEditLesson(editLessonURL){
		AUI().use(
	  		'aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent: '<p> <Strong><liferay-ui:message key="you-are-about-to-edit-the-lesson-for-which-you-are-not-the-primary-contributor" /></Strong></p>', centered: true,
	  				headerContent: null, 
	  				modal: true,
	  				render: '#requestLesson',
	  				width: 350,
	  				zIndex: 999,
	  				resizable: false,
	  				toolbars: {
	  					footer: [
	  					{
	  						label: '<liferay-ui:message key="proceed" />',
	  						on: {
	  							click: function() {
	  								location.href = editLessonURL;
	  							}
	  					}
	  					},
	  					{
	  						label: '<liferay-ui:message key="cancel" />',
	  						on: {
	  							click: function() {
	  								modal.hide();
	  							}
	  						}
	  					}
	  					]
	  				}
	  			}
	  		).render();
	  	  	});
	}
	
	function updateMarkedAs(markedAs,message){
	
		AUI().use(
		  		'aui-modal',
		  		function(Y) {
		  			var modal = new Y.Modal(
		  			{
		  				bodyContent: '<p> <Strong>'+message+'</Strong></p>', 
		  				centered: true,
		  				headerContent: null, 
		  				modal: true,
		  				width: 350,
		  				zIndex: 999,
		  				resizable: false,
		  				toolbars: {
		  					footer: [
		  					{
		  						label: '<liferay-ui:message key="yes" />',
		  						on: {
		  							click: function() {
		  								modal.hide();
		  								$.ajax({
		  							        url:"<%=MarkedAsLessonByAdminURL%>",
		  							        type: 'GET',
		  							        datatype:'html',
		  							        data:{
		  							        	"<portlet:namespace />lessonId":${lessonId},
		  							        	"<portlet:namespace />markedAs":markedAs
		  							        },
		  							        success: function(data){
		  							        	var redirectTo='${tabName}';
		  							        	if(redirectTo.length>0){
		  							        		window.location.href="<%=openPortletURL%>";
		  							        	}else{
		  							        		window.location.href="${homeUrl}";
		  							        	}
		  									}
		  							    });
		  							
		  							}
		  						}
		  					},
		  					{
		  						label: '<liferay-ui:message key="no" />',
		  						on: {
		  							click: function() {
		  								modal.hide();
		  							}
		  						}
		  					}
		  					]
		  				}
		  			}
		  		).render();
		  	  	});
	}
	
    var markedContent = null;
	function makeLessonInappropriate(makeLessonInappropriateUrl){
		AUI().use(
	  		'aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent: '<p> <Strong><liferay-ui:message key="reason-for-marking-this-inappropriate" /></Strong><textarea maxlength="300" id="markedContent" placeholder=\'<liferay-ui:message key="place-holder-type-here" />\' rows="4" cols="55" class="input-block-level"></textarea></p>', 
	  				centered: true,
	  				headerContent: null, 
	  				modal: true,
	  				width: 300,
	  				zIndex: 999,
	  				resizable: false,
	  				toolbars: {
	  					footer: [
	  					{
	  						label: '<liferay-ui:message key="ok" />',
	  						on: {
	  							click: function() {
	  								markedContent = Y.one('#markedContent').val();
	  								$.ajax({
	  							        url:makeLessonInappropriateUrl,
	  							        type: 'GET',
	  							        datatype:'html',
	  							        data:{
	  							        	"<portlet:namespace />n":${lessonId},
	  							        	"<portlet:namespace />markedContent":markedContent,
	  							        	"<portlet:namespace />markedAs":'Inappropriate'
	  							        },
	  							        success: function(data){
	  							        	$("#LessonInappropriate").hide();
	  							        	$("#inappropriateText").show();
	  							        	modal.hide();
	  									}
	  							    });
	  								
	  								
	  							}
	  					}
	  					},
	  					{
	  						label: '<liferay-ui:message key="cancel" />',
	  						on: {
	  							click: function() {
	  								modal.hide();
	  							}
	  						}
	  					}
	  					]
	  				}
	  			}
	  		).render();
	  	  	});
	}
	
	
	
	function authorLesson(url,id){

		 AUI().use('aui-base','liferay-portlet-url','aui-node', function(A) {
			$.ajax({
		        url:url+'&p_p_resource_id=userLessons',
		        type: 'GET',
		        datatype:'html',
		        data:{
		        	_lessons_WAR_nyyouportlet_authorId:id,
		        	
		        },
		        success: function(data){
		        	
		        	$("#hidden").hide();
		        	$(".tab-content>.active").html(data);
					$("#display-top-contributors-180").html(data);
					$("#top-contributors-180").hide();
					$("#display-top-contributors-180").show();
					$('#display-top-contributors-180').find('.thumbnail-content').each(function(i,val){	    
					    if(i%3 == 0) {  
					      $(this).addClass('no-margin clearfix');
					    }
					});
		        	
				}
		    }); 
		});  
	  
	}
	
	
	
	//CARUOSEL LOADING ONE FRAME AT TIME SCRIPT<START>
	var ShowDocumentCarousel =null;
	
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
	
	//CARUOSEL LOADING ONE FRAME AT TIME SCRIPT<END>
	
	$(function(){
	 $('.video-text .intro-text').each(function(i){
		 $(this).find('a').each(function(i1){
			$(this).attr("target","_blank").css({"font-weight": "bold", "text-decoration": "underline"});
			if($(this).attr('href').indexOf('/<%= Constant.PORTLET_PROP_NAME_OF_PORTLET %>/engage/launcher/referenceId/')>=0){ 
				$(this).attr("onClick","event.preventDefault();replaceChapterIframe('"+($(this).attr('href'))+"')");
			}
		 })
	 })
	 $('.video-text .intro-text .custom-alert').remove();
	});
	
	function replaceChapterIframe(src){
		$('.carousel-inner .active .video-text iframe').remove();
		$('.carousel-inner .active .video-text video').remove();
		$('.carousel-inner .active .video-text .doc-preview').hide();
		var iframeTag = '<iframe allowscriptaccess="always" src="'+src+'"	style="height: 370px; width: 100%; border:0;"  webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>';
		$('.carousel-inner .active .video-text .span8').append(iframeTag);
	}
	
	$('.fullScreenFunctionality').click(function(){
		$('.item.active .video-text .span8 iframe').css("height","1000px");
		$('.item.active .video-text .span8').removeClass('span8').addClass('span12');
		$('.item.active .video-text .span4').addClass('hide');
		$('.item.active .band').addClass('hide');
		$('.carousel-control.left').addClass('hide');
		$('.carousel-control.right').addClass('hide');
		$('.exitFullScreenFunctionality').removeClass('hide');
		$('.fullScreenFunctionality').addClass('hide');
	});
	
	$('.exitFullScreenFunctionality').click(function(){
		$('.item.active .video-text .span12').removeClass('span12').addClass('span8');
		$('.item.active .video-text .span8 iframe').css("height","370px");
		$('.item.active .video-text .span4.hide').removeClass('hide');
		$('.item.active .band.hide').removeClass('hide');
		$('.carousel-control.left.hide').removeClass('hide');
		$('.carousel-control.right.hide').removeClass('hide');
		$('.exitFullScreenFunctionality').addClass('hide');
		$('.fullScreenFunctionality').removeClass('hide');
	});
</script>
</c:if>
<c:if test="${!userPermissionToAccess}">
	 ${privacyCheckMessage}
</c:if>