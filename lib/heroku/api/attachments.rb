module Heroku
  class API

    # GET /apps/:app/attachments
    def get_attachments(app)
      request(
        :expects => 200,
        :method => :get,
        :path => "/apps/#{escape app}/attachments"
      )
    end

  end
end
