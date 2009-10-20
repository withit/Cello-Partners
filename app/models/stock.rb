class Stock < ActiveResource::Base
  self.site = "http://localhost:4567/"
  self.format = :json
  
  def available
    self.OnHand - self.IsCommited
  end
  
  
end
