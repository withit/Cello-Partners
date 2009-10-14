module ValueLists
  def index
    load_all_objects
  end
  
  def create
    @current_object = current_model.new(object_parameters)
    instance_variable_set "@#{singular_instance_variable_name}", @current_object
    if @current_object.save
      redirect_to :action => "index" 
    else
      load_all_objects
      render :action => 'index'
    end
  end
  
  def edit
    load_all_objects
    load_current_object
    render :action => "index"
  end
  
  def update
    load_current_object
    if @current_object.update_attributes(object_parameters)
      redirect_to :action => "index"
    else
      load_all_objects
      render :action => 'index'
    end
  end
  
  def destroy
    load_current_object
    @current_object.destroy
    redirect_to :action => "index"
  end
  
  private
  
  def load_current_object
    @current_object = current_model.find(params[:id])
    instance_variable_set "@#{singular_instance_variable_name}", @current_object
  end
  
  def load_all_objects
    @current_objects =  current_model.all
    instance_variable_set "@#{plural_instance_variable_name}", @current_objects
  end
  
  def current_model_name
    controller_name.singularize.camelize
  end

  def current_model
    current_model_name.constantize
  end
  
  def plural_instance_variable_name
    controller_name
  end
  
  def singular_instance_variable_name
    controller_name.singularize
  end
  
  def object_parameters
    params[current_model_name.underscore]
  end
end
