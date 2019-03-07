require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct the mistakes
  an author of answer should be able to 
  edit his answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create :answer, question: question, user: user }
  given(:gist_url) { 'https://gist.github.com/drougojrom/f58ff41d729b2065448e853d3642c6d0' }

  scenario 'Unauthenticated user can not edit an answer' do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(user)
      visit question_path(answer.question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Update'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits his answer with errors', js: true do
      sign_in user
      visit question_path answer.question

      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Update'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Body can't be blank"
    end
    scenario 'tries to edit other users answer' do
      visit question_path(answer.question)      
      expect(page).to_not have_link 'Edit'
    end
  end
end
