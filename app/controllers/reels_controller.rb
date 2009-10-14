class ReelsController < ApplicationController
  include ValueLists
  
  def new
  end
  
  def upload
    render('new') && return unless params[:reel] && params[:reel][:data] && params[:reel][:data].present?
    @rows_detected = Reel.load_from_file(params[:reel][:data])
    render :action => 'create'
  end
end
