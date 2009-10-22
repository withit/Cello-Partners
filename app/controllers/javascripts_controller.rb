class JavascriptsController < ApplicationController
  skip_before_filter :require_login
  def callipers
    @callipers = Reel.callipers
    respond_to do |format|
      format.js
    end
  end
end
