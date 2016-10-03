var lessonsController=ngApp.controller("LessonsController",["$scope","$timeout","$interpolate", "$compile", "$filter",function($scope,$timeout,$interpolate, $compile, $filter) {
	var lessonShowCount =15;
    $scope.load = function() {
    	$scope.limit = lessonShowCount;
    };
    
    $scope.loadMore = function() {
    	$scope.limit += lessonShowCount;
    	
    };
    
    $scope.applyScript = function(){ 
	    $('.tab-content .divLoadingclass').remove();
		// On click 
		$('.angularContent').show();
	    $(".info-flip-icon").on('click',function(){  
	          $(this).closest('article.lesson').stop().animate({
	               top: '355px',
	               opacity: 0, 
	          }, 300); 
	    }); 
	    // On mouseleave  
	    $(".my-flip").on( "mouseleave", function(event) {
	          $(this).find('article.lesson').stop().animate({
	        	  	top: '0px',
	                opacity: 1,
	          }, 300);
	        event.stopPropagation(); 
	    });
	    $('.description').perfectScrollbar({
		      wheelSpeed: 20,
		      wheelPropagation: false
		    }); 
    };
    
    $scope.loadCloudTags = function(lessons) {
		var e = $('#tagController');
		var scope2 = angular.element(e).scope();
		if(scope2 != null){
			scope2.cloudTags =[];
			for (var i = 0; i < lessons.length; i++) {
				var tags=lessons[i].tags;
				for(var j = 0; j < tags.length; j++) {
					scope2.cloudTags.push({id:tags[j].id,name:tags[j].name});
			    }
		    }
			if(scope2.$root.$$phase == null){
				scope2.$apply(function(){});
			}
			
			$timeout(function () {
			    var height = $("#tagAffix .ul-height-cal").height();
			    if(height >= 350){
			    	$("#tagAffix .ul-height-cal").css("overflow-y","auto");
			    }else{
			    	$("#tagAffix .ul-height-cal").css("overflow-y","hidden");
			    }
			});
		}//end of if 
    };

    $scope.filterByCount = function() {
    	$scope.limit = lessonShowCount;
    	$scope.categoryId=0;
    	$scope.tagId=0;
    	$scope.start = 0
    	$scope.end = 0;
    	getPopularLessons();
    }
    
    $scope.filterByCategory = function(tab) {
    	$scope.limit = lessonShowCount;
    	$scope.tagId=0;
    	if(tab == 'latest'){
    		getLatestLessons();
    	}else if(tab == 'popular'){
    		getPopularLessons();
    	}
    	var id=$('#inappropriate .tab-pane.active').children().first().attr('id');
    	if(id){
    		if(id=='archivedLessonsController'){
    			getArchivedLessons(id,Inappropriate,'no');
    		}else if(id=='deletedGroupLessonsController'){
    			getArchivedLessons(id,lessonDeletedFromGroup,'no');
    		}if(id=='userDeletedLessonsController'){
    			getArchivedLessons(id,lessonDeletedFromUser,'no');
    		}if(id=='quarantineLessonsController'){
    			getArchivedLessons(id,quarantine,'no');
    		}
    	}
    	
	};
	
	$scope.filterByTag = function(tab) {
		$scope.limit = lessonShowCount;
		$scope.categoryId=0;
		if(tab == 'latest'){
    		getLatestLessons();
    	}else if(tab == 'popular'){
    		getPopularLessons();
    	}else if(tab == 'feature'){
    		featuredLessons();
    	}
		var id=$('#inappropriate .tab-pane.active').children().first().attr('id');
    	if(id){
    		if(id=='archivedLessonsController'){
    			getArchivedLessons(id,Inappropriate,'no');
    		}else if(id=='deletedGroupLessonsController'){
    			getArchivedLessons(id,lessonDeletedFromGroup,'no');
    		}if(id=='userDeletedLessonsController'){
    			getArchivedLessons(id,lessonDeletedFromUser,'no');
    		}if(id=='quarantineLessonsController'){
    			getArchivedLessons(id,quarantine,'no');
    		}
    	}
    	
		
    	
	};
	
	$scope.deleteLesson = function(deleteLessonURL, lessonId){
		AUI().use(
		  		'aui-modal',
		  		function(Y) {
		  			var modal = new Y.Modal(
		  			{
		  				bodyContent: '<p> <Strong>Are you sure you want to remove this lesson?</Strong></p>', centered: true,
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
		  								        url:deleteLessonURL,
		  								        type: 'GET',
		  								        datatype:'html',
		  								        data:{
		  								        	_myStuff_WAR_nyyouportlet_lessonId:lessonId
		  								        },
		  								        success: function(data){
		  								        	$scope.$apply(function(){
		  								        		var json=JSON.parse(data)
		  								        		var lessons=JSON.parse(json.lessons);
		  								        		$scope.lessons=lessons;
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
}]);

lessonsController.directive('myRepeatDirective', function() {
	return function(scope, element, attrs) {
		if (scope.$last){
			var isCurrentLayout  = null;
			try{
				isCurrentLayout = element.closest('.tab-pane .angularContent').hasClass('view-available');
			}catch(err){
				isCurrentLayout = element.parent().parent().hasClass('view-available');
			}
			if(isCurrentLayout || isCurrentLayout == null ){
				scope.loadCloudTags(scope.filteredItems);
				scope.applyScript();
			}
		}
	}
});

lessonsController.directive('myStuffMyLessonsDirective', function() {
	return function(scope, element, attrs) {
		if (scope.$last){
			scope.applyScript();
		}
	}
});

lessonsController.directive('myInsideDirective', function() {
	return function(scope, element, attrs) {
		if (scope.$last){
			element.html("<span>"+scope.category.name+"</span>");
		}
	}
});

AUI().use('node-scroll-info',function(Y){ 
    var body = Y.one('body'); 
    body.plug(Y.Plugin.ScrollInfo); 
    body.scrollInfo.on('scrollToBottom', function(e){
    	// get Angular scope from the known DOM element
    	findScopeAndLoadMore('#lessonsController');
    	findScopeAndLoadMore('#draftAndPublishedLessonsController');
    	findScopeAndLoadMore('#favouriteLessonsController');
    	if($('#userDeletedLessonsController') != null){
    		var nameSpace= $('#userDeletedLessonsController').data('namespace');
    		if($('#'+nameSpace+'userDeleted').hasClass('active')){
    			findScopeAndLoadMore('#userDeletedLessonsController');
    		}else if($('#'+nameSpace+'deletedGroup').hasClass('active')){
    			findScopeAndLoadMore('#deletedGroupLessonsController');
    		}else if($('#'+nameSpace+'inappropriate').hasClass('active')){
    			findScopeAndLoadMore('#archivedLessonsController');
    		}else if($('#'+nameSpace+'quarantine').hasClass('active')){
    			findScopeAndLoadMore('#quarantineLessonsController');
    		}
    	}
    }); 
 });

function findScopeAndLoadMore(id){
	var scope = angular.element($(id)).scope();
	if(scope != null){
	scope.$apply(function() {
	    scope.loadMore();
	});
	}
}
