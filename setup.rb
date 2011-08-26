require 'packages/system_update'
require 'packages/git'

policy :rails_stack, :roles => :app do
  requires :system_update
  requires :git
  #requires :rvm
  #requires :rails, :version => '2.1.0'
  #requires :appserver
  #requires :database
  #requires :webserver
end

deployment do
  delivery :ssh do
    roles :app => '173.255.247.39'
    user 'root'
    password 'shed18[whams'
  end

  source do
    prefix   '/usr/local'           # where all source packages will be configured to install
    archives '/usr/local/sources'   # where all source packages will be downloaded to
    builds   '/usr/local/build'     # where all source packages will be built
  end
end