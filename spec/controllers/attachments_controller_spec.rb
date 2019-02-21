require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:question_with_attached_file) { create :question_with_attached_file }

    context 'user is the author of question' do
      before { log_in question_with_attached_file.user }

      it 'deletes the attachment' do
        expect { delete :destroy, params: { id: question_with_attached_file.files.first.id }, format: :js }.to change(ActiveStorage::Attachment, :count).by(-1)
        expect(response).to render_template :destroy
      end
    end
    context 'user is not the author of question' do
      let!(:new_user) { create(:user) }
      before { log_in new_user }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question_with_attached_file.files.first.id }, format: :js }.not_to change(ActiveStorage::Attachment, :count)
        expect(response).to redirect_to question
      end
    end
  end
end
