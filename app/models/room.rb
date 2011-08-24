class Room < ActiveRecord::Base
   attr_accessor :service_ids
  validates :status, :name, :presence => true
  belongs_to :location, :foreign_key => 'location_id'
  has_many :appointments, :dependent => :destroy

  has_many :room_services, :dependent => :destroy
  has_many :services, :through => :room_services


  define_index do
    indexes name, :sortable => true
    indexes capacity, :sortable => true
  end

  def assign_services(service_ids)
    selected_services = !service_ids.to_a.empty? ? Service.find(:all, :conditions => ["id IN (#{service_ids.to_a.uniq.join(', ')})"]) : []
    self.room_services.each do |e_l|
      if selected_services.map{|l| l.id}.include?(e_l.service_id)
        selected_services.delete_if{|sl| sl.id == e_l.service_id}
      else
        self.room_services.delete(e_l)
      end
    end
    self.services << selected_services
  end

end
