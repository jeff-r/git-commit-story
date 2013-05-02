require "ostruct"
require "yaml"

class GitCommitStory
  attr_reader :options

  def initialize(options)
    @config_file_name    = ".git-commit-story.yml"
    config_file_options = {}
    if File.exist?(@config_file_name)
      config_file_options = YAML.load_file(@config_file_name)
    end
    config_file_options.merge!(options)
    @options = config_file_options
  end

  def save_config_file
    File.open(@config_file_name, "w") { |f| f.puts @options.to_yaml }
  end

  def story_id
    if @options[:story_id]
      @options[:story_id]
    else
      puts "Enter a story"
      story_id = $stdin.gets
    end
  end

  def final_commit_message
    message = ""
    if options[:commit_message]
      message = options[:commit_message]
    else
      puts "Enter a commit message"
      message = $stdin.gets
    end
    "#{message}\n\nstory: #{story_id}"
  end

  def commit
    repo = Grit::Repo.new(".")
    repo.commit_index(final_commit_message)
  end
end
