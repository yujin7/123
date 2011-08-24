class PackageService < ActiveRecord::Base
  belongs_to :service, :foreign_key => 'service_id'
  belongs_to :package, :foreign_key => 'package_id'

  scope :all_service, lambda { |id|
    where("package_id = #{id}")
  }
end
