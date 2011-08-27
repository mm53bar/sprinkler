package :ufw, :provides => :firewall do
  description "uwf - uncomplicated firewall"
  
  requires :ufw_core, :ufw_deny, :ufw_autostart
end

package :ufw_core do
  requires :curl
  
  apt 'ufw'
  
  verify do
    has_executable 'ufw'
  end
end

package :ufw_deny do
  requires :ufw_core
  
  #open_ports = %w(80 443 22 25) # HTTP, HTTPS, SSH, SMTP

  runner "ufw default deny"
  #open_ports.each do |port|
  #  runner "ufw allow to 0.0.0.0/0 port #{port}"
  #end
  runner "ufw --force enable"
  runner "ufw logging on"
  
  #open_ports.each do |port|
  #  runner "curl localhost:#{port} > /tmp/ufw.port.#{port}.test"
  #end

  #verify do
  #  file_contains_not "/tmp/ufw.port.#{port}.test", "couldn't connect to host"
  #end
end

package :ufw_autostart do
  requires :ufw_core

  noop do
    pre :install, "update-rc.d ufw defaults"
  end
end

%w[start stop restart reload].each do |command|
  package :"ufw_#{command}" do
    requires :ufw_core

    noop do
      pre :install, "/etc/init.d/ufw #{command}"
    end
  end
end