package :nginx, :provides => :webserver do
  description 'Nginx Web Server'

  requires :nginx_source_core, :nginx_init, :sites_folders, :nginx_conf
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

package :nginx_source_core do
  requires :nginx_dependencies
  
  #source 'http://nginx.org/download/nginx-1.0.5.tar.gz' do
  #  prefix       '/usr/local/nginx'
  #  without      ['mail_pop3_module', 'mail_imap_module', 'mail_smtp_module']
  #  with         ['http_ssl_module', 'http_stub_status_module', 'http_gzip_static_module']
  #  option       ['sbin-path=/usr/sbin/nginx']
  #end
  
  runner "mkdir -p /usr/local/nginx && mkdir -p /usr/local/build && mkdir -p /usr/local/srouces"
  runner "wget -cq --directory-prefix='/usr/local/sources' http://nginx.org/download/nginx-1.0.5.tar.gz"
  runner "cd /usr/local/build && tar xzf /usr/local/sources/nginx-1.0.5.tar.gz"
  runner "cd /usr/local/build/nginx-1.0.5 && ./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --sbin-path=/usr/local/sbin/nginx"
  runner "cd /usr/local/build/nginx-1.0.5 && make"
  runner "cd /usr/local/build/nginx-1.0.5 && make install"
  
  verify do
    has_executable '/usr/local/sbin/nginx'
  end
end

package :nginx_init do
  requires :nginx_source_core
  
  init_file = '/etc/init.d/nginx'
  init_template = `cat #{File.join(File.dirname(__FILE__), '..', 'assets', 'nginx.init')}`
  
  push_text init_template, init_file
  runner 'sudo chmod +x /etc/init.d/nginx'
  runner '/etc/init.d/nginx restart'
  runner 'sudo /usr/sbin/update-rc.d -f nginx defaults'

  verify do
    has_file init_file
    has_executable '/etc/init.d/nginx'
  end
end

package :sites_folders do
  requires :nginx_source_core
  
  runner 'sudo mkdir /usr/local/nginx/sites-available'
  runner 'sudo mkdir /usr/local/nginx/sites-enabled'

  verify do
    has_directory '/usr/local/nginx/sites-available'
    has_directory '/usr/local/nginx/sites-enabled'
  end
end

package :nginx_conf do
  requires :nginx_source_core
  
  conf_file = '/usr/local/nginx/conf/nginx.conf'
  conf_template = `cat #{File.join(File.dirname(__FILE__), '..', 'assets', 'nginx.conf')}`
  
  runner "rm #{conf_file}"
  push_text conf_template, conf_file
  runner '/etc/init.d/nginx restart'

  verify do
    file_contains conf_file, 'sites-enabled'
  end
end

package :nginx_dependencies do
  libraries = %w( libpcre3 libpcre3-dev libpcrecpp0 libssl-dev zlib1g-dev )
  apt libraries
  
  verify do
    libraries.each {|library| has_apt library }
  end  
end
