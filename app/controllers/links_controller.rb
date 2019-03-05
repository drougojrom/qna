class LinksController < ApplicationController

  def update
    link.update(link_params)
  end

  def destroy
    @link = Link.find(params[:id])
    @link.destroy
  end

  private

  helper_method :link

  def link
    @link ||= Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:name, :url)
  end
end
