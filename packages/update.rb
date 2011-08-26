package :update, :provides => :system_update do
  description "System Update"
  
  requires :apt_update, :apt_upgrade
end

package :apt_update do
  runner 'aptitude update'
end

package :apt_upgrade do
  runner 'aptitude -y full-upgrade'
end
