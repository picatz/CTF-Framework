module Sinatra
  module App
    module Routing
      module Sessions
        def self.registered(app)

          app.get '/login' do
            erb :login
          end

          app.post '/login' do
            if user_login(params)
              session[:username] = params["username"]
              session[:user] = User.new
              session[:user].load_data(params["username"])
              @session = session
              erb :index
            else
              @failed = true
              erb :login
            end
          end

          app.get '/register' do
            erb :register
          end

          app.post '/register' do
            if user_register(params)
              session[:username] = params["username"]
              session[:user] = User.new
              session[:user].load_data(params["username"])
              @session = session
              erb :index
            else
              @failed = true
              erb :register
            end
          end

          app.get '/logout' do
            session[:username] = nil
            erb :logout
          end




        end
      end
    end
  end
end
