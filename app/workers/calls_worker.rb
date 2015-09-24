class CallsWorker
  require 'vacuum'
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely(10) }
  def perform()
    req = Vacuum.new

    req.configure(
      aws_access_key_id: ENV["AWSKEY"],
      aws_secret_access_key: ENV["AWSSECRET"],
      associate_tag: 'tag'
    )


    @wlist = List.all
    #binding.pry


    #searches for each item in the watchlist,
    #makes an api call to see what the current amazon price is

    @wlist.each do |item|

      #basically need to add a check to see if the item is
      #ebay or amazon, and if it is ebay do an ebay lookup for price
      #otherwise do an amazon lookup for price. done
      #can check this by relying on the api column (when its filled)
      #note - also add some kind of a display on the pricelist page showing
      #if its ebay / amazon (per item) and fix the $ issue on ebay items
      # if item.api == "ebay"
      #   # binding.pry
      #   # binding.pry
      #   # binding.pry

      #   @changing = List.find(item["id"].to_s)

      #   @x = Typhoeus.get("http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=1983b0454-8450-491a-93b7-f7481f1c1fe&siteid=0&version=515&ItemID=" + item["id"], followlocation: true)
      #   @x = JSON.parse(@x.body)


      #   #compares the amazon price to the current list price and if they are not equal
      #   #sends and email showing the two different prices (hopefully)
      #   #also sets the last check to be the old price, and the the new price to be the API return price
      #   # could improve this by implementing functionality to show if the result is bigger or smaller.
      #   p "EBAY PRICE CHECK DADADADADDAAAA"
      #   p "OLD PRICE EBAY:::"
      #   p @changing.price
      #   p "NEW PRICE:::"
      #   am_price = @x["Item"]["ConvertedCurrentPrice"]["Value"]
      #   p am_price
      #   time2 = Time.now


      #   if @changing.price != am_price
      #     PriceCheck.update_price(@changing, am_price).deliver_now
      #     #not working for some reason - need to show the last check / price
      #     @changing.lprices.create(date:time2,price:am_price)
      #     @changing.update(last_check: @changing.price)
      #     @changing.update(price: am_price)
      #   end




      # else

        res = req.item_lookup(
          query: {
            'ItemId' => item["asin"],
            #'SearchIndex' => 'Electronics',
            'ResponseGroup' => 'ItemAttributes',
            'ResponseGroup' => 'OfferSummary',
            #'ResponseGroup' => 'Medium',
            #'Sort' => '-price',
            #'Availability' => 'Available'
        })

        @z = res.to_h


        @changing = List.find(item["id"])

        #compares the amazon price to the current list price and if they are not equal
        #sends and email showing the two different prices (hopefully)
        #also sets the last check to be the old price, and the the new price to be the API return price
        # could improve this by implementing functionality to show if the result is bigger or smaller.
        p "OLD PRICE:::"
        p @changing.price
        p "NEW PRICE:::"
        p @z["ItemLookupResponse"]["Items"]["Item"]["OfferSummary"]["LowestNewPrice"]["FormattedPrice"]
        time2 = Time.now


        if @changing.price != @z["ItemLookupResponse"]["Items"]["Item"]["OfferSummary"]["LowestNewPrice"]["FormattedPrice"]
          #PriceCheck.update_price(@changing, @z["ItemLookupResponse"]["Items"]["Item"]["OfferSummary"]["LowestNewPrice"]["FormattedPrice"]).deliver_now
          #not working for some reason - need to show the last check / price
          @changing.lprices.create(date:time2,price:@z["ItemLookupResponse"]["Items"]["Item"]["OfferSummary"]["LowestNewPrice"]["FormattedPrice"])
          @changing.update(last_check: @changing.price)
          @changing.update(price: @z["ItemLookupResponse"]["Items"]["Item"]["OfferSummary"]["LowestNewPrice"]["FormattedPrice"])

          #time2 = Time.now


        end
      end
      #binding.pry


      p "**************"
      p "**************"
      p "**************"
      p "**************"
      p "**************"
      p "OLD PRICE:::"
      p @changing.price
      p "NEW PRICE:::"
      p @z["ItemLookupResponse"]["Items"]["Item"]["OfferSummary"]["LowestNewPrice"]["FormattedPrice"]
      #binding.pry
      p "create watch1"
      # List.create(title: @z["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Title"], price: author, date: title)
      #List.create(title:"MBA" , price: @z["ItemLookupResponse"]["Items"]["Item"]["OfferSummary"]["LowestNewPrice"]["FormattedPrice"], date: Time.now, asin:@id)


   


  end
end
