var documentPathArray = new Array();
var resourceIdArray = new Array();
var autoTranscriptArray = new Array();
var collectionIdArray = new Array();
var documentNameArray = new Array();
var embedMediaTitleArray = new Array();
var embedMediaDescArray = new Array();
var embedMediaArray = new Array();
var docTitleArray = new Array();
var docDescArray = new Array();
var vTranscriptArray = new Array();
var uploadCount = -1;
var uploadAjax;
var cancelUploadModal;
var confirmTranscriptModal;
var imgMap = new Object();
var imgCount = 0;
var docTitleMap = new Object();
var docTitleCount = 0;
var uploadTranscript = false;
//var prevVideoUploadTime = '';
var prevVideoUUID = '';
var transcriptVideoId = '';
var updateTranscript;
var updateTranscriptDialogClose = false;
var utResourceId='';
var autoTranscript='';

/** VT Maps - Start **/
var docPathDocIdMap = new Object();
var docPathRscIdMap = new Object();
var docPathNameMap = new Object();
var docPathRscIdMap = new Object();
var rscIdDocNameMap = new Object();
var rscIdDocCollIdMap = new Object();

var vtMap = new Object();
var tRscIdMap = new Object();
var rIdTnameMap = new Object();
var rIdTcollIdMap = new Object();
/** VT Maps - End **/

/** Update Transcript doc Maps - Start **/
var utDocPathRscIdMap = new Object();
var utDocPathDocNameMap = new Object();
var utDocPathDocTitleMap = new Object();
var utDocPathCollIdMap = new Object();
var utDocPathDocDescMap = new Object();

var unpublishDocIds = new Array();
var unpublishResId = new Array();

/*var unpublishDocUrl = new Array();
var unpublishColId = new Array();
var unpublishDocNme = new Array();*/
/** Update Transcript doc Maps - End **/

var uuid = '';

var uploadRsrcSpacId = document.getElementById("upload_rsrc_spc");

$('#divLoading').hide();

/**
 * PUBLISH LESSON
 */
formPublish2 = function(){
	if( validateLessonForm() ){
		jQuery('form').each( function (x, obj ){
			if( obj.name.indexOf( namespace + 'saveLesson') > -1){
				$("#"+obj.name).attr("action", saveLessonURL);
				obj.submit();
				$('#divPublishLoading').show();
				setTimeout(function(){
					$('#divPublishLoading').hide();
					window.location.href=homeUrl;
				}, 3000);
				
				/*alert("#"+namespace+"lessonId");
				if(typeof $("#"+namespace+"lessonId") == "undefined" || $("#"+namespace+"lessonId")=='draft' ) {
					$('#divPublishLoading').show();
				}*/
			}
		});
	}
};

/*$("#noteMessageBoxButton").on("click", function(){
	$('#divPublishLoading').hide();
	alert(homeUrl);
	window.location.href=homeUrl;
	
});*/


/**
 * UNPUBLISH LESSON
 */
formUnPublish2 = function(){
	if( validateLessonForm() ){
		jQuery('form').each( function (x, obj ){
			if( obj.name.indexOf( namespace + 'saveLesson') > -1){
				$("#"+obj.name).attr("action", unPublishedLessonURL);
				obj.submit();
				/*$('#divUnPublishLoading').show();*/
			}
		});
	}
};



/** Save As Draft **/
saveAsDraft = function(){
	if( validateLessonForm() ){
		jQuery('form').each( function (x, obj ){
			if( obj.name.indexOf( namespace + 'saveLesson') > -1){
				$("#"+obj.name).attr("action", saveLessonAsDraftURL);
				obj.submit();
			/*	$('#divPublishLoading').show();*/
     			 
			}
		});
	}
};


function validateLessonForm(){
	var isFormFilled = true;
	
	

	if(document.getElementById(namespace +'lessonTitleId').value == ""){
		$("#enterTitleErrorId").html("Please enter title.");
		$("#enterTitleErrorId").show();
		isFormFilled = false; 
		return false;
	}else if(document.getElementById(namespace +'lessonTitleId').value.length > 75){
		$("#enterTitleErrorId").html("Maximum 75 characters allowed. ");
		$("#enterTitleErrorId").show();
		return false;
	}
	
	if(($('ul#editUploadFileId li') == 'undefined')){
		if ($('ul#uploadFileId li').length == 0 && $('ul#embedFileId li').length == 0){
			alert("Please add a lesson file.");
			return false;
		}
	}else{
		if ( ($('ul#uploadFileId li').length == 0 && $('ul#embedFileId li').length == 0 ) 
				&& ($('ul#editUploadFileId li').length == 0 && $('ul#editEmbedFileId li').length == 0)){
			alert("Please add a lesson file.");
			return false;
		}
	}
	
	if($("input[type='radio']:checked").val()=="private"){
	       
        if(!$('.checkbox-check').is(':checked')){
        alert("Please select the group.");
        return false;
        
        }
	}
	
	if($("input[type='radio']:checked").val()=="public"){
		var lessonIds="";
		if(typeof(embedFilePath)!='undefined'){
			for(var  i=0;i<embedFilePath.length;i++){
				var embedURl="http:"+embedFilePath[i];
				if((embedURl.indexOf(siteURL))>=0){
					lessonIds+=embedURl.substring(embedURl.lastIndexOf("=")+1,embedURl.length)+",";
				}
			}
		}
		for(var  i=0;i<embedMediaArray.length;i++){
			var embedURl="http:"+embedMediaArray[i];
			if((embedURl.indexOf(siteURL))>=0){
				lessonIds+=embedURl.substring(embedURl.lastIndexOf("=")+1,embedURl.length)+",";
			}
		}
		$.ajax({
	        url:lessonPrivacy,
	        type: 'GET',
	        datatype:'html',
	        async: false,
	        data:{
	        	_lessons_WAR_nyyouportlet_lessonIds:lessonIds,
	        },
	        success: function(data){
	        	if(data.length>0){			        	
	        		$("#privacyCheckError").css('display','block');
	        		$("#privacyCheckError").html(data);
	        		isFormFilled=false;
	        	}else{
	        		isFormFilled=true;
	        	}
	        	return isFormFilled;	
	        }
		});
		return isFormFilled;
	} 
	
	return isFormFilled;	

}

/** Publish Playlist **/
publishPlaylist = function(){
	var isFormFilled = true;
	if(document.getElementById(namespace +'playlistTitleId').value == ""){
		$("#enterTitleErrorId").html("Please enter title.");
		$("#enterTitleErrorId").show();
		isFormFilled = false; 
		return false;
	}
	
	if( isFormFilled ){
		jQuery('form').each( function (x, obj ){
			if( obj.name.indexOf( namespace + 'savePlaylist') > -1){
				obj.submit();
				$('.publishProcess').show();
     			 
			}
		});
	}
};

$("#userfileId").change(function(){
	
	if(updateTranscript){
		if($('#userfileId').val().substring($('#userfileId').val().indexOf("."), $('#userfileId').val().length) != '.txt' ){
			$("#addTranscriptFileId").show();
			$("#"+namespace+"upload").attr("disabled",true);
			
		}else{
			$("#addTranscriptFileId").hide();
			$("#"+namespace+"upload").attr("disabled",false);
		}
	}else{
		
		if($('#userfileId').val().substring($('#userfileId').val().indexOf("."), $('#userfileId').val().length) == '.mp4')
			$("#addTranscriptId").show();
		else
			$("#addTranscriptId").hide();
	}
	
	
	
	
	
});

$("#addTransCheckId").on("click", function(){
	uploadTranscript = $("#addTransCheckId").is(":checked");
});

$('.updateScriptClass').on('click',function(){
	var tr_rsc = this.id.split("_");
	utResourceId = tr_rsc[1];
	updateTranscript = true;
	upload_fnc();
});
/**
 * UPLOAD INTO RESOURCE SPACE
 */

function uploadToResourceSpace(){
	/*if($('#userfileId').val().substring($('#userfileId').val().indexOf("."), $('#userfileId').val().length) == '.mp4' ){*/
		AUI().use(
		  		'aui-modal',
		  		function(Y) {
		  			confirmTranscriptModal = new Y.Modal(
		  			{
		  				bodyContent: '<p> <Strong>Do you want an automatic Transcript for the Video you are uploading ?</Strong></p>', centered: true,
		  				headerContent: null, 
		  				modal: true,
		  				render: '#upload_rsrc_spc',
		  				width: 350,
		  				zIndex: 999,
		  				resizable: false,
		  				toolbars: {
		  					footer: [
		  					{
		  						label: 'Yes',
		  						on: {
		  							click: function() {
		  								autoTranscript = 'true';
		  								confirmTranscriptModal.hide();
		  							}
		  						}
		  					},
		  					{
		  						label: 'No',
		  						on: {
		  							click: function() {
		  								autoTranscript = 'false';
		  								confirmTranscriptModal.hide();
		  							}
		  						}
		  					}
		  					]
		  				}
		  			}
		  		).render();
		  	});
		
		/*}else{
			alert("else");
			processUpload();
		}
	*/
};

$(function() {
	jQuery.support.cors = true;
	
	$('#formUpload').submit(function(event) {
		event.preventDefault();
		if($('#divLoading').is(':visible')){
			$("#uploadFileInprogressId").html("Please wait until file uploading is finished.");
			$("#uploadFileInprogressId").show();
			return false;
		}
		
		if( !setFormValuesFromLiferayForm() ) return false;
		
		if($('#userfileId').val().substring($('#userfileId').val().indexOf("."), $('#userfileId').val().length) == '.mp4' ){
				uploadToResourceSpace();
		}
		
		/*$("#"+namespace+"upload").prop("disabled",true);*/
		$('#divLoading').show();
		$('#cancelUpload').show();
		$("#fileUploadFail").hide();
		$("#selectUploadFileId").hide();
		
		$("#addTranscriptId").hide();
		$("#addTranscriptFileId").hide();
		
		var docTitle = $('#userfileId').val().replace(/.*(\/|\\)/, '');
		document.getElementById("titleId").value = docTitle.substring(0,docTitle.indexOf("."));
		
		var form = $(this);
		
		var fd = new FormData(document.getElementById("formUpload"));
		
		uploadAjax = $.ajax({
			type: form.attr('method'),
			url: form.attr('action'),
			data: fd,
			processData: false,
			contentType: false,
			cache: false,
			crossDomain: true,
			xhr: function() {
		        myXhr = new window.XMLHttpRequest();
		        if(myXhr.upload){
		            myXhr.upload.addEventListener('progress',showProgress, false);
		        } else {
		            alert("Upload progress is not supported.");
		        }
		        return myXhr;
			}
		}).done(function(data) {
			var responseObj = jQuery.parseJSON(data);
			uuid = generateUUID(docUuidURL);
			var docDesc = $("#"+namespace+"documentDescId").val();
			/*if(prevVideoUploadTime == '')
				imgMap[responseObj.resourceId] = responseObj.imageurl;*/
			
			if(prevVideoUUID == '')
				imgMap[responseObj.resourceId] = (responseObj.imageurl).concat("&uuid=",uuid);
			
			
			var encodedTitle = escape(docTitle);
			docTitleMap[responseObj.resourceId] = encodedTitle;
			imgCount = imgCount + 1;
			docTitleCount = docTitleCount + 1;
			//docTitleArray.push(docTitle);
			//docDescArray.push(docDesc);
			//document.getElementById(namespace + "documentTitle[]").value=docTitleArray;
			//document.getElementById(namespace + "documentDesc[]").value=docDescArray;
			
			//Code for hiding transcript of video
			if( (uploadTranscript && docTitle.substring(docTitle.lastIndexOf("."),docTitle.length) == '.txt') || updateTranscript ){
				vTranscriptArray.push(transcriptVideoId+">"+$('#'+namespace+'lessonTitleId').val()+">"+docTitle+">"+docDesc+">"+responseObj.resourceId+">"+responseObj.collectionId);
				uploadTranscript = false;
				transcriptVideo = '';
				//$("#uploadRsrcSpace ul").append('<li style="display:none;" class="img-resizer" id=rslist'+docTitleCount+'_'+docDesc+'_imgurl'+imgCount+'_'+responseObj.resourceId+'_'+responseObj.collectionId +'><img style="height:80px; width:70px;" src="'+responseObj.imageurl+'"> '+docTitle+'<a href="#" style="margin-top: 9px;" class="pull-right" id='+docTitleCount+'_'+docDesc+'_imgurl'+imgCount+'_'+responseObj.resourceId+'_'+responseObj.collectionId +' onClick="deleteRsrcSpaceDoc(this)"> Delete</a></li>');
			}else{
				$("#uploadRsrcSpace ul").append('<li class="img-resizer" id=rslist'+docTitleCount+'_'+docDesc+'_imgurl'+imgCount+'_'+responseObj.resourceId+'_'+responseObj.collectionId +'><img style="height:80px; width:70px;" src="'+responseObj.imageurl+'"> '+'<span title="'+docTitle+'">'+docTitle.substring(0, 10)+"..."+'</span>'+'<a href="#" style="margin-top: 8px; font-size: 20px; text-decoration: none;" class="pull-right" id='+docTitleCount+'_'+docDesc+'_imgurl'+imgCount+'_'+responseObj.resourceId+'_'+responseObj.collectionId +' onClick="deleteRsrcSpaceDoc(this)" title="Delete"> <i class="icon-trash"></i></a></li>');
			}
			/*
			$("#uploadRsrcSpace ul").append('<li class="img-resizer" id=rslist'+docTitleCount+'_'+docDesc+'_imgurl'+imgCount+'_'+responseObj.resourceId+'_'+responseObj.collectionId +'><img style="height:80px; width:70px;" src="'+responseObj.imageurl+'"> '+docTitle+'<a href="#" style="margin-top: 9px;" class="pull-right" id='+docTitleCount+'_'+docDesc+'_imgurl'+imgCount+'_'+responseObj.resourceId+'_'+responseObj.collectionId +' onClick="deleteRsrcSpaceDoc(this)"> Delete</a></li>');
			*/
			jQuery(':input(:hidden)').each( function (x, obj ){
				if( obj.name.indexOf( namespace + 'documentPath[]') > -1){
					/*var i = responseObj.imageurl.lastIndexOf("v=");
					if (i < 0) {
						
						//var curdate = $.format.date(new Date(), 'yyyy-MM-dd hh:mm:ss');
						//var resUrl = (responseObj.imageurl).concat("?v=",curdate);
						var resUrl = (responseObj.imageurl).concat("&uuid=",uuid);
						documentPathArray[uploadCount] = resUrl;
					}else{*/
					
						responseObj.imageurl = (responseObj.imageurl).concat("&uuid=",uuid);
						
						 /*if(prevVideoUploadTime != ''){
							var curUrlTime = responseObj.imageurl.substring(responseObj.imageurl.indexOf("v="), responseObj.imageurl.length);
							responseObj.imageurl = responseObj.imageurl.replace(curUrlTime, prevVideoUploadTime);
							prevVideoUploadTime = '';
							imgMap[responseObj.resourceId] = responseObj.imageurl;
							//upload_fnc();
							
						}*/
						
						 if(prevVideoUUID != ''){
							 	var curUUID = responseObj.imageurl.substring(responseObj.imageurl.indexOf("&uuid="), responseObj.imageurl.length);
								responseObj.imageurl = responseObj.imageurl.replace(curUUID, prevVideoUUID);
								prevVideoUUID = '';
								imgMap[responseObj.resourceId] = responseObj.imageurl;
								//upload_fnc();
									
						}
						 
						if(updateTranscript){
							var utVPath = docPathRscIdMap[utResourceId];
							//var utVtime = utVPath.substring(utVPath.indexOf("v="), utVPath.length);
							var utVUUID = utVPath.substring(utVPath.indexOf("&uuid="), utVPath.length);
							
							
							if(documentPathArray.length > 0){
								for (var i = 0; i < documentPathArray.length; i++) {
									//if(documentPathArray[i].indexOf(utVtime) > -1){
								    if(documentPathArray[i].indexOf(utVUUID) > -1){
								    	deleteUpdatedTranscripts(i);
								    }
								}
							}
							
							/*var utCurrentVTime = responseObj.imageurl.substring(responseObj.imageurl.indexOf("v="), responseObj.imageurl.length);
							responseObj.imageurl = responseObj.imageurl.replace(utCurrentVTime, utVtime);*/
							
							var utCurrentVUUID = responseObj.imageurl.substring(responseObj.imageurl.indexOf("&uuid="), responseObj.imageurl.length);
							responseObj.imageurl = responseObj.imageurl.replace(utCurrentVUUID, utVUUID);
							
							imgMap[responseObj.resourceId] = responseObj.imageurl;
							
						}
						 
						documentPathArray[uploadCount] = responseObj.imageurl;
					//}
					$(this).val( documentPathArray );
				}
				else if( obj.name.indexOf( namespace + 'resourceId[]') > -1){
					resourceIdArray[uploadCount] = responseObj.resourceId;
					
					if(autoTranscript != ''){
						autoTranscriptArray[uploadCount] = responseObj.resourceId + "_" + autoTranscript;
						document.getElementById(namespace + "autoTranscript[]").value = autoTranscriptArray;
						autoTranscript = '';
					}
					
					$(this).val( resourceIdArray );
					if(uploadTranscript && docTitle.substring(docTitle.lastIndexOf("."),docTitle.length) != '.txt' )//Map transcript to video
						transcriptVideoId = responseObj.resourceId;
					
					utDocPathRscIdMap[responseObj.imageurl] = responseObj.resourceId;
				}
				else if( obj.name.indexOf( namespace + 'collectionId[]') > -1){
					collectionIdArray[uploadCount] = responseObj.collectionId;
					 $(this).val( collectionIdArray );
					 
					 utDocPathCollIdMap[responseObj.imageurl] = responseObj.collectionId;
				}
				else if( obj.name.indexOf( namespace + 'documentName[]') > -1){
					//documentNameArray[uploadCount] = $('#title').val();
					documentNameArray[uploadCount] = $('#'+namespace+'lessonTitleId').val();
					$(this).val( documentNameArray );
					
					utDocPathDocNameMap[responseObj.imageurl] = $('#'+namespace+'lessonTitleId').val();
					
				}else if( obj.name.indexOf( namespace + 'documentTitle[]') > -1){
					docTitleArray[uploadCount] = escape(docTitle);
					$(this).val( docTitleArray );
					
					utDocPathDocTitleMap[responseObj.imageurl] = escape(docTitle);
					
				}else if( obj.name.indexOf( namespace + 'documentDesc[]') > -1){
					docDescArray[uploadCount] = docDesc;
					$(this).val( docDescArray );
					
					utDocPathDocDescMap[responseObj.imageurl] = docDesc;
				}
			});
			
			/** Re-populate VT Maps **/
			if(Object.keys(vtMap).length > 0){
				//Get transcript file of video details
				utDocPath = vtMap[docPathRscIdMap[utResourceId]];
				if(documentPath.indexOf(utDocPath) > 0){
					
					utDocRscId = tRscIdMap[utDocPath];
					utDocCollId = rIdTcollIdMap[utDocRscId];
					utDocName = rIdTnameMap[utDocRscId];
					utDocId = docPathDocIdMap[utDocPath];
					deleteDocDetails(utDocId, utDocPath, utDocRscId, utDocCollId, utDocName);//Delete transcript of the video
				}
			}
			
			
			
			$('#formUpload').each(function(){
			       this.reset();
			 });
			
			$('#divLoading').hide();
			$('#progressbar').attr("value",0);
			$('#progressbar').hide();
			$('#progressNumber').hide();
			$('#cancelUpload').hide();
			
			if(uploadTranscript){
					//prevVideoUploadTime = responseObj.imageurl.substring(responseObj.imageurl.indexOf("v="), responseObj.imageurl.length);
					prevVideoUUID = responseObj.imageurl.substring(responseObj.imageurl.indexOf("&uuid="), responseObj.imageurl.length);
					$("#addTranscriptId").hide();
					$("#addTranscriptFileId").show();
					updateTranscript=false;//make the updateTranscript=false to make regular upload work as usual (compared to the update transcript routine)
					//uploadTranscript = false;
					
			}else{
				updateTranscript=false;
				upload_fnc();
			}
			
		}).fail(function (event, jqXHR, ajaxSettings, thrownError) {
			
			$('#divLoading').hide();
			$('#progressbar').attr("value",0);
			$('#progressbar').hide();
			$('#progressNumber').hide();
			$('#cancelUpload').hide();
			$('#divPreviewImage').append('<img id="newImage' + uploadCount+ '" src="'+ contextPath +'/images/failed.gif">');
			$("#fileUploadFail").html("File upload failed.");
			$("#fileUploadFail").show();
			$("#uploadFileInprogressId").hide();
		});
		
		function showProgress(evt) {
			$('#divLoading').hide();
			$('#progressbar').show();
			$('#progressNumber').show();
			if (evt.lengthComputable) {
				var percentComplete = Math.round(evt.loaded * 100 / evt.total);
				document.getElementById('progressNumber').innerHTML = percentComplete.toString() + '%';
				$('#progressbar').attr("value",percentComplete);
				if(percentComplete == 100 ){
					$('#divLoading').show();
					$('#progressbar').hide();
					$('#progressNumber').hide();
					$('#cancelUpload').hide();
					$('#divLoading-text').html("Completing...<br/>This may take a few seconds...");
				}
			}
			else {
				document.getElementById('progressNumber').innerHTML = 'unable to compute';
			}
		}
		
		uploadCount++;
		return true;
	});
}); 

/**
 * VALIDATION
 */
setFormValuesFromLiferayForm = function (){
	var isFormFilled = true;
	jQuery(':input(:text)').each( function (x, obj ){
		 if ( $("#userfileId").val() == "" ){
			if( document.getElementById(namespace + "existingDocPath[]") == null || document.getElementById(namespace + "existingDocPath[]") == 'undefined'){
				$("#selectUploadFileId").html("Please select a file to upload");
				$("#selectUploadFileId").show();
			}
			
			isFormFilled = false; 
			return false;
		}
	});
	return isFormFilled;
};

/**
 * ONLOAD
 */
$(function() {
	$(".breadcrumbs").hide();	 
});


/** Search validation **/
$(function() {
	jQuery.support.cors = true;
	$('#search').submit(function(event) {
		
		if($('#searchText').val()==''){
			alert("Please enter text to search.");
			return false;
		}else if(!$('#lessonNameId').is(':checked') && !$('#tagId').is(':checked')
				&& !$('#authorId').is(':checked') && !$('#keywordsId').is(':checked')){
			alert("Please select search option.");
			return false;
		}else{
			return true;
		}
		
	});
	
}); 

$(function() {
	jQuery.support.cors = true;
	$("#collectionTag").change(function () {
	    $('#collectionname').val( $("#collectionTag").val() );
	});
	 
}); 

function embedMedia(){
	var embedTitle;
	var embedDesc;
	var embedUrl;
	if($("#"+namespace+"embedTitleId").val()==="" && $("#"+namespace+"embedmediaId").val()===""){
		 $("#embedTitleErrorId").html("Please enter title.");
		 $("#embedUrlErrorId").html("Please enter url.");
		 $("#embedTitleErrorId").show();
		 $("#embedUrlErrorId").show();
		 
	}else if($("#"+namespace+"embedTitleId").val()==="" ){
		
		 $("#embedTitleErrorId").html("Please enter title.");
		 $("#embedTitleErrorId").show();
		 $("#embedUrlErrorId").hide();
		
	}else if($("#"+namespace+"embedmediaId").val()===""){
		
		 $("#embedUrlErrorId").html("Please enter url.");
		 $("#embedTitleErrorId").hide();
		 $("#embedUrlErrorId").show();
		 
	}else{
		
		 $("#embedTitleErrorId").hide();
		 $("#embedUrlErrorId").hide();
		 
		 embedTitle = $("#"+namespace+"embedTitleId").val();
		 embedDesc = $("#"+namespace+"embedDescId").val();
		 embedUrl = $("#"+namespace+"embedmediaId").val();
		 embedUrl = embedUrl.replace("http://","//");
		 embedUrl = embedUrl.replace("https://","//");
		 embedIcon = "";
		 
		 if((embedUrl.indexOf('youtube')>0 || embedUrl.indexOf('YOUTUBE')>0) && embedUrl.indexOf("&")>0){
			 embedUrl = embedUrl.substring(0,embedUrl.indexOf("&"));
		 }
		 if(embedUrl.indexOf('youtube')>0 || embedUrl.indexOf('YOUTUBE')>0){
			 embedUrl = embedUrl.replace("=","/");
			 embedUrl = embedUrl.replace("watch?","");
			 embedUrl = embedUrl.replace("/v/","/embed/");			 
			 embedIcon = "http://i.ytimg.com/vi/" + embedUrl.substring(embedUrl.lastIndexOf("/")+1,embedUrl.length) + "/1.jpg";
		 }else{
			 embedIcon = contextPath+'/images/movie_mpg.png';
		 }
		 
		 embedMediaTitleArray.push(embedTitle);
		 embedMediaDescArray.push(embedDesc);
		 embedMediaArray.push(embedUrl);
		 
		 //to show loading mask while publishing
		 embedUrl = embedUrl + "?wmode=transparent";
		 
		 document.getElementById(namespace + "embedMediaTitle[]").value=embedMediaTitleArray;
		 document.getElementById(namespace + "embedMediaDesc[]").value=embedMediaDescArray;
		 document.getElementById(namespace + "embedMediaPath[]").value=embedMediaArray;
		 document.getElementById(namespace + "embedTitleId").value="";
		 document.getElementById(namespace + "embedDescId").value="";
		 document.getElementById(namespace + "embedmediaId").value="";
		 $("#embedImg ul").append('<li class="img-resizer" id=list'+embedTitle+'_'+embedDesc+'><img src=\''+embedIcon+'\'> '+embedTitle+'<a href="#" style="margin-top: 9px;" class="pull-right" id='+embedTitle+'_'+embedDesc+' onClick="deleteMedia(this)"> Delete</a></li>');
		 
		 embed_fnc();

	}

}
function deleteMedia(event){
	var res = (event.id).split("_"); 
	var index;
	
	$('#list'+event.id).remove();
	$('#vlist'+event.id).remove();
	
	index = embedMediaTitleArray.indexOf(res[0]);
	embedMediaTitleArray.splice(index, 1); 
	
	index = embedMediaDescArray.indexOf(res[1]);
	embedMediaDescArray.splice(index, 1); 
	
	embedMediaArray.splice(event, 1); 
	
	document.getElementById(namespace + "embedMediaTitle[]").value=embedMediaTitleArray;
	document.getElementById(namespace + "embedMediaDesc[]").value=embedMediaDescArray;
	document.getElementById(namespace + "embedMediaPath[]").value=embedMediaArray;
	showDefaultPreview();
}

function showDefaultPreview(){
	if(embedMediaArray.length==0 && documentPathArray.length==0)
		$("#video-placeholder").show();
}

function deleteRsrcSpaceDoc(event){
	var res = (event.id).split("_"); 
	var index;
	
	document.getElementById("rslist"+event.id).remove();
	//document.getElementById("rsimg"+event.id).remove();
	
	//index = docTitleArray.indexOf(res[0]);
	title = docTitleMap[res[3]];
	index = docTitleArray.indexOf(title);
	docTitleArray.splice(index, 1); 
	
	index = docDescArray.indexOf(res[1]);
	docDescArray.splice(index, 1); 
	
	//index = documentPathArray.indexOf(res[2]);
	index = documentPathArray.indexOf(imgMap[res[3]]);
	//videoUpldTime = imgMap[res[3]].substring(imgMap[res[3]].indexOf("v="), imgMap[res[3]].length);
	videoUpldUUID = imgMap[res[3]].substring(imgMap[res[3]].indexOf("&uuid="), imgMap[res[3]].length);
	documentPathArray.splice(index, 1); 
	//deleteTranscriptFile(res[3], videoUpldTime);
	deleteTranscriptFile(res[3], videoUpldUUID);

	if(documentPathArray.length==0)
		uploadCount = -1;
	
	/*index = resourceIdArray.indexOf(res[3]);
	resourceIdArray.splice(index, 1);*/
	
	for(var i=0; i<resourceIdArray.length; i++) {
        if(resourceIdArray[i] == res[3]) {
        	resourceIdArray.splice(i, 1);
            break;
        }
    }
	
	index = collectionIdArray.indexOf(res[4]);
	collectionIdArray.splice(index, 1); 
	
	for(var i=0; i<autoTranscriptArray.length; i++) {
        if(typeof(autoTranscriptArray[i]) != 'undefined' && autoTranscriptArray[i].substring(0, autoTranscriptArray[i].indexOf("_")) == res[3]) {
        	autoTranscriptArray.splice(i, 1);
            break;
        }
    }
	
	documentNameArray.splice($('#'+namespace+'lessonTitleId').val(), 1); 
		
	document.getElementById(namespace + "documentTitle[]").value=docTitleArray;
	document.getElementById(namespace + "documentDesc[]").value=docDescArray;
	document.getElementById(namespace + "documentPath[]").value=documentPathArray;
	document.getElementById(namespace + "documentName[]").value=documentNameArray;
	document.getElementById(namespace + "resourceId[]").value=resourceIdArray;
	document.getElementById(namespace + "collectionId[]").value=collectionIdArray;
	document.getElementById(namespace + "autoTranscript[]").value=autoTranscriptArray;

	showDefaultPreview();
	
}

// Code for hiding transcript of video
//function deleteTranscriptFile(vResourceId, videoUpldTime){
function deleteTranscriptFile(vResourceId, videoUpldUUID){
	var index;
	var itemDetail;
	var res;
	if(documentPathArray.length > 0){
		for(var i=0; i<documentPathArray.length; i++){
			//if(typeof documentPathArray[i] !== "undefined" && documentPathArray[i].contains(videoUpldTime)){
			if(typeof documentPathArray[i] !== "undefined" && documentPathArray[i].contains(videoUpldUUID)){
					index = documentPathArray.indexOf(documentPathArray[i]);
					documentPathArray.splice(index, 1); 
					break;
			}
		}
		
		for(var i=0; i<vTranscriptArray.length; i++){
			if(vTranscriptArray[i].contains(vResourceId)){
				itemDetail = vTranscriptArray[i];
				res = itemDetail.split(">");
				
				index = documentNameArray.indexOf(res[1]);
				documentNameArray.splice(index, 1);
				
				index = docTitleArray.indexOf(res[2]);
				docTitleArray.splice(index, 1);
				
				index = docDescArray.indexOf(res[3]);
				docDescArray.splice(index, 1); 
				
				for(var i=0; i<resourceIdArray.length; i++) {
			        if(resourceIdArray[i] == res[4]) {
			        	resourceIdArray.splice(i, 1);
			            break;
			        }
			    }
				
				index = collectionIdArray.indexOf(res[5]);
				collectionIdArray.splice(index, 1); 
				
				for(var i=0; i<vTranscriptArray.length; i++) {
			        if(vTranscriptArray[i] == itemDetail) {
			        	vTranscriptArray.splice(i, 1);//Delete current element from array
			            break;
			        }
			    }
				
			}
		}
		
		
	}
}

function updateTitle(obj){
	try{
		document.getElementById("titleId").value=obj.value;
		$("#enterTitleErrorId").hide();
		if(obj.value.trim()==''){
			$("#defaultTitleLabelId").show();
			$("#updatedTitleLabelId").hide();
		}else{
			$("#defaultTitleLabelId").hide();
			$("#updatedTitleLabelId").html("<h1>"+obj.value+"</h1>");
			$("#updatedTitleLabelId").show();
		}
	}catch(err){}
}
	
function updateDecsription(obj){
	$("#lessonDescLabel").html("<p align='justify'>"+obj.value+"</p>");
	$("#lessonDescLabel").show();
}

function embed_fnc()
{
xyz = document.getElementById("m_embed");
xyz.style.visibility = (xyz.style.visibility == "visible") ? "hidden" : "visible";
}

function upload_fnc(eventTitle)
{
	if(eventTitle=='close' || eventTitle=='cancel' ){
		if($('#progressbar').is(':visible') || $('#divLoading').is(':visible')){
			cancelUpload(eventTitle);
			updateTranscript = false;
		}else{
			uploadRsrcSpacId.style.visibility =  "hidden";
			updateTranscript = false;
		}
	}else{
		
		if($("#titleId").val()==''){
			$("#enterTitleErrorId").html("Please enter title.");
			$("#enterTitleErrorId").show();
			return false;
		}else if($("#titleId").val().length > 75){
			$("#enterTitleErrorId").html("Maximum 75 characters allowed. ");
			$("#enterTitleErrorId").show();
			return false;
		}else{
			uploadRsrcSpacId.style.visibility = (uploadRsrcSpacId.style.visibility == "visible") ? "hidden" : "visible";
			
			if(updateTranscriptDialogClose){
				updateTranscript = false;
				updateTranscriptDialogClose = false;
			}
			
			if(updateTranscript)
				updateTranscriptDialogClose = true;
			
			$("#addTranscriptId").hide();
			$("#addTranscriptFileId").hide();
			$("#fileUploadFail").hide();
			$("#selectUploadFileId").hide();
			$("#enterTitleErrorId").hide();
			$("#uploadFileInprogressId").hide();
			
			$('#formUpload').each(function(){
			    this.reset();
			});
			
		}
	}
	
	autoTranscript = '';
	confirmTranscriptModal.hide();
	
}

function cancelUpload(eventTitle){
	AUI().use(
  		'aui-modal',
  		function(Y) {
  			cancelUploadModal = new Y.Modal(
  			{
  				bodyContent: '<p> <Strong>Are you sure you want to cancel the upload ?</Strong></p>', centered: true,
  				headerContent: null, 
  				modal: true,
  				render: '#upload_rsrc_spc',
  				width: 350,
  				zIndex: 999,
  				resizable: false,
  				toolbars: {
  					footer: [
  					{
  						label: 'Yes',
  						on: {
  							click: function() {
  								uploadAjax.abort();
  								$("#fileUploadFail").hide();
  								$("#uploadFileInprogressId").hide();
  								$('#divLoading').hide();
  								$('#divPreviewImage').hide();
  								$('#formUpload').each(function(){
  								    this.reset();
  								});
  								if(eventTitle != 'cancel')
  									uploadRsrcSpacId.style.visibility =  "hidden";
  								
  								cancelUploadModal.hide();
  							}
  						}
  					},
  					{
  						label: 'Cancel',
  						on: {
  							click: function() {
  								$("#uploadFileInprogressId").hide();
  								cancelUploadModal.hide();
  							}
  						}
  					}
  					]
  				}
  			}
  		).render();
  	  	});
}

$( document ).ready(function() {
	$("#tags").bind('DOMNodeInserted DOMNodeRemoved',function () {
	    
		var tagsPreview="";
		$("#tags .textboxlistentry-text").each(function(){
			tagsPreview=tagsPreview+"<li>"+$(this).text()+"</li>";
		});
		$("#lesson_tags ul").html(tagsPreview);
		
	});
	
	
		
});


function closeCreateGroup(popupIdToClose)
{
 var popupDialog = Liferay.Util.Window.getById(popupIdToClose);
 popupDialog.destroy();
 var functionString = "groupsLoader";
 if(eval("typeof " + functionString) == 'function')
	 groupsLoader();
 else
    window.location.reload();
 
}

function addUpdateGroup(groupUrl,groupDetailUrl,keywordUrl,privacy,about){
	var successMsg;
	var aboutData;
	$("#"+groupnamespace+"groupPrivacy").val(privacy);
	
	if(groupUrl.indexOf('update') == -1)
		successMsg = 'Group created successfully.';
	else
		successMsg = 'Group updated successfully.';
	
	aboutData = $("#"+groupnamespace+"groupAbout");
	if(aboutData != null && aboutData.val() != null && aboutData.val() != ''){
		var regAboutDataExp = /^[a-zA-Z0-9.! ]*$/;
		 if (!regAboutDataExp.test(aboutData.val())) {
			 $("#"+groupnamespace+"groupAbout").focus().blur().focus();
		    return false;
		 }
		 if(aboutData.val().trim().length > 200){
			 $("#"+groupnamespace+"groupAbout").focus().blur().focus();
			 return false;
		 }
	}
 	var FileUploadResourceUrl = groupUrl;
	var uploadform = document.getElementById(groupnamespace+"createGroupForm");
	var fd = new FormData(uploadform);
	var groupName = $("#"+groupnamespace+"groupName").val();
	var groupDescription = $("#"+groupnamespace+"groupDescription").val();
	
	if(groupName == ''){
		if(groupDescription == ''){
			$("#"+groupnamespace+"groupDescription").focus().blur();
		}
		$("#"+groupnamespace+"groupName").focus().blur().focus();
	    return "false";
    }
	if(groupDescription == ''){
		$("#"+groupnamespace+"groupDescription").focus().blur().focus();
	    return "false";
    }
	
	if(groupName.length > 72){
		$("#"+groupnamespace+"groupName").focus();
		return "false";
    }
	
	if(groupDescription.length > 1000){
		$("#"+groupnamespace+"groupDescription").focus().blur().focus();
		return "false";
    }
	$("#groupProcessing").show();
	
	$.ajax({
	url: FileUploadResourceUrl,
	data:fd,
	dataType: 'html',
	processData: false,
	contentType: false,
	cache: false,
	type: 'POST',
	success: function(data){
		$("#groupProcessing").hide();
		try{
			var keywordRequest = JSON.parse(data);
			AUI().use('aui-modal',
				function(Y) {
					var modal = new Y.Modal(
					{
					bodyContent: '<p> <Strong>'+keywordRequest.message+' or proceed to Request</Strong></p>', 
					centered: true,
					headerContent: null, 
					modal: true,
					cssClass:'popup_alert',
					width: 350,
					zIndex: 999,
					resizable: false,
					toolbars: {
					footer: [
								{
		  						label: 'Yes',
		  						on: {
		  							click: function() {
		  								modal.hide();
		  								//uploadform.reset();
		  								//$('#'+groupnamespace+'categoriesItems').empty();
		  								//$('#'+groupnamespace+'tagsItems').empty();
		  								//$('#'+groupnamespace+'categoriesSelectedIds').val('');
		  								//$('#'+groupnamespace+'tagsSelectedNames').val('');
		  								requestKeywordAlert('Do you want to request admin for approval ? ',keywordUrl,keywordRequest);
		  							}
		  						}
								},
								{
		  						label: 'No',
		  						on: {
		  							click: function() {
		  								modal.hide();
		  								//uploadform.reset();
		  								//$('#'+groupnamespace+'categoriesItems').empty();
		  								//$('#'+groupnamespace+'tagsItems').empty();
		  								//$('#'+groupnamespace+'categoriesSelectedIds').val('');
		  								//$('#'+groupnamespace+'tagsSelectedNames').val('');
		  								//$('#popOverBodyCotent').hide();
		  								
		  							}
		  						}
								}
							]
							}
					}).render();
  				});
		}catch(err){
			//uploadform.reset();
			//$('#'+groupnamespace+'categoriesItems').empty();
			//$('#'+groupnamespace+'tagsItems').empty();
			//$('#'+groupnamespace+'categoriesSelectedIds').val('');
			//$('#'+groupnamespace+'tagsSelectedNames').val('');
			customAlertForGroups(data,groupDetailUrl,true);
		}
	 }
     });
  }



function deleteUpdatedTranscripts(index){
	documentPathArray.splice(documentPathArray.indexOf(documentPathArray[index]), 1); 
	docTitleArray.splice(docTitleArray.indexOf(utDocPathDocTitleMap[documentPathArray[index]]), 1); 
	docDescArray.splice(docDescArray.indexOf(utDocPathDocDescMap[documentPathArray[index]]), 1);
	documentNameArray.splice(documentNameArray.indexOf(utDocPathDocNameMap[documentPathArray[index]]), 1); 
	resourceIdArray.splice(resourceIdArray.indexOf(utDocPathRscIdMap[documentPathArray[index]]), 1); 
	collectionIdArray.splice(collectionIdArray.indexOf(utDocPathCollIdMap[documentPathArray[index]]), 1); 
	
	document.getElementById(namespace + "documentPath[]").value=documentPathArray;
	document.getElementById(namespace + "documentTitle[]").value=docTitleArray;
	document.getElementById(namespace + "documentDesc[]").value=docDescArray;
	document.getElementById(namespace + "documentName[]").value=documentNameArray;
	document.getElementById(namespace + "resourceId[]").value=resourceIdArray;
	document.getElementById(namespace + "collectionId[]").value=collectionIdArray;
	
}

function populateVTMaps(){
	
		for (var key in docPathNameMap){
			docPath = key;
			docName = docPathNameMap[key];
			docExt = docName.substring(docName.indexOf(".mp4"), docName.length);
			
			//vTime = docPath.substring(docPath.indexOf("?v="), docPath.length);
			vUUID = docPath.substring(docPath.indexOf("&uuid="), docPath.length);
		
			if(docExt == '.mp4'){
				for (var vkey in docPathNameMap){
					dPath = vkey;
					dName = docPathNameMap[vkey];
					dExt = dName.substring(dName.indexOf(".txt"), dName.length);
					//dvTime = dPath.substring(dPath.indexOf("?v="), dPath.length);
					dvUUID = dPath.substring(dPath.indexOf("&uuid="), dPath.length);
				
					if(docPath != dPath && dExt == ".txt" 
						//&& (vTime == dvTime)){
						&& (vUUID == dvUUID)){
						
						vtMap[docPath] = dPath;//video-transcript paths map  ->  key: video path & value: transcript path
						tRscIdMap[dPath] = docPathRscIdMap[dPath];//transcript path-resourceId map -> key: transcript path & value: resource id
						rIdTnameMap[docPathRscIdMap[dPath]] = dName;//resourceId-transcript name map -> key: resource id & value: transcript name
						rIdTcollIdMap[docPathRscIdMap[dPath]] = rscIdDocCollIdMap[docPathRscIdMap[dPath]];
					}
				}
				
			}
		}
		
		//Hide existing video's transcript file
		for (var vk in vtMap){
			var docId = "doc_"+tRscIdMap[vtMap[vk]];
			$("#"+docId).hide();
		}
		
		$('#filesDivLoading').hide();
} 



function deleteExistingRsrcFile(docId, imagePath, resId, collId, docName){
	
	var tPath;
	var tRscId;
	var tName;
	
	$('#'+docId).remove();
	
	deleteDocDetails(docId, imagePath, resId, collId, docName);
	
	if(docName.substring(docName.indexOf(".mp4"), docName.length) == '.mp4'){
		var docId;
		for (var vk in vtMap){
			if(vk == imagePath){
				tPath = vtMap[vk];
				tRscId = tRscIdMap[vtMap[vk]];
				tName = rIdTnameMap[tRscIdMap[vtMap[vk]]];
				tCollId = rIdTcollIdMap[tRscId];
				
				docId = docPathDocIdMap[tPath];
				
				deleteDocDetails(docId, tPath, tRscId, tCollId, tName);//Delete transcript of the video
			}
		}
	}
	
	if(documentPathArray.length > 0){
		//var imgVtime = imagePath.substring(imagePath.indexOf("v="), imagePath.length);
		var imgVUUID = imagePath.substring(imagePath.indexOf("&uuid="), imagePath.length);
		for (var i = 0; i < documentPathArray.length; i++) {
		    //if(documentPathArray[i].indexOf(imgVtime) > -1){
		    if(documentPathArray[i].indexOf(imgVUUID) > -1){
		    	deleteUpdatedTranscripts(i);
		    }
		}
	}
		
} 

function deleteDocDetails(docId, imagePath, resId, collId, docName){

	unpublishResId.push(resId);
	/*unpublishDocUrl.push(imagePath);
	unpublishColId.push(collId);
	unpublishDocNme.push(docName);*/
	
	unpublishDocIds.push(docId);
	documentIds.splice(documentIds.indexOf(docId), 1); 
	
	documentPath.splice(documentPath.indexOf(imagePath), 1); 
	resourceId.splice(resourceId.indexOf(resId), 1); 
	collectionId.splice(collectionId.indexOf(collId), 1); 
	documentName.splice(documentName.indexOf(docName), 1);
	
	document.getElementById(namespace + "existingDocIds[]").value=documentIds;
	document.getElementById(namespace + "existingDocPath[]").value=documentPath;
	document.getElementById(namespace + "existingResourceId[]").value=resourceId;
	document.getElementById(namespace + "existingCollId[]").value=collectionId;
	document.getElementById(namespace + "existingDocName[]").value=documentName;
	
	document.getElementById(namespace + "unpublishDocIds[]").value=unpublishDocIds;
	document.getElementById(namespace + "unpublishResourceId[]").value=unpublishResId;
	/*document.getElementById(namespace + "unpublishDocPath[]").value=unpublishDocUrl;
	document.getElementById(namespace + "unpublishCollId[]").value=unpublishColId;
	document.getElementById(namespace + "unpublishDocName[]").value=unpublishDocNme;*/
}

function populateDocDetails(docId, docPath, resId, collId, docName){
	
	documentIds.push(docId);
	documentPath.push(docPath);
	resourceId.push(resId);
	collectionId.push(collId);
	documentName.push(docName);
	
	docPathDocIdMap[docPath] = docId;
	docPathNameMap[docPath] = docName;
	docPathRscIdMap[docPath] = resId;
	rscIdDocNameMap[resId] = docName;
	rscIdDocCollIdMap[resId] = collId;
	docPathRscIdMap[resId] = docPath;
	
	document.getElementById(namespace + "existingDocIds[]").value=documentIds;
	document.getElementById(namespace + "existingDocPath[]").value=documentPath;
	document.getElementById(namespace + "existingResourceId[]").value=resourceId;
	document.getElementById(namespace + "existingCollId[]").value=collectionId;
	document.getElementById(namespace + "existingDocName[]").value=documentName;
	
}


function populateEmbedDetails(docId, docName, docPath){
	documentIds.push(docId);
	embedFileName.push(docName);
	embedFilePath.push(docPath);
	
	document.getElementById(namespace + "existingDocIds[]").value=documentIds;
	document.getElementById(namespace + "existingEmbedMediaTitle[]").value=embedFileName;
	document.getElementById(namespace + "existingEmbedMediaPath[]").value=embedFilePath;

}

function deleteExistingEmbedFile(docId, docName, docPath){
	
	$('#'+docId).remove();
	
	unpublishDocIds.push(docId);
	documentIds.splice(documentIds.indexOf(docId), 1); 
	
	embedFileName.splice(embedFileName.indexOf(docName), 1); 
	embedFilePath.splice(embedFilePath.indexOf(docPath), 1); 

	document.getElementById(namespace + "existingDocIds[]").value=documentIds;
	document.getElementById(namespace + "existingEmbedMediaTitle[]").value=embedFileName;
	document.getElementById(namespace + "existingEmbedMediaPath[]").value=embedFilePath;
	document.getElementById(namespace + "unpublishDocIds[]").value=unpublishDocIds;
	
}

function generateUUID(uuidURL) {
	var documentUUID = '';
    
	$.ajax({
        url:uuidURL,
        type: 'GET',
        datatype:'text',
        async: false,
        success: function(data){
        	documentUUID = data;	
        }
	});
	
   return documentUUID;
};


function customAlertForGroups(data,detailUrl,closePopOver){
	var str = data;
	var userGroupId = '';
	var groupDetailUrl = '';
	try{
		var userGroupId = str.match(/[0-9]+/g).map(function(n)
		{
		    return +(n);
		});
		groupDetailUrl = detailUrl.replace("**usergroupId**",userGroupId);
		data = str.replace(userGroupId, '');
	}catch(err){
		groupDetailUrl = '';
	}
	AUI().use('aui-modal',
		function(Y) {
			var modal = new Y.Modal(
			{
			bodyContent: '<p> <Strong>'+data+'</Strong></p>', centered: true,
			headerContent: null, 
			modal: true,
			cssClass:'popup_alert',
			width: 350,
			zIndex: 999,
			resizable: false,
			toolbars: {
			footer: [
						{
						label: 'Ok',
						on: {
							click: function() {
								modal.hide();
								/*if(closePopOver){
									$('#popOverBodyCotent').hide();
								}*/
								if(groupDetailUrl.trim().length>5){
									window.location.href = groupDetailUrl;
								}
							}
						}
						}
					]
					}
			}).render();
		});
}

function customAlert(data,closePopOver){
	AUI().use('aui-modal',
		function(Y) {
			var modal = new Y.Modal(
			{
			bodyContent: '<p> <Strong>'+data+'</Strong></p>', centered: true,
			headerContent: null, 
			modal: true,
			cssClass:'popup_alert',
			width: 350,
			zIndex: 999,
			resizable: false,
			toolbars: {
			footer: [
						{
						label: 'Ok',
						on: {
							click: function() {
								modal.hide();
							}
						}
						}
					]
					}
			}).render();
		});
}

function requestKeywordAlert(data,keywordUrl,keywordRequest){
	AUI().use('aui-modal',
			function(Y) {
				var modal = new Y.Modal(
				{
				bodyContent: '<p> <Strong>'+data+'</Strong></p>', centered: true,
				headerContent: null, 
				modal: true,
				cssClass:'popup_alert',
				width: 350,
				zIndex: 999,
				resizable: false,
				toolbars: {
				footer: [
							{
							label: 'Yes',
							on: {
								click: function() {
									$.ajax({
	  									url: keywordUrl.replace("**keywordId**",keywordRequest.keywordId).replace("**keywordName**",keywordRequest.keywordName),
	  									dataType: 'html',
	  									processData: false,
	  									contentType: false,
	  									cache: false,
	  									type: 'POST',
	  									success: function(data1){
	  										modal.hide();
	  										customAlert(data1,true);
	  									}
	  								});
								}
							}
							},
							{
								label: 'No',
								on: {
									click: function() {
										modal.hide();
									}
								}
							}
						]
						}
				}).render();
			});
}

function carouselIframeLoader(rtClickCnt,ltClickCnt,totDocCount,iframeStyle){
	
	this.rightClickCount = rtClickCnt;
	this.leftClickCount = ltClickCnt;
	this.totalDocument = totDocCount;
	this.iframeStyle = iframeStyle;
	this.createIframeInActiveItem = function(id){
		$('.item iframe').remove();
		id.find('.doc-preview').show();
		var iframeId = id.find('.iframe-hidden-data').data('iframeid');
		var iframesrc = id.find('.iframe-hidden-data').data('iframesrc');
		if(iframesrc != null){
			var iframeTag = '<iframe id="#id" allowscriptaccess="always" src="#path"	style="#style"  webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>';
			if(iframesrc.indexOf('stream.nyu.edu/media/')>-1){
				iframesrc = iframesrc.substr(iframesrc.lastIndexOf('/')+1);
				iframesrc='https://cdnapisec.kaltura.com/p/1674401/sp/167440100/embedIframeJs/uiconf_id/23435171/partner_id/1674401?iframeembed=true&playerId=kaltura_player&entry_id='+iframesrc;
			}else if(iframesrc.indexOf('stream.nyu.edu/id/')>-1){
				iframesrc = iframesrc.substr(iframesrc.lastIndexOf('/')+1,iframesrc.indexOf('?'));
				iframesrc='https://cdnapisec.kaltura.com/p/1674401/sp/167440100/embedIframeJs/uiconf_id/23435171/partner_id/1674401?iframeembed=true&playerId=kaltura_player&entry_id='+iframesrc;
			}
			iframeTag = iframeTag.replace("#id", iframeId);
			iframeTag = iframeTag.replace("#path", iframesrc);
			iframeTag = iframeTag.replace('#style',this.iframeStyle);
			id.find('.iframe-hidden-data').parent().append(iframeTag);
		}
	}
	
	this.rightClick = function(){
		this.rightClickCount = this.rightClickCount+1;
		if(this.rightClickCount > this.totalDocument){
			this.rightClickCount = 1;
		}
		this.createIframeInActiveItem($('.item.order-'+this.rightClickCount));
		this.leftClickCount = this.rightClickCount - 1;
	}
	
	this.leftClick = function(){
		if(this.leftClickCount < 1){
			this.leftClickCount = this.totalDocument;
		}
		this.createIframeInActiveItem($('.item.order-'+this.leftClickCount));
		this.leftClickCount = this.leftClickCount-1 ;
		this.rightClickCount = this.leftClickCount + 1;
	}
	
	this.indicatorsClick = function(id){
		var order = id.data('slideTo');
		order = order+1;
		this.createIframeInActiveItem($('.item.order-'+order));
		this.rightClickCount = order;
		this.leftClickCount = order-1;
	}
}