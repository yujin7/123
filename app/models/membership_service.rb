class MembershipService < ActiveRecord::Base
  belongs_to :service, :foreign_key => 'service_id'
  belongs_to :membership, :foreign_key => 'membership_id'

end
