class ReelsController < ApplicationController
  include ValueLists
  
  def new
  end
  
  def upload
    render('new') && return unless params[:reel] && params[:reel][:data] && params[:reel][:data].present?
    @rows_detected = Reel.load_from_file(params[:reel][:data])
    render :action => 'create'
  end
  
  private
  
  def module_name
    ["new","upload"].include?(action_name) ? 'load_reels' : 'product_reels'
  end
  
  def functions_hash
    returning(super) do |h|
      h["new"] = "form"
    end
  end
end
