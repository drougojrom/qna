class LinksController < ApplicationController

  before_action :linkable_author?, only: [:update, :destroy]

  authorize_resource

  def update
    link.update(link_params)
  end

  def destroy
    link.destroy
  end

  private

  helper_method :link

  def link
    @link ||= Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:name, :url)
  end

  def linkable_author?
    current_user.author_of?(link.linkable)
  end
end
