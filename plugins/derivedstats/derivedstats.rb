$:.unshift File.dirname(__FILE__)

module AresMUSH
  module DerivedStats

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("derivedstats", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "drvstat"
        if (cmd.switch_is?("set"))
          return DstatSetCmd
        elsif (cmd.switch_is?("view"))
          return DstatsViewCmd
        else
          return DstatCmd
        end
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end
   end
  end
end
