#Puppet Module - Satis
This module manages the installation and configuration of Satis.

If you already have a webserver installed, don't use this class because nginx will be installed as default.

##Dependencies

- https://github.com/andreas-weber/puppet-composer

## Puppetfile

```
mod 'aw_satis', :git => 'https://github.com/andreas-weber/puppet-satis.git'
```

## Usage

See puppet manifests.
