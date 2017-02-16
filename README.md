[![Build Status](https://travis-ci.org/GeoffWilliams/easy_install.svg?branch=master)](https://travis-ci.org/GeoffWilliams/easy_install)
# easy_install

#### Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Download and install packages from tarballs with with Puppet


## Setup

### What easy_install affects
* Install a hash of prerequisite packages on the system if required
* Create a user and group if required
* Download, extract and run the installer

## Usage

### Basic
```puppet
class { "easy_install":
  media_source   => "http://megacorp.com/software/coolapp.tar",
  user           => "coolapp"
  creates        => "/opt/coolapp"
}
```
Download tarball from media source, extract and run installer:
* Run as user 'coolapp'
* Only runs if `/opt/coolapp` does not yet exist (to prevent constant re-installation)

### Custom
```puppet
class { "easy_install":
  media_source   => "http://megacorp.com/software/coolapp.tar",
  prereq_package => {"foo"=>{}, "bar"=>{}},
  environment    => "FOO=bar",
  arguments      => "--foo",
}
```
You can set parameters to the `easy_install` class to suit your needs, see class definition for details.

In this example, we:
* Supplied a different list of prerequisites packages to install (`foo` and `bar`)
* Supplied a custom environment to run the installation script (set shell variables, etc)
* Passed the `--foo` option to our installer script

## Reference

### Defined resource types
* `easy_install` - Install BMC Patrol agent

## Limitations

* Proxies not supported
* Download platform must be supported by [puppet-archive](https://forge.puppet.com/puppet/archive/readme)
* Not supported by Puppet, Inc.

## Development

PRs accepted :)

## Testing
This module supports testing using [PDQTest](https://github.com/GeoffWilliams/pdqtest).


Test can be executed with:

```
bundle install
bundle exec pdqtest all
```


See `.travis.yml` for a working CI example
