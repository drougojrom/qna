require 'rails_helper'

feature 'User can delete a question', %q{
  If the user is an author of the question
  he should be able to delete it 
  from the platform
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:question_with_attached_file) { create(:question_with_attached_file) }

  describe 'An authenticated user tries to delete a question' do
    scenario 'user is the author of the question' do
      sign_in(question.user)
      visit question_path(question)

      expect(page).to have_link 'Delete'
      click_on 'Delete'
      expect(page).to have_content 'Your question was deleted'
      expect(page).to_not have_content question.body     
      expect(page).to_not have_content question.title
    end

    scenario 'user is not the author of the question' do
      sign_in(user)
      visit question_path(question)

      expect(page).not_to have_link 'Delete'
      expect(current_path).to eq question_path(question)
    end

    scenario 'user is removing the attachment', js: true do
      sign_in question_with_attached_file.user
      visit question_path(question_with_attached_file)

      within '.question' do
        expect(page).to have_link 'Remove file'
        file_url = url_for(question_with_attached_file.files.first)
        click_on 'Remove file'
        page.accept_confirm
        expect(page).to_not have_link 'Remove file'
        expect(page).to_not have_link file_url
      end
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end
