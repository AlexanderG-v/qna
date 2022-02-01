class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    return unless current_user&.author?(@link.linkable)

    @link.destroy
    flash.now[:notice] = 'Link was successfully deleted'
  end
end
