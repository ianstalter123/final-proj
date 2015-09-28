class List < ActiveRecord::Base
	has_many :lprices, dependent: :destroy
 

	  def self.get_am(asin)
		req = Vacuum.new

      	req.configure(
        aws_access_key_id: ENV["AWSKEY"],
        aws_secret_access_key: ENV["AWSSECRET"],
        associate_tag: 'tag'
      	)

      	res = req.item_lookup(
        query: {
          'ItemId' => asin,
          'ResponseGroup' => 'Medium',
      	})

      	@z = res.to_h
      	@z
      end
end
