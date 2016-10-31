module Sinatra
  module App
    module Routing
      module Challenges
        def self.registered(app)

          app.post '/challenge/:name' do
            require_logged_in
            if @manager.challenge_exists?(params['name'])
              if @manager.got_flag?(params['name'], params['flag'])
                if session[:user].already_completed_challenge?( :challenge => params['name'] )
                  @already_completed = true
                  erb :challenges
                else
                  session[:user].add_completed_challenge( :challenge => params['name'] )
                  session[:user].add_points( :points => 100 )
                  @completed = true
                  erb :challenges
                end
              else
                @failed = true
                @challenge = @manager.load_challenges(:name => params['name'], :count => 1 )
                erb :challenge
              end
            end
          end

          app.get '/challenges' do
            require_logged_in
            erb :challenges
          end

          app.get '/challenge/:name' do
            require_logged_in
            if @manager.challenge_exists?(params['name'])
              @challenge = @manager.load_challenges(:name => params['name'], :count => 1 )
              if session[:user].already_completed_challenge?( :challenge => params['name'] )
                @already_completed = true
              end
              erb :challenge
            else
              redirect('/challenges')
            end
          end
        end
      end
    end
  end
end
