module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end
      
      attr_accessor :name

      def parse_args
        self.name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          attr = model.fs3_attributes.sort_by(:name, :order=> "ALPHA")
          skills = model.fs3_action_skills.sort_by(:name, :order=> "ALPHA")
          advs = model.fs3_advantages.sort_by(:name, :order=> "ALPHA");

          # Initiative calcs -- base value Perception+Alertness
          baseinit = attr[2].rating + skills[0].rating
            adv = advs.find{|a| a.name== "Gunslinger"}
            if adv != nil
              baseinit += adv.rating
            end

          # Dodge calcs -- base value Reflexes+1
          basedodge = attr[4].rating + 1

          # Toughness calcs -- base value Brawn+Armor Rating
          basetoughness = attr[0].rating

          # Resolve calcs -- base value Grit+Wits
          baseres = attr[1].rating + attr[5].rating
            adv = advs.find{|a| a.name== "Jedi"}
            if adv != nil and adv.rating == 3
              baseres += 1
            end
            adv = advs.find{|a| a.name== "Sith"}
            if adv != nil and adv.rating >= 1
              baseres += 1
            end
            adv = advs.find{|a| a.name== "Operative"}
            if adv != nil and adv.rating == 3
              baseres += 1
            end
            adv = advs.find{|a| a.name== "Fringer"}
            if adv != nil and adv.rating >= 2
              baseres += 1
            end

          # Vitality calcs -- base value Brawn+Grit
          basevit = attr[0].rating + attr[1].rating

          # AP calcs -- base value Resolve x2
          baseap = baseres*2

          # Stamina calcs -- base value Vitality x3
          basestam = basevit*3
            adv = advs.find{|a| a.name== "Jedi"}
            if adv != nil and adv.rating >= 1
              basestam += 1
            end
            adv = advs.find{|a| a.name== "Sith"}
            if adv != nil and adv.rating >= 2
              basestam += 1
            end
            adv = advs.find{|a| a.name== "Jensaarai"}
            if adv != nil and adv.rating >= 1
              basestam += 1
            end
            adv = advs.find{|a| a.name== "Mandalorian Tradition"}
            if adv != nil
              basestam += adv.rating
            end
            adv = advs.find{|a| a.name== "Soldier"}
            if adv != nil and adv.rating >= 2
              basestam += 2
            end
            adv = advs.find{|a| a.name== "Martial Arts"}
            if adv != nil and adv.rating == 3
              basestam += 1
            end
            adv = advs.find{|a| a.name== "Melee Expert"}
            if adv != nil and adv.rating >= 2
              basestam += adv.rating
            end
            adv = advs.find{|a| a.name== "Fringer"}
            if adv != nil and adv.rating == 3
              basestam += 4
            end

          # HP calcs -- base value Vitality+2
          basehp = basevit+2
            adv = advs.find{|a| a.name== "Mandalorian Tradition"}
            if adv != nil
              basehp += adv.rating
            end

          content = ["Initiative:", "#{baseinit}/#{baseinit}", "(Perception+Alertness)",
                     "Dodge:", "#{basedodge}/#{basedodge}", "(Reflex+1)", 
                     "Toughness:", "#{basetoughness}/#{basetoughness}", "(Brawn+Armor Rating)", 
                     "Resolve:", "#{baseres}/#{baseres}", "(Grit+Wits)", 
                     "Vitality:", "#{basevit}/#{basevit}", "(Brawn+Grit)", 
                     "Action Points:", "#{baseap}/#{baseap}", "(Resolve x2)", 
                     "Stamina:", "#{basestam}/#{basestam}", "(Vitality x3)", 
                     "Health:", "#{basehp}/#{basehp}", "(Vitality+2)"
                    ]

          template = BorderedTableTemplate.new content, 25, "#{model.name}'s Derived Stats", "", "Current/Base Values (before situational Advantages)\n"
          client.emit template.render
        end
      end

    end
  end
end
