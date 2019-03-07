require 'rails_helper'

feature 'User can remove links from his question', %q{
  In order to correct his question, as a user
  I want to be able to remove
  links from my question
} do
  given(:question) { create :question, :with_link }
  given(:user) { create(:user) }

  scenario 'User adds links when asks a question', js: true do
    sign_in question.user
    visit question_path(question)

    expect(page).to have_link 'MyString', href: "https://mylink.com/asas" 

    within '.links' do
      expect(page).to have_link 'Delete link'
      click_on 'Delete link'
      expect(page).to_not have_link "https://mylink.com/asas"
      expect(page).to_not have_link 'Delete link'
    end
  end

  scenario 'user is not the author of the question' do
    sign_in(user)
    visit question_path(question)

    within '.links' do
      expect(page).not_to have_link 'Delete link'
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(question)
    within '.links' do
      expect(page).to_not have_link 'Delete link'
    end
  end
end
