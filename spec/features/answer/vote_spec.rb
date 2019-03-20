require 'rails_helper'

feature 'Vote for an answer', %q{
  In order to show the importance of
  the answer I as a user
  want to be able to vote for that 
  question
} do
  given(:user) { create :user }
  given(:another_user) { create :user }
  given(:third_user) { create :user }
  given(:question) { create :question }
  given(:answer) { create :answer, question: question, user: user }

  context 'authenticated user' do
    before do
      sign_in another_user
      visit question_path answer.question
    end

    scenario 'two users increase rating on 2 by 1', js: true do
      within '.answers' do
        within "#answer_rating_#{answer.id}" do
          expect(page).to have_content('0')
        end
        within '.voting' do
          click_on('Vote up')
        end
        within "#answer_rating_#{answer.id}" do
          expect(page).to have_content('1')
        end
      end
      sign_out
      sign_in third_user
      visit question_path answer.question
      within '.answers' do
        within '.voting' do
          click_on('Vote up')
        end

        within "#answer_rating_#{answer.id}" do
          expect(page).to have_content('2')
        end
      end
    end

    scenario 'can not vote twice', js: true do
      within '.answers' do
        expect(page).to_not have_css("#vote_for_answer_#{answer.id}.disabled")
        within '.voting' do
          click_on('Vote up')
        end
      end
      within '.answers' do
        expect(page).to have_css("#vote_for_answer_#{answer.id}.disabled")
      end
    end


    scenario 'can revoke his vote after vote', js: true do
      within '.answers' do
        expect(page).to have_css("#vote_for_answer_#{answer.id}")
        expect(page).to_not have_css("#vote_for_answer_#{answer.id}.disabled")
        expect(page).to have_css("#vote_revoke_answer_#{answer.id}.disabled")
        within '.voting' do
          click_on('Vote up')
        end
      end
      within '.answers' do
        expect(page).to have_css("#vote_revoke_answer_#{answer.id}")
        expect(page).to_not have_css("#vote_revoke_answer_#{answer.id}.disabled")
        expect(page).to have_css("#vote_for_answer_#{answer.id}.disabled")
      end
    end
  end

  context 'unauthenticated user' do
    scenario 'can not vote', js: true do
      visit question_path answer.question
      within '.answers' do
        expect(page).to_not have_css('.voting')
      end
    end
  end
end

