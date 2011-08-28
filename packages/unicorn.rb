package :unicorn, :provides => :appserver do
  description 'Unicorn App Server'

  # unicorn should be installed from your app's Gemfile so there is nothing to do here

  optional :upstream_configuration
end

package :upstream_configuration do
  description "Nginx as Reverse Proxy Configuration for Unicorn"
  requires :nginx
  
  config_file = '/etc/nginx/sites-available/filter'
  symlink_file = '/etc/nginx/sites-enabled/filter'
  config_template = `cat #{File.join(File.dirname(__FILE__), '..', 'assets', 'unicorn.conf')}`
  
  push_text config_template, config_file
  runner "ln -s #{config_file} #{symlink_file}"
  runner '/etc/init.d/nginx start'

  verify do
    has_file config_file
    has_symlink symlink_file
  end
end
