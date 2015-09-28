var CompareApp = angular.module("CompareApp", ['angularMoment','ngRoute','720kb.tooltips']);

CompareApp.run(["amMoment", function(amMoment) {
    amMoment.changeLocale('en-gb');
}]);


CompareApp.config(['$httpProvider','$routeProvider', function($httpProvider,$routeProvider) {
  
  $httpProvider.defaults.headers.common['X-CSRF-Token'] =
    $('meta[name=csrf-token]').attr('content');

    $routeProvider
      .when('/', {
        templateUrl: '/partials/home.html',
        controller: 'CompareController'
      })

      .when('/new/:itemID/:api/', {
        templateUrl: '/partials/new.html',
        controller: 'ShowController'
      })
      .when('/charts/:itemID/', {
        templateUrl: '/partials/charts.html',
        controller: 'ChartController'
      })
      // .when('/signup', {
      //   templateUrl: '/assets/angular/partials/signup.html',
      //   controller: 'CompareController'
      // })
      // .when('/login', {
      //   templateUrl: '/assets/angular/partials/login.html',
      //   controller: 'CompareController'
      // })
      .when('/watchlist', {
        templateUrl: '/partials/watchlist.html',
        controller: 'WatchController'
      })
      .otherwise({
      	templateUrl: '/partials/home.html',
    template: "This route isn't set!"
 	 });
}]);

CompareApp.directive('testSpot', function() {
  return {
    template: '<h1>test spot</h1>',
    // scope: {
    //   pokemon: "=pokemonData" 
    // }
  
  };
});

