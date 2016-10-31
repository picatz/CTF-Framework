module Sinatra
	module App
		module Routing
			module Errors
				def self.registered(app)
					app.error do
						#"Y U NO WORK?"
						erb :error
					end

					app.not_found do
						erb :error
						#halt 404, "Whoops! You requested a route that wasn't available."
					end
				end
			end
		end
	end
end

