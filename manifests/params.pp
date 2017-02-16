# Bmc_patrol::Params
#
# Params pattern
class bmc_patrol::params {
  $user  = "patrol"
  $group = "patrol"
  case $facts['os']['family'] {
    "AIX": {
      $home = "/usr/patrol"
    }
    "Solaris": {
      $home = "/opt/patrol"
    }
    "RedHat": {
      $home = "/opt/patrol"

      # HASH of packages so that we may specify install source, etc
      $prereq_package = {
        "compat-libstdc++-296.i686" => {},
        "compat-libstdc++-33.i686"  => {},
        "nss-softokn-freebl.i686"   => {},
        "glibc.i686 pam-devel.i686" => {},
      }

    }
    default: {
      fail("Module ${module_name} does not support ${facts['os']['family']}")
    }
  }

  $creates = "${home}/Patrol3"
  $extract_dir = "/backup"
}
