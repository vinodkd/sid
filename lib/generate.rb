require 'erb'
require 'fileutils'

module Sid
  class Generator
    def initialize(output_file,output)
      @output_file = output_file
      @output = output
      @gen_arch_img = (@output["to-build"][:has_architecture])? true : false
      setup "gen_root()",'sid.erb'
      setup "gen_features(root)","gen_features.erb"
      setup "gen_capabilities(root)","gen_capabilities.erb"
      setup "gen_requires(root,ctx)","gen_requires.erb"
      setup "gen_defining_tasks(val,ctx)","gen_defining_tasks.erb"
      setup "gen_using(using,ctx)","gen_using.erb"
      setup "gen_building(building,ctx)","gen_building.erb"
      setup "gen_arch_lnk(ctx)","gen_arch_lnk.erb"
      setup "gen_arch_img(root)","gen_arch_img.erb"
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
      
      css_source_file = File.join(File.dirname(__FILE__),"sid.css")
      css_output_file = File.join(File.dirname(@output_file),'sid.css')
      FileUtils.cp css_source_file, css_output_file
      
      if @gen_arch_img
        gv_output_file = @output_file.sub '.html','.dot'
        File.open(gv_output_file, "w+") do |gvfile|
          gvfile.puts gen_arch_img @output
        end
        png_output_file = @output_file.sub '.html', '.png'
        dot_done = `dot #{gv_output_file} | neato -n -s -Tpng -o#{png_output_file}`
      end      
    end
  end
end

