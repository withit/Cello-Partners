class Stock < ActiveResource::Base
  self.site = "http://localhost"
  self.format = :json
  
  def available
    self.OnHand - self.IsCommited
  end
  
  
end
