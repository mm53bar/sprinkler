package :unicorn, :provides => :appserver do
  description 'Unicorn App Server'

  # unicorn should be installed from your app's Gemfile so there is nothing to do here

  optional :unicorn_configuration, :upstream_configuration
end

package :unicorn_configuration do
  description "Nginx as Reverse Proxy Configuration for Unicorn"
  config_file = '/var/nginx/unicorn.conf'
  config_template = `cat #{File.join(File.dirname(__FILE__), '..', 'assets', 'unicorn.conf')}`
  
  push_text config_template, config_file, :sudo => true do
    pre :install, 'mkdir -p /var/nginx/'
  end

  verify do
    has_file config_file
  end
end

package :upstream_configuration do
  description "Load Unicorn cluster configuration in Nginx configuration file"
  requires :nginx
  config_file = '/etc/nginx/nginx.conf'

  push_text 'include /var/nginx/unicorn.conf;', config_file, :sudo => true do
    post :install, 'rm /etc/nginx/sites-available/default'
  end

  verify do
    file_contains config_file, "include /var/nginx/unicorn.conf"
  end
end