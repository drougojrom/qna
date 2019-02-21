class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find_by(id: params[:id])
    @file.purge
    render :destroy
  end

  private 

  def attachment_params
    params.require(:attachment).permit(:id)
  end
end
