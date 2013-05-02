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
  end

  describe "with a story id" do
    it "doesn't prompt for a story" do
      $stdout.should_not_receive(:puts)
      $stdin.should_not_receive(:gets)
      GitCommitStory.new(story_id: "anything").options[:story_id]
    end
  end

  describe "without a story id" do
    it "prompts for a story" do
      $stdout.should_receive(:puts)
      $stdin.should_receive(:gets)
      gcs = GitCommitStory.new({})
      gcs.story_id
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
    puts options.to_yaml.to_s
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
      $stdout.should_receive(:puts).with("Enter a commit message")
      $stdin.should_receive(:gets).and_return("new commit message")
      gcs = GitCommitStory.new(story_id: "whatever")
      gcs.final_commit_message.should == "new commit message\n\nstory: whatever"
    end
  end

  it "saves a commit"
  it "reads the committer from the git config"
end
