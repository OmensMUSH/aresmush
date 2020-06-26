module AresMUSH

  class Character < Ohm::Model
    collection :derived_stats, "AresMUSH::DerivedStat"
  end
  
  class DerivedStat < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :value
    reference :character, "AresMUSH::Character"
    index :name
        
  end
  
end