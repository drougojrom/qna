require 'rails_helper'

feature 'User can delete an answer for a question', %q{
  Authenticated user who is the author of the answer
  should be able to remove that answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create :answer, question: question, user: user }

  describe 'An authenticated user tries to delete an answer' do
    scenario 'user is the author of answer' do
      sign_in(user)
      visit question_path(answer.question)      
      expect(page).to have_link 'Delete'
      click_on 'Delete'
      expect(page).to have_content 'Your answer was deleted'
      expect(page).to_not have_content answer
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
  end

  scenario 'Unathenticated user tries to delete an answer' do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Delete'
    expect(current_path).to eq question_path(answer.question)
  end
end
