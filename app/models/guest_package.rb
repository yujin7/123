class GuestPackage < ActiveRecord::Base
  belongs_to :package, :foreign_key => 'package_id'
  belongs_to :guest, :foreign_key => 'guest_id'
end
