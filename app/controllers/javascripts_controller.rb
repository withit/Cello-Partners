class JavascriptsController < ApplicationController
  def callipers
    @callipers = Reel.callipers
    respond_to do |format|
      format.js
    end
  end
end
