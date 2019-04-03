require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  as an author of answer
  I want to be able to add links
} do
  given(:user) { create :user }
  given(:gist_url) { 'https://google.com/sas' }
  given(:question) { create :question }

  scenario 'User adds links when he answers on the question', js: true do
    sign_in user
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'text text text'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Answer'
    end
    expect(page).to have_link 'My gist', href: gist_url
  end
end
