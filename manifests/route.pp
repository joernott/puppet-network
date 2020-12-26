# @summary network::route
#
# Configures /etc/sysconfig/networking-scripts/route-$name.
#
# === Parameters:
#
#   $ipaddress - required
#   $netmask   - required
#   $gateway   - required
#   $restart   - optional - defaults to true
#
# === Actions:
#
# Deploys the file /etc/sysconfig/network-scripts/route-$name.
#
# === Requires:
#
#   File["ifcfg-$name"]
#   Service['network']
#
# === Sample Usage:
#
#   network::route { 'eth0':
#     ipaddress => [ '192.168.17.0', ],
#     netmask   => [ '255.255.255.0', ],
#     gateway   => [ '192.168.17.250', ],
#   }
#
#   network::route { 'bond2':
#     ipaddress => [ '192.168.2.0', '10.0.0.0', ],
#     netmask   => [ '255.255.255.0', '255.0.0.0', ],
#     gateway   => [ '192.168.1.1', '10.0.0.1', ],
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
define network::route (

  Stdlib::IP::Address                  $ipaddress,
  Integer[8, 32]                       $prefix,
  Array[Stdlib::IP::Address::Nosubnet] $gateway,
  String                               $interface,
) {
  require 'network::routes'
  
  $filename = "/etc/sysconfig/network-scripts/route-${interface}"
  $routedef = "\n# ${title}\n${ipaddress}/${prefix} via ${gateway} dev ${interface}\n"
  
  concat::fragment{"${filename}_${title}":
    target  => $filename,
    content => $routedef,
    order   => '10',
  }
}
