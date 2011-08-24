class GiftVoucher < ActiveRecord::Base
  has_many :payments
end
