require 'json'

module BigDiffer
  class Config
    BASE_URL_REGEX = /^(?<base_url>http(s)?:\/\/[^\/]+).*$/
    SERVICE_NAMES = ['github', 'gitlab']

    def self.add(service, key, url = nil)
      config = load_config
      url ||= url_for_service(service)

      if config[url]
        raise "Configuration for #{url} already exists"
      end
      
      unless SERVICE_NAMES.include? service
        raise "Invalid service: #{service}; Must be one of [#{SERVICE_NAMES.join(',')}]"
      end

      new_config = {
        service: service,
        key: key
      }
      config[url] = new_config
      
      update_config(config)
      { url: new_config }
    end

    def self.delete(url)
      config = load_config
      unless config[url]
        raise "No configuration for #{url} exists"
      end
      config.delete(url)
      update_config(config)
    end

    def self.fetch_all
      load_config
    end

    def self.fetch(url)
      config = load_config
      base_url = base_url_for(url)
      unless config[base_url]
        raise "No configuration for #{base_url} exists"
      end
      config[base_url]
    end

    private
    def self.config_path
      ENV['BIG_DIFFER_CONFIG'] || File.join(ENV['HOME'], '.bigdiffer')
    end

    def self.load_config
      return {} unless File.exist? config_path
      content = File.read config_path
      JSON.parse(content)
    end

    def self.update_config(config)
      json = JSON.dump(config)
      File.open(config_path, 'w') do |file|
        file.write(json)
      end
    end

    def self.base_url_for(url)
      match = BASE_URL_REGEX.match(url)
      if match.nil? || match['base_url'].nil?
        raise "Could not get base url for #{url}"
      end
      match['base_url']
    end
    
    def self.url_for_service(service)
      if service == 'github'
        'https://github.com'
      elsif service == 'gitlab'
        'https://gitlab.com'
      else
        raise "Cannot determine url for service #{service}"
      end
    end
  end
end