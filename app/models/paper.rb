class Paper < Struct.new(:grade, :subgrade, :calliper, :gsm)
  def <=> other
    (grade <=> other.grade).nonzero? || 
    (subgrade <=> other.subgrade).nonzero? ||
    (calliper <=> other.calliper).nonzero? ||
    (gsm <=> other.gsm)
  end
end