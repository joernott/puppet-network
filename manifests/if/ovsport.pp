# == Definition: network::if::ovsport
#
# Creates an OVSPort interface with static IP address.
#
# === Parameters:
#
#   $ensure       - required - up|down
#   $ipaddress    - required
#   $netmask      - required
#   $gateway      - optional
#   $ipv6address  - optional
#   $ipv6init     - optional - defaults to false
#   $ipv6gateway  - optional
#   $macaddress   - optional - defaults to macaddress_$title
#   $ipv6autoconf - optional - defaults to false
#   $userctl      - optional - defaults to false
#   $mtu          - optional
#   $ethtool_opts - optional
#   $peerdns      - optional
#   $ipv6peerdns  - optional - defaults to false
#   $dns1         - optional
#   $dns2         - optional
#   $domain       - optional
#   $type         - optional - defaults to OVSIntPort
#   $ovs_bridge   - optional
#   $netboot      - optional
#   $onboot       - optional
#
# === Actions:
#
# Deploys the file /etc/sysconfig/network-scripts/ifcfg-$name.
#
# === Sample Usage:
#
#   network::if::ovsport { 'int0':
#     ensure      => 'up',
#     ipaddress   => '10.21.30.248',
#     netmask     => '255.255.255.128',
#     macaddress  => $::macaddress_eth0,
#     domain      => 'is.domain.com domain.com',
#     ipv6init    => true,
#     ipv6address => '123:4567:89ab:cdef:123:4567:89ab:cdef'
#     ipv6gateway => '123:4567:89ab:cdef:123:4567:89ab:1' 
#     ovs_bridge  => 'ovsbr0',
#     netboot     => undef,
#     onboot      => 'yes'
#   }
#
#   network::if::ovsport { 'eth0':
#     ensure      => 'up',
#     type        => 'OVSPort',
#     ovs_bridge  => 'ovsbr0'
#   }
#      
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
# Joern Ott <joern.ott@ott-consult.de>
#
# === Copyright:
#
# Copyright (C) 2011 Ott-Consult UG, unless otherwise noted.
#
define network::if::ovsport (
  $ensure,
  $ipaddress = undef,
  $netmask = undef,
  $gateway = undef,
  $ipv6address = undef,
  $ipv6init = false,
  $ipv6gateway = undef,
  $macaddress = undef,
  $ipv6autoconf = false,
  $userctl = false,
  $bootproto = undef,
  $mtu = undef,
  $ethtool_opts = undef,
  $peerdns = false,
  $ipv6peerdns = false,
  $dns1 = undef,
  $dns2 = undef,
  $domain = undef,
  $linkdelay = undef,
  $type = 'OVSIntPort',
  $ovs_bridge = undef,
  $netboot = undef,
  $onboot = 'yes'
) {
  # Validate our data
  if $ipaddress != undef {
    if ! is_ip_address($ipaddress) { fail("${ipaddress} is not an IP address.") }
  }
  if $ipv6address != undef {
    if ! is_ip_address($ipv6address) { fail("${ipv6address} is not an IPv6 address.") }
  }

  if ! is_mac_address($macaddress) {
    # Strip off any tailing VLAN (ie eth5.90 -> eth5).
    $title_clean = regsubst($title,'^(\w+)\.\d+$','\1')
    $macaddy = getvar("::macaddress_${title_clean}")
  } else {
    $macaddy = $macaddress
  }
  # Validate booleans
  validate_bool($userctl)
  validate_bool($ipv6init)
  validate_bool($ipv6autoconf)
  validate_bool($peerdns)
  validate_bool($ipv6peerdns)

  network_if_base { $title:
    ensure       => $ensure,
    ipv6init     => $ipv6init,
    ipaddress    => $ipaddress,
    ipv6address  => $ipv6address,
    netmask      => $netmask,
    gateway      => $gateway,
    ipv6gateway  => $ipv6gateway,
    ipv6autoconf => $ipv6autoconf,
    macaddress   => $macaddy,
    bootproto    => $bootproto,
    userctl      => $userctl,
    mtu          => $mtu,
    ethtool_opts => $ethtool_opts,
    peerdns      => $peerdns,
    ipv6peerdns  => $ipv6peerdns,
    dns1         => $dns1,
    dns2         => $dns2,
    domain       => $domain,
    linkdelay    => $linkdelay,
    type         => $type,
    ovs_bridge   => $ovs_bridge,
    devicetype   => 'ovs',
    netboot      => $netboot,
    onboot       => $onboot,
  }
} # define network::if::ovsport
