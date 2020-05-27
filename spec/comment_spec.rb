require 'rails_helper'
require 'capybara/rspec'
describe 'Comment tests', type: :feature do
  it 'Testing that users can comment and comment count increases by one' do
    expect { Comment.create(content: 'Some comment', post_id: 1, user_id: 2).save }.to change { Comment.count }.by(1)
  end

  it 'expects valid comment contains user post and comment' do
    comment = FactoryBot.create(:comment, user_id: 1, post_id: 1)
    expect(comment).to be_valid
  end

  it 'comment without user is invalid' do
    comment = Comment.create(content: 'some contents', post_id: 1)
    expect(comment).not_to be_valid
  end

  it 'comment without post is invalid' do
    comment = Comment.create(content: 'some contents', user_id: 1)
    expect(comment).not_to be_valid
  end
end
