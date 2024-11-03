class GaugeController < ApplicationController
  before_action :authenticate_user!

  def index
    @gauges = Gauge.all
  end

  def new
    head :forbidden unless current_user.profile.is_employee?
  end

  def show
  end
end
