# @PDQTest

# Skip preqeq package installation for testing purposes
class { "bmc_patrol":
  media_source   => "/cut/spec/fixtures/FOOBAR.tar",
  prereq_package => {},
}
