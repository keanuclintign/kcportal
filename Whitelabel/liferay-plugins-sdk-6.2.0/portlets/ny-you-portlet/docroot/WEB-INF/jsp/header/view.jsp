<%@page import="com.liferay.portal.kernel.json.JSONObject"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil"%>
<%@page import="com.nyu.model.Slides"%>
<%@ include file="/WEB-INF/jsp/init.jsp" %>
<%@page import="com.liferay.portlet.documentlibrary.service.DLFileEntryLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil"%>
<%@page import="com.liferay.portlet.documentlibrary.model.DLFileEntry"%>
<%@page import="com.liferay.portal.service.ClassNameLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool, com.liferay.portal.kernel.json.JSONArray"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>	<%--	added by asif	 --%>

<%-- <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/bootstrap.min.js"></script> --%>
<script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"></script>

<portlet:renderURL var="showSlidesURL"/>

<portlet:renderURL var="addEditSlideURL" windowState="pop_up" >
	<portlet:param name="action" value="addEditSlide" />
	<portlet:param name="slideId" value="**slideId**" />
</portlet:renderURL>	

<%-- <portlet:actionURL var="addSlideURL">
	<portlet:param name="action" value="addSlide" />
</portlet:actionURL> 

<portlet:renderURL var="editSlideURL" >
	<portlet:param name="action" value="editSlide" />
</portlet:renderURL>--%>

<portlet:renderURL var="updateSlideURL" >
	<portlet:param name="action" value="updateSlide" />
</portlet:renderURL>

<portlet:resourceURL var="deleteSlideURL" id="deleteSlide" ></portlet:resourceURL>


<%
	String slideImagePath = null;
	long slideId = 0;
	Slides slide = null;
	String isDescPositioned = "";
	if(request.getAttribute(Constant.SLIDE_JSP)!=null){
		slide = (Slides)request.getAttribute(Constant.SLIDE_JSP);
	}
	long slidesClassNameId = ClassNameLocalServiceUtil.getClassNameId(Slides.class);
	boolean isSlideEmpty = true;
	JSONArray slidesJSONArray = (JSONArray)request.getAttribute(Constant.SLIDES_JSON_ARRAY);
	JSONObject firstSlide = null;
	if(Validator.isNotNull(slidesJSONArray)  && slidesJSONArray.length()>0){
		firstSlide = slidesJSONArray.getJSONObject(0);
		isSlideEmpty = false;
	}
%>
 
							
<section class="container" ng-controller="sliderController">
	<div class="row-fluid">
		<div class="span6 box-black hidden-phone" style="background-color: #d7e3ea; color: #000000;">
			
			<!--============== CAROUSEL ==============-->
			<div id="introCarousel" class="carousel slide" style="display: block;">  
				<div ng-show="slides.length > 1">
					<div id="menuControl" class="clearfix pull-right">				
					    <a href="javascript:void(0)" id="playPauseCarousel" class="pull-left carousel-pause cursor-pointer"><span class="icon-pause"> </span></a> 
					 	<a href="javascript:void(0)" class="pull-left" onclick="$('#introCarousel').carousel('prev')"><i class="icon-backward"> </i></a>  
					    <ol class="unstyled carousel-indicators pull-left"> 
					    	<!--  no of slide indigators goes here -->  
					    	<li data-target="#introCarousel"  
					    		data-slide-to="{{$index}}" 
								ng-class="{'active': $first}"
								ng-show="slides.length > 1" 
								ng-repeat="slide in slides">
					    	</li>
					    </ol>				    			    	
					    <a href="javascript:void(0)" class="pull-left" onclick="$('#introCarousel').carousel('next')"><i class="icon-forward"> </i></a>
					</div> 
				</div>
				    <!-- Carousel items -->
				    <%if(request.isUserInRole(Constant.PORTAL_ADMIN_ROLE)){ %>
						<div class="dropdown pull-right carousel-dropdown" ng-show="!slides.length">
								<a class="dropdown-toggle cursor-pointer" ng-click="performClick($event);$event.stopPropagation();" id="dLabel" role="button" data-toggle="dropdown" data-target="#" style="text-decoration:none;">
								<i class="icon-cog"></i> </a> 
								<ul class="dropdown-menu pull-right" role="menu" aria-labelledby="dLabel">
									<li><a tabindex="-1" href="javascript:void(0)" class="add-slide-btn" ng-click="performClick($event);$event.stopPropagation();" data-action="Add Slide">
										<liferay-ui:message key="add-slide" />
									</a></li>
								</ul>
						</div> <!-- end dropdown -->
					<%} %>
				    <div class="carousel-inner"> 	
				    	<div class="item active remove-onload">
							<div class='slide-img <%=firstSlide == null ?"hide":(firstSlide.getString(Constant.SLIDE_IMAGE).trim().equals("")?"hide":"")%>'>
								<img src='<%=firstSlide != null ?firstSlide.getString(Constant.SLIDE_IMAGE):"" %>'/>
							</div>
							<div class="slide-content" <%=firstSlide == null ?"hide":(firstSlide.getString(Constant.DESC_POSITION).trim().equals("")?"hide":" style='"+firstSlide.getString(Constant.DESC_POSITION)+": 270px; width: 285px;'")%> >
								<%=firstSlide != null ?firstSlide.getString(Constant.COMMON_STRING_CONSTANT_DESCRIPTION).replace("<a","<a onclick='performHerfClick(this,event);event.stopPropagation()'"):"" %> 
							</div> 
						</div>  					
						<div class="item" ng-click="openImageLink($event)" ng-repeat="slide in slides" data-slideid="{{slide.slideId}}" data-slideimg="{{slide.slideImage}}" data-imagelink="{{slide.imageLink}}" ng-class="{'active': $first}" slides-directive>
							<%if(request.isUserInRole(Constant.PORTAL_ADMIN_ROLE)){ %>
								<div class="dropdown pull-right carousel-dropdown">
									<a class="dropdown-toggle cursor-pointer" ng-click="performClick($event);$event.stopPropagation();" id="dLabel" role="button" data-toggle="dropdown" data-target="#" style="text-decoration:none;">
									<i class="icon-cog"></i> </a> 
									<ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
										<li><a tabindex="-1" href="javascript:void(0)" class="add-slide-btn" ng-click="performClick($event);$event.stopPropagation();" data-action="Add Slide">
											<liferay-ui:message key="add-slide" />
										</a></li>
										<li><a tabindex="-1" href="javascript:void(0)" class="edit-slide-btn" ng-click="performClick($event);$event.stopPropagation();" data-action="Edit Slide">
											<liferay-ui:message key="edit-slide" />
										</a></li>
										<li><a tabindex="-1" href="javascript:void(0)" class="delete-slide-btn" ng-click="performClick($event);$event.stopPropagation();" data-action="Delete Slide">
											<liferay-ui:message key="delete-slide" />
										</a></li>  
									</ul>
								</div>
						     <%}%>
							<div class="slide-img">
							<img ng-src="{{slide.slideImage}}" />
							</div>
							<div class="slide-content" ng-show="'{{slide.descPosition}}' == 'padding-left' || '{{slide.descPosition}}' == 'padding-right'" style="{{slide.descPosition}}: 270px; width: 285px;">  </div>
							<div class="slide-content" ng-show="'{{slide.descPosition}}' == ''"></div> 
						</div>  
				    </div> 
					<div ng-show="slides.length > 1">
					     <!-- Carousel nav --> 
					     <!-- <a class="carousel-control left" href="#introCarousel" data-slide="prev"><i class="icon-backward"></i></a>
						 <a class="carousel-control right" href="#introCarousel" data-slide="next"><i class="icon-forward"> </i></a>   -->
					</div>
			</div> <!--  end introCarousel -->
			
		</div> <!-- end box-black  -->
		<%@include file="create.jsp" %>
		<%@include file="request.jsp" %>
	</div>
</section>
<!-- ============== TAKE A TOUR MODAL ============== -->
<div id="takeTourVideo"> </div>
<div id="modalContent"  style="display: none;"> 
	<video width="800" controls>
	  <source src="${takeTourVideoUrl}" type="video/mp4">
	    <liferay-ui:message key="your-browser-does-not-support-html5-video" />.
	</video>
</div>

<div class="clearfix" style="margin-top: 40px;">
	<hr style="border-color: #adadad; margin-bottom: -34px;" />
	<h2 class="title-learn backgroundicon-learn color background-left">
		<liferay-ui:message key="discover" />
	</h2>
</div>

<%-- <!-- ADD Slide Modal --> 
<div id="addSlideModal"> </div> <!-- end adMediaModal --> 
<div id="addSliderContent"> 	
	<div class="slide-message alert alert-success" style="margin: 15px; display: none;"> </div>
	<form action="#" onSubmit="event.preventDefault()" method="post" id="addUpdateSlideForm" enctype="multipart/form-data" name="addUpdateSlide" class="add-update-slide-form">
		<div class="control-group"> 
			<p id="noImageDescErrorId" style="display:none; color:red;">Please upload an image or enter content.</p>
			<label for="uploadImage" class="control-label"> Upload image </label>
			<!-- <input type="file" class="field input-block-level" id="uploadImage" name="uploadImage"> -->
			<aui:model-context bean="<%=slide %>" model="<%=Slides.class %>"/>
			<div id="thumbnail">
						<%
						if(request.getParameter(Constant.SLIDE_JSP)!=null){
							slideId = slide.getId();
							isDescPositioned = slide.getDescPosition();
							DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(DLFileEntry.class);
							dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID, slidesClassNameId));
							dynamicQuery.add(RestrictionsFactoryUtil.eq("classPK", slide.getId()));
							List<DLFileEntry> dlFileEntries = DLFileEntryLocalServiceUtil.dynamicQuery(dynamicQuery);
							if(dlFileEntries!=null && dlFileEntries.size()>0){
								slideImagePath = themeDisplay.getPortalURL() + themeDisplay.getPathContext() + "/documents/" + dlFileEntries.get(0).getGroupId() + StringPool.SLASH + dlFileEntries.get(0).getUuid();
							}else{
								slideImagePath = themeDisplay.getPathThemeImages()+"<%= Constant.PORTLET_PROP_PATH_VENDOR %>placeholder.png";
							}
							}
						else{
								slideImagePath = themeDisplay.getPathThemeImages()+"<%= Constant.PORTLET_PROP_PATH_VENDOR %>placeholder.png";
							} 
						%>
						
					<img src="<%=slideImagePath%>" id="slideImageId" style="height: 100px; width: 138px; margin-bottom: 5px;" class="img-polaroid"></img></br>
		
		
			<span class="btn btn-default" onclick="<portlet:namespace />uploadImage('<%=uploadImage%>','Upload Image')">Change</span>
			<span class="btn btn-default" id="deleteButtonId" data-id='' onclick="deleteSlideImage(this)">Delete</span>
			 <aui:input id="thumbnailUpload"  name="file" type="hidden" label="Add Thumbnail" /> 
			 <aui:input id="fileUpload" name="dummy" type="hidden" label="Add Thumbnail" />
		</div>
			
			
		</div>
		<div class="control-group"> 
			<label for="uploadContent" class="control-label"> Content </label>
			<aui:input type="textarea" name="uploadContent" id="uploadContentId" cssClass="field input-block-level slide-content" label=""/>
			<!-- <textarea class="field input-block-level" name="uploadContent" id="uploadContent"> </textarea>  -->
			<!-- <textarea name="slide-content-textarea" id="slide-content-textarea" class="field input-block-level" ></textarea> -->
			<textarea id="slide-content-textarea" name="slide-content-textarea" class="jqte-test"></textarea>
			<aui:input type="hidden"  name="description" id="description"/>
			<aui:input type="hidden"  name="slideId" id="slideId" value="0"/>
			<p id="enterDescErrorId" style="display:none; color:red;">Please enter content.</p>
			<p id="descLengthErrorId" style="display:none; color:red;">Maximum 1000 characters are allowed.</p>
		</div>
		
		<div class="controls">
           	<label class="checkbox">
            	<input type="checkbox" name="isPositionSelected" id="isPositionSelected" class="slide-position-checkbox"> Position the description
            </label>
	        <div style="display:none;" class="position-radio-div"> 
	        	<!-- <label class="radio"> -->  
				<div class="control-group" id="contentPosition">  
					<label class="radio"> 
					<input type="radio" class="field position-right-radio" name="optionsRadios" value="padding-left" id="optionsRadiosLeft">
					Right </label>
					
					<label class="radio"> 
					<input type="radio" class="field position-left-radio" name="optionsRadios" value="padding-right" id="optionsRadiosRight">
					Left </label>
				</div>
			</div>
        </div>
		
		<footer style="background: #e4e4e4; padding: 15px;">
			<div class="text-right"> 
				<a href="javascript:void(0)" class="btn candel-slide-modal"> Cancel </a>
				<!-- <a href="#" class="btn btn-primary" id="addNewSlide" onclick="addHeaderSlide()"> Add </a>  -->
				<!-- <button type="button" class="btn btn-primary" id="addNewSlide" name="addNewSlide">Add</button> -->
				<aui:button type="submit" id="addNewSlide" name="addNewSlide" cssClass="upload-media-sumit" value="Add" />
				<aui:button type="submit" id="updateSlide" name="updateSlide" cssClass="upload-media-sumit" value="Update" />
			</div>
		</footer>
		<!-- <div class="control-group"> 
			<label for="selectCollaborators" class="control-label"> Slide Position </label>
			<input type="text" class="field input-block-level">
		</div> -->
	</form>   
</div>   --%>
<!-- DELETE Slide Modal --> 
<div id="deleteSlideModal"> </div> <!-- end adMediaModal --> 
<div id="deleteSliderContent" class="hide" >  
	<p style="padding: 15px;">
		<liferay-ui:message key="are-you-sure-you-want-to-delete-the-slide" /> ?
	</p>
	<footer style="background: #e4e4e4; padding: 15px;">
		<div class="text-right"> 
			<a href="javascript:void(0)" class="btn delete-slide-no"> 
				<liferay-ui:message key="cancel" /> 
			</a>
			<a href="javascript:void(0)" class="btn btn-primary delete-slide-yes" > 
				<liferay-ui:message key="ok" /> 
			</a> 
		</div>
	</footer>
</div>


<script>
var slideAction;
var editSlider;
var deleteSlider;
var parent;
var slidesJSONArray = [];
var slideId;

	if('<%=isSlideEmpty%>'== 'false'){
	 slidesJSONArray = JSON.parse(JSON.stringify(<%=slidesJSONArray%>)); 
	}//alert(slidesJSONArray);

var sliderController = ngApp.controller('sliderController',["$scope",function($scope){ 
	 $scope.slides = slidesJSONArray;
	 $scope.openImageLink = function($event) {
	    var slideImg = $($event.currentTarget).data('slideimg');
	    var imageLink = $($event.currentTarget).data('imagelink');
	    if((!slideImg.indexOf('<%= Constant.PORTLET_PROP_PORTLET_THEME %>') >= 0) && imageLink !='' && slideImg != ''){
	    	if(!(imageLink.indexOf('//') >= 0)){
	    		imageLink = '//'+imageLink;
	    	}
	    	window.open(imageLink, "_blank");
	    }
	  }
	 $scope.performClick= function($event) {
		 $($event.currentTarget).trigger('click'); 
	}
}]);
sliderController.directive('slidesDirective', function() {
	return function(scope, element, attrs) {
		
		 var slideDescription = scope.slide.description;
		 var slideImg = scope.slide.slideImage;
		 var imageLink = scope.slide.imageLink;
		 if((!slideImg.indexOf('<%= Constant.PORTLET_PROP_PORTLET_THEME %>') >= 0) && imageLink !='' && slideImg != ''){
		  $(element).addClass('cursor-pointer');
		 }
		 slideDescription = slideDescription.replace("<a","<a onclick='performHerfClick(this,event);event.stopPropagation()'"); 
		 $(element).find('.slide-content').html(slideDescription);
		 if(scope.$last){
			 $('.remove-onload').remove();
		 }
	}
});

function performHerfClick(id,event){
	var target = $(id).attr("target");
	if(target == null || target ==''){
		target = '_blank';
	}
	window.open($(id).attr("href"),target);
	event.preventDefault();
}

$(function(){ 
	$('#introCarousel').carousel();	 
	 
	$('#contentPosition').on('click',function(){
		$(this).next().toggle();
	});
	
	$('.dropdown-menu').on('click','.delete-slide-btn', function(){  
		parent = $(this).closest('.item'); 
		//alert($(this).data("action"));
		slideId = parent.data("slideid");
		
	});	
	
	$('.dropdown-menu').on('click','.add-slide-btn, .edit-slide-btn', function(){ 
		parent = $(this).closest('.item'); 
		slideAction = $(this).data("action");
		var url =''
		if(slideAction=='Edit Slide'){
			 url = "<%=addEditSlideURL%>".replace("**slideId**", parent.data("slideid"));
			<portlet:namespace/>addAndEditSlide(url, 'Edit Slide');
		}
		if(slideAction=='Add Slide'){
			url =  "<%=addEditSlideURL%>".replace("**slideId**",0);
			<portlet:namespace/>addAndEditSlide(url, 'Add Slide');	
		}
	}); 	
 
	$('#playPauseCarousel').on('click',function(){
		$(this).find('span').toggleClass('icon-pause icon-play');
		$(this).toggleClass('carousel-play carousel-pause'); 
		
		if($(this).hasClass('carousel-pause')) {
			$('#introCarousel').carousel('cycle');
		}else {$('#introCarousel').carousel('pause'); }
	});
	
});


function <portlet:namespace/>addAndEditSlide(url, windowTitle) {
	Liferay.Util.openWindow({
		dialog : {
			width : 500,
			height : 650,
			align : Liferay.Util.Window.ALIGN_CENTER,
			cache : false,
			modal : true
		},

		title : windowTitle,
		id : 'addAndEditSlide',
		uri : url
	});

}



YUI().use('aui-modal', function(Y) { 
	
			//MODAL for Delete Slider
			deleteSlider = new Y.Modal({
				contentBox: '#deleteSliderContent',
				centered: true,		
				destroyOnHide: false,
				headerContent: '<h3> Delete Slide </h3>',  
				modal: true,
				render: '#deleteSlideModal', 
				visible: false,
				zIndex: 101,
				width: 350,
				resizable: false
			  }).render(); 
			
			Y.all('.delete-slide-btn').on('click',function() { 
				$('#deleteSliderContent').removeClass('hide');
				deleteSlider.show();
		    });

			Y.all(".delete-slide-no").on("click", function(){
				deleteSlider.hide();
		     });
			
			Y.all(".delete-slide-yes").on("click", function(){
				$.ajax({
					url: '<%=deleteSlideURL%>',
					type: 'GET',
			        data:{
				  		<portlet:namespace/>slideId:slideId
					  }
					
				}).done(function(data) {
					deleteSlider.hide();
					window.location.href='<%=showSlidesURL%>';					
				}).fail(function (event, jqXHR, ajaxSettings, thrownError) {
				
				});
				
		     });
			
}); 	 
Liferay.provide(window,
	    '<portlet:namespace/>closePopup',
	        function(popupIdToClose,reload) {
	    	var popupDialog = Liferay.Util.Window.getById(popupIdToClose);
	    	popupDialog.destroy();
	    	if(reload){
	    		window.location.reload();
	    	}
	        },
	        ['liferay-util-window']
);


</script>