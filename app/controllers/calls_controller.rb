class CallsController < ApplicationController

  #seperate the get functionality into a different
  #controller
  #get the search working correctly with input item
  #limit the number of items returned on search


  require 'vacuum'

  # GET /calls
  # GET /lists.json
  def index
    
    @list = List.all
    req = Vacuum.new

    #add file to store secret passwords to git ignore etc
    #integrate these functions into the models for calls and lists
    #rename things so they are better
    
    req.configure(
        aws_access_key_id: ENV["AWSKEY"],
        aws_secret_access_key: ENV["AWSSECRET"],
      associate_tag: 'tag'
    )

    res = req.item_search(
      query: {
        'Keywords' => 'ipad',
        'SearchIndex' => 'Electronics',
        #'ResponseGroup' => 'Images',
        #'ResponseGroup' => 'Offers',
        'ResponseGroup' => 'Medium',
        #'Sort' => '-price',
        'Availability' => 'Available'
      }
    )
    @z = res.to_h

    @as = @z["ItemSearchResponse"]["Items"]["Item"]
    #binding.pry
    @x = Typhoeus.get("http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SECURITY-APPNAME=" + ENV["APPID"] + "&keywords=ipad&RESPONSE-DATA-FORMAT=JSON&limit=13", followlocation: true)
    @x = JSON.parse(@x.body)
    @x = @x["findItemsByKeywordsResponse"][0]["searchResult"][0]['item']
    render :json => {
      :x => @x,
      :as => @as,
      :list => @list
    }

  end

  def charts

      id = params[:id]
      @list = List.find(id)

      render :json => {
      :prices => @list.lprices,
      :list => @list

    }

  end

  def results
     search_term = params[:title]
     search_term1 = URI.encode(search_term)
     #binding.pry
        @list = List.all
    req = Vacuum.new

    req.configure(
        aws_access_key_id: ENV["AWSKEY"],
        aws_secret_access_key: ENV["AWSSECRET"],
      associate_tag: 'tag'
    )

    res = req.item_search(
      query: {
        'Keywords' => search_term,
        'SearchIndex' => 'Electronics',
        #'ResponseGroup' => 'Images',
        #'ResponseGroup' => 'Offers',
        'ResponseGroup' => 'Medium',
        #'Sort' => '-price',
        'Availability' => 'Available'
      }
    )
    @z = res.to_h

    @as = @z["ItemSearchResponse"]["Items"]["Item"]
    #binding.pry
    @x = Typhoeus.get("http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SECURITY-APPNAME=" + ENV["APPID"] + "&keywords=" + search_term1 + "&RESPONSE-DATA-FORMAT=JSON&limit=13", followlocation: true)
    @x = JSON.parse(@x.body)
    @x = @x["findItemsByKeywordsResponse"][0]["searchResult"][0]['item']
    render :json => {
      :x => @x,
      :as => @as,
      :list => @list
    }

  end

  # GET /lists/1
  # GET /lists/1.json
  #used to retrieve values of one item

end
