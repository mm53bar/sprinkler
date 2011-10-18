package :rbenv, :provides => :ruby do
  description 'Install rubies using rbenv'
  
  requires :install_rbenv, :symlink_rubies, :set_default_ruby, :add_rbenv_bundler, :config_gemrc
end

package :install_rbenv do
  requires :git, :deploy
  
  runner "sudo -u #{DEPLOY_USER} -i git clone git://github.com/sstephenson/rbenv.git /home/#{DEPLOY_USER}/.rbenv"
  push_text 'export PATH="$HOME/.rbenv/bin:$PATH"', "/home/#{DEPLOY_USER}/.bash_profile"
  push_text 'eval "$(rbenv init -)"', "/home/#{DEPLOY_USER}/.bash_profile"
  runner "chown '#{DEPLOY_USER}' /home/#{DEPLOY_USER}/.bash_profile"
  
  verify do
    has_executable "/home/#{DEPLOY_USER}/.rbenv/bin/rbenv"
  end
end

package :symlink_rubies do
  requires :default_rubies
  
  runner "mkdir -p /home/#{DEPLOY_USER}/.rbenv/versions"
  runner "ln -s /opt/ruby-1.9.2-p290 /home/#{DEPLOY_USER}/.rbenv/versions/1.9.2-p290"
  runner "ln -s /opt/ruby-1.8.7-p352 /home/#{DEPLOY_USER}/.rbenv/versions/1.8.7-p352"

  verify do
    @commands << "sudo -u #{DEPLOY_USER} -i /home/#{DEPLOY_USER}/.rbenv/bin/rbenv versions | grep 1.8.7-p352"
    @commands << "sudo -u #{DEPLOY_USER} -i /home/#{DEPLOY_USER}/.rbenv/bin/rbenv versions | grep 1.9.2-p290"
    has_symlink "/home/#{DEPLOY_USER}/.rbenv/versions/1.9.2-p290", '/opt/ruby-1.9.2-p290' 
    has_symlink "/home/#{DEPLOY_USER}/.rbenv/versions/1.8.7-p352", '/opt/ruby-1.8.7-p352' 
  end
end

package :set_default_ruby do
  requires :install_rbenv, :symlink_rubies
  
  push_text '1.9.2-p290', "/home/#{DEPLOY_USER}/.rbenv/global"
  
  verify do
    file_contains "/home/#{DEPLOY_USER}/.rbenv/global", '1.9.2-p290'
  end
end

package :add_rbenv_bundler do
  requires :config_gemrc
  
  runner "/home/#{DEPLOY_USER}/.rbenv/versions/1.9.2-p290/bin/gem install bundler"
  runner "/home/#{DEPLOY_USER}/.rbenv/bin/rbenv rehash"
  
  verify do 
    @commands << "/home/#{DEPLOY_USER}/.rbenv/versions/1.9.2-p290/bin/gem list | grep bundler"
  end
end

