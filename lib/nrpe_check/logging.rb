require 'syslog'
require 'timeout'


module NRPE
  module Logging

    BASENAME = File.basename(__FILE__, ".rb")

    def log message, sev
      msg = "#{BASENAME} #{sev} - #{message}"
      begin
        Timeout::timeout(1) do
          Syslog.open(pname, Syslog::LOG_PID | Syslog::LOG_CONS, Syslog::LOG_USER) do |s|
            s.info msg
          end
        end
      rescue Exception => e
        # nowhere to log
      end
    end

    def log_info msg
      log msg, "info"
    end

    def log_failure msg
      log msg, "failure"
    end

  end # module Logging
end # module NRPE
