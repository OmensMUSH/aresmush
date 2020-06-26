module AresMUSH    
  module DerivedStats
    class DstatCmd
      include CommandHandler
  
      def handle
        attrs = Global.read_config("derivedstats", "dstats")
        list = attrs.sort_by { |a| a['name']}
                    .map { |a| "%xh#{a['name'].ljust(15)}%xn #{a['value']} #{a['desc'].rjust(30)} "}
                    
        template = BorderedPagedListTemplate.new list, cmd.page, 25, "Derived Stats"
        client.emit template.render
      end
    end
  end
end