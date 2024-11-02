class GaugeController < ApplicationController
  def index
    @gauges = Gauge.all
  end

  def new
  end

  def show
  end
end
