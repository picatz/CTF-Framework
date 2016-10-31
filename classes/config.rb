class Config
  # Um. Just make everything easily accessible for this class.
  attr_accessor :port, :ip_address, :port, :logging, :ctf_name
  attr_accessor :ssl, :ssl_options, :description, :ctf_tagline
  attr_accessor :index, :layout, :copyright, :teams, :challenges
  attr_accessor :public_scoreboard, :restrictions

  # initialize() takes in a configuration file and parses
  # out the needed information which allow the main use
  # of the Config class to function properly.
  #
  # == Example
  #
  #  # Typical use case to load configuration file "config.yaml"
  #  config = Config.new("config.yaml")
  #  => true
  #
  def initialize(config)
    if valid_config_file?(config)
      @file = config
      config = YAML.load_file(config)
    end
    @ctf_name = config[:ctf_name]
    @ctf_tagline = config[:ctf_tagline]
    @port = config[:port]
    @ip_address = config[:ip_address]
    @port = config[:port]
    @logging = config[:logging]
    @ssl = config[:ssl]
    @ssl_options = config[:ssl_options]
    @layout = config[:layout]
    @index = config[:index]
    @copyright = config[:copyright]
    @teams = config[:teams]
    @challenges = config[:challenges]
    @public_scoreboard = config[:public_scoreboard]
    @restrictions = config[:restrictions]
  end

  # valid_config_file?() takes in a configuration file
  # and will determine whether or not it is a valid
  # configuration file according to whatever I've decided.
  #
  # == Example
  #
  #  # Typical use case to validate configuration file "config.yaml"
  #  valid_config_file?("config.yaml")
  #
  def valid_config_file?(config)
    file_loadable?(config)
    file_extension?(config)
    true
  end

  # file_extension?() takes in a configuration file
  # and will determine whether or not it has the proper
  # file extension according to whatever I've decided, which
  # is a "config.yaml" file.
  #
  # == Example
  #
  #  # Typical use case to validate configuration file "config.yaml" extension
  #  file_extension?("config.yaml")
  #  => true
  #
  def file_extension?(config)
    unless File.extname(config) == ".yaml"
      puts "[error]".red + " Config file #{config.bold} does not have the proper extension '.yaml' or '.yml'"
      exit 1
    end
    true
  end

  # file_loadable?() takes in a configuration file
  # and will determine whether or not it is a loadable
  # yaml file
  #
  # == Example
  #
  #  # Typical use case to validate configuration file "config.yaml" extension
  #  file_loadable?("config.yaml")
  #  => true
  #
  def file_loadable?(config)
    begin
      !!YAML.load(config)
    rescue
      puts "[error]".red + " Config file #{config.bold} seems to be an invalid YAML file, possible syntax error"
      exit 1
    end
    true
  end

  # public_scoreboard?() helps determine if a scoreboard
  # is set to be accessible to the public or not
  #
  # == Example
  #
  #  # Typical use case to check if the scoreboard is public
  #  config = Config.new("config.yaml")
  #  config.public_scoreboard?
  #  => true
  #
  def public_scoreboard?
    @public_scoreboard ? true : false
  end

  # debug() method to be able pry into this class's behavior
  #
  # == Examples
  #
  #  # Debug the User class with the user "picat"'s information
  #  config = Config.new("config.yaml")
  #  config.debug
  #  [1] pry(#<Config>)> _
  #
  def debug
    binding.pry
  end
end
