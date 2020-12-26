# == Definition: network::if::static
#
# Creates a normal interface with static IP address.
#
# === Parameters:
#
#   $ensure         - required - up|down
#   $ipaddress      - optional
#   $netmask        - optional
#   $gateway        - optional
#   $ipv6address    - optional
#   $ipv6init       - optional - defaults to false
#   $ipv6gateway    - optional
#   $manage_hwaddr  - optional - defaults to true
#   $macaddress     - optional - defaults to macaddress_$title
#   $ipv6autoconf   - optional - defaults to false
#   $userctl        - optional - defaults to false
#   $mtu            - optional
#   $ethtool_opts   - optional
#   $peerdns        - optional
#   $ipv6peerdns    - optional - defaults to false
#   $dns1           - optional
#   $dns2           - optional
#   $domain         - optional
#   $scope          - optional
#   $flush          - optional
#   $zone           - optional
#   $metric         - optional
#   $defroute       - optional
#   $restart        - optional - defaults to true
#   $arpcheck       - optional - defaults to true
#
# === Actions:
#
# Deploys the file /etc/sysconfig/network-scripts/ifcfg-$name.
#
# === Sample Usage:
#
#   network::if::static { 'eth0':
#     ensure      => 'up',
#     ipaddress   => '10.21.30.248',
#     netmask     => '255.255.255.128',
#     macaddress  => $::macaddress_eth0,
#     domain      => 'is.domain.com domain.com',
#     ipv6init    => true,
#     ipv6address => '123:4567:89ab:cdef:123:4567:89ab:cdef',
#     ipv6gateway => '123:4567:89ab:cdef:123:4567:89ab:1',
#   }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2011 Mike Arnold, unless otherwise noted.
#
define network::if::static (
  Enum['up','down']                                  $ensure,
  Optional[Stdlib::MAC]                              $macaddress         = undef,
  Optional[Stdlib::IP::Address::V4::Nosubnet]        $ipaddress          = undef,
  Optional[Stdlib::IP::Address::V4::Nosubnet]        $netmask            = undef,
  Optional[Integer[8,32]]                            $prefix             = undef,
  Boolean                                            $ipv4_failure_fatal = false,
  Optional[Stdlib::IP::Address::V4::Nosubnet]        $gateway            = undef,
  Optional[Stdlib::IP::Address::V6]                  $ipv6address        = undef,
  Boolean                                            $ipv6init           = false,
  Optional[Stdlib::IP::Address::V6::Nosubnet]        $ipv6gateway        = undef,
  Boolean                                            $manage_hwaddr      = true,
  Boolean                                            $ipv6autoconf       = false,
  Optional[Array[Stdlib::IP::Address::V6::Nosubnet]] $ipv6secondaries    = undef,
  Boolean                                            $ipv6_failure_fatal = false,
  Optional[Enum['yes','no']]                         $ipv6_defroute      = undef,
  Boolean                                            $ipv6_privacy       = false,
  Optional[String]                                   $ipv6_addr_gen_mode = 'stable-privacy',
  Boolean                                            $userctl            = false,
  Optional[Integer]                                  $mtu                = undef,
  Optional[String]                                   $ethtool_opts       = undef,
  Boolean                                            $peerdns            = false,
  Boolean                                            $ipv6peerdns        = false,
  Optional[String]                                   $dns1               = undef,
  Optional[String]                                   $dns2               = undef,
  Optional[String]                                   $domain             = undef,
  Optional[Integer]                                  $linkdelay          = undef,
  Optional[String]                                   $scope              = undef,
  Boolean                                            $flush              = false,
  Optional[String]                                   $zone               = undef,
  Optional[Enum['yes','no']]                         $defroute           = undef,
  Optional[Integer]                                  $metric             = undef,
  Boolean                                            $restart            = true,
  Boolean                                            $arpcheck           = true,
  Optional[String]                                   $uuid               = undef,
  Boolean                                            $browser_only       = false,
  Optional[String]                                   $proxy_method       = undef,
) {

  network::if_base { $title:
    ensure          => $ensure,
    ipv6init        => $ipv6init,
    ipaddress       => $ipaddress,
    ipv6address     => $primary_ipv6address,
    netmask         => $netmask,
    gateway         => $gateway,
    ipv6gateway     => $ipv6gateway,
    ipv6autoconf    => $ipv6autoconf,
    ipv6secondaries => $ipv6secondaries,
    macaddress      => $macaddress,
    manage_hwaddr   => $manage_hwaddr,
    bootproto       => 'none',
    userctl         => $userctl,
    mtu             => $mtu,
    ethtool_opts    => $ethtool_opts,
    peerdns         => $peerdns,
    ipv6peerdns     => $ipv6peerdns,
    dns1            => $dns1,
    dns2            => $dns2,
    domain          => $domain,
    linkdelay       => $linkdelay,
    scope           => $scope,
    flush           => $flush,
    zone            => $zone,
    defroute        => $defroute,
    metric          => $metric,
    restart         => $restart,
    arpcheck        => $arpcheck,
  }
} # define network::if::static
