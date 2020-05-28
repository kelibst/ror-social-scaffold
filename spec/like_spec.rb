require 'rails_helper'
require 'capybara/rspec'
describe 'Like tests', type: :feature do
  it 'Testing that users can like and like count increases by one' do
    expect { Like.create(post_id: 1, user_id: 1).save }.to change { Like.count }.by(1)
  end

  it 'expects valid like contains user post ' do
    like = FactoryBot.create(:like, user_id: 1, post_id: 1)
    expect(like).to be_valid
  end

  it 'like without user is invalid' do
    like = Like.create(post_id: 1)
    expect(like).not_to be_valid
  end

  it 'like without post is invalid' do
    like = Like.create(user_id: 1)
    expect(like).not_to be_valid
  end
end
