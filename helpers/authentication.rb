module Sinatra
  module App
    module Authentication

      # user_login() allows a user to login if
      # that params containing a "username" that
      # exists and the "password" param matches
      # that of the user that is being logged in
      # to or not.
      #
      # == Example
      #
      #  # Typical use case to edit picat's password
      #  # in the relevant params.
      #  user_login(params)
      #  => true
      #
      def user_login(params)
        users = UserManager.new
        if users.user_exists?(params["username"])
          user = User.new
          user.load_data(params["username"], true)
          user.password_match?(params["password"])
        else
          false
        end
      end

      # password_authenticated?() checks if a user
      # is authenticated like the user_login but for
      # verifying the authentication of a user that
      # is already logged in to edit their profile.
      #
      # == Example
      #
      #  # Typical use
      #  password_authenticated?(:username => "picat", :password => "password123")
      #  => true
      #
      def password_authenticated?(params)
        user = User.new
        user.load_data(params[:username], true)
        user.password_match?(params[:password])
      end

      # user_register() allows the registration of a new user
      # if the username or email doesn't already exist.
      #
      # == Example
      #
      #  # Typical use case to register a new user
      #  user_register(params)
      #  => true
      #
      def user_register(params)
        users = UserManager.new
        if users.user_exists?(params["username"]) or users.email_exists?(params["email"])
          false
        else
          params = cleanse_params(params)
          if verify_params( :all => params )
            create_user(params, request)
            true
          else
            false
          end
        end
      end

      # create_user() allows the creation of a new user
      # but dosen't do any checks, which is the job of
      # the user user_register() method and the verify_params()
      # method.
      #
      # == Example
      #
      #  # Typical use case to create a new user, hopefully
      #  # with the proper checks to prevent conflicting data
      #  create_user(params, request)
      #  => true
      #
      def create_user(params, request)
        user = User.new
        user.create(request, params["real_name"], params["username"], params["password"], params["email"], params["team"])
        # TODO: Add e-mail or slack-chat authentication
        # send_verifcation_link
      end

      # cleanse_params() will remove extra white space for params
      # by iterating over the values over the params passed into the method
      #
      # == Example
      #
      #  # Typical use case to cleanse params
      #  # with the proper checks to prevent conflicting data
      #  cleanse_params(params)
      #  => returns cleansed params as a hash
      #
      def cleanse_params(params)
        cleansed_params = {}
        params.each do |k,v|
          cleansed_params[k] = v.strip
        end
        cleansed_params
      end

      # cleanse_params() will verify cleansed params which
      # will check the configuration file and check if the params
      # match the restrictions in the config file.
      #
      # == Example
      #
      #  # Typical use case to verify params
      #  # with the proper checks to prevent conflicting data
      #  verify_params(params)
      #  => true
      #
      def verify_params(params)
        if params[:all]
          if @config.restrictions[:email_regex_restriction]
            unless params[:all]["email"] =~ @config.restrictions[:email_regex_restriction]
              binding.pry
              return false
            end
          end
          if @config.restrictions[:password_count_restriction]
            unless params[:all]["password"].split('').count >= @config.restrictions[:password_count_restriction].to_i
              binding.pry
              return false
            end
          end
        elsif params[:email]
          if @config.restrictions[:email_regex_restriction]
            unless params[:email] =~ @config.restrictions[:email_regex_restrict]
              binding.pry
              return false
            end
          end
        elsif params[:password]
          if @config.restrictions[:password_count_restriction]
            unless params[:password].split('').count >= @config.restrictions[:password_count_restriction].to_i
              binding.pry
              return false
            end
          end
        end
        true
      end

    end
  end
end
