$: << File.dirname(__FILE__)

require 'config'
require 'packages/update'
require 'packages/git'
require 'packages/root'
require 'packages/host'
require 'packages/deploy'
require 'packages/init'

policy :stack, :roles => :app do
  requires :initialize
  requires :system_update
  requires :host
  requires :deployer
  #requires :lock_down_root
  requires :scm
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
