class Api::V1::BaseController < ApplicationController

  include ActionController::Serialization

  before_action :doorkeeper_authorize!

  # TODO: remove later
  skip_authorization_check

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
