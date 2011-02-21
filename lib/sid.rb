require 'yaml'
require 'generate'

module Sid
  class Sid
    def initialize(input_file)
      if !File.exists? input_file
        raise "#{input_file} doesnt exist"
      else
        @input_file = input_file
      end
      @new_components = {}
    end
    
    def parse
      begin
        @spec = YAML::load(File.open(@input_file))
        return @spec.clone
      rescue Exception => e
        raise "#{@input_file} could not be parsed correctly: #{e}"
      end
    end
    
    def process(output, child = false)
      raise "parsed input file required" if !output

      root = output['to-build']
      if !root
        output['to-build'] = {'suggestion' => 'add an application to build'}
        return
      end
      raise 'expected "to-build" to be a hash' if !root.instance_of? Hash
      raise 'application to be built should have a name' if !root['name']
      raise 'application to be built should have a version' if !root['version']

      if(!child) 
        process_features root
        process_capabilities root
        process_architecture_definition root
      end
      process_required_components root
      process_child_components root
      output
    end
    
    def generate(output)
      output_file = @input_file.sub '.sid', '.html' 
      generator = Generator.new output_file,output
      generator.generate 
    end
    
    private
    
    def process_features(root)
      with_features = root['with-features']
      and_features  = root['and-features']
      if !and_features and !with_features
        root['features'] = [{'suggestion' => 'add some features'}] 
      end

      raise "only one features section allowed" if with_features and and_features
      root['features']=with_features if with_features
      root['features']=and_features if and_features
    end

    def process_capabilities(root)
      with_capabilities = root['with-capabilities']
      and_capabilities  = root['and-capabilities']
      if !(root['and-capabilities'] or root['with-capabilities'])
        root['capabilities'] = [{'suggestion' => "add some capabilities"}] 
      end
      raise "only one capabilities section allowed" if with_capabilities and and_capabilities
      
      root['capabilities']=with_capabilities  if with_capabilities
      root['capabilities']=and_capabilities if and_capabilities
    end

    def process_required_components(root)
      if !root['requires']
        root[:has_components] = false
        root['requires'] = {'suggestion' => "add some required components"} 
      else
        root[:has_components] = true
      end
      requires = root['requires']
      process_define_tasks requires, root
      process_using requires, root
      process_building requires, root
    end

    def process_define_tasks(requires,root)
      #p requires
      # TODO: figure out how to make a todo list with data here
      if !requires['defining']
        root[:has_definition_tasks] = false
      else
        root[:has_definition_tasks] = true
      end
    end
    
    def process_using(requires,root)
      if !requires['using']
        root[:has_existing_components] = false
      else  # check that every child is a map, if not add a suggestion to make it one.
        root[:has_existing_components] = true
        requires['using'].each do |c|
          if !c.instance_of? Hash
            c = {c => {'suggestion'=> "define this component"}}
          end
        end
      end
    end
    
    def process_building(requires,root)
      if !requires['building']
        root[:has_new_components] = false
      else  # put all found components to be built for use later.
        root[:has_new_components] = true
        root[:new_components] ={}
        requires['building'].each do |c|
          if !c.instance_of? Hash
            c = {c => {'suggestion'=> "define this component"}}
          else
            root[:new_components][c] = false  # ie, add the component, and false => we've not yet validated its defn yet.
          end
        end
      end
    end
    
    def process_architecture_definition(root)
      if !root['realizing-architecture']
        root[:has_architecture] = false
        root['realizing-architecture'] = [{'suggestion' => "add an architecture diagram using dot format"}] 
      else
        root[:has_architecture] = true
        root[:arch_ref] = @input_file.sub '.sid','.png'
        process_arch_diagram root['realizing-architecture']
      end
    end

    def process_arch_diagram(arch)
      # nothing to do for now, but in future i could put in the nodes here as well
    end
    
    def process_child_components(root)
      # ||to-build found? || components declared? || outcome
      # |     N           |       N               |   no action reqd
      # |     N           |       Y               |   suggest adding defns
      # |     Y           |       N               |   suggest adding decls
      # |     N           |       N               |   confirm they match, then process the children
      to_build_found = root['to-build']
      components_declared = root[:has_components]
      root[:has_child_definitons] = (to_build_found)? true : false
      
      return if !to_build_found and !components_declared 
      
      if !to_build_found and components_declared
        root['to-build'] = [{'suggestion' => "add definitions for declared components"}] 
      elsif to_build_found and !components_declared 
        root['to-build'] = [{'suggestion' => "add declarations for declared components"}] 
      else
        # check if the components listed here match the ones listed in the "building" section
        root['to-build'].each do | child|
          if !root[:new_components].has_key? child # this is not a declared component
            child['suggestion']="this component is not defined above. Should it be?"
          end
          root[:new_components][child]=true
          # TODO: call Sid.process on them with child=true
        end
        # now deal with components declared, but not defined
        root[:new_components].each_pair() do |k,v|
          root['to-build'].push({"suggestion" =>"#{k} is declared, but not defined. Do you want to?"}) if !v
        end
      end
    end
  end
end