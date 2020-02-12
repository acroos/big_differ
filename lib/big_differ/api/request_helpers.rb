require 'json'

module BigDiffer::Api
  module RequestHelpers
    def parse_body(response)
      JSON.parse(response.body)
    end

    def is_success?(response)
      response.status >= 200 && response.status < 300
    end
  end
end