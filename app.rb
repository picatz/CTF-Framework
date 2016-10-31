#!/usr/bin/env ruby
#
# Author::    Kent 'picat' Gruber
# Copyright:: Copyright (c) 2016 Kent Gruber
# License::   MIT

# Require Gems
require 'sinatra/base'
require 'rack/protection'
require 'rack/ssl'
#require 'rack/reverse_proxy'
require 'rack-ssl-enforcer'
require 'thin'
require 'yaml'
require 'logger'
require 'trollop'
require 'colorize'
require 'bcrypt'
require 'securerandom'
require 'pry'

# Require Custom Classes
require_relative 'classes/config'
require_relative 'classes/user'
require_relative 'classes/user_manager'
require_relative 'classes/challenge'
require_relative 'classes/challenge_manager'
require_relative 'classes/engine'

# Require Custom Helpers
require_relative 'helpers/helpers'
require_relative 'helpers/authentication'
require_relative 'helpers/profile'

# Require Custom Routes
require_relative 'routes/main'
require_relative 'routes/profile'
require_relative 'routes/sessions'
require_relative 'routes/scoreboard'
require_relative 'routes/challenges'
require_relative 'routes/errors'

# Main CTF class
class CTF < Sinatra::Base

  before do
    @config = Config.new("config.yaml")
    @manager = UserManager.new
  end

  # Configurations for the application
  configure do
    @user = User.new
    @config = Config.new("config.yaml")
    set :title, @config.ctf_name
    set :environment, :production
    set :bind, @config.ip_address
    set :port, @config.port
    enable :logging
    set :server, :thin
    server.threaded = settings.threaded if server.respond_to? :threaded=
    enable :sessions
    set :root, File.dirname(__FILE__)
    use Rack::SSL if @config.ssl
    use Rack::SslEnforcer if @config.ssl
    use Rack::Deflater
    helpers  Sinatra::App::Authentication
    helpers  Sinatra::App::Helpers
    helpers  Sinatra::App::Profile
    register Sinatra::App::Routing::Main
    register Sinatra::App::Routing::Profile
    register Sinatra::App::Routing::Scoreboard
    register Sinatra::App::Routing::Challenges
    register Sinatra::App::Routing::Sessions
    register Sinatra::App::Routing::Errors
  end

  def self.run!
    super do |server|
      if @config.ssl
        server.ssl = true
        server.ssl_options = {
          :cert_chain_file  => File.dirname(__FILE__) + "/#{@config.ssl_options[:cert_chain_file]}",
          :private_key_file => File.dirname(__FILE__) + "/#{@config.ssl_options[:private_key_file]}",
          :verify_peer      => @config.ssl_options[:verify_peer]
        }
      else
        # who needs ssl anyway?
      end
    end
  end
end

# Default option to help menu if nothing is set.
foo = ARGV[0] || ARGV[0] = '-h'

# Available options.
opts = Trollop::options do
  banner "CTF".red.bold + " FRAMEWORK".white
  version "CTF FRAMEWORK Web App v 1.0"
  opt :run, "Run the application"
  opt :edit, "Edit configuration file"
end

if opts[:edit]
  config = Config.new("config.yaml")
  puts "SUPRISE, THIS ISN'T FINNISHED YET!".red.bold
  puts "You can edit the config file with pry for now if you want?"
  binding.pry
end

if opts[:run]
  CTF.run!
end
