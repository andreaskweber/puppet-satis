# == Class: aw_satis
#
# The aw_satis class manages the installation and configuration of satis.
# When an oauth token for github is passend, an auth.json file will be created.
#
# === Parameters
#
# [*server_name*]
#   The server name should be the fqdn under which the satis installation is
#   accessible by http.
#
# [*token*]
#   The oauth token to access github api.
#
# === Examples
#
#  class { 'aw_satis':
#    server_name => 'satis.example.com',
#    token       => 'my_github_oauth_token'
#  }
#
# === Authors
#
# Andreas Weber <code@andreas-weber.me>
#
# === Copyright
#
# Copyright 2015 Andreas Weber
#
class aw_satis (
  $server_name,
  $token = undef
)
{
  include aw_satis::params

  package { [
    'nginx'
  ]:
    ensure  => 'installed'
  }

  service { 'nginx':
    ensure  => 'running',
    enable  => true,
    require => Package['nginx'],
  }

  file { $::aw_satis::params::configuration_path:
    ensure => 'directory',
    owner  => '0',
    group  => '0',
    mode   => '0755',
  }

  user { $::aw_satis::params::user:
    ensure     => present,
    system     => true,
    managehome => true,
    home       => $::aw_satis::params::home_path,
  }

  if $token != undef {
    aw_composer::token { $::aw_satis::params::user:
      home_dir => $::aw_satis::params::home_path,
      token    => $token
    }
  }

  file { $::aw_satis::params::repositories_path:
    ensure  => 'directory',
    owner   => $::aw_satis::params::user,
    group   => $::aw_satis::params::user,
    mode    => '0755',
    require => User[$::aw_satis::params::user]
  }

  file { "/etc/nginx/sites-enabled/${server_name}":
    ensure  => file,
    owner   => '0',
    group   => '0',
    mode    => '0644',
    content => template($::aw_satis::params::vhost_template),
    require => File[$::aw_satis::params::repositories_path],
    notify  => Service['nginx']
  }

  exec { 'install satis':
    command     => "composer --no-interaction create-project composer/satis --stability=dev --keep-vcs ${aw_satis::params::home_path}/satis",
    creates     => "${aw_satis::params::home_path}/satis",
    path        => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    user        => $::aw_satis::params::user,
    environment => [
      "COMPOSER_HOME=${aw_satis::params::home_path}"
    ],
    require     => [
      Class['aw_packages'],
      Class['aw_php'],
      Class['aw_composer'],
      User[$::aw_satis::params::user]
    ]
  }

  exec { 'upgrade satis':
    command     => "git fetch && git checkout ${::aw_satis::params::satis_version} && composer --no-interaction install",
    creates     => "${aw_satis::params::home_path}/satis",
    unless      => "test $(git rev-parse HEAD) = ${::aw_satis::params::satis_version}",
    path        => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    user        => $::aw_satis::params::user,
    environment => [
      "COMPOSER_HOME=${aw_satis::params::home_path}"
    ],
    require     => Exec['install satis']
  }
}
