class GuestNote < ActiveRecord::Base
  validates :note, :presence => true

  belongs_to :guest
  belongs_to :user
end
