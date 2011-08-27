package :rvm, :provides => :ruby do
  description 'Install RVM'
  
  requires :rvm_multi_user, :default_rubies
end

package :rvm_multi_user do
  requires :git, :curl
  
  runner "bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)"
  
  verify do
  #  has_executable 'rvm'
    has_directory '/usr/local/rvm'
  end
end

package :default_rubies do
  requires :ruby_dependencies
  
  runner "source /etc/profile && rvm install ruby-1.8.7-p174,ruby-1.9.2-p180"
  
  verify do
    has_executable "/usr/local/rvm/rubies/ruby-1.8.7-p174/bin/ruby"
    has_executable "/usr/local/rvm/rubies/ruby-1.9.2-p180/bin/ruby"  
  end
end

package :ruby_dependencies do
  requires :build_essential, :curl, :git
  description 'Install dependencies that are recommended by RVM'
  
  dependencies = %w(bison openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 
                    libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake)
  
  dependencies.each do |dependency|
    apt dependency
  end  
end