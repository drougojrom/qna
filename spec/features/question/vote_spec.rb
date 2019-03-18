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
    before do
      sign_in user
      visit question_path question
    end

    scenario 'two users increase rating on 2 by 1', js: true do
      within "#rating_question_#{question.id}" do
        expect(page).to have_content('0')
      end
      click_on('Vote up')
      within "#rating_question_#{question.id}" do
        expect(page).to have_content('1')
      end
      sign_out
      sign_in another_user
      visit question_path question
      click_on('Vote up')
      within "#rating_question_#{question.id}" do
        expect(page).to have_content('2')
      end
    end

    scenario 'can not vote twice', js: true do
      expect(page).to_not have_css("#vote_for_question_#{question.id}.disabled")
      click_on('Vote up')
      expect(page).to have_css("#vote_for_question_#{question.id}.disabled")
    end


    scenario 'can revoke his vote after vote', js: true do
      expect(page).to have_css("#vote_for_question_#{question.id}")
      expect(page).to_not have_css("#vote_for_question_#{question.id}.disabled")
      expect(page).to have_css("#vote_revoke_question_#{question.id}.disabled")
      click_on('Vote up')
      expect(page).to have_css("#vote_revoke_question_#{question.id}")
      expect(page).to_not have_css("#vote_revoke_question_#{question.id}.disabled")
      expect(page).to have_css("#vote_for_question_#{question.id}.disabled")
    end
  end

  context 'unauthenticated user' do
    scenario 'can not vote', js: true do
      visit question_path question
      expect(page).to have_css("#vote_for_question_#{question.id}.disabled")
      expect(page).to have_css("#vote_against_question_#{question.id}.disabled")
      expect(page).to have_css("#vote_revoke_question_#{question.id}.disabled")
    end
  end
end
