var tagController=ngApp.controller("TagController",["$scope","$rootScope",function($scope,$rootScope) {
	$scope.filterByCloudTag=function(tagId){
		$rootScope.searchPageWise="";
		var e = $('#lessonsController');
		scope = angular.element(e).scope();
	    if(scope != null){
			scope.tagId=tagId;
			if(scope.filterTab=="latest"){
				scope.filterByTag('latest');
			}else if(scope.filterTab=="popular"){
				scope.filterByTag('popular');
			}else if(scope.filterTab=="feature"){
				scope.filterByTag('feature');
			}
		}
		
		e = $('#groupsController');
	    scope = angular.element(e).scope();
	    if(scope != null){
			scope.tagId=tagId;
			scope.filterByTag();		
		}
	};
	/*
	$scope.loadCloudTags = function(collection) {
    	var e = $('#tagController');
    	var scope2 = angular.element(e).scope();
    	scope2.cloudTags =[];
		for (var i = 0; i < collection.length; i++) {
			var tags=collection[i].tags;
			for(var j = 0; j < tags.length; j++) {
				scope2.cloudTags.push({id:tags[j].id,name:tags[j].name});
		    }
        }*/

}]);

