module Sinatra
  module App
    module Routing
      module Main
        def self.registered(app)

          app.get '/' do
            erb :index
          end

        end
      end
    end
  end
end
