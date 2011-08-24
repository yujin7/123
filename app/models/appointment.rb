class Appointment < ActiveRecord::Base
  require 'country_select'
  validates :guest_id, :customer_height_before, :customer_weight_before, :special_requests,  :comments, :presence => true
  belongs_to :guest, :foreign_key => 'guest_id'
  belongs_to :service
  belongs_to :package
  belongs_to :employee
  belongs_to :room
  has_many :appointment_payments

  scope :recent_by_guest, lambda{|guest_id, limit|
    {
      :conditions => "guest_id = #{guest_id}",
      :order => "updated_at DESC",
      :limit => limit
    }
  }

  def booking_id
    return "A#{self.id}"
  end
end
