require 'rails_helper'

describe List do 	
	it {is_expected.to respond_to :title}
	it {is_expected.to respond_to :date}
	it {is_expected.to respond_to :item}
	it {is_expected.to respond_to :email}

describe "when title is blank" do
		it "should not be valid" do
			list = List.create(
				title: "",
				)
			expect(list).to_not be_valid
		end
	end
	describe "when price is blank" do
		it "should not be valid" do
			list = List.create(
				price: "",
				)
			expect(list).to_not be_valid
		end
	end
	describe "when url is blank" do
		it "should not be valid" do
			list = List.create(
				url: "",
				)
			expect(list).to_not be_valid
		end
	end
	describe "when email does not have an @ sign" do
		it "should not be valid" do
			list = List.create(
				email: "someone@gmailcom",
				)
			expect(list).to_not be_valid
		end		
	end

	describe "when get_am is called" do
		it "should return a result" do
			res = List.get_am('B0087Z67VG')
			expect(res["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Title"]) == "CABLES TO GO 6FT HDMI MALE MALE - 4021643"
		end
	end
end