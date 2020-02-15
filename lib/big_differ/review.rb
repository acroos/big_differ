require 'big_differ/api/api'
require 'colorize'

module BigDiffer
  class Review
    def initialize(url, config)
      @api = Api::Api.new(url, config)
    end

    def begin
      diffs = @api.fetch_diffs
      diffs.each do |diff|
        print_diff(diff)
      end
    end

    private
    def print_diff(diff)
      print_separator
      puts "FILE INFO".yellow
      print_separator
      print_file_info(diff)
      print_separator
      puts "CHANGES".yellow
      print_separator
      diff.changes.split("\n").each do |line|
        if line.start_with? '+'
          puts line.green
        elsif line.start_with? '-'
          puts line.red
        else
          puts line
        end
      end
      print_separator
    end

    def print_file_info(diff)
      unless diff.is_new?
        puts "old file:"
        puts "  path:       #{diff.old_filename}"
        puts "  mode:       #{diff.old_mode}"
        puts "  start line: #{diff.old_start_line}"
        puts "  line count: #{diff.old_line_count}"
      end

      puts "new file:"
      puts "  path:       #{diff.new_filename}"
      puts "  mode:       #{diff.new_mode}"
      puts "  start line: #{diff.new_start_line}"
      puts "  line count: #{diff.new_line_count}"
    end

    def print_separator
      separator = "=" * 100
      puts separator
    end
  end
end