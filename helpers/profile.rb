module Sinatra
  module App
    module Profile

      # manage_edit() is the main helper method for a users profile
      # which will allow them to modify their current information
      # if possible. The params are passed in a a large hash when a user
      # POSTs to edit their profile. The user parameter should be
      # of a User class to be able to work properly.
      #
      # == Example
      #
      #  # Typical use case to manage the editing options for a user passing
      #  # in the relevant params.
      #  manage_edit(user, params)
      #  => true
      #
      def manage_edit(user, params)
        # strip out any of dat nast white space
        params.each_pair { |k,v| v.strip! }
        temp_params = {}
        params.each_pair do |k,v|
          if v.empty?
            temp_params[k] = false
          else
            temp_params[k] = v
          end
        end
        params = temp_params
        edits = []

        if params["real_name"]
          edits << edit_real_name(user, params["real_name"])
        end

        if params["username"]
          edits << edit_username(user, params["username"])
        end

        if params["email"]
          edits << edit_email(user, params["email"])
        end

        if params["new_password"]
          edits << edit_password(user, params["new_password"])
        end

        # TODO: way better error handling for user and stuff
        if edits.include? false
          return false
        else
          true
        end
      end

      # edit_real_name() allows a user to edit their real name
      #
      # == Example
      #
      #  # Typical use case to edit "picat"'s real name
      #  # in the relevant params.
      #  manage_edit(user, "Kent Gruber")
      #  => true
      #
      def edit_real_name(user, real_name)
        user.real_name = real_name
        user.save_data
      end

      # edit_username() allows a user to edit their username
      #
      # == Example
      #
      #  # Typical use case to edit picat's username
      #  # in the relevant params.
      #  manage_edit(user, "blu3wing")
      #  => true
      #
      def edit_username(user, username)
        manager = UserManager.new
        if manager.user_exists?(username)
          return false
        else
          manager.remove( :username => user.username )
          user.username = username
          session["username"] = username
          session["user"] = user
          user.save_data
        end
      end

      # edit_email() allows a user to edit their username
      #
      # == Example
      #
      #  # Typical use case to edit picat's username
      #  # in the relevant params.
      #  manage_edit(user, "blu3wing")
      #  => true
      #
      def edit_email(user, email)
        if @config.restrictions[:email_regex_restriction]
          unless email =~ @config.restrictions[:email_regex_restriction]
            return false
          end
        end
        user.email = email
        user.save_data
      end

      # edit_password() allows a user to edit their password
      #
      # == Example
      #
      #  # Typical use case to edit picat's password
      #  # in the relevant params.
      #  manage_edit(user, "superstrongpassworddonothackme")
      #  => true
      #
      def edit_password(user, new_password)
        if @config.restrictions[:password_count_restriction]
          unless new_password >= @config.restrictions[:password_count_restriction].to_i
            return false
          end
        end
        user.password = user.hash_plaintext(new_password)
        user.save_data
      end

    end
  end
end
