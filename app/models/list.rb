class List < ActiveRecord::Base
	has_many :lprices, dependent: :destroy
end
