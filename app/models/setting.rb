class Setting < ActiveRecord::Base
  set_table_name 'app_settings'
  set_primary_key 'ID'
  
  def type_label type=self.Type
    case type
    when 0 then "N/A"
    when 1 then 'Application Scope'
    when 2 then 'User Scope'
    when 3 then 'Other'
    end
  end
  
  def type_options
    (0..3).collect do |i|
      [type_label(i),i]
    end
  end
  
  def self.method_missing method, *args, &block
    if setting = find(:first, :conditions => {:Label => method.to_s})
      setting.Value
    else
      super
    end
  end
  
  validates_presence_of :type, :value, :label
  
  self.columns.collect(&:name).each do |column_name|
    next unless column_name =~ /[A-Z]/
    define_method column_name.underscore do
      self.send(column_name)
    end
    
    define_method "#{column_name.underscore}=" do |new_value|
      self.send("#{column_name}=", new_value)
    end
  end
end
