[![Build Status](https://travis-ci.org/GeoffWilliams/bmc_patrol.svg?branch=master)](https://travis-ci.org/GeoffWilliams/bmc_patrol)
# bmc_patrol

#### Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Install BMC agent using a tarball downloaded from a web server that contains a silent install script (`install.sh`)

## Setup

### What bmc_patrol affects
* Install a list of prereq_package
* Create a `patrol` user and group
* Download, extract and run the installer

## Usage

### Basic
```puppet
class { "bmc_patrol":
  media_source   => "http://megacorp.com/software/BMCPATROL.tar",,
}
```
Download tarball from media source, extract and run installer:
* Run as user 'patrol'
* Install into `/usr/patrol` on AIX, all other system to `/opt/patrol`
* Only runs if `/(opt|usr)/patrol/Patrol3` does not yet exist (to prevent constant re-installation)

### Custom
```puppet
class { "bmc_patrol":
  media_source   => "http://megacorp.com/software/BMCPATROL.tar",
  prereq_package => {"foo"=>{}, "bar"=>{}},
  creates        => "/opt/patrol/Patrol3/magic"
  environment    => "FOO=bar",
  arguments      => "--foo",
}
```
You can set parameters to the `bmc_patrol` class to suit your needs, see class definition for details.

In this example, we:
* Supplied a different list of prerequisites packages to install (`foo` and `bar`)
* Detect whether we need to run checking for the absence of a file at `/opt/patrol/Patrol3/magic` - if the file is missing we download and run the installer
* Supplied a custom environment to run the installation script (set shell variables, etc)
* Passed the `--foo` option to our installer script

## Reference

### Classes
* `bmc_patrol` - Install BMC Patrol agent

## Limitations

* Proxies not supported
* The tarball must contain a directory with the same name as the downloaded file minus any `.tar.gz` extension.  Inside this directory, there must be an executable script called `install.sh`
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
