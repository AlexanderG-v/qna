class Api::V1::UsersController < Api::V1::BaseController
  def me
    render json: current_resource_owner
  end
end
