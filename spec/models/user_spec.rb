require 'rails_helper'

RSpec.describe User, type: :model do
  let(:username) { "Lizzi" }
  let(:password) { "asdfasdf" }

  before(:each) do
    User.create!(username: username, password: password)
  end

  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }

  it { should validate_length_of(:password).is_at_least(6).on :create }

  it "should not have a password saved to db" do
    user = User.find_by_username(username)

    expect(user.password).to be_nil
  end

  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:session_token) }

  it "can confirm that a test password matches user's password" do
    user = User.find_by_username(username)

    expect(user.is_password?(password)).to be true
  end

  it "can confirm that a test password does not match user's password" do
    user = User.find_by_username(username)

    expect(user.is_password?(password + "aaaa")).to be false
  end
end
