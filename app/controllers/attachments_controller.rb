class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    if current_user&.author_of?(@file.record)
      @file.purge
      render :destroy
    else
      redirect_to @file.record
    end
  end
end
