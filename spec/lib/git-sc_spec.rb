require "git-sc"

describe GitSc do
  it "initializes" do
    GitSc.run.should == "Hola"
  end

  it "reads the committer from the git config"
  it "initializes .git-sc if none exists"
  it "reads .git-sc if one exists"
  it "prompts for a story"
  it "gets the story from the user"
  it "makes a commit message"
  it "saves a commit"
end
