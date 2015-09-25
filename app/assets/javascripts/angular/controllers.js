CompareApp.controller("CompareController", ['$scope', '$http', function($scope, $http) {

	$scope.loading = true;

	$http.get('/lists')
		.success(function(data) {
			$scope.lists3 = data.lists;

		})
		.error(function(data) {});

	$scope.searchForItems = function() {
		$scope.loading = true;
		// console.log("time to search")
		// 	$http.get('/calls')
		// .success(function(data) {

		// 	$scope.loading = false;
		// 	$scope.lists = data.x;
		// 	$scope.lists2 = data.as;
		// 	$scope.lists3 = data.list;
		// })
		// .error(function(data) {});

		$http.get('/calls/' + $scope.term)
			.success(function(data) {
				$scope.loading = false;
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

	$http.get('/lists')
		.success(function(data) {
			$scope.lists3 = data.lists;

		})
		.error(function(data) {});

	$scope.test = new Date();

}]);

CompareApp.controller("ChartController", ['$scope', '$http', '$routeParams', function($scope, $http, $routeParams) {

	$scope.width = 800;
	$scope.height = 450;
	$scope.yAxis = 'Price';
	$scope.xAxis = '';

	$scope.salesData = [
		// {date: 3,price: 77},
		// {date: 4,price: 70},
		// {date: 5,price: 60},
		// {date: 6,price: 63},
		// {date: 7,price: 55},
		// {date: 8,price: 47},
		// {date: 9,price: 55},
		// {date: 10,price: 30}
	];

	//basically add an additional route that returns the prices for this individual list ,
	//as opposed to returning all the lists
	$scope.id = $routeParams.itemID;
	$http.get('/' + $scope.id + '/calls/')
		.success(function(data) {
			$scope.prices = data.prices;
			console.log($scope.prices)
			$scope.list = data.list;
			console.log($scope.list['image']);
			console.log($scope.list['title']);
			$scope.image = $scope.list['image']
			$scope.title = $scope.list['title']

			//generates an array of objects in order to create a simple price / time chart
			for (var i = 0; i < $scope.prices.length; i++) {
				$scope.salesData.push({
					date: $scope.prices[i].date,
					price: Number($scope.prices[i].price.substring(1))
				})
			}

			$scope.max = 0;

			var arrLength = $scope.salesData.length;
			for (var i = 0; i < arrLength; i++) {
				// Find Maximum X Axis Value
				if (Number($scope.salesData[i].price) > $scope.max)
					$scope.max = Number($scope.salesData[i].price);
			}


			console.log($scope.max)
			console.log("MAXXXXXXX")

			//console.log($scope.salesData)

		})
		.error(function(data) {});

	console.log("it's chart time");

}]);


CompareApp.controller("ShowController", ['$scope', '$http', '$routeParams', '$location', function($scope, $http, $routeParams, $location) {
	console.log("show controller")
	var api = ""
	$scope.id = $routeParams.itemID;
	//console.log(isNaN($routeParams.itemID[0]));

	$scope.addToList = function(title, price, id, email, image, last_price) {
		console.log("ADDING TO LIST _ _ _ _ _ ");

	//basically checks if the id is a number or letter and 
	//if its a letter creates amazon, otherwise ebay item
		if (isNaN(id[0])) {
			console.log("EBAYEBAYEBAY")

			api = "amazon"

		} else {
			console.log("ZONZONZON")

			api = "ebay"

		}

		var date = new Date()
		console.log(date);
		console.log("**********");
		console.log(last_price)

		$http.post('/lists', {
			title: title,
			price: price,
			asin: id,
			email: email,
			date: date,
			image: image,
			last_price: last_price,
			api: api
		})
		$location.path('/watchlist')
	}


	//check what the first character of the ID is
	//for ebay number, for amazon letter


	if (isNaN($routeParams.itemID[0])) {
		$http.get('/lists/' + $scope.id)
			.success(function(data) {
				$scope.price = data.z["ItemLookupResponse"]["Items"]["Item"]["OfferSummary"]["LowestNewPrice"]["FormattedPrice"]
				$scope.item = data.z["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Title"]
				$scope.image = data.z["ItemLookupResponse"]["Items"]["Item"]["SmallImage"]["URL"]
				$scope.desired_price = "$0"
			})
			.error(function(data) {

			});

	} else {
		$http.get('/lists/' + $scope.id)
			.success(function(data) {
				console.log("RESPONSE!!!!!!!")
				console.log(data)


				$scope.price = data.ebay["Item"]["ConvertedCurrentPrice"]["Value"]
				$scope.item = data.ebay["Item"]["Title"]
				$scope.image = data.ebay["Item"]["GalleryURL"]
				$scope.desired_price = "$0"

			})
			.error(function(data) {

			});

		console.log("It's an EBAY ITEM !!!!!!!!!")
	}



}]);