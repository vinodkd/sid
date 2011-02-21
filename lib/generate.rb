require 'erb'

module Sid
  class Generator
    def initialize(output_file,output)
      @output_file = output_file
      @output = output
      setup "gen_root()",'sid.erb'
      setup "gen_features(root)","gen_features.erb"
      setup "gen_capabilities(root)","gen_capabilities.erb"
      setup "gen_requires(root,ctx)","gen_requires.erb"
      setup "gen_defining_tasks(val,ctx)","gen_defining_tasks.erb"
      setup "gen_using(using,ctx)","gen_using.erb"
      setup "gen_building(building,ctx)","gen_building.erb"
    end
    
    def setup(fn,erb_file)
      tloc = File.join(File.dirname(__FILE__),erb_file)
      erb = ERB.new(File.open(tloc).read(),nil,'<>')
      #erb = ERB.new("xxx<%=@output.output['to-build']['version']%>yyy",nil,'%<>')
      erb.def_method(self.class,fn,erb_file)
    end
    
    def generate
      File.open(@output_file,"w+") do |outfile|
        outfile.puts gen_root 
      end
    end
  end
end

