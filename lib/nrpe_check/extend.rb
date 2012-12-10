require File.join File.dirname(__FILE__), '..', 'nrpe_check'
STDOUT.sync = true

extend NRPE::Check