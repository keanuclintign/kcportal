/**
 * 
 */var requestLessonsController=ngApp.controller("requestLessonsController", function($scope, $interpolate, $compile, $filter,$timeout) {
	
	$scope.itemsPerPage = 10;
	$scope.currentPage=0;
	$scope.items = [];
	//$scope.tagId=0;
	$scope.appreciateAnswer=function(appreciateAnswerURL,answerId,requestType){
		 $.ajax({
		        url:appreciateAnswerURL,
		        type: 'GET',
		        datatype:'html',
		        data:{
		        	_requestlesson_WAR_nyyouportlet_answerId:answerId
		        },
		        success: function(data){
		        	
		        	$scope.$apply(function(){
		        		if(requestType==req_Opinion){
		        			var json=JSON.parse(data);
		        			$scope.answers=json.getAnswerJson;
		        			$scope.opinionSurvey=JSON.parse(json.getOpinionSurvey);
		        		}else{
		        			$scope.answers=JSON.parse(data);
		        		}
		        		showSuccessAlert("Appreciation posted successfully.");
		        	});
		        	
	    		} 	
		  });
		 
	};
	
	$scope.unAppreciateAnswer=function(unAppreciateAnswerURL,answerId,requestType){
		
		AUI().use(
		  		'aui-modal',
		  		function(Y) {
		  			var modal = new Y.Modal(
		  			{
		  				bodyContent: '<p> <b>Are you sure you want to take your appreciation back?</b></p>', 
		  				centered: true,
		  				headerContent: null, 
		  				modal: true,
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
		  								 $.ajax({
		  							        url:unAppreciateAnswerURL,
		  							        type: 'GET',
		  							        datatype:'html',
		  							        data:{
		  							        	_requestlesson_WAR_nyyouportlet_answerId:answerId
		  							        },
		  							        success: function(data){
		  							        	$scope.$apply(function(){
		  							        		if(requestType==req_Opinion){
		  							        			var json=JSON.parse(data);
		  							        			$scope.answers=json.getAnswerJson;
		  							        			$scope.opinionSurvey=JSON.parse(json.getOpinionSurvey);
		  							        		}else{
		  							        			$scope.answers=JSON.parse(data);
		  							        		}
		  							        		showSuccessAlert("Unappreciation posted successfully.");
		  							        	});
		  							        	
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
		  			}
		  		).render();
		  	  	});
		
	};
	
	 $scope.searchRequestByTag = function(tagId) {
		 	$scope.searchRequestPageWise="";
		 	if(tagId=='all'){
		 		$scope.tagId=0;
		 	}
		 	else{
		 		$scope.tagId=tagId;
		 	}
	};
		
	$scope.deleteRequest=function(deleteRequestURL,requestId){
		
		AUI().use(
		  		'aui-modal',
		  		function(Y) {
		  			var modal = new Y.Modal(
		  			{
		  				bodyContent: '<p> <b>Are you sure you want to remove this Request?</b></p>', 
		  				centered: true,
		  				headerContent: null, 
		  				modal: true,
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
		  								 $.ajax({
		  								        url:deleteRequestURL,
		  								        type: 'GET',
		  								        datatype:'html',
		  								        data:{
		  								        	_requestlesson_WAR_nyyouportlet_requestId:requestId
		  								        },
		  								        success: function(data){
		  								        	$scope.$apply(function(){
		  								        		var json=JSON.parse(data);
		  								        		$scope.allJsonRequests=json;
		  								    			$scope.tagsrequest=json;
		  								    			$scope.requestCloudTags=[];
		  								    			for(var i=0;i<$scope.tagsrequest.length; i++){
		  								    		
			  								  			 	var tags=$scope.tagsrequest[i].tags;
			  								  				for(var j = 0; j < tags.length; j++) {
			  								  					$scope.requestCloudTags.push({id:tags[j].id,name:tags[j].name});
			  								  			    } 
		  								    			} 
		  								    			$scope.currentPage=0;
		  								    			$scope.items=json;
		  								        	});
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
		  			}
		  		).render();
		  	  	});
	};
	
	$scope.deleteAnswer=function(deleteAnswerURL,requestId,answerId,requestType){
		AUI().use(
		  		'aui-modal',
		  		function(Y) {
		  			var modal = new Y.Modal(
		  			{
		  				bodyContent: '<p> <b>Are you sure you want to remove this Answer?</b></p>', 
		  				centered: true,
		  				headerContent: null, 
		  				modal: true,
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
		  								 $.ajax({
		  								        url:deleteAnswerURL,
		  								        type: 'GET',
		  								        datatype:'html',
		  								        data:{
		  								        	_requestlesson_WAR_nyyouportlet_answerId:answerId,
		  								        	_requestlesson_WAR_nyyouportlet_requestId:requestId
		  								        },
		  								        success: function(data){
		  								        	var json=JSON.parse(data);
		  								        	$scope.$apply(function(){
		  								        		if(requestType==req_Opinion){
		  								        			$scope.answers=json.getAnswerJson;
		  								        			$scope.opinionSurvey=JSON.parse(json.getOpinionSurvey);
		  								        		}
		  								        		else{
		  								        			$scope.answers=json;
		  								        		}
		  								        	
		  								        		
		  								        	});
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
		  			}
		  		).render();
		  	  	});
	};
	
	
	$scope.deleteComment=function(deleteCommentURL,requestId,answerCommentId,requestCommentId){
			AUI().use(
			  		'aui-modal',
			  		function(Y) {
			  			var modal = new Y.Modal(
			  			{
			  				bodyContent: '<p> <Strong>Are you sure you want to remove this comment?</Strong></p>', 
			  				centered: true,
			  				headerContent: null, 
			  				modal: true,
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
			  								 $.ajax({
			  								        url:deleteCommentURL,
			  								        type: 'GET',
			  								        datatype:'html',
			  								        data:{
			  								        	_requestlesson_WAR_nyyouportlet_answerCommentId:answerCommentId,
			  								        	_requestlesson_WAR_nyyouportlet_requestCommentId:requestCommentId,
			  								        	_requestlesson_WAR_nyyouportlet_requestId:requestId
			  								        },
			  								        success: function(data){
			  								        	$scope.$apply(function(){
			  								        	var json=JSON.parse(data);
			  								        	if(answerCommentId==0){
			  								        		$scope.comments=json;
			  								        	}
			  								        	else{
			  								        		$scope.answerComments=json;
			  								        	}
			  								        	
			  								        		
			  								        	});
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
			  			}
			  		).render();
			  	  	});
			
			
		};
		
	$scope.appreciateRequest=function(appreciateRequestURL,requestId){
		 $.ajax({
		        url:appreciateRequestURL,
		        type: 'GET',
		        datatype:'html',
		        data:{
		        	_requestlesson_WAR_nyyouportlet_requestId:requestId
		        },
		        success: function(data){
		        	$scope.$apply(function(){
		        		$scope.requestLesson=JSON.parse(data);
		        		showSuccessAlert("Appreciation posted successfully.");
		        	});
		        	
		        	
	    		} 	
		  });
		 
	};
	$scope.collaborateLinkToLesson=function(lessonId,requestId,collaborateLinkToLessonURL){
		var requestId = $('#requestId').text();
		$.ajax({
			url : collaborateLinkToLessonURL,
		  	type : 'POST',
		  	async : false,
		  	data:{
		        	_requestlesson_WAR_nyyouportlet_lessonId:lessonId,
		        	_requestlesson_WAR_nyyouportlet_requestId:requestId
			  	
			  },
		  	success: function(data){
		  		if(data.indexOf("already linked") > -1){
		  			
		  			$("#linkedLessonError").html(data);
		  			$("#linkedLessonError").show();
		  		
		  		}else{
		  			$("#linkedLessonError").empty();
		  			$("#linkedLessonError").hide();

		  			var e = $('#answerRequestController');
		  			var scope = angular.element(e).scope();
		  			scope.answers=JSON.parse(data);
		  			scope.$apply(function() {});
		  			
		  			$('.lesson-linked-success-alert').show();
					setTimeout(function(){
						$('.lesson-linked-success-alert').hide();
					}, 1000); 
					
					linkToLessonModal.hide();	
		  		}
		  		
			}
		});
	}
 
	$scope.unAppreciateRequest=function(unAppreciateRequestURL,requestId){
		
		AUI().use(
		  		'aui-modal',
		  		function(Y) {
		  			var modal = new Y.Modal(
		  			{
		  				bodyContent: '<p> <b>Are you sure you want to take your appreciation back?</b></p>', 
		  				centered: true,
		  				headerContent: null, 
		  				modal: true,
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
		  								$.ajax({
		  							        url:unAppreciateRequestURL,
		  							        type: 'GET',
		  							        datatype:'html',
		  							        data:{
		  							        	_requestlesson_WAR_nyyouportlet_requestId:requestId
		  							        },
		  							        success: function(data){
		  							        	$scope.$apply(function(){
		  							        		$scope.requestLesson=JSON.parse(data);
		  							        		showSuccessAlert("Unappreciation posted successfully.");
		  							        	});
		  							        	
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
		  			}
		  		).render();
		  	  	});
		
		
	};
		
	$scope.addAnswerComments=function(event,answerCommentURL,answerId){
		
		var body=$(event.target).prev().children('.inputAnswerComment').val();
		if(body == null || body.trim().length==0){
			showValidationAlert("please enter the comment.");
		}else if(body.trim().length > 500){
			showValidationAlert("Please enter comments below 500 characters.");
		}else{
			 $.ajax({
			        url:answerCommentURL,
			        type: 'POST',
			        datatype:'html',
			        data:{
			        	_requestlesson_WAR_nyyouportlet_answerId:answerId,
			        	_requestlesson_WAR_nyyouportlet_body:body
			        },
			        success: function(data){
			        	$scope.$apply(function(){
			        	$scope.answerComments=JSON.parse(data);	
			        	});
			        	
		    		} 	
			  });
		}
		 
		 $(event.target).prev().children('.inputAnswerComment').val("");
		 
	};
	
	$scope.deleteLinkedLesson=function(deleteLinkedLessonURL,answerRequestId,collaborationId, requestId){
			AUI().use(
			  		'aui-modal',
			  		function(Y) {
			  			var modal = new Y.Modal(
			  			{
			  				bodyContent: '<p> <b>Are you sure you want to remove this Linked Lesson ?</b></p>', 
			  				centered: true,
			  				headerContent: null, 
			  				modal: true,
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
			  								 $.ajax({
			  								        url:deleteLinkedLessonURL,
			  								        type: 'GET',
			  								        datatype:'html',
			  								        data:{
			  								        	_requestlesson_WAR_nyyouportlet_answerRequestId:answerRequestId,
			  								        	_requestlesson_WAR_nyyouportlet_collaborationId:collaborationId,
			  								        	_requestlesson_WAR_nyyouportlet_requestId:requestId
			  								        },
			  								        success: function(data){
			  								        	if(data.indexOf("not delete") > -1){
			  								        		$("#linkedLessonDeleteError").html(data);
			  									  			$("#linkedLessonDeleteError").show();
			  								        	}else{
			  								        		$("#linkedLessonDeleteError").empty();
			  									  			$("#linkedLessonDeleteError").hide();
			  									  			
			  								        		$scope.$apply(function(){
				  								        		$scope.answers=JSON.parse(data);
				  								        	});
			  								        	}
			  								        	
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
			  			}
			  		).render();
			  	  	});
			};
			
		$scope.$watch('filterItem', function(newValue, oldValue) {
			
		    if (newValue === oldValue) { return; }
		    $scope.currentPage=0;
		    $scope.items=$scope.filterItem;
		}, true);

			
	  $scope.prevPage = function() {
	    if ($scope.currentPage > 0) {
	      $scope.currentPage--;
	    }
	  };
	
	  $scope.prevPageDisabled = function() {
	    return $scope.currentPage === 0 ? "disabled" : "";
	  };
	
	  $scope.pageCount = function() {
	    return Math.ceil($scope.items.length/$scope.itemsPerPage)-1;
	  };
	
	  $scope.nextPage = function() {
	    if ($scope.currentPage < $scope.pageCount()) {
	      $scope.currentPage++;
	    }
	  };
	
	  $scope.nextPageDisabled = function() {
	    return $scope.currentPage === $scope.pageCount() ? "disabled" : "";
	  };
	
	  $scope.setPage = function(n) {
	    $scope.currentPage = n;
	  };
	
	 });

 	requestLessonsController.directive('myAnswerCommentDirective', function() {
		return function(scope, element, attrs) {
			$(element).find('.change-to-html').html(scope.answer.description);
		}
	});



 	AUI().use('node-scroll-info',function(Y){ 
    var body = Y.one('body'); 
    body.plug(Y.Plugin.ScrollInfo); 
    body.scrollInfo.on('scrollToBottom', function(e){
    	// get Angular scope from the known DOM element
    	e = $('#requestLessonsController');
    	scope = angular.element(e).scope();
    	// update the model with a wrap in $apply(fn) which will refresh the view for us
    	if(scope != null){
	    	scope.$apply(function() {
	    	    scope.loadMore();
	    	}); 
    	}
    }); 
 });


$(function(){
	$('#requestLessonsController .row-fluid').bind('DOMNodeInserted DOMNodeRemoved', function(event) {
		$(this).find('.thumbnail-lessons').each(
				function(i, val) {
					if (i % 3 == 0) {
						$(this).addClass('no-margin clearfix');
					}else{
						$(this).removeClass('no-margin clearfix');
					}
				});
		});
});

$('#surveyPolling .thumbnail-lessons').each(
		function(i, val) {
			if (i % 3 == 0) {
				$(this).addClass('no-margin clearfix');
			}else{
				$(this).removeClass('no-margin clearfix');
			}
});


requestLessonsController.filter('offset', function() {
	  return function(input, start) {
		   if(input !== undefined){
		    start = parseInt(start, 10);
		    return input.slice(start);
		   }
		  };
});


