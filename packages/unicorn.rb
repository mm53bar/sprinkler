package :unicorn, :provides => :appserver do
  description 'Unicorn App Server'

  # unicorn should be installed from your app's Gemfile so there is nothing to do here

  requires :upstream_configuration, :enable_site, :restart_nginx
end

package :upstream_configuration do
  description "Nginx as Reverse Proxy Configuration for Unicorn"
  requires :nginx
  
  config_file = "/usr/local/nginx/sites-available/#{APP_NAME}"
  config_template = ERB.new(File.read(File.join(File.join(File.dirname(__FILE__), '..', 'assets'), 'unicorn.conf.erb'))).result
  
  # if config_file exists then remove it
  runner "[[ -e #{config_file} ]] && rm #{config_file}"
  push_text config_template, config_file

  verify do
    has_file config_file
    file_contains config_file, "*.#{HOST};"
    file_contains config_file, "rewrite ^ http://#{HOST}$request_uri?;"
  end
end

package :enable_site do
  description "Symlink vhost file into sites_enabled"
  requires :upstream_configuration

  config_file = "/usr/local/nginx/sites-available/#{APP_NAME}"
  symlink_file = "/usr/local/nginx/sites-enabled/#{APP_NAME}"

  runner "ln -s #{config_file} #{symlink_file}"

  verify do
    has_symlink symlink_file
  end
end
    
package :restart_nginx do
  runner '/etc/init.d/nginx restart'
end
