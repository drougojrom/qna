require 'rails_helper'

feature 'User can edit links for his question', %q{
  In order to correct the mistakes
  an author of question should be able to 
  edit his questions links
} do
  given(:question_with_link) { create :question, :with_link }

  scenario 'Unauthenticated user can not edit a link to a question' do
    visit question_path(question_with_link)
    within '.links' do 
      expect(page).to_not have_link 'Edit link'
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his links', js: true do
      sign_in(question_with_link.user)
      visit question_path(question_with_link)

      within '.links' do
        click_on 'Edit'

        fill_in 'Link name', with: 'edited link name'
        fill_in 'Link url', with: 'edited link url'
        click_on 'Update link'

        expect(page).to have_content 'edited link name'
        expect(page).to have_content 'edited link url'
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits his links with errors', js: true do
      sign_in question_with_link.user
      visit question_path question_with_link

      within '.links' do
        click_on 'Edit'
        fill_in 'Link name', with: ''
        click_on 'Update'

        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Link name can't be blank"
    end

    scenario 'tries to edit other users links' do
      visit question_path(question_with_link)      
      expect(page).to_not have_link 'Edit link'
    end
  end
end
