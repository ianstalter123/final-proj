CompareApp.controller("CompareController", ['$scope', '$http', function($scope, $http) {

	//how much of this could i put in services
	//set this variable to control css animation spinner
	$scope.loading = false;
	$scope.drops = true;

	//loads all list items to be counted in navbar
	$http.get('/lists')
		.success(function(data) {
			$scope.lists3 = data.lists;
			$scope.trending = [];
			for (var i = 0; i < $scope.lists3.length - 1; i++) {

				//check if the price is below average, if so
				//push item into trending array

				$scope.drop = $scope.lists3[i].avg - Number($scope.lists3[i].price.substring(1))
				if ($scope.drop > 0) {
					$scope.trending.push($scope.lists3[i].title + "      current price: " +
						$scope.lists3[i].price + ", $" + $scope.drop.toFixed(2) + " below average")
				} else {
					$scope.trending.push($scope.lists3[i].title + "  current price: " +
						$scope.lists3[i].price + " , $" + Math.abs($scope.drop.toFixed(2)) + " above average")

				}

			}

		})
		.error(function(data) {});

	//searches for an item, make a call to the calls controller
	//and returns data from search results



	$scope.searchForItems = function() {
		if ($scope.term !== undefined) {

			$scope.error = false;
			$scope.loading = true;
			$http.get('/calls/' + $scope.term)
				.success(function(data) {
					$scope.loading = false;
					$scope.drops = false;
					$scope.lists = data.x;
					$scope.lists2 = data.as;
					$scope.lists3 = data.list;

				})
				.error(function(data) {

				});
		} else {

			$scope.error = true;
		}

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

CompareApp.controller("ChartController", ['$scope', '$http', '$routeParams', '$window', function($scope, $http, $routeParams, $window) {

	//setup for the chart page -> might be cool to put this in a directive!

	$scope.changeChartType = function(chartType) {
		$scope.chart.options.data[0].type = chartType;
		$scope.chart.render(); //re-render the chart to display the new layout
	}

	$scope.width = 800;
	$scope.height = 450;
	$scope.yAxis = 'Price';
	$scope.xAxis = '';
	//storage for chart data
	$scope.priceData = [];

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

			$scope.prices = $scope.prices.sort(function(a, b) {
				return new Date(b.date) - new Date(a.date);
			});



			for (var i = 0; i < $scope.prices.length; i++) {
				$scope.priceData.push({
					x: new Date($scope.prices[i].date).getTime(),
					y: Number($scope.prices[i].price.substring(1))
				})
			}

			//gets the min in order to create the chart
			var tmp = 0;
			$scope.min = 99999;
			var arrLength = $scope.priceData.length;
			for (var i = arrLength - 1; i >= 0; i--) {
				tmp = $scope.priceData[i].y;

				if (tmp < $scope.min) $scope.min = tmp;
				console.log($scope.min)
			}
			//get the high and low
			for (var i = 0; i < $scope.prices.length; i++) {
				$scope.clean.push(Number($scope.prices[i].price.substring(1)))
			}
			$scope.clean = $scope.clean.sort();
			$scope.low = $scope.clean[0];
			$scope.high = $scope.clean[$scope.clean.length - 1]

			//get the average and push to the database
			$scope.sum = 0;
			for (var i = 0; i < $scope.clean.length; i++) {
				$scope.sum += $scope.clean[i]; //don't forget to add the base
			}
			$scope.avg = $scope.sum / $scope.clean.length;



			$scope.chart = new CanvasJS.Chart("chartContainer", {
				animationEnabled: true,
				zoomEnabled: true,
				theme: 'theme1',
				title: {
					text: $scope.title
				},
				axisY: {
					minimum: $scope.min,
					label: "Price",
					valueFormatString: "#,##0.##", // move comma to change formatting
					prefix: "$",
					labelFontSize: 16,
					gridThickness: 0,
					stripLines: [{

						startValue: $scope.avg,
						endValue: $scope.avg,
						color: "#d8d8d8",
						label: "Average",
						labelFontColor: "#a8a8a8"
					}]
				},
				axisX: {
					labelFontSize: 16,
					gridThickness: 0

				},
				data: [{
					toolTipContent: "{x}: ${y} ",
					type: "splineArea",
					xValueType: "dateTime",
					dataPoints: $scope.priceData

				}]
			});
			$scope.chart.render();



			$http.patch('/lists/' + $scope.id, {
					avg: $scope.avg.toFixed(2),
				})
				.success(function(data) {
					console.log(data)


				})
				.error(function(data) {});

		})
		.error(function(data) {});

	console.log("it's chart time");

}]);


CompareApp.controller("ShowController", ['$scope', '$http', '$routeParams', '$location', function($scope, $http, $routeParams, $location) {
	console.log("show controller")

	$scope.error1 = false;
	//gets the store from the url
	$scope.api = $routeParams.api;

	$scope.drops = false;

	//for the new item form
	$scope.id = $routeParams.itemID;

	//http post function - call to route
	$scope.addToList = function(title, price, id, email, image, last_price, url, api) {
		console.log("ADDING TO LIST _ _ _ _ _ ");

		//gets the api from the route params and itemID from route params
		//for storing in the database 
		if (email !== undefined && last_price !== undefined) {
			$scope.error1 = false;
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
				api: api,
				url: url
			})
			$location.path('/watchlist')
		} else {
			console.log("make sure your fields are filled out!")
			$scope.error1 = true;
		}
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