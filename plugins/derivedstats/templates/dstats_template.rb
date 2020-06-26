module AresMUSH    
  module DerivedStats
    class DstatsTemplate < ErbTemplateRenderer
      attr_accessor :char
  
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/dstats.erb"
      end
  
      def attrs
        format_two_per_line @char.derived_stats
      end
            
      def format_two_per_line(list)
        list.to_a.sort_by { |a| a.name }
          .each_with_index
            .map do |a, i| 
              linebreak = i % 2 == 0 ? "\n" : ""
              title = left("#{ a.name }:", 15)
              value = left(a.value, 20)
              "#{linebreak}%xh#{title}%xn #{value}"
        end
      end      
    end
  end
end