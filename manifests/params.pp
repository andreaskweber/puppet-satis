# = Class: satis::params
#
# This class defines default parameters used by the main module class satis.
#
# == Variables:
#
# Refer to satis class for the variables defined here.
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
# Copyright 2014 Andreas Weber
#
class satis::params
{
  $user = 'satis'
  $home_path = '/var/lib/satis'
  $bin_path = '/var/lib/satis/satis/bin/satis'
  $configuration_path = '/etc/satis'
  $repositories_path = '/var/lib/satis/repositories'
  $satis_version = 'b20fd944ec40ad65c1e54bb0860fe844f4efd56e'
  $vhost_template = 'satis/vhost.erb'
}
