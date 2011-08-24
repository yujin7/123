class Taxtype < ActiveRecord::Base
  validates :name, :rate,  :status, :presence => true
  validates :name, :uniqueness => true
  define_index do
    indexes name, :sortable => true
    indexes rate, :sortable => true
    indexes status, :sortable => true
    #    indexes location, :sortable => true
  end
  scope :active, where("status != 'Deleted'")
  scope :deleted, where("status = 'Deleted'")
end
