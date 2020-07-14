module AresMUSH
  module Custom
    class SetPersCmd
      include CommandHandler
      
      attr_accessor :personality

      def parse_args
       self.personality = trim_arg(cmd.args)
      end

      def handle
        if Chargen.check_chargen_locked(enactor)
          client.emit "%xr%% You can't change this after app submission or approval.%xn"
        else
          enactor.update(personality: self.personality)
          client.emit_success "Personality set!"
        end
      end
    end
  end
end