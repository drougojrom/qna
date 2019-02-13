require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct the mistakes
  an author of question should be able to 
  edit his question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Unauthenticated user can not edit an question' do
    visit question_path(question)      
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        fill_in 'Body', with: 'edited question'
        click_on 'Update'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits his answer with errors' do
      sign_in user
      visit question_path question

      click_on 'Edit'
      within '.question' do
        fill_in 'Body', with: ''
        click_on 'Update'

        expect(page).to have_content answer.body
        expect(page).to_not have_content ''
        expect(page).to have_selector 'textarea'
      end
    end
    scenario 'tries to edit other users question' do
      visit question_path(question)      
      expect(page).to_not have_link 'Edit'
    end
  end
end
