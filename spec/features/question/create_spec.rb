require 'rails_helper'
require_relative '../../acceptance_helper'

feature 'User can create a question', %q{
  In order to get the answer from 
  the community
  an authenticated user should be able
  to create questions
} do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      within '.question' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      within '.question' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    expect(page).to_not have_content 'Ask question'
  end

  context 'multiple sessions', js: true do
    background do
      Capybara.using_session('user') do
        sign_in user
        visit questions_path
        click_on 'Ask question'
      end
    end

    scenario 'question appears on another user page' do
      Capybara.using_session('guest') do
        sign_in second_user        
        visit questions_path
      end

      Capybara.using_session('user') do
        within '.question' do
          fill_in 'Title', with: 'Test question'
          fill_in 'Body', with: 'text text text'
        end
        click_on 'Ask'
        expect(page).to have_content 'Your question successfully created'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end
