$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Custom
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("custom", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "dstats"
        #case cmd.switch
        #when "set"
          #return SetDstatCmd
        #else
          return DerivedStatsCmd
        #end
      when "personality"
        case cmd.switch
        when "set"
          return SetPersCmd
        else
          return PersCmd
        end
      end
      return nil
    end

  end
end
