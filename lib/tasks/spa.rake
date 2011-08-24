namespace :spa do
  desc "Create default permissions"
	task :create_default_permissions => :environment do
    permissions = ['view_appointment', 'create_appointment','update_appointment','delete_appointment','view_guest','create_guest','update_guest','delete_guest']
    for permission in permissions
      if !Permission.exists?(:name => permission)
        Permission.create(:name => permission)
      end
    end
  end
  
end