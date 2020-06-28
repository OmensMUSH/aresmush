module AresMUSH
  module DerivedStats

    def self.is_valid_dstat_name?(name)
      return false if !name
      names = Global.read_config('derivedstats', 'dstats').map { |a| a['name'].downcase }
      names.include?(name.downcase)
    end

    def self.find_dstat(model, dstat_name)
      name_downcase = dstat_name.downcase
      model.derived_stats.select { |a| a.name.downcase == name_downcase }.first
    end
  end
end