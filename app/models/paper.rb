class Paper < Struct.new(:grade, :subgrade, :calliper, :gsm)
  def <=> other
    (grade.to_s <=> other.grade.to_s).nonzero? || 
    (subgrade.to_s <=> other.subgrade.to_s).nonzero? ||
    (calliper.to_i <=> other.calliper.to_i).nonzero? ||
    (gsm.to_i <=> other.gsm.to_i)
  end
end