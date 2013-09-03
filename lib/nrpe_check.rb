$:.unshift File.join File.dirname(__FILE__), 'nrpe_check'
%w[check status].each {|l| require l}

[STDOUT, STDERR].each {|io| io.sync = true}
