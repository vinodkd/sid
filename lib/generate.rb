require 'erb'
require 'fileutils'

module Sid
  class Generator
    def initialize(output_file,output)
      @output_file = output_file
      @output = output
      setup "gen_root(root)",'sid.erb'
      setup "gen_features(root)","gen_features.erb"
      setup "gen_capabilities(root)","gen_capabilities.erb"
      setup "gen_impl_details(root)", "gen_impl_details.erb"
      setup "gen_requires(root,ctx)","gen_requires.erb"
      setup "gen_defining_tasks(val,ctx)","gen_defining_tasks.erb"
      setup "gen_using(using,ctx)","gen_using.erb"
      setup "gen_building(building,ctx)","gen_building.erb"
      setup "gen_arch_lnk(ctx)","gen_arch_lnk.erb"
      setup "gen_arch_img(root)","gen_arch_img.erb"
      setup "gen_children(root)","gen_children.erb"
    end
    
    def setup(fn,erb_file)
      tloc = File.join(File.dirname(__FILE__),erb_file)
      erb = ERB.new(File.open(tloc).read(),nil,'<>')
      #erb = ERB.new("xxx<%=@output.output['to-build']['version']%>yyy",nil,'%<>')
      erb.def_method(self.class,fn,erb_file)
    end
    
    def generate
      gen_main_file
      gen_css_file
      gen_arch_images @output["to-build"]
    end

    def gen_main_file
      File.open(@output_file,"w+") do |outfile|
        outfile.puts gen_root @output
      end
    end
      
    def gen_css_file
      css_source_file = File.join(File.dirname(__FILE__),"sid.css")
      css_output_file = File.join(File.dirname(@output_file),'sid.css')
      FileUtils.cp css_source_file, css_output_file
    end

    def gen_arch_images(root)
      gen_arch_img_reqd = (root[:has_architecture])? true : false
        
      if gen_arch_img_reqd
        gen_one_arch_image root
      end
      if root[:has_child_definitons]
        root['to-build'].each do | child|
          child.each do |key,val|
            #puts "gen key: #{key}"
            next if !root[:new_components].has_key? key # this is not a declared component
            gen_arch_images val
          end 
        end
      end
    end

    def gen_one_arch_image(root)
        #puts "genone arch ref : #{root[:arch_ref]}"
        gv_output_file = root[:arch_ref] + '.dot'
        File.open(gv_output_file, "w+") do |gvfile|
          gvfile.puts gen_arch_img root
        end
        png_output_file = gv_output_file.sub '.dot', '.png'
        dot_done = `dot #{gv_output_file} | neato -n -s -Tpng -o#{png_output_file}`
      end
  end
end

