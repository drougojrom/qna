class Api::V1::ProfilesController < Api::V1::BaseController
  # TODO: remove later
  skip_authorization_check

  def me
    render json: current_resource_owner
  end
end
