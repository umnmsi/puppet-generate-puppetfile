require 'generate_puppetfile'
require 'optparse'

module GeneratePuppetfile
  # Internal: Parse the options provided to generate-puppetfile
  class OptParser
    # Internal: Initialize the OptionParser
    #
    # Returns an OptionParser object.
    def self.parse(args)
      options = {}
      # Default values
      options[:modulename] = 'profile'
      options[:filter] = []
      options[:modulepaths] = []

      opts = OptionParser.new do |opts|
        opts.banner = 'generate-puppetfile [OPTIONS] [<MODULE> ... <MODULE>]'

        opts.on('-p', '--puppetfile FILE', 'Name of existing Puppetfile to verify and update') do |file|
          unless File.readable?(file)
            puts "\nPuppetfile '#{file}' cannot be read. Are you sure you passed in the correct filename?\n\n"
            exit 1
          end

          options[:puppetfile] = file
        end

        opts.on('-c', '--create_puppetfile', 'Create a Puppetfile in the working directory. Warning: overwrites any existing file with the same name.') do
          options[:create_puppetfile] = true
        end

        opts.on('-f', '--create-fixtures', 'Create a .fixtures.yml file in the working directory. This works in a module directory or at the top of your controlrepo.') do
          options[:create_fixtures] = true
        end

        opts.on('-m', '--modulename NAME', "Name of the module the fixtures file will be used with. Optional, for use with --create-fixtures when used in a module directory. Defaults to 'profile'.") do |name|
          options[:modulename] = name
        end

        opts.on('-l', '--latest-versions', "Use latest version of forge modules and default branch of repository modules in .fixtures.yml") do |name|
          options[:latest_versions] = true
        end

        opts.on('-f', '--filter DIR', "Skip checking DIR for .fixtures.yml modules") do |dir|
          options[:filter] << dir
        end

        opts.on('-r', '--use-refs', "Convert Puppetfile repo branches to refs") do |dir|
          options[:use_refs] = true
        end

        opts.on('-C', '--control_branch NAME', "Replace :control_branch with NAME in module definitions.") do |branch|
          options[:control_branch] = branch
        end

        opts.on('-M', '--modulepath DIR', "Check DIR for .fixtures.yml modules. Can be specified more than once.") do |dir|
          options[:modulepaths] << dir
        end

        opts.on('-s', '--silent', 'Run in silent mode. Supresses all non-debug output. Adds the -c flag automatically.') do
          options[:silent] = true
          options[:create_puppetfile] = true
        end

        opts.on('-d', '--debug', 'Enable debug logging') do
          options[:debug] = true
        end

        opts.on_tail('-i', '--ignore-comments', 'Ignore comments') do
          options[:ignore_comments] = true
        end

        opts.on_tail('--fixtures-only', 'Create a .fixtures.yml file from an existing Puppetfile. Requires the -p option.') do
          options[:fixtures_only] = true
        end

        opts.on_tail('-v', '--version', 'Show version') do
          puts "generate-puppetfile v#{GeneratePuppetfile::VERSION}"
          exit
        end
      end

      opts.parse!(args)
      options
    end
  end
end
