Gem::Specification.new do |s|
  s.name = 'nrpe_check'
  s.version = '0.0.1'
  s.authors = ['Dallas Marlow']
  s.email   = ['dallasmarlow@gmail.com']
  s.summary = 'nrpe check helper'
  
  s.files   = [
    'lib/nrpe_check.rb',
    'lib/nrpe_check/check.rb',
    'lib/nrpe_check/status.rb',
    'lib/nrpe_check/extend.rb',
  ]

  s.require_paths = ["lib"]
end