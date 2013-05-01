module Heroku
  class API

    def get_stack(app)
      request(
        :expects  => 200,
        :method   => :get,
        :path     => "/apps/#{escape app}/stack"
      )
    end

    def put_stack(app, stack)
      request(
        :body     => stack,
        :expects  => 200,
        :method   => :put,
        :path     => "/apps/#{escape app}/stack"
      )
    end

  end
end
