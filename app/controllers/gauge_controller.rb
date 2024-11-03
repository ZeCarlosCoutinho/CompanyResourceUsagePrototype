class GaugeController < ApplicationController
  before_action :authenticate_user!

  def index
    @gauges = Gauge.all
  end

  def new
  end

  def show
  end
end
