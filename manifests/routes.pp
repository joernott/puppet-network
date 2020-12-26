class network::routes(
  Array[String]  $interfaces,
  Boolean        $restart   = true,
) {

  if $restart {
    if $facts['os']['family'] == "RedHat" {
      case $facts['os']['major'] {
        '6', '7': {
          $notify = [Service['network']]
        }
        'default': {
          $notify = [Service['NetworkManager']]
        }
      }
    } else {
      $notify = []
    }
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
