module Sinatra
  module App
    module Routing
      module Profile
        def self.registered(app)

          app.get '/profile' do
            require_logged_in
            @data =  session["user"].data
            erb :profile
          end

          app.get '/profile/:username' do
            require_logged_in
            redirect('/') unless UserManager.new.user_exists?(params['username'])
            @data = user_data(params['username'])
            erb :profile
          end

          app.get '/edit-profile' do
            require_logged_in
            @data = session["user"].data
            erb :edit_profile
          end

          app.post '/edit-profile' do
            require_logged_in
            if password_authenticated?(:username => session["username"], :password => params["current_password"])
              if manage_edit(session["user"], params)
                @data = session["user"].data
                @edited = true
                erb :edit_profile
              else
                @failed = true
                @data = session["user"].data
                erb :edit_profile
              end
            else
              @failed = true
              @data = session["user"].data
              erb :edit_profile
            end
          end

        end
      end
    end
  end
end
