class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    authorize! :destroy, @link.linkable

    @link.destroy
    flash.now[:notice] = 'Link was successfully deleted'
  end
end
