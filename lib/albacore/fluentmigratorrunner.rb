require "albacore/albacoretask"
require "albacore/config/fluentmigratorrunnerconfig"

class FluentMigratorRunner
  TaskName = :fluentmigrator
  
  include Albacore::Task
  include Albacore::RunCommand

  attr_reader   :output,
                :verbose,
                :preview

  attr_accessor :target, 
                :provider, 
                :connection, 
                :namespace, 
                :output_filename, 
                :steps, 
                :tag, 
                :task, 
                :version, 
                :script_directory, 
                :profile, 
                :timeout

  def initialize()
    super()
    update_attributes(Albacore.configuration.fluentmigrator.to_hash)
  end

  def execute()
    result = run_command("FluentMigrator", get_command_parameters)
    fail_with_message("Fluent Migrator failed, see the build log for more details.") unless result
  end

  def verbose
    @verbose = true
  end
  
  def preview
    @preview = true
  end
  
  def output
    @output = true
  end

  def get_command_parameters
    p = []
    p << "/target=\"#{@target}\""
    p << "/provider=#{@provider}"
    p << "/connection=\"#{@connection}\""
    p << "/ns=#{@namespace}" if @namespace
    p << "/out" if @output
    p << "/outfile=\"#{@output_filename}\"" if @output_filename
    p << "/preview" if @preview
    p << "/steps=#{@steps}" if @steps
    p << "/task=#{@task}" if @task
    p << "/version=#{@version}" if @version
    p << "/verbose=#{@verbose}" if @verbose
    p << "/wd=\"#{@script_directory}\"" if @script_directory
    p << "/profile=#{@profile}" if @profile
    p << "/timeout=#{@timeout}" if @timeout
    p << "/tag=#{@tag}" if @tag
    p
  end

  def get_command_line
    c = []
    c << "#{@command}"
    c << get_command_parameters
    c
  end
end
