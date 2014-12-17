# == Define: satis::repository
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
#  satis::repository{ 'example':
#    config => 'puppet:///modules/satis/example.json'
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
define satis::repository ($config)
{
  require 'satis'

  $config_path = "${satis::params::configuration_path}/${name}.json"
  $repository_path = "${satis::params::repositories_path}/${name}"

  file { $config_path:
    owner   => '0',
    group   => '0',
    mode    => '0755',
    source  => $config
  }

  exec { "create satis repo ${name}":
    command     => "${satis::params::bin_path} --no-interaction build ${config_path} ${repository_path}",
    refreshonly => true,
    cwd         => $::satis::params::home_path,
    user        => 'satis',
    environment => [
      "COMPOSER_HOME=${satis::params::home_path}"
    ]
  }

  cron { "cron satis repo ${name}":
    command => "${satis::params::bin_path} --no-interaction --quiet build ${config_path} ${repository_path}",
    minute  => '*/5',
    user    => 'satis' # autorequired
  }
}
