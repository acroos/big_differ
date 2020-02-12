require 'big_differ/api/diff'
require 'big_differ/api/regex_helpers'
require 'big_differ/api/request_helpers'
require 'faraday'
require 'uri'

module BigDiffer::Api
  class Gitlab
    include RegexHelpers, RequestHelpers
    GITLAB_URL_REGEX = /^(?<base_url>.*?)\/(?<user>[^\/]+)\/(?<repo>[^\/]+)\/merge_requests\/(?<request_id>[0-9]+)/
    API_URL_PREFIX = "api/v4"

    def initialize(request_url, access_token)
      match = match_url(GITLAB_URL_REGEX, request_url)
      @base_url = find_group(match, 'base_url')
      user = find_group(match, 'user')
      repo = find_group(match, 'repo')
      @project_id = URI::encode_www_form_component("#{user}/#{repo}")
      @request_id = find_group(match, 'request_id')
      @access_token = access_token
    end

    # GET /projects/:id/merge_requests/:merge_request_iid/changes
    def fetch_diffs
      response = Faraday.get(changes_url, {}, auth_header)
      body = parse_body(response)
      raise body['message'] unless is_success?(response)
      Diff.from_gitlab_json(body)
    end

    private
    def changes_url
      "#{@base_url}/#{API_URL_PREFIX}/projects/#{@project_id}/merge_requests/#{@request_id}/changes"
    end

    def auth_header
      {'Authorization' => "Bearer #{@access_token}"}
    end
  end
end