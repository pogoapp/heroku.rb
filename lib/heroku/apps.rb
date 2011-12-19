module Heroku
  class Connection < Excon::Connection
    APP_REGEX = %r{/apps/([^/]+)}

    # DELETE /apps/:name
    def delete_app(name)
      request(:expects => 200, :method => :delete, :path => "/apps/#{name}")
    end

    # stub DELETE /apps/:name
    Excon.stub(:expects => 200, :method => :delete, :path => APP_REGEX) do |params|
      request_params, mock_data = parse_stub_params(params)
      name = APP_REGEX.match(data[:path]).captures.first
      if app = mock_data[:apps].detect {|app| app['name'] == name}
        mock_data[:apps].delete(app)
        {
          :body   => Heroku::OkJson.encode({}),
          :status => 200
        }
      else
        {
          :body   => 'App not found.',
          :status => 404
        }
      end
    end

    # GET /apps
    def get_apps
      request(:expects => 200, :method => :get, :path => "/apps")
    end

    # stub GET /apps/
    Excon.stub(:expects => 200, :method => :get, :path => '/apps') do |params|
      request_params, mock_data = parse_stub_params(params)
      {
        :body   => Heroku::OkJson.encode(mock_data[:apps]),
        :status => 200
      }
    end

    # GET /apps/:name
    def get_app(name)
      request(:expects => 200, :method => :get, :path => "/apps/#{name}")
    end

    # stub GET /apps/:name
    Excon.stub(:expects => 200, :method => :get, :path => APP_REGEX) do |params|
      request_params, mock_data = parse_stub_params(params)
      name = APP_REGEX.match(data[:path]).captures.first
      if app = mock_data[:apps].detect {|app| app['name'] == name}
        {
          :body   => Heroku::OkJson.encode(app),
          :status => 200
        }
      else
        {
          :body   => 'App not found.',
          :status => 404
        }
      end
    end

    # POST /apps
    def post_app(params={})
      request(:body => {'app' => params}, :expects => 202, :method => :post, :path => '/apps')
    end

    # stub POST /apps
    Excon.stub(:expects => 202, :method => :post, :path => '/apps') do |params|
      request_params, mock_data = parse_stub_params(params)
      name = request_params[:body]['app[name]'].first || "generated-name-#{rand(999)}"

      if mock_data[:apps].detect {|app| app['name'] == name}
        {
          :body => Heroku::OkJson.encode('error' => 'Name is already taken'),
          :status => 422
        }
      else
        app = {
          'created_at'          => Time.now.strftime("%G/%d/%m %H:%M:%S %z"),
          'create_status'       => 'complete',
          'id'                  => rand(99999),
          'name'                => name,
          'owner_email'         => 'email@example.com',
          'stack'               => request_params['app[stack]'].first || 'bamboo-mri-1.9.2',
          'slug_size'           => nil,
          'requested_stack'     => nil,
          'git_url'             => "git@heroku.com:#{name}.git",
          'repo_migrate_status' => 'complete',
          'repo_size'           => nil,
          'dynos'               => 0,
          'web_url'             => "http://#{name}.herokuapp.com/",
          'workers'             => 0

        }

        mock_data[:apps] << app
        {
          :body   => Heroku::OkJson.encode(app),
          :status => 202
        }
      end
    end

    # POST /apps/:name/server/maintenance
    def post_app_server_maintenance(name, new_server_maintenance)
      body = "maintenance_mode=#{new_server_maintenance}"
      request(:body => body, :expects => 200, :method => :post, :path => "/apps/#{name}/server/maintenance")
    end

    # stub POST /apps/:name/server/maintenance
    Excon.stub(:expects => 200, :method => :post, :path => %r{#{APP_REGEX}/server/maintenance}) do |params|
      request_params, mock_data = parse_stub_params(params)
      name = %r{#{APP_REGEX}/server/maintenance}.match(data[:path]).captures.first

      app = mock_data[:apps].detect {|app| app['name'] == name}

      if app.nil?
        case request_params[:body]['maintenance_mode'].first
        when '0'
          mock_data[:body][:maintenance_mode] -= [name]
        when '1'
          mock_data[:body][:maintenance_mode] |= [name]
        end

        {
          :status => 200
        }
      else
        {
          :body => Heroku::OkJson.encode('error' => 'App not found.'),
          :status => 404
        }
      end
    end

    # PUT /apps/:name
    def put_app(name, params)
      request(:body => {'app' => params}, :expects => 200, :method => :put, :path => "/apps/#{name}")
    end

    # stub PUT /apps/:name
    Excon.stub(:expects => 200, :method => :put, :path => APP_REGEX) do |params|
      request_params, mock_data = parse_stub_params(params)
      name = APP_REGEX.match(data[:path]).captures.first

      if app = mock_data[:apps].detect {|app| app['name'] == name}
        app['name'] = request_params[:body]['app[name]']
        {
          :body   => Heroku::OkJson.encode('name' => request_params['app[name]']),
          :status => 200
        }
      else
        {
          :body   => 'App not found.',
          :status => 404
        }
      end
    end

  end
end
