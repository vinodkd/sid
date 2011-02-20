require 'yaml'

module Sid
  class Sid
    def initialize(input_file, child = false)
      @child = child
      if !File.exists? input_file
        puts "Error: #{input_file} doesnt exist"
        exit
      else
        @input_file = input_file
      end
    end
    
    def process
      begin
        @spec = YAML::load(File.open(@input_file))
        @output = @spec.clone
        
      rescue TypeError => e
        puts "Error processing #{@input_file}: #{e}"
        return
      end
      
      if !@spec['to-build']
        @spec['to-build'] = {'suggestion' => 'add an application to build'}
        return
      end
      
      if(!@child) 
        process_features
        process_capabilities
        process_architecture_definition
      end
      process_required_components
      process_child_components
      p @output
    end
    
    def generate
    end
    
    private
    
    def process_features
      if !@spec['to-build']['and-features'] and !@spec['to-build']['with-features']
        @output['to-build']['with-features'] = {'suggestion'=> "add some features"} 
      end
    end

    def process_capabilities
      if !(@spec['to-build']['and-capabilities'] or @spec['to-build']['with-capabilities'])
        @output['to-build']['with-capabilities'] = {'suggestion' => "add some capabilities"} 
      end
    end

    def process_required_components
      if !@spec['to-build']['requires']
        @has_components = false
        @output['to-build']['requires'] = {'suggestion' => "add some required components"} 
      else
        @has_components = true
        process_define_tasks
        process_using
        process_building
      end
    end

    def process_define_tasks
      # TODO: figure out how to make a todo list with data here
    end
    
    def process_using
      if @spec['to-build']['requires']['using']
        # check that every child is a map
      end
    end
    
    def process_building
      # put all found components to be built for use later.
    end
    def process_architecture_definition
      if !@spec['to-build']['realizing-architecture']
        @output['to-build']['realizing-architecture'] = {'suggestion' => "add an architecture diagram using dot format"} 
      else
        process_arch_diagram
      end
    end

    def process_arch_diagram
    end
    
    def process_child_components
      if !@spec['to-build']['to-build'] and @has_components
        @output['to-build']['to-build'] = {'suggestion' => "add definitions for declared components"} 
      else
        # check if the components listed here match the ones listed in the "building" section
        # call Sid.process on them with child=true
      end
    end

  end
end