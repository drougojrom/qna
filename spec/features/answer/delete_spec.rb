require 'rails_helper'

feature 'User can delete an answer for a question', %q{
  Authenticated user who is the author of the answer
  should be able to remove that answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create :answer, question: question, user: user }

  describe 'An authenticated user tries to delete an answer' do

  end

  scenario 'Unathenticated user tries to delete an answer' do
    visit question_path(answer.question)
    
    expect(page).to_not have_content 'Delete answer'
    expect(current_path).to eq question_path(answer.question)
  end
end
