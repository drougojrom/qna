require 'rails_helper'

feature 'User can unsubscribe from question', %q{
  In order to unfollow on the questions answers, user should be
  able to unsubscribe from the questions update on new answers
} do
  given(:question) { create :question }

  scenario 'User can unsubscribe from question', js: true do
    sign_in(question.user)
    visit question_path(question)

    within '.subscribe' do
      click_on 'Subscribe'
    end

    expect(page).to_not have_link 'Subscribe'
    expect(page).to have_link 'Unsubscribe'

    within '.subscribe' do
      click_on 'Unsubscribe'
    end

    expect(page).to have_link 'Subscribe'
    expect(page).to_not have_link 'Unsubscribe'
  end
end