class GaugeLogController < ApplicationController
  before_action :authenticate_user!

  def create
  end

  def approve
    gauge_log = GaugeLog.find(approve_params[:id].to_i)
    gauge_log.approve!(current_user.profile)
  end

  def update
  end

  private

  def approve_params
    params.permit(:id)
  end
end
