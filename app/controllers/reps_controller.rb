class RepsController < ApplicationController
  def show
    @rep = current_user.organisation.rep
  end
end
