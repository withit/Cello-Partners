module ArticlesHelper
  def template_fields template, locals = {}
    render :partial => "templates/#{template.class.to_s.underscore}", :locals => locals
  end
end
