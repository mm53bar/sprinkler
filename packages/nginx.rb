package :nginx, :provides => :webserver do
  description 'Nginx Web Server'

  requires :nginx_core
  optional :nginx_configuration
end

package :nginx_core do
  apt 'nginx' do
    post :install, '/etc/init.d/nginx start'
  end

  verify do
    has_executable '/usr/sbin/nginx'
    has_executable '/etc/init.d/nginx'
  end
end
