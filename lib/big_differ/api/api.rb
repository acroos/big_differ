require 'big_differ/api/github'
require 'big_differ/api/gitlab'

module BigDiffer::Api
  class Api
    def initialize(url, config)
      access_token = config['key']
      @client = config['service'] == 'github' ?
        Github.new(url, access_token) :
        Gitlab.new(url, access_token)
    end

    def fetch_diffs
      @client.fetch_diffs
    end
  end
end