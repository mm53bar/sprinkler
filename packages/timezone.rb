package :configure_timezone, :provides => :timezone do
  description "Configure timezone"
  
  requires :set_timezone, :reset_tzdata
end

package :set_timezone do
  timezone = "America/Edmonton"
  push_text timezone, "/etc/timezone"
  
  verify do
    file_contains "/etc/timezone", timezone
  end
end

package :reset_tzdata do
  runner "dpkg-reconfigure --frontend noninteractive tzdata"
end


