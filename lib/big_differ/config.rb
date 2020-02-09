require 'json'

module BigDiffer
    # {
    #   name: {
    #     url: String,
    #     key: String,
    #     service: ['gitlab', 'github']
    #   }
    # }
  class Config
    SERVICE_NAMES = ['github', 'gitlab']

    def add(name, service, key, url)
      config = load_config
      if config[name]
        raise "Configuration for #{name} already exists"
      end
      
      unless SERVICE_NAMES.include? service
        raise "Invalid service name: #{service}; Must be one of [#{SERVICE_NAMES.join(',')}]"
      end

      new_config = {
        service: service,
        key: key,
        url: url || url_for_service(service)
      }
      config[name] = new_config
      
      update_config(config)
      new_config
    end

    def delete(name)
      config = load_config
      unless config[name]
        raise "No configuration for #{name} exists"
      end
      config.delete(name)
      update_config(config)
    end

    def fetch
      load_config
    end

    private
    def config_path
      ENV['BIG_DIFFER_CONFIG'] || File.join(ENV['HOME'], '.bigdiffer')
    end

    def load_config
      return {} unless File.exist? config_path
      content = File.read config_path
      JSON.parse(content)
    end

    def update_config(config)
      json = JSON.dump(config)
      File.open(config_path, 'w') do |file|
        file.write(json)
      end
    end
    
    def url_for_service(service)
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