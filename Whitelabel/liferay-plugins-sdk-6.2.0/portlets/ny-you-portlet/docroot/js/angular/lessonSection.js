var lessonSectionController=ngApp.controller("lessonSectionController",["$scope", "$interpolate", "$compile", "$filter", function($scope, $interpolate, $compile, $filter) {
	$scope.clearSearch = function(){
		$scope.searchuserGroup = '';
		$scope.searchuser = '';
	}
	
	$scope.showCorrectFormat = function(exts) {
	   	return function(resource) {
	    	  return exts.indexOf(resource.extension.toLowerCase())>=0;
	    }
	}
}]);

lessonSectionController.directive('lessonSectionSingleDirective',['$compile',function($compile) {
	return {
	    restrict: 'A',
	    replace: true,
	    link: function(scope, element, attrs) {
		var id = '';
		var type = element.data('type');
		if(type == 'UserGroup'){
			id = scope.object.userGroupId
		}else{
			id = scope.object.userId
		}
		if(scope.object.ischecked == 'true'){
			if(!($('#groupAndInvitation #preview'+type+'List ul li').hasClass(id+'-class'))){
				 $('#groupAndInvitation #preview'+type+'List ul').append("<li class='textboxlistentry "+id+"-class'>"+scope.object.name+"&nbsp;<i onclick='removeSelection("+id+",\""+type+"\")' style='color:#d21212;cursor:pointer' class='icon icon-remove'></i></li>")
			}
		}
		element.on('change',function(){
			var uniId = element.val()+"-class";
			var uniType = element.data('type');
			if (scope.object.ischecked == 'true'){
				scope.object.ischecked = 'false';
				if($('#groupAndInvitation #preview'+uniType+'List ul li').hasClass(uniId)){
					 $("#groupAndInvitation #preview"+uniType+"List ul li."+uniId).remove();	
				}
			}else{
				scope.object.ischecked = 'true';
				if(scope.object.ischecked == 'true'){
					$('#groupAndInvitation #preview'+uniType+'List ul').append("<li class='textboxlistentry "+element.val()+"-class'>"+scope.object.name+"&nbsp;<i onclick='removeSelection("+element.val()+",\""+uniType+"\")' style='color:#d21212;cursor:pointer' class='icon icon-remove'></i></li>")
				}
			}
		});
	}
}
}]);


lessonSectionController.directive('unsacpeDirective', function() {
	return function(scope, element, attrs) {
		var documentName=unescape(unescape(unescape(scope.resourceMediaData.documentName)));
		$(element).find('.resourceUnescape').remove();
		$(element).find('p.span8 .span11').append(documentName)
		
	}
});


function removeSelection(id,type){
	var scope = angular.element($('#groupAndInvitation')).scope();
	scope.$apply(function() {
		scope.searchuserGroup = '';
		scope.searchuser = '';
		if(type == 'UserGroup'){
			$.each(scope.userGroupArray, function() {
			    if (this.userGroupId == id) {
			        this.ischecked = "false";
			    }
			});
		}else{
			$.each(scope.userArray, function() {
			    if (this.userId == id) {
			        this.ischecked = "false";
			    }
			});
		}
	});
	$('#groupAndInvitation .'+type).find("input[value='"+id+"']").attr("checked",false);
	$("#groupAndInvitation #preview"+type+"List ul li."+id+"-class").remove();
}