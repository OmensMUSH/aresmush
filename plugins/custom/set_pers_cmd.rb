module AresMUSH
  module Custom
    class SetPersCmd
      include CommandHandler
      
      attr_accessor :personality

      def parse_args
       self.personality = trim_arg(cmd.args)
      end

      def handle
        enactor.update(personality: self.personality)
        client.emit_success "Personality set!"
      end
    end
  end
end