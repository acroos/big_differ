require 'big_differ/api/api'

module BigDiffer
  class Review
    def initialize(url, config)
      @api = Api::Api.new(url, config)
    end

    def begin
      diffs = @api.fetch_diffs
      diffs.each do |diff|
        puts diff.changes
      end
    end
  end
end