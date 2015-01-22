# == Define: aw_satis::repository
#
# This resource manages the creation and updating from different satis repositories.
#
# === Parameters
#
# [*config*]
#   The source path to the repository configuration file.
#
# === Examples
#
#  aw_satis::repository{ 'example':
#    config => 'puppet:///modules/aw_satis/example.json'
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
define aw_satis::repository ($config)
{
  include aw_satis
  include aw_satis::params

  $config_path = "${aw_satis::params::configuration_path}/${name}.json"
  $repository_path = "${aw_satis::params::repositories_path}/${name}"

  file { $config_path:
    owner   => '0',
    group   => '0',
    mode    => '0755',
    source  => $config
  }

  exec { "create satis repo ${name}":
    command     => "${aw_satis::params::bin_path} --no-interaction build ${config_path} ${repository_path}",
    refreshonly => true,
    cwd         => $::aw_satis::params::home_path,
    user        => $::aw_satis::params::user,
    environment => [
      "COMPOSER_HOME=${aw_satis::params::home_path}"
    ]
  }

  cron { "cron satis repo ${name}":
    command => "${aw_satis::params::bin_path} --no-interaction --quiet build ${config_path} ${repository_path}",
    minute  => '*/5',
    user    => $::aw_satis::params::user
  }
}
