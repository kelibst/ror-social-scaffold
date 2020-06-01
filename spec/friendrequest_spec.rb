require 'rails_helper'
require 'capybara/rspec'

describe 'Friend request testging', type: :feature do
  before :each do
    a = User.new(name: 'gajksj', email: 'user@example.com', password: 'password1234')
    a.save
    b = User.new(name: 'gfdgsj', email: 'ali@example.com', password: 'password1234')
    b.save
    c = Friendship.new(user_id: 1, friend_id: 2, confirmed: false)
    c.save
    visit '/users/sign_in'
    within('main') do
      fill_in 'user[email]', with: 'user@example.com'
      fill_in 'user[password]', with: 'password1234'
    end
    click_button 'commit'
  end
  it 'friend request page' do
    visit '/users'
    expect(page).to have_content 'Send request'
  end
  it 'sends request' do
    visit 'users'
    first(:link, 'Send request').click

    expect(page).to have_content 'Cancel request'
  end

  it 'redirects logged in users request' do
    visit '/users/sign_in'
    expect(page).to have_content 'You are already signed in.'
  end

  it 'Testing that friend request hit the database' do
    visit 'users'
    expect { first(:link, 'Send request').click }.to change { Friendship.count }.by(1)
  end

  it 'Testing that friend cancel hits the database' do
    visit 'users'
    first(:link, 'Send request').click
    expect { first(:link, 'Cancel request').click }.to change { Friendship.count }.by(-1)
  end
end
