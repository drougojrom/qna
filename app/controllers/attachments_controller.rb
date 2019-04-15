class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource class: ActiveStorage::Attachment

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
