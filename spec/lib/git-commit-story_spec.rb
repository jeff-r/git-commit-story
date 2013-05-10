require "git-commit-story"
require "yaml"

describe GitCommitStory do
  let(:config_file_name) { ".git-commit-story.yml" }

  before do
    YAML.stub(:load_file).with(config_file_name).and_return({})
    File.stub(:open).with(anything, "w")
    File.stub(:exist?).and_return(true)
    $stdin.stub(:gets)
    $stdout.stub(:puts)
    $stderr.stub(:puts)
  end

  describe "with a story id" do
    it "doesn't prompt for a story" do
      $stdout.should_not_receive(:puts)
      $stdin.should_not_receive(:gets)
      GitCommitStory.new(story_id: "anything").story_id
    end
  end

  describe "without a story id" do
    it "prompts for a story" do
      $stdout.should_receive(:print).with("Enter a story: ")
      $stdin.should_receive(:gets).and_return("story")
      gcs = GitCommitStory.new({})
      gcs.story_id
    end

    it "saves the new story id to options" do
      new_story_id = "my new story"
      $stdin.stub(:gets).and_return("#{new_story_id}\n")
      gcs = GitCommitStory.new({})
      gcs.story_id
      gcs.options[:story_id].should == new_story_id
    end

    it "includes a saved story id in the prompt" do
      gcs = GitCommitStory.new({message: "new message"})
      gcs.options[:previous_story_id] = "previous story"
      $stdout.should_receive(:print).with("Enter a story [previous story]: ")
      $stdin.should_receive(:gets).and_return("")
      gcs.story_id
    end

    it "uses the previous story id if the user presses enter" do
      gcs = GitCommitStory.new({message: "new message"})
      new_story_id = "previous story"
      gcs.options[:previous_story_id] = new_story_id
      $stdin.stub(:gets).and_return("")
      gcs.story_id
      gcs.options[:story_id].should == new_story_id
    end
  end

  it "reads .git-commit-story.yml if one exists" do
    YAML.should_receive(:load_file).with(config_file_name).and_return({foo: "bar"})
    gcs = GitCommitStory.new({})
    gcs.options[:foo].should == "bar"
  end

  it "overrides config file options with passed options" do
    YAML.should_receive(:load_file).with(config_file_name).and_return({foo: "bar", what: "ever"})
    gcs = GitCommitStory.new({foo: "baz"})
    gcs.options[:foo].should == "baz"
    gcs.options[:what].should == "ever"
  end

  it "saves its configuration to a .git-commit-story.yml" do
    mock_file = mock("file")
    options = { foo: "bar" }
    mock_file.should_receive(:puts).with(options.to_yaml.to_s)
    File.should_receive(:open).with(config_file_name, "w").and_yield(mock_file)
    GitCommitStory.new(options).save_config_file
  end

  describe "with a commit message" do
    it "adds the story id to the commit message" do
      commit_message = "the commit message"
      gcs = GitCommitStory.new(commit_message: commit_message, story_id: "whatever")
      message = "#{commit_message}\n\nstory: whatever"
      gcs.final_commit_message.should == message
    end
  end

  describe "without a commit message" do
    it "prompts for a commit message" do
      $stdout.should_receive(:print).with("Enter a commit message: ")
      $stdin.should_receive(:gets).and_return("new commit message\n")
      gcs = GitCommitStory.new(story_id: "whatever")
      gcs.final_commit_message.should == "new commit message\n\nstory: whatever"
    end
  end

  it "saves a commit" do
    gcs = GitCommitStory.new(:commit_message => "commit message", story_id: "whatever")
    shell_command_string = "git commit -m '#{gcs.final_commit_message}'"
    gcs.should_receive(:system).with(shell_command_string)
    gcs.commit
  end

  it "saves the previous story_id after a commit" do
    gcs = GitCommitStory.new(:commit_message => "commit message", story_id: "whatever")
    gcs.stub(:system)
    gcs.should_receive(:save_config_file)
    gcs.commit
    gcs.options[:previous_story_id].should == "whatever"
  end

  it "aborts a commit if the user enters an empty message" do
    gcs = GitCommitStory.new(story_id: "whatever")
    $stdin.stub(:gets).and_return("")
    $stdout.should_receive(:puts).with("No message supplied")
    expect {
      gcs.get_message_from_prompt
    }.to raise_error SystemExit
  end

  it "aborts a commit if the user enters an empty story id" do
    gcs = GitCommitStory.new(message: "whatever")
    $stdin.stub(:gets).and_return("")
    $stdout.should_receive(:puts).with("No story id was supplied")
    expect {
      gcs.story_id
    }.to raise_error SystemExit
  end

end
