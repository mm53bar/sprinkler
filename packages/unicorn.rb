package :unicorn, :provides => :appserver do
  description 'Unicorn App Server'

  # unicorn should be installed from your app's Gemfile so there is nothing to do here

  optional :upstream_configuration
end

package :upstream_configuration do
  description "Nginx as Reverse Proxy Configuration for Unicorn"
  requires :nginx
  
  config_file = '/usr/local/nginx/sites-available/filter'
  symlink_file = '/usr/local/nginx/sites-enabled/filter'
  config_template = ERB.new(File.read(File.join(File.join(File.dirname(__FILE__), '..', 'assets'), 'unicorn.conf.erb'))).result
  
  push_text config_template, config_file
  runner "ln -s #{config_file} #{symlink_file}"
  runner '/etc/init.d/nginx restart'

  verify do
    has_file config_file
    has_symlink symlink_file
  end
end
