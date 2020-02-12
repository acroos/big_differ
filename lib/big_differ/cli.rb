require 'colorize'
require 'pp'
require 'thor'
require 'big_differ/config'
require 'big_differ/review'

module BigDiffer
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "config ACTION", "Add or remove configurations"
    option :service, type: :string, aliases: '-s'
    option :key, type: :string, aliases: '-k'
    option :url, type: :string, aliases: '-u'
    def config(action)
      case action
      when 'add'
        service = options[:service]
        key = options[:key]
        url = options[:url]
        added = BigDiffer::Config.add(service, key, url)
        puts "Added configuration for #{added[:url]}"
        pp added
      when 'delete'
        url = options[:url]
        BigDiffer::Config.delete(url)
        puts "Deleted configuration for #{url}"
      when 'list'
        configs = BigDiffer::Config.fetch_all || []
        pp configs
      else
        raise "Invalid action #{action}; Expected one of [add, delete, list]"
      end
    end

    desc "review URL", "Starts an interactive review"
    def review(url)
      config = BigDiffer::Config.fetch(url)
      current_review = BigDiffer::Review.new(url, config)
      current_review.begin
    end
  end
end