# spec/models/contact.rb
require 'spec_helper'

describe Post do
  it 'has a valid factory' do
    create(:post).should be_valid
  end
  it 'is invalid without a title' do
    build(:post, title: nil).should_not be_valid
  end
  it 'is invalid without a contact' do
    build(:post, contact: nil).should_not be_valid
  end

  it 'is invalid without content' do
    build(:post, content: nil).should_not be_valid
  end
end
