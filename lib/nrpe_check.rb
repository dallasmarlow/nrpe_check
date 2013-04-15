$:.unshift File.join File.dirname(__FILE__), 'nrpe_check'
%w[check logging network status].each {|l| require l}

[STDOUT, STDERR].each &:sync
