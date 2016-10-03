var groupsController=ngApp.controller("GroupsController",["$scope","$timeout","$interpolate", "$compile", "$filter", function($scope,$timeout,$interpolate, $compile, $filter) {
	var groupShowCount = 15;
	//var filterBy = $filter("filter");
	
    $scope.load = function() {
    	$scope.categoryId = 0;
    	$scope.tagId = 0;
    	$scope.limit = groupShowCount;
    };
    
    $scope.loadMore = function() {
    	$scope.limit += groupShowCount;
    };
    
    $scope.loadCloudTags = function(groups) {
    	var e = $('#tagController');
    	var scope2 = angular.element(e).scope();
    	if(scope2 != null){
	    	scope2.cloudTags =[];
			for (var i = 0; i < groups.length; i++) {
				var tags=groups[i].tags;
				for(var j = 0; j < tags.length; j++) {
					scope2.cloudTags.push({id:tags[j].id,name:tags[j].name});
			    }
	        }
    	}
    	$timeout(function () {
		    var height = $("#tagAffix .ul-height-cal").height();
		    if(height >= 350){
		    	$("#tagAffix .ul-height-cal").css("overflow-y","auto");
		    }else{
		    	$("#tagAffix .ul-height-cal").css("overflow-y","hidden");
		    }
		});
    };
	
    
    $scope.deleteGroup=function(deleteUrl,groupURL){
    	AUI().use(
    	  		'aui-modal',
    	  		function(Y) {
    	  			var modal = new Y.Modal(
    	  			{
    	  				bodyContent: '<p> <Strong>Are you sure you want to remove this group?</Strong></p>', centered: true,
    	  				headerContent: null, 
    	  				modal: true,
    	  				render: '#group',
    	  				width: 350,
    	  				zIndex: 999,
    	  				resizable: false,
    	  				toolbars: {
    	  					footer: [
    	  					{
    	  						label: 'Yes',
    	  						on: {
    	  							click: function() {
    	  								//location.href = deleteUrl;
    	  								$.ajax({
    	  									url: deleteUrl,
    	  									dataType: 'html',
    	  									processData: false,
    	  									contentType: false,
    	  									type: 'POST',
    	  									success: function(data){
    	  										modal.hide();
    	  										if($("#all-groups").length > 0){
    	  											$("#groupResults").empty();
    	  											$("#all-groups").html(data);
    	  										}
    	  										else{
    	  											window.location.href=groupURL;
    	  										}
    	  									}
    	  								});
    	  							}
    	  					}
    	  					},
    	  					{
    	  						label: 'Cancel',
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
    
    $scope.deleteAnnouncement=function(entryId,deleteURL){
    	AUI().use(
    	  		'aui-modal',
    	  		function(Y) {
    	  			var modal = new Y.Modal(
    	  			{
    	  				bodyContent: '<p> <Strong>Are you sure you want to remove this Announcement?</Strong></p>', 
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
    	  								    url:deleteURL,
    	  								    type: 'GET',
    	  								    datatype:'html',
    	  								    data:{
    	  								    	_group_WAR_nyyouportlet_entryId:entryId,
    	  								    },
    	  								    success: function(data){	
    	  								    	$scope.$apply(function(){
    	  								    		$scope.groupAnnouncements=JSON.parse(data);
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
    
   
    
    $scope.createEditGroup=function(url, windowTitle){
    	Liferay.Util.openWindow(
    			{
    				dialog: {
    					width: 600,
    					height:740,
    					align: Liferay.Util.Window.ALIGN_CENTER,
    					cache: false,
    					modal: true
    				},
    				
    				title: windowTitle,
    				id: 'createGroup',				
    				uri:url
    			}
    		);
    };
    
    $scope.subscriber=function(subscriberURL,groupId,groupPrivacy,isOwner,namespace1)    {
    	var groupPriv=groupPrivacy+"";
    	var isOwn=isOwner+"";
    	var subsData=$(".group-"+groupId).data('sub');
    	var groupIdVariable=namespace1+"groupId";
    	var subsDataVariable=namespace1+"subsData";
    	var joinUrl=subscriberURL+'&'+groupIdVariable+'='+groupId+'&'+subsDataVariable+'='+subsData;
    	$.ajax({
            url:joinUrl,
            type: 'GET',
            datatype:'html',
            data:{
            	
            },
            success: function(data){
            	if(subsData.indexOf('requestJoin')>=0)
    	        	{
            		$(".group-"+groupId).html("Unrequest");
            		$(".group-"+groupId).removeClass('btn-info');
            		$(".group-"+groupId).addClass('btn-primary');
            		$(".group-"+groupId).data('sub','unrequest');
    	        	}
            	else if(subsData.indexOf('unrequest')>=0)
    	        	{
            		$(".group-"+groupId).html("Request to join");
            		$(".group-"+groupId).removeClass('btn-primary');
            		$(".group-"+groupId).addClass('btn-info');
            		$(".group-"+groupId).data('sub','requestJoin');
    	        	}
            	else if(subsData.indexOf('unsubscribe')>=0)
            		{
            		if(groupPriv.indexOf('true')>=0 && (!(isOwn.indexOf('true')>=0))){
            			$(".group-"+groupId).html("Request to join");
                		$(".group-"+groupId).removeClass('btn-primary');
                		$(".group-"+groupId).addClass('btn-info');
                		$(".group-"+groupId).data('sub','requestJoin');
            		}else{
    	        		$(".group-"+groupId).html("Join");
    					$(".group-"+groupId).addClass('btn-warning');
    					$(".group-"+groupId).data('sub','subscribe');
            		}
            		}
            	else{            		
    	        		$(".group-"+groupId).html("Leave");
    	        		$(".group-"+groupId).removeClass('btn-warning');
    	        		$(".group-"+groupId).data('sub','unsubscribe');
    	        	}
             }
            
          });
    		
    };
    
   
    	   
    $scope.filterByCategory=function(){
    	$scope.limit = groupShowCount;
	};
	
    $scope.filterByTag=function(){
    	$scope.limit = groupShowCount;
	};
}]);

groupsController.directive('myGroupRepeatDirective', function() {
	return function(scope, element, attrs) {
		if(scope.group.authorId == scope.group.userID){
			$(element).find('.showOrHide').remove();
			if($(element).find('.mobile-quick-menu') != null){
				$(element).find('.mobile-quick-menu').on('click',function(event){
					event.preventDefault(); 				
					if($(this).prev().css('display') != 'block'){
					 	$('.open-action').fadeOut().removeClass('open-action');
					 	$(this).prev().addClass('open-action').fadeIn();
					} 
					else { $('.open-action').fadeOut().removeClass('open-action'); }  
				});
			}
		}else{
			$(element).find('.showOrHide-manage').remove();
			$(element).find('.mobile-quick-menu').on('click',function(event){
				event.preventDefault(); 				
				if($(this).prev().css('display') != 'block'){
				 	$('.open-action').fadeOut().removeClass('open-action');
				 	$(this).prev().addClass('open-action').fadeIn();
				} 
				else { $('.open-action').fadeOut().removeClass('open-action'); }  
			});
		}
		
		if (scope.$last){
			
			scope.loadCloudTags(scope.filteredItems);
			// On click   
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
		}
	}
});
groupsController.directive('myInsideDirective', function() {
	return function(scope, element, attrs) {
		if (scope.$last){
			element.html("<span>"+scope.category.name+"</span>");
		}
	}
});

groupsController.directive('textToHtmlConverter', function() {
	return function(scope, element, attrs) {
			element.html(scope.announcement.content);
	}
});


AUI().use('node-scroll-info',function(Y){ 
    var body = Y.one('body'); 
    body.plug(Y.Plugin.ScrollInfo); 
    body.scrollInfo.on('scrollToBottom', function(e){
    	// get Angular scope from the known DOM element
    	e = $('#groupsController');
    	scope = angular.element(e).scope();
    	// update the model with a wrap in $apply(fn) which will refresh the view for us
    	if(scope != null){
	    	scope.$apply(function() {
	    	    scope.loadMore();
	    	}); 
    	}
    	
    }); 
 });


