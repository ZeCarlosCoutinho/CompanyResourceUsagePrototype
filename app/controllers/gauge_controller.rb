class GaugeController < ApplicationController
  before_action :authenticate_user!
  before_action :disallow_non_employees, only: %i[new create]

  def index
    @gauges = Gauge.all
  end

  def new
  end

  def create
    new_gauge = Gauge.new(
      name: create_params[:name],
      unit: create_params[:unit],
      time_slot: Gauge.time_slots[:daily], # TODO This needs to be changed when we support different time slots
      start_date: create_params[:start_date],
      end_date: create_params[:end_date]
    )

    return head :bad_request unless new_gauge.valid?
    new_gauge.save!
  end

  def show
  end

  private

  def create_params
    params.require(:gauge).permit(:name, :unit, :start_date, :end_date)
  end

  def disallow_non_employees
    head :forbidden unless current_user.profile.is_employee?
  end
end
