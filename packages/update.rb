package :update, :provides => :system_update do
  description "System Update"
  
  requires :apt_update, :apt_upgrade
end

package :apt_update do
  runner 'apt-get update'
end

package :apt_upgrade do
  runner 'apt-get -y full-upgrade'
end
