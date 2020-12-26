# == Definition: network::bond
#
# Creates a bonded interface with no IP information and enables the
# bonding driver.
#
# === Parameters:
#
#   $ensure       - required - up|down
#   $mtu          - optional
#   $ethtool_opts - optional
#   $bonding_opts - optional
#   $zone         - optional
#   $restart      - optional - defaults to true
#
# === Actions:
#
# Deploys the file /etc/sysconfig/network-scripts/ifcfg-$name.
# Updates /etc/modprobe.conf with bonding driver parameters.
#
# === Sample Usage:
#
#   network::bond { 'bond2':
#     ensure => 'up',
#   }
#
# === Authors:
#
# Jason Vervlied <jvervlied@3cinteractive.com>
#
# === Copyright:
#
# Copyright (C) 2015 Jason Vervlied, unless otherwise noted.
#
define network::bond (
  Enum['up','down'] $ensure,
  Optional[Integer] $mtu          = undef,
  Optional[String]  $ethtool_opts = undef,
  String            $bonding_opts = 'miimon=100',
  Optional[String]  $zone         = undef,
  Boolean           $restart      = true,
) {

  network::if_base { $title:
    ensure       => $ensure,
    ipaddress    => '',
    netmask      => '',
    gateway      => '',
    macaddress   => '',
    bootproto    => 'none',
    ipv6address  => '',
    ipv6gateway  => '',
    mtu          => $mtu,
    ethtool_opts => $ethtool_opts,
    bonding_opts => $bonding_opts,
    zone         => $zone,
    restart      => $restart,
  }
}
