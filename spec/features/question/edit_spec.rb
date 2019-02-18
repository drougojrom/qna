require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct the mistakes
  an author of question should be able to 
  edit his question
} do
  given(:question) { create(:question) }

  scenario 'Unauthenticated user can not edit an question' do
    visit question_path(question)      
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(question.user)
      visit question_path(question)

      within '.question' do
        click_on 'Edit'

        fill_in 'Question title', with: 'edited question title'
        fill_in 'Question body', with: 'edited question body'
        click_on 'Update'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question body'
        expect(page).to have_content 'edited question title'
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits his question with errors', js: true do
      sign_in question.user
      visit question_path question

      click_on 'Edit'
      within '.question' do
        fill_in 'Question body', with: ''
        click_on 'Update'

        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Body can't be blank"
    end
    scenario 'tries to edit other users question' do
      visit question_path(question)      
      expect(page).to_not have_link 'Edit'
    end
  end
end
