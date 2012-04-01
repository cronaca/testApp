require 'spec_helper'

describe Comment do
  let(:user) { FactoryGirl.create(:user) }
  before { @comment = user.comments.build(content: "Lorem ipsum")}
  end

  subject { @comment }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:micropost_id)}
  it { should respond_to(:user)}
  it { should respond_to(:microposts)}
  its(:user) { should == user }
  its(:microposts) { should == micropost }
  
  it { should be_valid}
  
  describe "when user_id is not present" do
	before {@comment.user_id = nil}
	it { should_not be_valid}
  end
  
  describe "when micropost_id is not present" do
	before {@comment.micropost_id = nil}
	it { should_not be_valid}
  end
  
  describe "accessible attributes" do
	it "should not allow access to micropost_id" do
		expect do
		Comment.new(micropost_id: micropost_id)
	end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end
  end
