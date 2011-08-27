package :postgres, :provides => :database do
  description 'PostgreSQL database'
  requires :postgres_core, :postgres_autostart
end

package :postgres_core do
  apt %w( postgresql postgresql-client libpq-dev )
  
  verify do
    has_executable 'psql'
  end
end
  
package :postgres_autostart do
  description "PostgreSQL: Autostart on reboot"
  requires :postgres_core
  
  runner '/usr/sbin/update-rc.d postgresql-8.4 default'
end

%w[start stop restart reload].each do |command|
  package :"postgres_#{command}" do
    requires :postgres_core

    runner "/etc/init.d/postgresql-8.4 #{command}"
  end
end