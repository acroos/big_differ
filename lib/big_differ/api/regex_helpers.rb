module BigDiffer::Api
  module RegexHelpers
    def match_url(regex, request_url)
      match = regex.match(request_url)
      if match.nil?
        raise "URL #{request_url} does not match the desired pattern #{regex}"
      end
      match
    end

    def find_group(regex_match, group_name)
      group = regex_match[group_name]
      if group.nil?
        raise "Could not find valid #{group_name} in URL"
      end
      group
    end
  end
end