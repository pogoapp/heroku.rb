module Heroku
  class API

    # GET /apps/:app/ps
    def get_ps(app)
      request(
        :expects  => 200,
        :method   => :get,
        :path     => "/apps/#{escape app}/ps"
      )
    end

    # POST /apps/:app/ps
    def post_ps(app, command, options={})
      options = { 'command' => command }.merge(options)
      request(
        :expects  => 200,
        :method   => :post,
        :path     => "/apps/#{escape app}/ps",
        :query    => ps_options(options)
      )
    end

    # POST /apps/:app/ps/restart
    def post_ps_restart(app, options={})
      request(
        :expects  => 200,
        :method   => :post,
        :path     => "/apps/#{escape app}/ps/restart",
        :query    => options
      )
    end

    # POST /apps/:app/ps/scale
    def post_ps_scale(app, type, quantity)
      request(
        :expects  => 200,
        :method   => :post,
        :path     => "/apps/#{escape app}/ps/scale",
        :query    => {
          'type'  => type,
          'qty'   => quantity
        }
      )
    end

    # POST /apps/:app/ps/stop
    def post_ps_stop(app, options)
      request(
        :expects  => 200,
        :method   => :post,
        :path     => "/apps/#{escape app}/ps/stop",
        :query    => options
      )
    end

    # PUT /apps/:app/dynos
    def put_dynos(app, dynos)
      request(
        :expects  => 200,
        :method   => :put,
        :path     => "/apps/#{escape app}/dynos",
        :query    => {'dynos' => dynos}
      )
    end

    # PUT /apps/:app/workers
    def put_workers(app, workers)
      request(
        :expects  => 200,
        :method   => :put,
        :path     => "/apps/#{escape app}/workers",
        :query    => {'workers' => workers}
      )
    end
  end
end
