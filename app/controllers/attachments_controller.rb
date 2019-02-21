class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def delete_file
    @file = ActiveStorage::Attachment.find_by(id: params[:id])
    if current_user.author_of?(@file.attachable)
      @file.destroy
      render :destroy
    else
      render status: 403
    end
  end

  private 

  def attachment_params
    params.require(:attachment).permit(:id)
  end
end
