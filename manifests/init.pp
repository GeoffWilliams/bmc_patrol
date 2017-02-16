# Bmc_patrol
#
# Install the BMC Patrol agent
#
# Assumptions/prerequisites
# * Firewall rules in place
# * Partition/space for BMC allocated and mounted
class bmc_patrol(
    $media_source,
    $download_dir   = undef,
    $extract_dir    = $bmc_patrol::params::extract_dir,
    $user           = $bmc_patrol::params::user,
    $group          = $bmc_patrol::params::group,
    $home           = $bmc_patrol::params::home,
    $prereq_package = $bmc_patrol::params::prereq_package,
    $creates        = $bmc_patrol::params::creates
) inherits bmc_patrol::params {

  user { $user:
    ensure           => present,
    gid              => $group,
    home             => $home,
    expiry           => absent,
    password_max_age => -1,
  }

  group { $group:
    ensure => present,
  }

  file { $home:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => "0700",
  }

  file { $extract_dir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => "0700",
  }

  # Install all prerequisites
  ensure_packages($prereq_package, {'ensure' => 'present'})

  #
  # install BMC
  #

  # figure out the filename part of the media we are downloading, eg
  # http://192.168.66.33/foo/bar/baz/patrol_agent_version_666_new_solaris.tar
  # -> patrol_agent_version_666_new_solaris.tar
  $filename = basename($media_source)

  # From the filename, strip any .tar(.gz)? and you are left with the directory
  # name
  $dirname = regsubst($filename,'\.tar(\.gz)?$','')

  include download_and_do
  download_and_do::extract_and_run { $filename:
    source       => $media_source,
    run_relative => "cd ${dirname} && ./install.sh",
    download_dir => $download_dir,
    extract_dir  => $extract_dir,
    creates      => $creates,
    user         => $user,
    group        => $group,
    require      => [
      Package[keys($prereq_package)],
      User[$user],
      File[$extract_dir],
    ],
  }


}
