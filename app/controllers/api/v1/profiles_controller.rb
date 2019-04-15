class Api::V1::ProfilesController < ApplicationController

  before_action :doorkeeper_authorize!

  # TODO: remove later
  skip_authorization_check

  def me
    head :ok
  end
end
