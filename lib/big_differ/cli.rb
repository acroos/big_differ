require 'colorize'
require 'pp'
require 'thor'
require 'big_differ/config'
require 'big_differ/review'

module BigDiffer
  class CLI < Thor
    @@config = BigDiffer::Config.new
    def self.exit_on_failure?
      true
    end

    desc "config ACTION", "Add or remove configurations"
    option :name, type: :string, aliases: '-n'
    option :service, type: :string, aliases: '-s'
    option :key, type: :string, aliases: '-k'
    option :url, type: :string, aliases: '-u'
    def config(action)
      case action
      when 'add'
        name = options[:name]
        service = options[:service]
        key = options[:key]
        url = options[:url]
        added = @@config.add(name, service, key, url)
        puts "Added configuration for #{name}"
        pp added
      when 'delete'
        name = options[:name]
        @@config.delete(name)
        puts "Deleted configuration for #{name}"
      when 'list'
        configs = @@config.fetch || []
        pp configs
      else
        raise "Invalid action #{action}; Expected one of [add, delete, list]"
      end
    end

    desc "review URL", "Starts an interactive review"
    def review(url)
      current_review = BigDiffer::Review.new(url)
    end
  end
end