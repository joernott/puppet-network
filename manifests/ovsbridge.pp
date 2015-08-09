# == Definition: network::ovsbridge
#
# Creates an openvswitch bridge interface
#
# === Parameters:
#
#   $ensure        - required - up|down
#
# === Actions:
#
# Deploys the file /etc/sysconfig/network-scripts/ifcfg-$name.
#
# === Sample Usage:
#
#   network::ovsbridge { 'ovsbr0':
#        ensure        => 'up',
#   }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
# Jörn Ott    <joern.ott@ott-consult.de>
#
# === Copyright:
#
# Copyright (C) 2015 Ott-Consult UG, unless otherwise noted.
#
define network::ovsbridge (
) {
  include '::network'

  $interface = $name

  file { "ifcfg-${interface}":
    ensure  => 'present',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    path    => "/etc/sysconfig/network-scripts/ifcfg-${interface}",
    content => template('network/ifcfg-ovsbr.erb'),
  }
} # define network::ovsbridge
