class Equipment < ActiveRecord::Base
  #  set_table_name('equipment')
  validates :name, :uniqueness => true
  validates :name, :total_number, :no_out_of_service, :status, :code_number, :presence => true
  define_index do
    indexes name, :sortable => true
    #    indexes location, :sortable => true
  end
  belongs_to :location, :foreign_key => 'location_id'
  has_many :location_equipments, :dependent => :destroy

  has_many :equipments_services, :dependent => :destroy
  has_many :services, :through => :equipments_services
end
