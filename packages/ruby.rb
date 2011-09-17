package :ruby_build, :provides => :ruby do
  description 'Install rubies using ruby-build'
  
  requires :install_ruby_build, :default_rubies, :default_ruby, :add_bundler, :config_gemrc
end

package :install_ruby_build do
  requires :git
  
  runner "mkdir -p /usr/local/sources && cd /usr/local/sources"
  runner "git clone git://github.com/sstephenson/ruby-build.git"
  runner "cd ruby-build"
  runner "./install.sh"
  
  verify do
    has_executable 'ruby-build'
  end
end

package :default_rubies do
  requires :ruby_dependencies
  
  runner "ruby-build 1.9.2-p290 /usr/local/rubies/ruby-1.9.2-p290"
  runner "ruby-build 1.8.7-p352 /usr/local/rubies/ruby-1.8.7-p352"
  
  verify do
    @commands << "/usr/local/rubies/ruby-1.9.2-p290/bin/ruby -v"
    @commands << "/usr/local/rubies/ruby-1.8.7-p352/bin/ruby -v"
  end
end

package :default_ruby do
  requires :default_rubies
  
  runner "ln -s /usr/local/rubies/ruby-1.9.2-p290/bin/* /usr/local/bin/"
  runner "source /etc/profile"

  verify do
    @commands << "ruby -v"
    @commands << "gem -v"
    has_symlink '/usr/local/bin/ruby', '/usr/local/rubies/ruby-1.9.2-p290/bin/ruby' 
    has_executable "ruby"
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

package :add_bundler do
  requires :default_ruby, config_gemrc
  
  # only need to symlink bundler because all other gems should be in Gemfile and can be run using bundle exec (or binstubs)
  runner "gem install bundler --version=1.0.18"
  runner "ln -s /usr/local/rubies/ruby-1.9.2-p290/lib/ruby/gems/1.9.1/gems/bundler-1.0.18/bin/bundle /usr/local/bin/bundle"
  
  verify do 
    @commands << 'gem list | grep bundler' 
    has_symlink '/usr/local/bin/bundle', '/usr/local/rubies/ruby-1.9.2-p290/lib/ruby/gems/1.9.1/gems/bundler-1.0.18/bin/bundle'
  end
end

package :config_gemrc do
  requires :default_ruby, :deploy

  gemrc_template =`cat #{File.join(ASSETS_PATH, 'gemrc')}`
  gemrc_file = '/home/deploy/.gemrc'

  push_text gemrc_template, gemrc_file
  runner "chown deploy:deploy #{gemrc_file}"

  verify do
    has_file gemrc_file
  end
end
