<%@page import="com.nyu.util.Constant"%>

<div id='**sectionId**' data-index="**sectionIndexOrder**" class="advanced-page" ng-controller = "lessonSectionController">
	<div class="section-title">
		<%if(request.getAttribute(Constant.BASIC_LESSON)==null || request.getAttribute(Constant.BASIC_LESSON).toString().equals("")){ %>   
			<a href="#" class="btn btn-link btn-large drag-drop-handler ui-state-default drag-drop-btn"> Drag and Drop to rearrange </a>
		 <%} %>
		<a href="javascript:void(0);" class="delete-lesson pull-right nyu-tooltip" title="Delete section"
		style="text-decoration: none"> <i class="icon-trash"></i> </a> 
		<!-- <div class="order-change-dropdown" style="display:none;">
			<ul class="unstyled">
				<li> <span class="arrow"> </span>
					<a href="javascript:void(0);" class="section-move-up"> <i class="fa fa-level-up"> </i> Move Up </a> 
				</li>
				<li> <a href="javascript:void(0);" class="section-move-down"> <i class="fa fa-level-down"> </i> Move Down </a> </li>
				<li> <a href="javascript:void(0);" class="delete-lesson"> <i class="fa fa-remove"> </i> Delete </a> </li>
			</ul> end unstyled
		</div> end order-change-dropdown -->

		<h3>  <span>
					<!-- <span  class="insert-text sectionTitle" > Click here to insert title (Required) </span> -->
					<input class='insert-text sectionTitle' type='text' placeholder="Enter section title" style="margin-bottom: 7px;"/> 
			  </span>
			
			<!-- <progress class="media-progress-bar" max=100  value="0" style="display:none; margin-top: 10px; margin-left: 410px;"></progress> -->
			
			<span class="media-progress-number pull-right" style="display:none; margin: 0 7px 0 0;"></span>							
			<div class="progress pull-right" style="display:none; width:180px;">
				<div class="bar"></div>
			</div>
			<p class="text-error progress-fail-error" style="display:none;">Upload media failed. Please try again.</p>							 
			<!-- <a href="#" class="upload-media-cancel" style="display: none;"> Cancel </a> --> 
			<span class="label label-success upload-media-ready pull-right" style="display: none; margin-right: 80px;">Ready</span> 
		</h3>
		<p class="section-title-error" style="display: none; color: red;"></p>
		<div class="toggle-handler">  
			<button class="btn btn-mini learning-objectives"  style="background: #d9d9d9;"> Choose Learning Objectives </button>
			<button class="btn btn-mini expand-add-media" style="background: #d9d9d9;"> Add Text and Media </button>
		</div>	
			
			
		<!-- LEARNING OBJECT POPOVER -->
				<div class="learning-objectives-popover open-objectives">
					<header> <h5> Choose Learning Objective  <a href="javascript:void(0);" class="pull-right close-popover"> <i class="icon-remove"></i> </a> </h5> </header>
					<div class="popover-body">
					<input type="hidden" name="learnSelectedIds" class="learn-selected-ids" />
					<div ng-if="nyuLessonObjectives.length==0">
						No objectives added.
					</div>
					<div  ng-repeat="nlobj in nyuLessonObjectives" >
						<li>
					<span>
						<input type="checkbox" data-name="{{nlobj.lessonObjective}}"  value="{{nlobj.objectiveId}}" name="objectiveIds" class="checkbox nyu-obj-class"/>
					</span>
					<span class="label label-info">{{nlobj.lessonObjective}}</span> 
					</li>
					</div>
					<div class="clearfix" style="margin-top: 10%;"> 
							<aui:button type="button" onclick="javascript:saveObjectives($(this))" id="saveObjective" value="Ok" cssClass=""/>
							<aui:button type="button" id="cancelObjective" value="cancel" cssClass="" />
						</div>
					</div> <!-- end popover-body -->		
																	
					
				</div> <!-- end upload-data -->
				<div class="learn-selected-names" style="margin-top: 7px;"> </div>
	</div> <!-- end section-title -->
	<div class="section-content section-active" style="display: none;">
		<!-- Modal Box of Upload --> 					
		<div  id="uploadMediaModalBox" class="custom-modal-box upload-media-modal-box">
		   <div class="box-content">
				<header> <h4> Upload File </h4> </header>
				<div class="modalbody">
					<form action='<%= Constant.PORTLET_PROP_VENDOR_RESOURCESPACE_URL %>' enctype="multipart/form-data" method="post" id="formAddMedia" class="upload-media-form">
						<aui:input type="hidden" name="documentTitle" id="documentTitleId" label="Title" value=""/>
						<aui:input type="hidden" name="documentDesc" label="Description" id="documentDescId" value=""/>
						<label for="Resources">
							<span>Select file </span>
							<input type="file"   name="userfile" id="userfileId" class="mediaFileName" style="width:75%">
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
						</label>
						<label id="mediaSelectUploadFileId" style="display:none; color:red;" class="media-upload-file-error"></label>
						<label id="mediaUploadFileInprogressId" style="display:none; color:red;"></label>
						<div class="text-right">											
							<aui:button type="submit" id="uploadBtn" name="upload" cssClass="upload-media-sumit" value="Upload" />
							<!-- <button type="button" class="btn btn-primary uploadMediaSumit" name="uploadMedia" value="Upload Media" onclick="uploadMediaToResourceSpace(this)" >Upload</button> -->
							<a href="#" class="btn cancel-upload-btn">Cancel </a>
						</div>
						<p class="text-warning status"><strong><i class="icon-warning-sign"></i> <liferay-ui:message key="this-will-be-added-to-the-x-archive" arguments="<%=Constant.CURRENT_BRAND_NAME %>" /></strong></p>
					</form>
				</div> <!--  end modal-body  --> 
			</div> <!--  end box-content  -->
		</div> <!--  end custom-modal-box  -->
		<div class="initial-content" style="display: none;">
			<p> <img scr="" class="img-polaroid adv-content-thumb"> </p>
			<div class="drop-down-menu"> 
				<div>
					<button class="btn lesson-upload btn-availability">Upload</button>
					<button class="btn lesson-embed btn-availability">Embed</button>
					<button class="btn lesson-add-text btn-availability"  style="display: none;">Add Text</button>
					<button class="btn lesson-add-widget btn-availability" style="display: none;">Add Widget</button>								
					<button style="display: none;" class="nyu-tooltip btn lesson-add-favourites btn-availability" title="Work in progress">Add from Favourites</button>
				</div>
				<p class="section-content-error" style="display: none; color: red;"></p> 
			</div> <!-- end drop-down-menu -->
		</div> <!-- end initial-content -->
		<!-- Modal Box of Embed URL --> 					
			<div  id="embedMediaModalBox" class="custom-modal-box embed-media-modal-box">
			   <div class="box-content">
					<header> <h4> Enter URL </h4> </header>
					<div class="modalbody"> 
						<input type="text" class="embed-media-input input-block-level" placeholder="YouTube, Vimeo or any other https URL"> 									
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
				<p style="width:100%; height: 272px; border:1px solid #ccc;">  
					<img  src="<%=themeDisplay.getPathThemeImages()+"/"+Constant.CURRENT_OWNER+"/"+Constant.CONTENT_PREVIEW_PLACEHOLDER%>" class="upload-media-file-preview" style="width:100%; height: 272px; border: 1px solid #cccccc;"> 
					<img  src="<%=themeDisplay.getPathThemeImages()+ Constant.PORTLET_PROP_PATH_VENDOR   %>video-player-icon.png"  style="opacity: 0.2; width: 40%; margin: 10% 30%;display:none;" class="embed-content-player"> 
				</p> 
				<p class="upload-media-file-name"></p>
				<div>
					<!-- <button class="btn back-btn"> <i class="icon-back"> </i> Back </button> -->
				<!-- 	<button class="btn replace-btn"  style="display:none;" onclick='updateMedia("upload", this)'> <i class="icon-refresh"> </i> Replace </button> -->
					<!-- <button class="btn delete-btn" style="display:none;" > <i class="icon-trash"> </i> Delete </button> -->
					<button class="btn add-media-btn" onclick='addMedia(this)'>  <liferay-ui:message key="add-from-archive" /> </button>
					<button class="btn upload-media-btn" onclick='uploadMedia("upload", this)'>Upload Media</button>	
					<button class="btn lesson-embed btn-availability">Add URL</button>
					<span  class="resourceReplaced" style="display:none;" ></span>
					<span  class="resourceIdClass" style="display:none;" ></span>
					<span  class="imageUrlClass" style="display:none;"></span>
					<span  class="docTitleClass" style="display:none;"></span>
					<span  class="docUuIdClass" style="display:none;"></span>
					<span  class="docAutoTranscript" style="display:none;"></span>
					<span  class="docUploadType" style="display:none;"></span>
					<input type="hidden" ng-model="embedUrl" style="margin-bottom:0" class="input-block-level scope-embed-url" id="inputURL" name="inputURL" placeholder="http://youtu.be/Cd01Vp94K68" >
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
				
				<p class="section-content-error" style="display: none; color: red; margin-top:5px;">Please add content.</p> 
				<p class="section-embed-url-error" style="display: none; color: red;">Please Embed Only Https (or) Youtube (or) Vimeo Links</p> 
			</div> <!-- end span6 -->							
			<div class="span6"> 
				<p style="background: none repeat scroll 0% 0% rgb(204, 204, 204); width: 100%; margin: 0px; padding: 6px 1px;">&nbsp; <strong> Add Description to media </strong> </p>
				<p> <textarea ng-model = "docDescription" name="upload-textarea-#textAreaId#" id="upload-textarea-#textAreaId#" class="input-block-level scope-upload-text" style="height:255px;"></textarea> </p> 
			</div> <!-- end span6 -->
		</div> <!-- end case1-content row-fluid --> 
		
		<!-- Embed URL -->
		<%-- <div class="embed-content row-fluid hidden"> 
			<div class="span6"> 
				<p style="width:100%; height: 272px; border:1px solid #ccc;"> 
					<img  src="<%=themeDisplay.getPathThemeImages()+ Constant.PORTLET_PROP_PATH_VENDOR   %>youtube.png" style="width:100%; height: 272px;" class="embed-content-preview"> 
					<img  src="<%=themeDisplay.getPathThemeImages()+ Constant.PORTLET_PROP_PATH_VENDOR   %>video-player-icon.png"  style="opacity: 0.2; width: 40%; margin: 10% 30%;display:none;" class="embed-content-player"> 
				</p>  
				<!--  <iframe class="embed-content-iframe" style="width:100%; height: 272px; border: 1px solid #cccccc;display:block;"></iframe> --> 
				
				<p class="controls"> 
					<!-- <label for="inputURL"> Enter URL </label> -->
					<!-- <input type="hidden" ng-model="embedUrl" style="margin-bottom:0" class="input-block-level scope-embed-url" id="inputURL" name="inputURL" placeholder="http://youtu.be/Cd01Vp94K68" > -->
					<!-- <span class="embed-error" style="color:red; display: none;">Please enter Url</span>  -->
				</p>
				<p> <button class="btn lesson-embed btn-availability">Add URL</button> </p> 
				<!-- <p>
					<button class="btn embed-save"> Save </button>
					<button class="btn embed-delete"> Delete </button>
				</p> -->
				<!-- <p class="section-embed-url-error" style="display: none; color: red;">Please Embed Only Https (or) Youtube (or) Vimeo Links</p> 
				<p class="section-content-error" style="display: none; color: red;">Please add URL.</p>  -->
				<!--<span class="swapping-arrow">
					<i class="icon-arrow-left"></i><BR>
					<i class="icon-arrow-right"></i>
				</span> <!-- end swapping-arrow -->
				
			</div> <!-- end span6 -->							
			<div class="span6"> 
				<p style="background: none repeat scroll 0% 0% rgb(204, 204, 204); width: 100%; margin: 0px; padding: 6px 1px;">&nbsp; <strong> Add Description to media </strong> </p>
				<p> <textarea  ng-model = "embedDescription" name="embed-textarea-#textAreaId#" id="embed-textarea-#textAreaId#" class="scope-embed-text input-block-level" rows="12"></textarea> </p> 
			</div> <!-- end span6 -->
		</div> <!-- end embed-content -->  --%>
		
		<!-- Add Text -->
		<!-- <div class="text-content row-fluid hidden"> 						
			<div class="span12"> 
				<p> <textarea ng-model = "lessonDescription" name="lessonDescription-textarea-#textAreaId#" id="lessonDescription-textarea-#textAreaId#" class="scope-lesson-description input-block-level" rows="12"></textarea> </p> 
				<p> <button class="btn text-save"> Save </button> <button class="btn text-delete"> Delete </button> </p>
			</div> end span6
		</div>  --><!-- end text-content -->
	</div> <!-- end section-content --> 
</div> <!-- end advanced-page --> 	
