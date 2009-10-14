class Status < Struct.new(:id, :label)
  def self.all
    [new(1,'Active'), new(0,'Inactive')]
  end
end