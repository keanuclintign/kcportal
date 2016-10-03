
<%@page import="com.nyu.util.Constant"%>
<%@page import="com.liferay.util.portlet.PortletProps"%>
<%@page import="com.liferay.portal.kernel.util.PropsUtil"%>
<%@page import="com.liferay.portal.kernel.util.PropsKeys"%>
<div id="lessonSectionResourceController" ng-controller="lessonSectionController" class="text-left"> 

<div id="addMediaModal" style="display:none;"> </div> <!-- end adMediaModal --> 
<div id="modalContent"  style="display:none;">
	<div id="myMediaToggler">
		<div id="searchContent">  
			<form style="margin-bottom: 12px;">
				<label for="searchPageWise"> <strong><liferay-ui:message key="search" /></strong> </label>
				<input type="text" class="input-block-level" id="searchMedia" name="Search"  ng-model="searchMedia" size="30" placeholder="<liferay-ui:message key="type-here" />..."/> 
			</form>
		</div> 
			<h4 class="header toggler-header-collapsed clearfix cursor-pointer">
				<span><liferay-ui:message key="media-files" /> :&nbsp;{{(resourceData | filter:showCorrectFormat('mp4,zip') |filter:searchMedia).length}}</span>
				<span class="divLoadingMask pull-right" style="display:block; width: 18px;">
					<img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt="" /> 
				</span>
			</h4>
		
   		
		<div class="content toggler-content-collapsed">
			<ul class="group-list unstyled scroll-overFlow" >
				 <li class="group-list-item" ng-repeat="resourceMediaData in (resourceData | filter:showCorrectFormat('mp4,zip') |filter:searchMedia)" unsacpe-directive>
					<div class="clearfix">
						<p class="span3">
							<img ng-src="{{resourceMediaData.documentPath}}" width="64px" height="48px"> 
						</p>
						<p class="span8" style='margin-top: 10px;'>
							<span class="span1 clearfix">
								<input type="radio" class="resourceRadio"  name="media" onclick="addMediaFiles(this)"/>
								<input type="hidden"  name="fileName" value="{{resourceMediaData.documentName}} " class="mediaFileName"/>
								<input type="hidden"  name="filePath" value="{{resourceMediaData.documentPath}}" class="mediaFilePath"/>
								<input type="hidden"  name="mediaResourceId" value="{{resourceMediaData.refId}}" class="mediaResourceId"/>
								<input type="hidden"  name="docUuid" value="{{resourceMediaData.docUuid}}" class="mediaDocUuid"/>
							</span>
							<span class="span11">
								<span class="resourceUnescape">{{resourceMediaData.documentName}} </span>
							</span>	
						</p>
					</div>
				</li>
				
			</ul>
		</div>
		
		
		<h4 class="header toggler-header-collapsed clearfix cursor-pointer">
			<span><liferay-ui:message key="presentation" />:&nbsp;{{(resourceData | filter:showCorrectFormat('pptx,ppt') |filter:searchMedia).length}}</span>
			<span class="divLoadingMask pull-right" style="display:block; width: 18px;">
				<img src="${renderRequest.getContextPath()}/images/nyuloading.gif" alt="" /> 
			</span>
		</h4>
		<div class="content toggler-content-collapsed">
			
			
			<ul class="group-list unstyled scroll-overFlow" >
				 <li class="group-list-item"  ng-repeat="resourceMediaData in (resourceData | filter:showCorrectFormat('pptx,ppt') |filter:searchMedia)" unsacpe-directive>
					<div class="clearfix">
						<p class="span3">
							<img ng-src="{{resourceMediaData.documentPath}}" width="64px" height="48px"> 
						</p>
						<p class="span8" style='margin-top: 10px;'>
							<span class="span1 clearfix">
								<input type="radio" class="resourceRadio"  name="media" onclick="addMediaFiles(this)"/>
								<input type="hidden"  name="fileName" value="{{resourceMediaData.documentName}} " class="mediaFileName"/>
								<input type="hidden"  name="filePath" value="{{resourceMediaData.documentPath}}" class="mediaFilePath"/>
								<input type="hidden"  name="mediaResourceId" value="{{resourceMediaData.refId}}" class="mediaResourceId"/>
								<input type="hidden"  name="docUuid" value="{{resourceMediaData.docUuid}}" class="mediaDocUuid"/>
							</span>
							<span class="span11">
								<span class="resourceUnescape">{{resourceMediaData.documentName}} </span>
							</span>	
						</p>
					</div>
				</li>
				
			</ul>
			
			
		</div>
		
		<h4 class="header toggler-header-collapsed clearfix cursor-pointer">
			<span><liferay-ui:message key="documents" />:&nbsp;{{(resourceData | filter:showCorrectFormat('docx,xlsx,txt,doc,xls,pdf') |filter:searchMedia).length}}</span>
			<span class="divLoadingMask pull-right" style="display:block; width: 18px;">
				<img src="${renderRequest.getContextPath()}/images/nyuloading.gif"
					alt="" />
				</span>
		</h4>
		<div class="content toggler-content-collapsed">
			
			
			<ul class="group-list unstyled scroll-overFlow" >
				 <li class="group-list-item"  ng-repeat="resourceMediaData in (resourceData | filter:showCorrectFormat('docx,xlsx,txt,doc,xls,pdf') |filter:searchMedia)" unsacpe-directive>
					<div class="clearfix">
						<p class="span3">
							<img ng-src="{{resourceMediaData.documentPath}}" width="64px" height="48px"> 
						</p>
						<p class="span8" style='margin-top: 10px;'>
							<span class="span1 clearfix">
								<input type="radio" class="resourceRadio"  name="media" onclick="addMediaFiles(this)"/>
								<input type="hidden"  name="fileName" value="{{resourceMediaData.documentName}} " class="mediaFileName"/>
								<input type="hidden"  name="filePath" value="{{resourceMediaData.documentPath}}" class="mediaFilePath"/>
								<input type="hidden"  name="mediaResourceId" value="{{resourceMediaData.refId}}" class="mediaResourceId"/>
								<input type="hidden"  name="docUuid" value="{{resourceMediaData.docUuid}}" class="mediaDocUuid"/>
							</span>
							<span class="span11">
								<span class="resourceUnescape">{{resourceMediaData.documentName}} </span>
							</span>	
						</p>
					</div>
				</li>
				
			</ul>
		</div>
	</div>
</div>
</div>


<script> 
 
function resourceData(){
			$("#searchMedia").val("");
			$(".divLoadingMask").css("display","block");
			$(".resourceRadio:checked").attr("checked",false);
			var e = $('#lessonSectionResourceController');
			var scope = angular.element(e).scope();
			
    		$(".divLoadingMask").css("display","none");	
	    	 scope.$apply(function() {
	    		 scope.searchMedia="";
	    	}); 
}	

$(document).ready(function(){
	var e = $('#lessonSectionResourceController');
   	var scope = angular.element(e).scope();
	
	$(".divLoadingMask").css("display","block");	
   	scope.$apply(function() {
   		scope.resourceData=JSON.parse(JSON.stringify(<%=request.getAttribute(Constant.COMMON_STRING_CONSTANT_RESOURCE_DATA)%>));
   	}); 
   	$(".divLoadingMask").css("display","none");	
});

</script> 