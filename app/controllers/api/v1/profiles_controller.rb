class Api::V1::ProfilesController < Api::V1::BaseController

  load_and_authorize_resource

  def me
    render json: current_resource_owner
  end

  def all_users
    render json: User.all_except(current_resource_owner)
  end
end
