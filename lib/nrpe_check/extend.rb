require File.join File.dirname(__FILE__), '..', 'nrpe_check'
[STDOUT, STDERR].each {|io| io.sync = true}

extend NRPE::Check
