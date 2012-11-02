#! /usr/bin/env ruby
require 'nrpe_check/extend'

filename = ARGV.first

check do
  exit_with_status :unknown, "no filename given" unless filename

  if File.exists? filename
    status :ok, "file: #{filename} exists"
  else
    status :critical, "file: #{filename} does not exist"
  end
end
