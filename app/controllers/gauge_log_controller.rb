class GaugeLogController < ApplicationController
  before_action :authenticate_user!
  before_action :disallow_non_managers, only: :approve

  def create
  end

  def approve
    gauge_log = GaugeLog.find_by(id: approve_params[:id].to_i)

    return head :not_found if gauge_log.blank?
    return head :bad_request if gauge_log.approved?

    gauge_log.approve!(current_user.profile)
  end

  def update
  end

  private

  def approve_params
    params.permit(:id)
  end

  def disallow_non_managers
    head :forbidden unless current_user.profile.is_manager?
  end
end
