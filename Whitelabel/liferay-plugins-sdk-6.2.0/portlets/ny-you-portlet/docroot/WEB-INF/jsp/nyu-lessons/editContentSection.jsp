<%@page import="com.nyu.util.Constant"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<div class="progress-content">
				<div class="lesson-content ${shadowClass}">
					<div class="preview-lesson-details">
						<h1> <%=lesson.getLessonName() %> </h1>
						<p><%=lesson.getDescription() %></p>
					</div>
					<!-- <h4> Lesson Outline </h4> -->
					<div style="display:none">	
						<liferay-ui:input-editor name="discussionMessage" initMethod="" skipEditorLoading="false"
												toolbarSet="edit-in-place"  ></liferay-ui:input-editor>	
					</div>
					<div id="mySortableLayout">	
					<c:forEach items="${documentSection}" var="documentSec" varStatus="i">
					<c:set var="Sectioncount" value="${Sectioncount+1}"/>
					<c:set var="resourceType" value="${documentSec.type}" scope="page" />
					<% String resourceType = (String) pageContext.getAttribute(Constant.RESOURCE_TYPE);%>
					<div id='lesson-section-${Sectioncount}' data-index="${Sectioncount}" data-sectionid="${documentSec.sectionId}" data-documentid="${documentSec.documentId}" 
																						class="advanced-page" ng-controller = "lessonSectionController">
				
					<div class="section-title">
						<a href="#" class="btn btn-link btn-large drag-drop-handler ui-state-default drag-drop-btn"> Drag and Drop to rearrange </a>
						<a href="javascript:void(0);" class="setting-icon delete-lesson nyu-tooltip" title="Delete section"
						style="text-decoration: none"> <i class="icon-trash"></i> </a>  
						<h3><%-- <span  class="insert-text sectionTitle" > ${documentSec.title}</span>  --%>  
									<input class='insert-text sectionTitle' style="margin-bottom: 7px;" type='text' placeholder="Enter section title" value="${documentSec.title}"/>
									<span class="media-progress-number pull-right" style="display:none; margin: 0px 20px 0 0;"></span>	
									<div class="progress pull-right" style="display:none;">
										<div class="bar"></div>
									</div>
							<!-- <progress class="media-progress-bar" max=100  value="0" style="display:none; margin-top: 10px; margin-left: 635px;"></progress> -->
							<a href="#" class="upload-media-cancel" style="display: none;"> Cancel </a> 
							<span class="label label-success upload-media-ready pull-right" style="display: none;">Ready</span> 
						</h3>
						<p class="section-title-error" style="display: none; color: red;"></p>							
						<div class="toggle-handler">  
							<button class="btn btn-mini learning-objectives"  style="background: #d9d9d9;"> Choose Learning Objectives </button>
							<button class="btn btn-mini expand-add-media"  style="background: #d9d9d9;"> Add Text and Media </button>
						</div>
						
						
						 
						<!-- LEARNING OBJECT POPOVER -->
								<div class="learning-objectives-popover open-objectives">
									<header> <h5> Choose Learning Objective  <a href="javascript:void(0);" class="pull-right close-popover"> <i class="icon-remove"></i> </a> </h5> </header>
									
									<div class="popover-body">
									<input type="hidden" name="learnSelectedIds" class="learn-selected-ids" value="${documentSec.existingObjIds}"/>
									<div>
									<c:if test="${empty lessonObjectives}">
										No objectives added.
									</c:if>
									<c:forEach items="${lessonObjectives}" var="lessonObj" varStatus="i">
										<li>
										<span>
											<c:if test="${documentSec.objectiveIds.contains(lessonObj.id)}">	
												<input type="checkbox" checked="" data-name="${lessonObj.objective}"  value="${lessonObj.id}" name="objectiveIds" class="checkbox nyu-obj-class"/>
											</c:if>
											<c:if test="${!documentSec.objectiveIds.contains(lessonObj.id)}">	
												<input type="checkbox" data-name="${lessonObj.objective}"  value="${lessonObj.id}" name="objectiveIds" class="checkbox nyu-obj-class"/>
											</c:if>
										</span>
										<span class="label label-info">${lessonObj.objective}</span> 
										</li>
									</c:forEach>
									</div>
									<div class="clearfix" style="margin-top: 10%;"> 
											<aui:button type="button" onclick="javascript:saveObjectives($(this))" id="saveObjective" value="Ok" cssClass=""/>
											<aui:button type="button" id="cancelObjective" value="cancel" cssClass="" />
										</div>
									</div> <!-- end popover-body -->
								</div> <!-- end upload-data -->
								<div class="learn-selected-names" style="margin-top: 7px;">
							 <c:forEach items="${lessonObjectives}" var="lessonObj" varStatus="i">
								<c:if test="${documentSec.objectiveIds.contains(lessonObj.id)}">	
									<span class="label label-info">${lessonObj.objective}</span> 
								</c:if>
							</c:forEach>
							</div>
					</div> <!-- end section-title -->
					<div class="section-content section-active">
						<!-- Modal Box of Upload --> 					
						<div  id="uploadMediaModalBox" class="custom-modal-box upload-media-modal-box">
						   <div class="box-content">
								<header> <h4> Upload File </h4> </header>
								<div class="modalbody">
									<form action='<%=PortletProps.get("liferay.nyu.resourcespace.url") %>' enctype="multipart/form-data" method="post" id="formAddMedia" class="upload-media-form">
										<aui:input type="hidden" name="documentTitle" id="documentTitleId" label="Title" value=""/>
										<aui:input type="hidden" name="documentDesc" label="Description" id="documentDescId" value=""/>
										<label for="Resources">
											<span>Select file </span>
											<input type="file"   name="userfile" id="userfileId" class="mediaFileName" style="width:50%">
											<input type="hidden" name="resourcetype" value="2" /> 
											<input type="hidden" name="collectionname" id="collectionname" /> 
											<input type="hidden" name="title" id="titleId" class="media-file-title" /> 
											<input type="hidden" name="author" id="author" />
											<input type="hidden" name="keywords" id="keywords" />
											<!-- Docx, Xls, pptx file format removed -- microexcel -->
											<label style="font-size:11px; ">Supported formats: MP4(H-264), PDF, JPG, PNG, TXT, 3D ZIP  </label>
											<div id="mediaDivLoading" align="center" style="display:none;">
												<img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt="" /> 
												<label id="mediaDivLoading-text" style="color:#8131AF;">Uploading...<br/>This may take a few minutes...</label>
											</div>
											<!-- <div id="mediaProgressNumber" style="display:none;"></div>
											<progress id='mediaProgressbar' max=100  value="0" style="display:none;"></progress>
											<div id="mediaCancelUpload" style="display:none;"><a href="#" onclick='updateMedia("cancel",this)' >Cancel</a></div>  -->
										</label>
										<label id="mediaSelectUploadFileId" style="display:none; color:red;"></label>
										<label id="mediaUploadFileInprogressId" style="display:none; color:red;"></label>
										<div class="text-right">											
											<aui:button type="submit" id="uploadBtn" name="upload" cssClass="upload-media-sumit" value="Upload" />
											<!-- <button type="button" class="btn btn-primary uploadMediaSumit" name="uploadMedia" value="Upload Media" onclick="uploadMediaToResourceSpace(this)" >Upload</button> -->
											<a href="#" class="btn cancel-upload-btn">Cancel </a>
										</div>
										<p class="text-warning status"><strong><i class="icon-warning-sign"></i>  <liferay-ui:message key="this-will-be-added-to-the-x-archive" /> </strong></p>
									</form>
								</div> <!--  end modal-body  --> 
							</div> <!--  end box-content  -->
						</div> <!--  end custom-modal-box  -->
						<%-- <div class="initial-content">
							 <div class="learn-selected-names">
							 <c:forEach items="${lessonObjectives}" var="lessonObj" varStatus="i">
								<c:if test="${documentSec.objectiveIds.contains(lessonObj.id)}">	
									<span class="label label-info">${lessonObj.objective}</span> 
								</c:if>
							</c:forEach>
							</div>
							
							<p> <img src="${lessonImg}" class="img-polaroid"> </p>
							<div class="drop-down-menu"> 
								<div>
									<button class="btn lesson-upload btn-availability" ${ resourceType.equals('resourceSpace') ? '' : 'disabled="disabled"'}>Upload</button>
									<button class="btn lesson-embed btn-availability" ${(resourceType eq 'embed' || resourceType eq 'youtube')  ? '' : 'display="none"'}>Embed</button>
									<button class="btn lesson-add-text btn-availability" ${ resourceType == null ? '' : 'disabled="disabled"'}>Add Text</button>
									<button style="display: none;" class="btn lesson-add-widget btn-availability" ${ resourceType.equals('widget') ? '' : 'display="none"'}>Add Widget</button>								
									<button style="display: none;" class="btn lesson-add-favourites btn-availability" ${ resourceType.equals('favourites') ? '' : 'display="none"'}>Add from Favourites</button>
								</div>
								<p class="section-content-error" style="display: none; color: red;"></p> 
							</div> <!-- end drop-down-menu -->
						</div> <!-- end initial-content --> --%>
						
						<!-- Modal Box of Embed URL --> 					
							<div  id="embedMediaModalBox" class="custom-modal-box embed-media-modal-box">
							   <div class="box-content">
									<header> <h4> Enter URL </h4> </header>
									<div class="modalbody"> 
										<input type="text" class="embed-media-input input-block-level"  placeholder="YouTube, Vimeo or any other https URL"> 									
										<div class="text-right"> 
											<button class="btn btn-primary embed-media-url"> Save </button>    
											<a class="btn cancel-embet-url" href="#">Cancel </a> 
										</div>
										<span class="modal-embed-url-error" style="display: none; color: red;">Please Embed Only Https (or) Youtube (or) Vimeo Links</span>
										<span class="embed-url-empty-error" style="display: none; color: red;">Please add URL.</span> 
									</div> <!--  end modal-body  --> 
								</div> <!--  end box-content  -->
							</div> <!--  end custom-modal-box  -->
							
						<!-- Image with Textbox -->
						<div class="upload-content row-fluid">
							<div class="span6"> 
								<c:set var="resourceIdValue" value="${documentSec.resourceId}" scope="page"/>
								<c:if test="${fn:containsIgnoreCase(documentSec.type,'resource')}">
									<%-- <iframe src="${documentSec.documentPath}" class="iframeClass"  webkitallowfullscreen
									mozallowfullscreen allowfullscreen></iframe> --%>
									<img  src="${documentSec.resourceImgUrl}"  style="width:99%; height: 270px; border: 1px solid #cccccc;" >
									</c:if>
								  
									<c:if test="${ resourceType.equals('resourceSpace')}">
												<img  src="<%=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.CONTENT_PREVIEW_PLACEHOLDER%>" class="upload-media-file-preview" style="width:100%; height: 272px; border: 1px solid #cccccc;display:none">
												<p style="width:100%; height: 272px; border:1px solid #ccc; display:none;" class="embed-content-player"> <img  src="<%=themeDisplay.getPathThemeImages() %>/<%= Constant.VENDOR_NAME %>/video-player-icon.png"  style="opacity: 0.2; width: 40%; margin: 10% 30%;" ></p>
									</c:if>
									<c:if test="${ (resourceType eq 'embed' || resourceType eq 'youtube')}">
											<img  src="<%=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.CONTENT_PREVIEW_PLACEHOLDER%>" class="upload-media-file-preview" style="width:100%; height: 272px; border: 1px solid #cccccc;display:none">
											<p style="width:100%; height: 272px; border:1px solid #ccc;"  class="embed-content-player"> <img  src="<%=themeDisplay.getPathThemeImages() %>/<%= Constant.VENDOR_NAME %>/video-player-icon.png"  style="opacity: 0.2; width: 40%; margin: 10% 30%;"></p>
									</c:if>
									 
								<p class="upload-media-file-name"></p>
								<div>
									<!-- <button class="btn back-btn"> <i class="icon-back"> </i> Back </button> -->
								<!-- 	<button class="btn replace-btn"  style="display:none;" onclick='updateMedia("upload", this)'> <i class="icon-refresh"> </i> Replace </button> -->
									<!-- <button class="btn delete-btn" style="display:none;" > <i class="icon-trash"> </i> Delete </button> -->
									<button class="btn add-media-btn" onclick='addMedia(this)'>  <liferay-ui:message key="add-from-archive" /> </button>
									<button class="btn upload-media-btn" onclick='uploadMedia("upload", this)'> Upload Media</button>	
									<button class="btn lesson-embed btn-availability">Add URL</button> 
									<span  class="resourceReplaced" style="display:none;" ></span>
									<span  class="resourceIdClass" style="display:none;" >${documentSec.resourceId}</span>
									<span  class="imageUrlClass" style="display:none;">${documentSec.resourceImgUrl}</span>
									<span  class="docTitleClass" style="display:none;">${documentSec.resourceTitle}</span>
									<span  class="docUuIdClass" style="display:none;">${documentSec.docUuid}</span>
									<span  class="docAutoTranscript" style="display:none;">${documentSec.hasAutoTranscript}</span>
									
									<c:choose>
										<c:when test="${resourceIdValue gt 0}">
											<p class="controls"> 
												<input type="hidden" style="margin-bottom:0" class="input-block-level scope-embed-url" id="inputURL" name="inputURL" placeholder="http://youtu.be/Cd01Vp94K68" value="" />
											</p>
										</c:when>
										<c:otherwise>
											<c:set var="appendHttps" value="${documentSec.documentPath}" scope="page" />
											<%
											String validatedDocPath = GetterUtil.getString(pageContext.getAttribute("appendHttps"),"");
											if(validatedDocPath.toLowerCase().startsWith(StringPool.DOUBLE_SLASH)){
												validatedDocPath = Constant.HTTPS_COLON + validatedDocPath;
											}else if(!validatedDocPath.toLowerCase().startsWith(Constant.HTTPS_DOUBLE_SLASH)){
												validatedDocPath = Constant.HTTPS_DOUBLE_SLASH + validatedDocPath;
											} 
											%>
											<p class="controls"> <input type="hidden"  ng-init="embedUrl='<%=validatedDocPath%>'" ng-model="embedUrl"  class="scope-embed-url input-block-level" id="inputURL" name="inputURL" placeholder="http://youtu.be/Cd01Vp94K68" value="<%=validatedDocPath%>" /> </p>
										</c:otherwise>
									</c:choose>
								
									<!-- <input ng-model = "docResourceId" type="text" name="resourceId" id="resourceId" class="resourceIdClass"/>
									<input ng-model = "docImageUrl" type="text" name="imageurl" id="imageurl" class="imageUrlClass" />
									<input ng-model = "docTitle" type="text" name="docTitle" id="docTitle" class="docTitleClass"/>
									<input ng-model = "docUuId" type="text" name="docUuId" id="docUuId" class="docUuIdClass"/> -->
								</div> <!-- end btn-group --> 								
								<!--<span class="swapping-arrow">
									<i class="icon-arrow-left"></i><BR>
									<i class="icon-arrow-right"></i><br>
									<i class="icon-link"></i>
								</span> <!-- end swapping-arrow -->
								
								<p class="section-content-error" style="display: none; color: red;">Add or Upload media.</p> 
								<p class="section-embed-url-error" style="display: none; color: red;">Please Embed Only Https (or) Youtube (or) Vimeo Links</p> 
								<p class="section-content-error" style="display: none; color: red;">Please add url.</p> 
								
							</div> <!-- end span6 -->							
							<div class="span6"> 
								<p style="background: none repeat scroll 0% 0% rgb(204, 204, 204); width: 100%; margin: 0px; padding: 6px 1px;">&nbsp; <strong> Add Description to media </strong> </p>
								
								<p> 
									<textarea   name="upload-textarea-${Sectioncount}" id="upload-textarea-${Sectioncount}" class="input-block-level scope-upload-text" rows="12">
										<c:if test="${ resourceType.equals('resourceSpace')}">
												${documentSec.uploadText}
										</c:if>
										<c:if test="${ (resourceType eq 'embed' || resourceType eq 'youtube')}">
												${documentSec.embedText}
										</c:if>
									</textarea> 
								</p>
								
								<%-- <p class="${ resourceType.equals('resourceSpace') ? '' : 'hidden'}"> <textarea   name="upload-textarea-${Sectioncount}" id="upload-textarea-${Sectioncount}" class="input-block-level scope-upload-text" rows="12">${documentSec.uploadText}</textarea> </p>
								<p  class="${(resourceType eq 'embed' || resourceType eq 'youtube')  ? '' : 'hidden'}"> <textarea  name="upload-textarea-${Sectioncount}" id="upload-textarea-${Sectioncount}" class="scope-upload-text input-block-level" rows="12">${documentSec.embedText}</textarea></p> --%> 
							</div> <!-- end span6 -->
						</div> <!-- end case1-content row-fluid --> 
						
						<!-- Embed URL -->
						<%--  <div class="embed-content row-fluid ${(resourceType eq 'embed' || resourceType eq 'youtube')  ? '' : 'hidden'}" > 
							<div class="span6"> 
								<p> <img  src="<%=themeDisplay.getPathThemeImages()+ Constant.PORTLET_PROP_PATH_VENDOR  %>youtube.png" class="upload-media-file-preview" style="width:100%; height: 270px;"> </p> 
								<p style="width:100%; height: 272px; border:1px solid #ccc;"> 
									<img  src="<%=themeDisplay.getPathThemeImages()+ Constant.PORTLET_PROP_PATH_VENDOR   %>video-player-icon.png"  style="opacity: 0.2; width: 40%; margin: 5% 30%;" class="upload-media-file-preview"> 
								</p>  
								
								<p class="muted">  </p> 
								<c:set var="resourceIdValue" value="${documentSec.resourceId}" scope="page"/>
								<c:choose>
									<c:when test="${resourceIdValue gt 0}">
										<!-- <p class="controls"> <input type="text" class="scope-embed-url input-block-level" id="inputURL" name="inputURL" placeholder="http://youtu.be/Cd01Vp94K68" value=""/> </p> -->
										<p class="controls"> 
											<!-- <label for="inputURL"> Enter URL </label> -->
											<input type="hidden" style="margin-bottom:0" class="input-block-level scope-embed-url" id="inputURL" name="inputURL" placeholder="http://youtu.be/Cd01Vp94K68" value="" />
											<!-- <span class="embed-error" style="color:red; display: none;">Please enter Url</span>  -->
										</p>
									</c:when>
									<c:otherwise>
										<p class="controls"> <input type="text"  ng-init="embedUrl='${documentSec.documentPath}'" ng-model="embedUrl"  class="scope-embed-url input-block-level" id="inputURL" name="inputURL" placeholder="http://youtu.be/Cd01Vp94K68" value="${documentSec.documentPath}" /> </p>
										<p class="controls"> 
											<!-- <label for="inputURL"> Enter URL </label> -->
											<input type="hidden" style="margin-bottom:0" ng-init="embedUrl='${documentSec.documentPath}'" ng-model="embedUrl" class="input-block-level scope-embed-url" id="inputURL" name="inputURL" placeholder="http://youtu.be/Cd01Vp94K68"  value="${documentSec.documentPath}" />
											<!-- <span class="embed-error" style="color:red; display: none;">Please enter Url</span>  -->
										</p>
									</c:otherwise>
								</c:choose>
								<p> <button class="btn lesson-embed btn-availability">Add URL</button> </p> 
								<!-- <p>
									<button class="btn embed-save"> Save </button>
									<button class="btn embed-delete"> Delete </button>
								</p> -->
								<p class="section-embed-url-error" style="display: none; color: red;">Please Embed Only Https (or) Youtube (or) Vimeo Links</p> 
								<!--<span class="swapping-arrow">
									<i class="icon-arrow-left"></i><BR>
									<i class="icon-arrow-right"></i>
								</span> <!-- end swapping-arrow -->
								
								<p class="section-content-error" style="display: none; color: red;">Please add url.</p> 
								
							</div> <!-- end span6 -->							
							<div class="span6"> 
								<p style="background: none repeat scroll 0% 0% rgb(204, 204, 204); width: 100%; margin: 0px; padding: 6px 1px;">&nbsp; <strong> Add Description to media </strong> </p>
								<p> <textarea  name="embed-textarea-${Sectioncount}" id="embed-textarea-${Sectioncount}" class="scope-embed-text input-block-level" rows="12">${documentSec.embedText}</textarea> </p> 
							</div> <!-- end span6 -->
						</div> <!-- end embed-content --> --%>
						
						<!-- Add Text -->
						<%-- <div class="text-content row-fluid hidden"> 						
							<div class="span12"> 
								<p> <textarea  name="lessonDescription-textarea-${Sectioncount}" id="lessonDescription-textarea-${Sectioncount}" class="scope-lesson-description input-block-level" rows="12">${documentSec.textContent}</textarea> </p> 
								<p> <button class="btn text-save"> Save </button> <button class="btn text-delete"> Delete </button> </p>
							</div> <!-- end span6 -->
						</div> <!-- end text-content --> --%>
					</div> <!-- end section-content --> 
				</div> <!-- end advanced-page --> 	
						</c:forEach>	
					</div> <!-- end mySortableLayout -->	
					<div class="custom-alert section-save-alert">  						
						<div class="message-body"> 
								<h4 class="message-heading"> Lesson Save  </h4>
								<div class="content"> 
									Lesson is being Saved<br>
									please Wait.......
								</div>
						</div>  <!--  end message-body --> 						
					</div> 	
					<div class="text-center"> 
						<%if(!(GetterUtil.getString(request.getAttribute(Constant.BASIC_LESSON),Constant.NO_BASIC_LESSON).equals(Constant.BASIC_LESSON))){ %>
						<button class="btn btn-primary add-another-page" style="margin-top: 15px;"> <i class="icon-plus"> </i> Add another section </button>
						<%}%>
					</div>
					<!-- <input type="button" id="sectionSaveContinue" name="saveContinue" class="btn btn-primary" value="Save and continue" />  -->
					<div class="text-right">
						<div class="span7 text-left content-disclaimer">
							<strong>Note:</strong><i> Any information entered will be lost if the back or forward button on the browser is clicked.</i>
						</div>	 
						<c:if test="${!(fromPreviewEdit eq 'yes')}">
							<input type="button" class="btn btn-default" onclick="cancelLesson('<%=homeUrl%>')" value="Cancel" />
							<input type="button" onclick="saveSections()"   name="saveContinue" class="btn btn-primary" value="Save" /> 
						</c:if>
						<c:if test="${fromPreviewEdit eq 'yes'}">
							<a href='${createAdvanceLessonURL}' class="previous btn btn-default" >Back </a>
							<button type="button" title="cancel" class="previous btn btn-default" onclick="javascript:window.location.href='<%=homeUrl%>'">Cancel</button>
							<input type="button" onclick="saveSections()"   name="saveContinue" class="btn btn-primary" value="Save and continue" /> 	
							<div class="custom-alert section-process-alert">  						
								<div class="message-body"> 
										<h4 class="message-heading"> Alert  </h4>
										<div class="content"> 
											Please wait till section upload process is complete.
											<div class="text-right">
											<button type="button" class="btn" id="alertMessageBoxButton" >Ok</button>
											</div> 
										</div>
								</div>  <!--  end message-body --> 						
							</div> <!--  end custom-alert -->
						</c:if>
					</div>
					
				</div> <!-- end lesson-content --> 
				</div> <!-- end progress-content -->
				<div class="processingImg" align="center" style="display:none;">
					<img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt="" /> 
				</div>
				<div class="hide" id="transcribeTemplate" >
					<p> <Strong>Please Select the Type of Transcript for the Video you are uploading ?</Strong></p>
					<p style="margin: 0px">
						<%-- <span><input type="radio" name="transcribe" class="is-checked-transcribe" value="<%=Constant.TRANSCRIBE_SPHINX%>" /></span><span><%=Constant.TRANSCRIBE_SPHINX%></span> --%>
						<span><input type="radio" name="transcribe" class="is-checked-transcribe" checked="checked" value="<%=Constant.TRANSCRIBE_AUTOMATED%>" /></span><span><%=Constant.TRANSCRIBE_AUTOMATED%></span>
						<%-- <span><input type="radio" name="transcribe" class="is-checked-transcribe" value="<%=Constant.TRANSCRIBE_MANUAL%>" /></span><span><%=Constant.TRANSCRIBE_MANUAL%></span> --%>
						<span><input type="radio" name="transcribe" class="is-checked-transcribe" value="<%=Constant.TRANSCRIBE_NONE%>" /></span><span><%=Constant.TRANSCRIBE_NONE%></span>
					</p>
					<p class="text-left content-disclaimer" style="margin: 0px"><strong>Note:</strong><i id="yui_patched_v3_11_0_3_1441175231250_53"> Transcription will be available after sometime.</i> </p>
				</div>