module BigDiffer::Api
  class Diff
    FILE_PARSER_REGEX = /\A.*---\s(a)?\/(?<old_file>.*?)\s\+\+\+\sb\/(?<new_file>.*?)\s@@.*@@\s(?<changes>.*)\z/m

    attr_accessor :old_file, :new_file, :changes
    def initialize(old_file, new_file, changes)
      @old_file = old_file
      @new_file = new_file
      @changes = changes
    end

    def self.parse_git_diff(diff_text)
      file_diffs = diff_text.split(/^diff\s\-\-git\sa\/.*\sb\/.*$/).reject(&:empty?)
      file_diffs.map do |file_diff|
        match = parse(file_diff)
        Diff.new(match['old_file'], match['new_file'], match['changes'])
      end
    end

    def self.from_gitlab_json(json)
      changes = json['changes']
      changes.map do |change|
        match = parse(change['diff'])
        Diff.new(change['old_path'], change['new_path'], match['changes'])
      end
    end

    private
    def self.parse(file_diff)
      match = FILE_PARSER_REGEX.match(file_diff)
      if match.nil?
        raise "Could not parse file diff"
      end
      match
    end
  end
end