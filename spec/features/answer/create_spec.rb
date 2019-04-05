require 'rails_helper'

feature 'User can create an answer for a question', %q{
  Authenticated users should be able to answer
  on questions, published on the platform
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:second_user) { create(:user) }

  describe 'An authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers on a question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers on a question' do
      within '.new-answer' do 
        fill_in 'Body', with: 'test answer'
        click_on 'Answer'
      end
      expect(page).to have_content 'test answer'
    end

    context 'multiple sessions' do
      background do
        Capybara.using_session('user') do
          sign_in user
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end
      end

      scenario 'answer appears on another user page' do
        Capybara.using_session('user') do
          click_on 'Answer'
          within '.new-answer' do 
            fill_in 'Body', with: 'test answer'
            click_on 'Answer'
          end
          expect(page).to have_content 'test answer'
        end

        Capybara.using_session('guest') do
          within '.answers' do
            expect(page).to have_content 'test answer'
          end
        end
      end

      scenario 'commenting on answer' do
        Capybara.using_session('user') do
          within '.new-comment' do
            fill_in 'Body', with: 'test comment'
            click_on 'Post comment'
          end
          expect(page).to have_content 'test comment'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'test comment'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to answer on a question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
