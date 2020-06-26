module AresMUSH    
  module DerivedStats
    class DstatSetCmd
      include CommandHandler
      
      attr_accessor :dstat_name, :dstat_value
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.dstat_name = titlecase_arg(args.arg1)
        self.dstat_value = downcase_arg(args.arg2)
      end
      
      def required_args
        [self.dstat_name, self.dstat_value]
      end
                            
      def handle
        attr = DerivedStats.find_dstat(enactor, self.dstat_name)

        if (attr)
          attr.update(value: self.dstat_value)
        else
          client.emit_success "#{self.dstat_name} isn't a derived stat."
        end
         
          client.emit_success "#{self.dstat_name} set to #{self.dstat_value}."
      end
    end
  end
end