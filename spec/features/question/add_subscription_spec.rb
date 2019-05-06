require 'rails_helper'

feature 'User can subscribe to question', %q{
  In order to follow on the questions answers, user should be
  able to subscribe to the questions update on new answers
} do
  given(:question) { create :question }

  scenario 'User can subscribe to question', js: true do
    sign_in(question.user)
    visit question_path(question)

    within '.question' do
      click_on 'Subscribe'
    end

    expect(page).to_not have_link 'Subscribe'
    expect(page).to have_link 'Unsubscribe'
  end
end