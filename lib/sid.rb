require 'yaml'
require 'erb'

module Sid
  class Sid
    def initialize(input_file, child = false)
      @child = child
      if !File.exists? input_file
        raise "#{input_file} doesnt exist"
      else
        @input_file = input_file
      end
    end
    
    def parse
      begin
        @spec = YAML::load(File.open(@input_file))
        @output = @spec.clone
      rescue Exception => e
        raise "#{@input_file} could not be parsed correctly: #{e}"
      end
    end
    
    def process
      raise "parse input file first" if !@output

      root = @output['to-build']
      if !root
        @output['to-build'] = {'suggestion' => 'add an application to build'}
        return
      end
      raise 'expected "to-build" to be a hash' if !root.instance_of? Hash
      raise 'application to be built should have a name' if !root['name']
      raise 'application to be built should have a version' if !root['version']

      if(!@child) 
        process_features root
        process_capabilities root
        process_architecture_definition root
      end
      process_required_components root
      process_child_components root
      p @output
    end
    
    def generate
      output_file = @input_file.sub '.sid', '.html' 
      tloc = File.join(File.dirname(__FILE__),'sid.erb')
      template = ERB.new(File.open(tloc).read(),nil,'<>')
      
      File.open(output_file,"w+") do |outfile|
        outfile.puts template.result(binding)
      end
      
    end
    
    private
    
    def process_features(root)
      with_features = root['with-features']
      and_features  = root['and-features']
      if !and_features and !with_features
        root['features'] = [{'suggestion' => 'add some features'}] 
      elsif with_features
        root['features']=with_features
      elsif and_features
        root['features']=and_features
      end
    end

    def process_capabilities(root)
      with_capabilities = root['with-capabilities']
      and_capabilities = root['and-capabilities']
      if !(root['and-capabilities'] or root['with-capabilities'])
        root['capabilities'] = [{'suggestion' => "add some capabilities"}] 
      elsif with_capabilities
        root['capabilities']=with_capabilities
      elsif and_capabilities
        root['capabilities']=and_capabilities
      end
    end

    def process_required_components(root)
      if !root['requires']
        @has_components = false
        root['requires'] = {'suggestion' => "add some required components"} 
      else
        @has_components = true
      end
      requires = root['requires']
      process_define_tasks requires
      process_using requires
      process_building requires
    end

    def process_define_tasks(requires)
      p requires
      # TODO: figure out how to make a todo list with data here
      if !requires['defining']
        @has_definition_tasks = false
      else
        @has_definition_tasks = true
      end
    end
    
    def process_using(requires)
      if !requires['using']
        @has_existing_components = false
        # check that every child is a map
      else
        @has_existing_components = true
      end
    end
    
    def process_building(requires)
      if !requires['building']
        @has_new_components = false
        # put all found components to be built for use later.
      else
        @has_new_components = true
      end
    end
    def process_architecture_definition(root)
      if !root['realizing-architecture']
        @has_architecture = false
        root['realizing-architecture'] = [{'suggestion' => "add an architecture diagram using dot format"}] 
      else
        @has_architecture = true
        process_arch_diagram root['realizing-architecture']
      end
    end

    def process_arch_diagram(arch)
    end
    
    def process_child_components(root)
      if !root['to-build'] and @has_components
        @has_child_definiitons = false
        root['to-build'] = [{'suggestion' => "add definitions for declared components"}] 
      else
        @has_child_definiitons = false
        # check if the components listed here match the ones listed in the "building" section
        # call Sid.process on them with child=true
      end
    end

  end
end