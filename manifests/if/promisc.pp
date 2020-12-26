# == Definition: network::if::promisc
#
# Creates a promiscuous interface.
#
# === Parameters:
#
#   $ensure        - required - up|down
#   $macaddress    - optional, defaults to macaddress_$title
#   $manage_hwaddr - optional - defaults to true
#   $bootproto     - optional, defaults to undef ('none')
#   $userctl       - optional
#   $mtu           - optional
#   $ethtool_opts  - optional
#   $promisc       - defaults to true
#
# === Actions:
#
# Deploys the file /etc/sysconfig/network-scripts/ifcfg-$name.
#
# === Requires:
#
#   Service['network']
#
# === Sample Usage:
#
#   network::if::promisc { 'eth1':
#     ensure => 'up',
#   }
#
#   network::if::promisc { 'eth1':
#     ensure => 'up',
#     macaddress => aa:bb:cc:dd:ee:ff,
#   }
#
# === Authors:
#
# Elyse Salberg <elyse_salberg@putnam.com>
#
# === Copyright:
#
# Copyright (C) 2015 Elyse Salberg, unless otherwise noted.
#
define network::if::promisc (
  Enum['up','down']     $ensure,
  Optional[Stdlib::MAC] $macaddress    = undef,
  Boolean               $manage_hwaddr = true,
  Boolean               $userctl       = false,
  Optional[Integer]     $mtu           = undef,
  Optional[String]      $ethtool_opts  = undef,
  Boolean               $restart       = true,
  Boolean               $promisc       = true,
) {
  include '::network'

  $interface = $name

  $onboot = $ensure ? {
    'up'    => 'yes',
    'down'  => 'no',
    default => undef,
  }

  if $promisc {
    case $::operatingsystem {
      /^(RedHat|CentOS|OEL|OracleLinux|SLC|Scientific)$/: {
        case $::operatingsystemmajrelease {
          '6','7', '8': {
            $ifup_source   = "puppet:///modules/${module_name}/promisc/ifup-local-promisc_6"
            $ifdown_source = "puppet:///modules/${module_name}/promisc/ifdown-local-promisc_6"
          }
          default: {
            fail('Promiscuous network setup is currently only available for EL 5, 6, 7 and 8.')
          }
        }

        file { [ '/sbin/ifup-local', '/sbin/ifdown-local' ]:
          ensure  => 'present',
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          content => '#!/bin/bash',
          replace => false,
        }
        file {'ifup-local-promisc':
          ensure => 'file',
          path   => '/sbin/ifup-local-promisc',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
          source => $ifup_source,
        }
        file {'ifdown-local-promisc':
          ensure => 'file',
          path   => '/sbin/ifdown-local-promisc',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
          source => $ifdown_source,
        }
        file_line { 'ifup-local-promisc':
          path    => '/sbin/ifup-local',
          line    => '/sbin/ifup-local-promisc',
          require => [ File['/sbin/ifup-local'],File['/sbin/ifup-local-promisc'] ],
        }
        file_line { 'ifdown-local-promisc':
          path    => '/sbin/ifdown-local',
          line    => '/sbin/ifdown-local-promisc',
          require => [ File['/sbin/ifdown-local'],File['/sbin/ifdown-local-promisc'] ],
        }
      }
      default: {
        notice('Promiscuous network setup currently is only available for RedHat.')
      }
    }
  }

  network::if_base { $title:
    ensure        => $ensure,
    ipaddress     => '',
    netmask       => '',
    gateway       => '',
    macaddress    => $macaddress,
    manage_hwaddr => $manage_hwaddr,
    bootproto     => 'none',
    ipv6address   => '',
    ipv6gateway   => '',
    mtu           => $mtu,
    ethtool_opts  => $ethtool_opts,
    promisc       => $promisc,
  }
} # define network::if::promisc
