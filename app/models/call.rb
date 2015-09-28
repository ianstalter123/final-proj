class Call < ActiveRecord::Base

	def self.get_items(title)
		search_term = title
     	search_term1 = URI.encode(search_term)
  
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
        'ResponseGroup' => 'Medium',
        'Availability' => 'Available'
      	}
    	)
    	@z = res.to_h
    	@as = @z["ItemSearchResponse"]["Items"]["Item"]
    	@x = Typhoeus.get("http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SECURITY-APPNAME=" + ENV["APPID"] + "&keywords=" + search_term1 + "&RESPONSE-DATA-FORMAT=JSON&limit=13", followlocation: true)
    	@x = JSON.parse(@x.body)
    	@x = @x["findItemsByKeywordsResponse"][0]["searchResult"][0]['item']

    	[@as,@x]
	end

	
end
