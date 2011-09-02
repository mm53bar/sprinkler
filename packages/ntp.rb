package :ntp do

  description "NTP client to prevent time skew issues."

  apt "ntp"

  verify do
    has_dpkg "ntp"
  end

end