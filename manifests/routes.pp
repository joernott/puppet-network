class network::routes(
  Array[String]  $interfaces,
  Boolean        $restart   = true,
) {

  if $restart {
    $notify = [Service['network']]
  } else {
    $notify = []
  }

  $interfaces.each|$interface| {
    $filename = "/etc/sysconfig/network-scripts/route-${interface}"
  
    concat{$filename:
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      notify => $notify,
    }

    concat::fragment{ "header_${filename}":
      target  => $filename,
      content => "# This file is managed by puppet",
      order   => '01',
    }
  }
}
