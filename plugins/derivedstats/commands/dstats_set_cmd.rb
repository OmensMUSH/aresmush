module AresMUSH    
  module DerivedStats
    class DstatSetCmd
      include CommandHandler
      
      attr_accessor :target_name, :dstat_name, :dstat_value
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target_name = enactor_name
        self.dstat_name = titlecase_arg(args.arg1)
        self.dstat_value = downcase_arg(args.arg2)
      end
      
      def required_args
        [self.target_name, self.dstat_name, self.dstat_value]
      end

      def check_valid_ability
        return t('derivedstats.invalid_dstat_name') if !DerivedStats.is_valid_dstat_name?(self.dstat_name)
        return nil
      end
                            
      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          # See if we already have this attribute
          # DerivedStats -- is the object reference for function calls from helper.rb
          # derivedstats -- is the reference for the locale/en text strings and the config yml (derivedstats -> dstats)
          # DerivedStat  -- is the reference for the db model
          attr = DerivedStats.find_dstat(model, self.dstat_name)
     
          # If so, update it (or remove).  Otherwise create a new one.

          if (self.dstat_value == '-1')
            attr.delete
            client.emit_success "#{dstat_name} removed."
            return
          end

          if (attr)
            attr.update(value: self.dstat_value)
          else
            DerivedStat.create(name: self.dstat_name, value: self.dstat_value, character: model)
          end
     
          client.emit_success "#{dstat_name} set to #{dstat_value}!"
       end
      end
    end
  end
end