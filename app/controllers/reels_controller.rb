class ReelsController < ApplicationController
  def new
  end
  
  def create
    @rows_detected = Reel.load_from_file(params[:reel][:data])
  end
end
