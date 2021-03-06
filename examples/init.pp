# @PDQTest

# Create dir to hold installed package (if installing the package doesn't do
# this for us)
file { "/opt/coolapp":
  ensure => directory,
  owner  => "easy",
  group  => "easy",
  mode   => "0700"
}

easy_install { "coolapp":
  media_source   => "/cut/spec/fixtures/coolapp.tar.gz",
  user           => "easy",
  group          => "easy",
}
