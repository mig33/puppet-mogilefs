# Class: mogilefs::spec
#
# This class is used only for rpsec-puppet tests
# Can be taken as an example on how to do custom classes but should not
# be modified.
#
# == Usage
#
# This class is not intended to be used directly.
# Use it as reference
#
class mogilefs::spec inherits mogilefs {

  # This just a test to override the arguments of an existing resource
  # Note that you can achieve this same result with just:
  # class { "mogilefs": template => "mogilefs/spec.erb" }

  File['mogilefs.conf'] {
    content => template('mogilefs/spec.erb'),
  }

}
