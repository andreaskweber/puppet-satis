# = Class: aw_satis::params
#
# This class defines default parameters used by the main module class satis.
#
# == Variables:
#
# Refer to aw_satis class for the variables defined here.
#
# == Examples:
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes.
#
# === Authors
#
# Andreas Weber <code@andreas-weber.me>
#
# === Copyright
#
# Copyright 2015 Andreas Weber
#
class aw_satis::params
{
  $user = 'satis'
  $home_path = '/var/lib/satis'
  $bin_path = '/var/lib/satis/satis/bin/satis'
  $configuration_path = '/etc/satis'
  $repositories_path = '/var/lib/satis/repositories'
  $satis_version = '3dc787c16f1082784808e4a09d0e9e2fb2661afc'
  $vhost_template = 'aw_satis/vhost.erb'
}
