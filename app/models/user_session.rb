require 'digest/md5'
class UserSession
  cattr_accessor :controller 
  
  attr_accessor :username, :password
  
  def errors
  end
  
  def new_session?
    controller.session[:user_id].nil?
  end
  
  alias :new_record? :new_session?
  
  def initialize attributes={}
    self.username = attributes[:username]
    self.password = attributes[:password]
  end
  
  def save
    user = User.find_by_username(username)
    if user.password == crypted_password
      controller.session[:user_id] = user.id
      true
    else
      false
    end
  end
  
  def crypted_password
    Digest::MD5.hexdigest(password)
  end
end