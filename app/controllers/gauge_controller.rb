class GaugeController < ApplicationController
  before_action :authenticate_user!

  def index
    @gauges = Gauge.all
  end

  def new
    head :forbidden unless current_user.profile.is_employee?
  end

  def create
    new_gauge = Gauge.new(
      name: create_params[:name],
      unit: create_params[:unit],
      time_slot: Gauge.time_slots[:daily], # TODO This needs to be changed when we support different time slots
      start_date: create_params[:start_date],
      end_date: create_params[:end_date]
    )

    # head :bad_request unless new_gauge.is_valid?
    new_gauge.save!
  end

  def show
  end

  private

  def create_params
    params.require(:gauge).permit(:name, :unit, :start_date, :end_date)
  end
end
