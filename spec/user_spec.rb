require 'rails_helper'
require 'capybara/rspec'
describe 'Testing user log in capability', type: :feature do
  it 'name is require to create user' do
    user1 = User.create(id: 4, email: 'user@example.com', password: 'password')

    expect(user1).not_to be_valid
  end

  it 'password is require to create user' do
    user1 = User.create(id: 5, name: 'keli', email: 'user@example.com')

    expect(user1).not_to be_valid
  end

  it 'user should be able to create account with the right params' do
    user1 = User.create(id: 100, name: 'keli', email: 'user@example.com', password: 'password')

    expect(user1).to be_valid
  end
end
