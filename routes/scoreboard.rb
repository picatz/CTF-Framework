module Sinatra
  module App
    module Routing
      module Scoreboard
        def self.registered(app)

          app.get '/scoreboard' do
            if username
              @scores = @manager.load_scores
              erb :scoreboard
            else
              if @config.public_scoreboard?
                @scores = @manager.load_scores
                erb :scoreboard
              else
                redirect('/')
              end
            end
          end

          app.get '/scoreboard/:team' do
            if username
              @scores = @manager.load_scores(:team => params["team"])
              erb :scoreboard
            else
              if @config.public_scoreboard?
                @scores = @manager.new.load_scores(:team => params["team"])
                erb :scoreboard
              else
                redirect('/')
              end
            end
          end


        end
      end
    end
  end
end
