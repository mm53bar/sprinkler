package :filter, :provides => :app do
  description "Finalize settings for the app"

  requires :app_dir, :known_hosts
end

package :app_dir do
  description 'Create the application directory'
  runner "mkdir -p /var/applications/filter"
  runner "chown '#{DEPLOY_USER}' /var/applications/filter"
  
  verify do
    has_directory '/var/applications/filter'
  end
end

package :known_hosts do
  description "Add codebase to known_hosts so that capistrano doesn't prompt for it"
  
  runner "sudo -u #{DEPLOY_USER} -i -- 'ssh-keyscan codebasehq.com >> ~/.ssh/known_hosts'"
  
  verify do
    file_contains '/home/deploy/.ssh/known_hosts', 'codebasehq.com'
  end
end
