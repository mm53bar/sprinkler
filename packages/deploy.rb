package :deploy, :provides => :deployer do
  description 'Create deploy user'
  
  requires :create_deploy_user
end

package :create_deploy_user do
  description "Create the deploy user"
  
  runner "useradd --create-home --shell /bin/bash --user-group --groups users,sudo #{DEPLOY_USER}"
  runner "echo '#{DEPLOY_USER}:#{DEPLOY_USER_PASSWORD}' | chpasswd"
  
  verify do
    has_directory "/home/#{DEPLOY_USER}"
  end
end
