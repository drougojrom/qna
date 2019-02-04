require 'rails_helper'

feature 'User can create an answer for a question', %q{
  Authenticated users should be able to answer
  on questions, published on the platform
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
    click_on 'Answer'
  end

  scenario 'answer on a question with errors' do
    click_on 'Answer'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'answer on a question' do
    fill_in 'Body', with: 'test answer'
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'test answer'
  end
end
