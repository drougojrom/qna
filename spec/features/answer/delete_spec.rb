require 'rails_helper'

feature 'User can delete an answer for a question', %q{
  Authenticated user who is the author of the answer
  should be able to remove that answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create :answer, question: question, user: user }
  given(:answer_with_attached_file) { create :answer_with_attached_file }

  describe 'An authenticated user tries to delete an answer' do
    scenario 'user is the author of answer', js: true do
      sign_in(answer.user)
      visit question_path(answer.question)      
      expect(page).to have_link 'Delete'
      within '.answers' do
        click_on 'Delete'
        page.accept_confirm
        expect(page).to_not have_content answer.body
      end
    end

    context 'user is not the author of answer' do
      let!(:new_user) { create(:user) }
      it 'does not allow to delete an answer' do
        sign_in(new_user)
        visit question_path(answer.question)      

        expect(page).to_not have_link 'Delete'
        expect(current_path).to eq question_path(answer.question)
      end
    end

    scenario 'user is removing the attachment', js: true do
      sign_in answer_with_attached_file.user
      visit question_path(answer_with_attached_file.question)

      within '.answer' do
        expect(page).to have_link 'Remove file'
        click_on 'Remove file'
        page.accept_confirm
        expect(page).to_not have_link 'Remove file'
      end
    end
  end

  scenario 'Unathenticated user tries to delete an answer' do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Delete'
    expect(current_path).to eq question_path(answer.question)
  end
end
