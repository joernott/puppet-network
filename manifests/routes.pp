class network::routes(
  String  $interface,
  Boolean $restart   = true,
) {

  $filename = "/etc/sysconfig/network-scripts/route-${interface}"
  if $restart {
      $notify = [Service['network']]
  } else {
      $notify = []
  }
  
  concat{"/etc/sysconfig/network-scripts/route-${interface}":
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => $notify,
  }

  concat::fragment{ "header_/etc/sysconfig/network-scripts/route-${interface}":
    target  => $filename,
    content => "# This file is managed by puppet",
    order   => '01',
  }
}
