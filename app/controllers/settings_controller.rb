class SettingsController < ApplicationController
  def index
    @settings = Setting.all
  end
  
  def create
    @setting = Setting.new(params[:setting])
    if @setting.save
      redirect_to settings_path
    else
      @settings = Setting.all
      render 'index'
    end
  end
  
  def edit
    @settings = Setting.all
    @setting = Setting.find(params[:id])
    render 'index'
  end
  
  def update
    @setting = Setting.find(params[:id])
    if @setting.update_attributes(params[:setting])
      redirect_to settings_path
    else
      @settings = Setting.all
      render 'index'
    end
  end
  
  private
  
  def module_name
    'app_settings'
  end
end
