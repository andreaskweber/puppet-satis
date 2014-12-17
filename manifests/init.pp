# == Class: satis
#
# The satis class manages the installation and configuration of satis.
#
# === Parameters
#
# [*server_name*]
#   The server name should be the fqdn under which the satis installation is
#   accessible by http.
#
# === Examples
#
#  class { 'satis':
#    server_name => 'satis.example.com
#  }
#
# === Authors
#
# Andreas Weber <code@andreas-weber.me>
#
# === Copyright
#
# Copyright 2014 Andreas Weber
#
class satis ($server_name)
{
  include satis::params

  package { [
    'git',
    'php5-cli',
    'nginx'
  ]:
    ensure  => 'installed'
  }

  service { 'nginx':
    ensure  => 'running',
    enable  => true,
    require => Package['nginx'],
  }

  class { 'composer':
    command_name => 'composer',
    target_dir   => '/usr/local/bin',
    require      => Package['php5-cli']
  }

  file { $::satis::params::configuration_path:
    ensure => 'directory',
    owner  => '0',
    group  => '0',
    mode   => '0755',
  }

  user { 'satis':
    ensure     => present,
    system     => true,
    managehome => true,
    home       => $::satis::params::home_path,
  }

  file { $::satis::params::repositories_path:
    ensure  => 'directory',
    owner   => 'satis',
    group   => 'satis',
    mode    => '0755',
    require => User['satis']
  }

  file { "/etc/nginx/sites-enabled/${server_name}":
    ensure  => file,
    owner   => '0',
    group   => '0',
    mode    => '0644',
    content => template($::satis::params::vhost_template),
    require => File[$::satis::params::repositories_path],
    notify  => Service['nginx']
  }

  exec { 'install satis':
    command     => "composer --no-interaction create-project composer/satis --stability=dev --keep-vcs ${satis::params::home_path}/satis",
    creates     => "${satis::params::home_path}/satis",
    path        => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    user        => 'satis',
    environment => [
      "COMPOSER_HOME=${satis::params::home_path}"
    ],
    require     => User['satis']
  }

  exec { 'upgrade satis':
    command     => "git fetch && git checkout ${::satis::params::satis_version} && composer --no-interaction install",
    creates     => "${satis::params::home_path}/satis",
    unless      => "test $(git rev-parse HEAD) = ${::satis::params::satis_version}",
    path        => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    user        => 'satis',
    environment => [
      "COMPOSER_HOME=${satis::params::home_path}"
    ],
    require     => [
      User['satis'],
      Exec['install satis']
    ]
  }
}
