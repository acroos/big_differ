require 'thor'

module BigDiffer
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "config", "Opens up an interactive configuration session"
    method_option :key, type: :hash, aliases: '-k'
    method_option :rmkey, type: :string
    method_option :url, type: :string, aliases: '-u'
    method_option :rmurl, type: :string
    def config
    end

    desc "review URL", "Starts an interactive review"
    def review(url)
    end
  end
end