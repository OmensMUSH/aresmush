module AresMUSH
  module Custom
    class SetDstatCmd
      include CommandHandler
      
      attr_accessor :dstats

      def parse_args
       args = cmd.parse_args(ArgParser.arg1_equals_arg2)
       self.dstat_name = titlecase_arg(args.arg1)
       self.dstat_value = downcase_arg(args.arg2)
      end

      def handle
	dstats = enactor.dstats
	dstats['#{self.dstat_name}'] = self.dstat_value
	enactor.update(dstats: dstats)

     	client.emit_success "#{self.dstat_name} set to #{self.dstat_value}."

      end
    end
  end
end