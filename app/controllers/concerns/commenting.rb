module Commenting
  extend ActiveSupport::Concern

  included do 
    before_action :set_commentable
    respond_to :json
  end

  private 

  def set_commentable

  end
end
