class ValueListFormBuilder < ActionView::Helpers::FormBuilder
  def id
    @object.id || 'New'
  end
  
  def actions
    result = submit(object.new_record? ? 'Create' : "Update")
    unless @object.new_record?
      result << " or "
      result << @template.link_to('Cancel', {:action => 'index'})
    end
    result
  end
end