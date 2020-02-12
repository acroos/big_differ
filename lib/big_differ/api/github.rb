require 'big_differ/api/diff'
require 'big_differ/api/regex_helpers'
require 'big_differ/api/request_helpers'
require 'faraday'
require 'uri'

module BigDiffer::Api
  class Github
    include RegexHelpers, RequestHelpers
    GITHUB_URL_REGEX = /^http(s)?\:\/\/github\.com\/(?<user>[^\/]+)\/(?<repo>[^\/]+)\/pull\/(?<request_id>[0-9]+)/

    def initialize(request_url, access_token)
      match = match_url(GITHUB_URL_REGEX, request_url)
      @user = find_group(match, 'user')
      @repo = find_group(match, 'repo')
      @request_id = find_group(match, 'request_id')
      @access_token = access_token
    end
  
  
    def fetch_diffs
      response = Faraday.get(changes_url, {}, changes_headers)
      raise parse_body(response)['message'] unless is_success?(response)
      Diff.parse_git_diff(response.body)
    end

    private
    def changes_url
      "https://api.github.com/repos/#{@user}/#{@repo}/pulls/#{@request_id}"
    end

    private
    def changes_headers
      { "Accept" => "application/vnd.github.v3.diff" }.merge(auth_header)
    end

    def auth_header
      { "Authorization" => "token #{@access_token}" }
    end
  end
end