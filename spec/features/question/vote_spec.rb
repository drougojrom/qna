require 'rails_helper'

feature 'Vote for a question', %q{
  In order to show the importance of
  the question I as a user
  want to be able to vote for that 
  question
} do
  given(:user) { create :user }
  given(:another_user) { create :user }
  given(:question) { create :question }

  context 'authenticated user' do

  end

  context 'unathentocated user' do
    scenario 'can not vote', js: true do
      visit question_path question
      expect(page).to have_css("#vote_for_question_#{question.id}.disabled")
      expect(page).to have_css("#vote_against_question_#{question.id}.disabled")
      expect(page).to have_css("#vote_revoke_question_#{question.id}.disabled")
    end
  end
end
