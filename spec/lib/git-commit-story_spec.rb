require "git-commit-story"

describe GitCommitStory do
  it "initializes" do
    GitCommitStory.run.should == "Hola"
  end

  it "reads the committer from the git config"
  it "initializes .git-sc if none exists"
  it "reads .git-sc if one exists"
  it "prompts for a story"
  it "gets the story from the user"
  it "makes a commit message"
  it "saves a commit"
end
