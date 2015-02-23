# = Definition apt_mirror::mirror
#
# == Parameters
#
# [*mirror*]
#
# Hostname or URL for upstream mirror  ( e.g. 'us.archive.ubuntu.com' or 'http://apt.puppetlabs.com' )
#
# REQUIRED 
#
# [*os*]
#
# Name of operating system
#
# Default: 'ubuntu'
#
# [*release*]
#
# Array of release version names to include in mirror ( e.g. [ 'trusty', 'trusty-updates', ] )
#
# Default: [ 'precise', ]
#
# [*components*]
#
# Array of repo components to include in mirror ( e.g. [ 'main', 'restricted', 'universe', 'multiverse', ] )
#
# Default: ['main', 'contrib', 'non-free']
#
# [*source*]
#
# Enable mirroring of source packages. Boolean, true|false
#
# Default: false
#
# [*alt_arch*]
#
# Array of alternate architectures to include in mirror. ( e.g. [ 'i386', 'armel', 'powerpc', ] )
#
# Default: undef
#
define apt_mirror::mirror (
  $mirror,
  $os         = 'ubuntu',
  $release    = ['precise'],
  $components = ['main', 'contrib', 'non-free'],
  $source     = false,
  $alt_arch   = undef,
  $autoupdate = false,
  $hours      = '4',
  $minute     = '0',
) {
  include apt_mirror::params
  $base_path         = $apt_mirror::params::base_path
  $mirror_path       = $apt_mirror::params::mirror_path
  $var_path          = $apt_mirror::params::var_path
  $defaultarch       = $apt_mirror::params::defaultarch
  $cleanscript       = $apt_mirror::params::cleanscript
  $postmirror_script = $apt_mirror::params::postmirror_script
  $run_postmirror    = $apt_mirror::params::run_postmirror
  $nthreads          = $apt_mirror::params::nthreads
  $tilde             = $apt_mirror::params::tilde
  $user              = $apt_mirror::params::user
  $group             = $apt_mirror::params::group
  concat { "/etc/apt/${name}.list":
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  concat::fragment { "${name}.list header":
    target  => "/etc/apt/${name}.list",
    content => template('apt_mirror/header.erb'),
    order   => '01',
  }
  concat::fragment { $name:
    target  => "/etc/apt/${name}.list",
    content => template('apt_mirror/mirror.erb'),
    order   => '02',
  }

  cron { $name:
    ensure  => $autoupdate ? { default => absent, true => present },
    user    => $user,
    command => "/usr/bin/apt-mirror /etc/apt/${name}.list",
    minute  => $minute,
    hour    => $hours,
  }
}
