
package :root, :provides => :lock_down_root do
  description "Root access"
  
  requires :root_login
  #recommends :root_authorize_public_key
end

package :root_login do
  description "Login as root - if not already"
  
  # Ensure root access.
  runner 'sudo sh -'
  
  verify do
  end
end

package :root_authorize_public_key do
  description "Upload/Authorize public key (from current client/deployer)"
  requires :root_login
  
  public_key_file = '/tmp/id_rsa.pub'
  local_public_key_file = File.join(ENV['HOME'], '.ssh', 'id_rsa.pub')
  
  transfer local_public_key_file, public_key_file do
    pre :install, 'mkdir /root/.ssh'
    pre :install, 'chmod 0700 /root/.ssh'
    
    pre :install, "touch /root/.ssh/authorized_keys"
    pre :install, "chmod 0700 /root/.ssh/authorized_keys"
    
    post :install, "cat #{public_key_file} >> /root/.ssh/authorized_keys"
  end
  
  verify do
  end
end

