module AresMUSH
  module Custom
    class DerivedStatsCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          attr = model.fs3_attributes.sort_by(:name, :order=> "ALPHA")
          skills = model.fs3_action_skills.sort_by(:name, :order=> "ALPHA")

          init = attr[2].rating + skills[0].rating
          dodge = attr[4].rating + 1
          toughness = attr[0].rating
          res = attr[1].rating + attr[5].rating
          ap = res*2
          vit = attr[0].rating + attr[1].rating
          stam = vit*3
          hp = vit+2

          content = ["Initiative:", "#{init}", "(Perception+Alertness)", "Dodge:", "#{dodge}", "(Reflex+1)", "Toughness:", "#{toughness}", "(Brawn+Armor Rating)", "Resolve:", "#{res}", "(Grit+Wits)", "Action Points:", "#{ap}", "(Resolve x2)", "Vitality:", "#{vit}", "(Brawn+Grit)", "Stamina:", "#{stam}", "(Vitality x3)", "Health:", "#{hp}", "(Vitality+2)"]

          template = BorderedTableTemplate.new content, 25, "#{model.name}'s Derived Stats", "", "Base Values (before Advantages)\n"
          client.emit template.render
        end
      end
    end
  end
end