class GaugeLogController < ApplicationController
  before_action :authenticate_user!
  before_action :disallow_non_managers, only: :approve
  before_action :disallow_non_employees, only: %i[create update]

  def create
    new_gauge_log = GaugeLog.new(
      value: create_params[:value].to_f,
      date: Date.parse(create_params[:date]),
      gauge: Gauge.find_by(id: create_params[:gauge_id]),
      filled_in_by: current_user.profile
    )

    return head :bad_request unless new_gauge_log.valid?

    new_gauge_log.save!
    redirect_back_or_to "/gauge/index"
  end

  def approve
    gauge_log = GaugeLog.find_by(id: approve_params[:id].to_i)

    return head :not_found if gauge_log.blank?
    return head :bad_request if gauge_log.approved?

    gauge_log.approve!(current_user.profile)
    redirect_back_or_to "/gauge/index"
  end

  def update
    gauge_log = GaugeLog.find_by(id: update_params[:id].to_i)

    return head :not_found if gauge_log.blank?
    return head :bad_request if gauge_log.approved?

    gauge_log.value = update_params[:value].to_f if update_params[:value].present?
    gauge_log.date = Date.parse(update_params[:date]) if update_params[:date].present?
    return head :bad_request unless gauge_log.valid?

    gauge_log.save!
    redirect_back_or_to "/gauge/index"
  end

  private

  def create_params
    params.require(:gauge_log).permit(:value, :date, :gauge_id)
  end

  def approve_params
    params.permit(:id)
  end

  def update_params
    params.require(:gauge_log).permit(:value, :date, :id)
  end

  def disallow_non_managers
    head :forbidden unless current_user.profile.is_manager?
  end

  def disallow_non_employees
    head :forbidden unless current_user.profile.is_employee?
  end
end
