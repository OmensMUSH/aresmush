module AresMUSH
  module DerivedStats

    def self.find_dstat(model, dstat_name)
      name_downcase = dstat_name.downcase
      model.derived_stats.select { |a| a.name.downcase == name_downcase }.first
    end
  end
end