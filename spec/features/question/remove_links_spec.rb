require 'rails_helper'

feature 'User can remove links from his question', %q{
  In order to correct his question, as a user
  I want to be able to remove
  links from my question
} do
  given(:question) { create :question, :with_link }

  scenario 'User adds links when asks a question', js: true do
    sign_in question.user
    visit question_path(question)

    expect(page).to have_link 'MyString', href: "MyString"

    within '.links' do
      expect(page).to have_link 'Delete link'
      click_on 'Delete link'
      expect(page).to_not have_link 'MyString'
    end
  end
end
