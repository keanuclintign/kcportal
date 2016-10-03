var userStatsController=ngApp.controller("userStatsController", function($scope, $interpolate, $compile, $filter) {

	$scope.itemsPerPage = 6;
	$scope.currentMonth_currentPage=0;
	$scope.currentMonth_items = [];

	$scope.currentMonth_PrevPage = function() {
		if ($scope.currentMonth_currentPage > 0) {
			$scope.currentMonth_currentPage--;
		}
	};

	$scope.currentMonth_PrevPageDisabled = function() {
		return $scope.currentMonth_currentPage === 0 ? "disabled" : "";
	};

	$scope.currentMonth_pageCount = function() {
		return Math.ceil($scope.currentMonth_items.length/$scope.itemsPerPage)-1;
	};

	$scope.currentMonth_nextPage = function() {
		if ($scope.currentMonth_currentPage < $scope.currentMonth_pageCount()) {
			$scope.currentMonth_currentPage++;
		}
	};

	$scope.currentMonth_nextPageDisabled = function() {
		return $scope.currentMonth_currentPage === $scope.currentMonth_pageCount() ? "disabled" : "";
	};

	$scope.setPage = function(n) {
		$scope.currentMonth_currentPage = n;
	};



	$scope.previousMonth_previousPage=0;
	$scope.previousMonth_items = [];

	$scope.previousMonth_PrevPage = function() {
		if ($scope.previousMonth_previousPage > 0) {
			$scope.previousMonth_previousPage--;
		}
	};

	$scope.previousMonth_PrevPageDisabled = function() {
		return $scope.previousMonth_previousPage === 0 ? "disabled" : "";
	};

	$scope.previousMonth_pageCount = function() {
		return Math.ceil($scope.previousMonth_items.length/$scope.itemsPerPage)-1;
	};

	$scope.previousMonth_nextPage = function() {
		if ($scope.previousMonth_previousPage < $scope.previousMonth_pageCount()) {
			$scope.previousMonth_previousPage++;
		}
	};

	$scope.previousMonth_nextPageDisabled = function() {
		return $scope.previousMonth_previousPage === $scope.previousMonth_pageCount() ? "disabled" : "";
	};

	$scope.setPage = function(n) {
		$scope.previousMonth_previousPage = n;
	};
});

userStatsController.filter('offset', function() {
	return function(input, start) {
		if(input !== undefined){
			start = parseInt(start, 10);
			return input.slice(start);
		}
	};
});
