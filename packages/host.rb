package :update_host, :provides => :host do
  description 'Updates hosts and hostname'
  
  requires :hostname, :hosts
end

package :hosts do
  description "Update hosts file"
  
  hosts_file = '/etc/hosts'
  runner "echo -e '\n127.0.0.1 #{HOST}.local #{HOST}\n' >> #{hosts_file}"
  
  verify do
    file_contains hosts_file, HOST
  end
end

package :hostname do
  description "Create hostname file"
  
  hostname_file = '/etc/hostname'
  runner "echo #{HOST} > #{hostname_file}"
  runner "hostname -F #{hostname_file}"
  
  verify do
    file_contains hostname_file, HOST
  end
end
