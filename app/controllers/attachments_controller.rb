class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    return unless current_user.author?(@attachment.record)

    @attachment.purge
    flash.now[:notice] = 'File was successfully deleted'
  end
end
