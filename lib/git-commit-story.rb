require "ostruct"
require "yaml"

class GitCommitStory
  attr_reader :options

  def initialize(options)
    @config_file_name    = ".git-commit-story.yml"
    config_file_options = options_from_config_file
    config_file_options.merge!(options)
    @options = config_file_options
  end

  def options_from_config_file
    if File.exist?(@config_file_name)
      config_file_options = YAML.load_file(@config_file_name)
    else
      {}
    end
  end

  def save_config_file
    File.open(@config_file_name, "w") { |f| f.puts @options.to_yaml }
  end

  def story_id
    if @options[:story_id]
      @options[:story_id]
    else
      prompt = if @options[:previous_story_id]
        "Enter a story [#{@options[:previous_story_id]}]: "
      else
        "Enter a story: "
      end
      $stdout.print prompt
      response = $stdin.gets.strip
      if response == ""
        if @options[:previous_story_id]
          @options[:story_id] = @options[:previous_story_id]
        else
          puts "No story id was supplied"
          abort
        end
      else
        @options[:story_id] = response
      end
    end
  end

  def final_commit_message
    message = ""
    if options[:commit_message]
      message = options[:commit_message]
    else
      message = get_message_from_prompt
    end
    "#{message}\n\nStory: #{story_id}"
  end

  def get_message_from_prompt
    $stdout.print "Enter a commit message: "
    message = $stdin.gets
    if message.length == 0
      puts "No message supplied"
      abort
    end
    message.strip
  end

  def commit
    message = %Q(git commit -m "#{final_commit_message}")
    result = system(message)
    options[:previous_story_id] = story_id
    save_config_file
  end
end
