require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  as an author of question
  I want to be able to add links
} do
  given(:user) { create :user }
  given(:gist_url) { 'https://gist.github.com/drougojrom/f58ff41d729b2065448e853d3642c6d0' }

  scenario 'User adds links when asks a question' do
    sign_in user
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
