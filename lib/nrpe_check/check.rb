module NRPE
  module Check

    def check
      set_default_status

      yield if block_given?
    rescue Exception => message
      exit_with_status :unknown, message
    end

    def status status, message = nil
      at_exit do
        exit_with_status status, message
      end
    end

    def exit_with_status status, message = nil
      case status.downcase
      when :ok, :warning, :critical, :unknown
        STDOUT.puts "#{status.upcase}: " + message if message

        exit! eval ['NRPE', 'Status', status.upcase].join '::'
      else
        raise 'invalid NRPE::Check exit status'
      end
    end

    def set_default_status
      status :unknown, "#{$0} failed to set an exit status"
    end

  end
end
