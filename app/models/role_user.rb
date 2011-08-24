class RoleUser < ActiveRecord::Base
  belongs_to :role, :foreign_key => 'role_id'
  belongs_to :user, :foreign_key => 'user_id'
end
