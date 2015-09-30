CompareApp.controller("CompareController", ['$scope', '$http', function($scope, $http) {

//set this variable to control css animation spinner
	$scope.loading = false;
	$scope.drops = true;

//loads all list items to be counted in navbar
	$http.get('/lists')
		.success(function(data) {
			$scope.lists3 = data.lists;

		})
		.error(function(data) {});

//searches for an item, make a call to the calls controller
//and returns data from search results
	$scope.searchForItems = function() {
		$scope.loading = true;
		$http.get('/calls/' + $scope.term)
			.success(function(data) {
				$scope.loading = false;
				$scope.drops = false;
				$scope.lists = data.x;
				$scope.lists2 = data.as;
				$scope.lists3 = data.list;
				console.log($scope.lists)
			})
			.error(function(data) {

			});

	}


}]);


CompareApp.controller("WatchController", ['$scope', '$http', function($scope, $http) {

//gets all of the list items in order to display on the watchlist page
	$http.get('/lists')
		.success(function(data) {
			$scope.lists3 = data.lists;

		})
		.error(function(data) {});

	$scope.test = new Date();

}]);

CompareApp.controller("ChartController", ['$scope', '$http', '$routeParams', function($scope, $http, $routeParams) {

//setup for the chart page -> might be cool to put this in a directive!
	$scope.width = 800;
	$scope.height = 450;
	$scope.yAxis = 'Price';
	$scope.xAxis = '';
//storage for chart data
	$scope.priceData = [
	];

//basically add an additional route that returns the prices for this individual list ,
//as opposed to returning all the lists
	$scope.id = $routeParams.itemID;
//route for this lists prices and data in order to display on chart
	$http.get('/' + $scope.id + '/calls/')
		.success(function(data) {
			$scope.prices = data.prices;
			$scope.list = data.list;
			$scope.image = $scope.list['image']
			$scope.title = $scope.list['title']
			$scope.clean = [];

//get the high and low
		for (var i = 0 ; i < $scope.prices.length; i++) {
			$scope.clean.push(Number($scope.prices[i].price.substring(1)))
		}
		$scope.clean = $scope.clean.sort();
		$scope.low = $scope.clean[0];
		$scope.high = $scope.clean[$scope.clean.length-1]

//get the average and push to the database
	$scope.sum = 0;
	for( var i = 0; i < $scope.clean.length; i++ ){
	    $scope.sum += $scope.clean[i]; //don't forget to add the base
	}
	$scope.avg = $scope.sum/$scope.clean.length;

	$http.patch('/lists/'+$scope.id, {
			avg: $scope.avg.toFixed(2),
		})
		.success(function(data) {
			console.log(data)

		})
		.error(function(data) {});
//pushes objects into array for use in the time chart easy iteration
			for (var i = 0; i < $scope.prices.length; i++) {
				$scope.priceData.push({
					date: $scope.prices[i].date,
					price: Number($scope.prices[i].price.substring(1))
				})
			}

			$scope.max = 0;
//gets the max in order to create the chart
			var arrLength = $scope.priceData.length;
			for (var i = 0; i < arrLength; i++) {
// Find Maximum X Axis Value
				if (Number($scope.priceData[i].price) > $scope.max)
					$scope.max = Number($scope.priceData[i].price);
			}


		})
		.error(function(data) {});

	console.log("it's chart time");

}]);


CompareApp.controller("ShowController", ['$scope', '$http', '$routeParams', '$location', function($scope, $http, $routeParams, $location) {
	console.log("show controller")

//gets the store from the url
	$scope.api = $routeParams.api;

//for the new item form
	$scope.id = $routeParams.itemID;

//http post function - call to route
	$scope.addToList = function(title, price, id, email, image, last_price, url, api) {
		console.log("ADDING TO LIST _ _ _ _ _ ");

//gets the api from the route params and itemID from route params
//for storing in the database 

		var date = new Date()
		console.log(date);
		console.log("**********");
		console.log(last_price)

		$http.post('/lists', {
			title: title,
			price: price,
			asin: id,
			asin: email,
			date: date,
			image: image,
			last_price: last_price,
			api: api,
			url:url
		})
		$location.path('/watchlist')
	}

//makes a different call depending on whether its amazon or ebay
	if ($scope.api == "amazon") {
		$http.get('/lists/' + $scope.id + '/' + $scope.api)
			.success(function(data) {
				console.log("RESPONSE!!!!!!!")
				$scope.price = data.z["ItemLookupResponse"]["Items"]["Item"]["OfferSummary"]["LowestNewPrice"]["FormattedPrice"]
				$scope.item = data.z["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Title"]
				$scope.image = data.z["ItemLookupResponse"]["Items"]["Item"]["SmallImage"]["URL"]
				$scope.url = data.z["ItemLookupResponse"]["Items"]["Item"]["ItemLinks"]["ItemLink"][0]["URL"]
				$scope.desired_price = "$0"
			})
			.error(function(data) {

			});

	} else {
		$http.get('/lists/' + $scope.id + '/' + $scope.api)
			.success(function(data) {
				console.log("RESPONSE!!!!!!!")
				console.log(data)


				$scope.price = data.ebay["Item"]["ConvertedCurrentPrice"]["Value"]
				$scope.item = data.ebay["Item"]["Title"]
				$scope.image = data.ebay["Item"]["GalleryURL"]
				$scope.url = data.ebay["Item"]["ViewItemURLForNaturalSearch"]
				$scope.desired_price = "$0"

			})
			.error(function(data) {

			});

		console.log("It's an EBAY ITEM !!!!!!!!!")
	}



}]);