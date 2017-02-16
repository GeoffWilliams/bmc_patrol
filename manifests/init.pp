# Bmc_patrol
#
# Install the BMC Patrol agent
#
# Assumptions/prerequisites
# * Firewall rules in place
# * Partition/space for BMC allocated and mounted
# * Installer files to remain permanently on the server
#
# @param title not used/for refrence only
# @param media_source Full URL/path to download media
# @param download_dir Location to store downloaded file,
# @param extract_dir Where to unpack the installation media
# @param user User for the patrol user
# @param group Group for the patrol user
# @param home Homedir for the patrol user
# @param prereq_package Hash of packages to install first
# @param creates File who's presence indicates we do not need to (re)install
# @param install_cmd Install command to run
# @param allow_insecure Allow insecure https to download files
# @param environment Shell environment to run the install script with
# @param arguments Arguments to run the install script with
# @param media_dir Directory inside the archive containing the installation
#   script (we will enter this directory before running the installer)
class easy_install(
    $media_source,
    $download_dir   = undef,
    $extract_dir    = $easy_install::params::extract_dir,
    $user           = undef,
    $group          = undef,
    $home           = undef,
    $prereq_package = {},
    $creates        = undef,
    $install_cmd    = $easy_install::params::install_cmd,
    $allow_insecure = false,
    $environment    = undef,
    $arguments      = "",
    $media_dir      = undef,

) inherits easy_install::params {

  # User if required
  if $user {
    user { $user:
      ensure           => present,
      gid              => $group,
      home             => pick($home, "/home/${user}"),
      expiry           => absent,
      password_max_age => -1,
    }
    $user_require = User[$user]
  } else {
    $user_require = undef
  }

  # Group if required
  if $group {
    group { $group:
      ensure => present,
    }
  }

  # create homedir if specified otherwise let the OS/user do it
  if $home {
    file { $home:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => "0700",
    }
    $home_require = File[$home]
  } else {
    $home_require = undef
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

  # Figure out the directory contained inside this tarball.  If the user told us
  # what it is, use that, otherwise guess
  if $media_dir {
    $_media_dir = $media_dir
  } else {
    # From the filename, strip any .tar(.gz)? and you are left with the directory
    # name
    $_media_dir = regsubst($filename,'\.tar(\.gz)?$','')
  }

  #$require_res = concat(Package[keys($prereq_package)], $user_require, $file_require)

  include download_and_do
  download_and_do::extract_and_run { $filename:
    source         => $media_source,
    run_relative   => "cd ${_media_dir} && ${install_cmd} ${arguments}",
    download_dir   => $download_dir,
    extract_dir    => $extract_dir,
    creates        => $creates,
    user           => $user,
    group          => $group,
    allow_insecure => $allow_insecure,
    require        => [
      Package[keys($prereq_package)],
      User[$user],
      File[$home],
    ],
  }


}
