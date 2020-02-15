module BigDiffer::Api
  class Diff
    FILE_PARSER_REGEX = /\A\s*((new\sfile\smode\s*(?<new_file_mode>\d{6}).*)|(.*?(?<old_file_mode>\d{6})))\s*---\s(a)?\/(?<old_filename>.*?)\s\+\+\+\sb\/(?<new_filename>.*?)\s@@\s*\-(?<old_start_line>\d+),(?<old_line_count>\d+)\s*\+(?<new_start_line>\d+),(?<new_line_count>\d+)\s*@@\s(?<changes>.*)\z/m

    attr_accessor :new_mode, :old_mode,
        :new_filename, :old_filename,
        :new_start_line, :old_start_line,
        :new_line_count, :old_line_count,
        :changes
    def initialize(new_mode, old_mode, new_filename, old_filename,
      new_start_line, old_start_line, new_line_count, old_line_count, changes)
      @new_mode = new_mode
      @old_mode = old_mode
      @new_filename = new_filename
      @old_filename = old_filename
      @new_start_line = new_start_line
      @old_start_line = old_start_line
      @new_line_count = new_line_count
      @old_line_count = old_line_count
      @changes = changes
    end

    def is_new?
      @old_mode.nil? || @old_mode.empty?
    end

    def self.parse_git_diff(diff_text)
      file_diffs = diff_text.split(/^diff\s\-\-git\sa\/.*\sb\/.*$/).reject(&:empty?)
      file_diffs.map do |file_diff|
        match = parse(file_diff)
        new_mode = match['new_mode'] rescue nil
        old_mode = match['old_mode'] rescue nil
        Diff.new(new_mode, old_mode, match['new_filename'],
          match['old_filename'], match['new_start_line'], match['old_start_line'],
          match['new_line_count'], match['old_line_count'], match['changes'])
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