class GrantsController < ApplicationController
  def index
    @roles = Role.all
  end
  
  def edit
    @role = Role.find(params[:role_id])
    @grants = @role.grants.group_by{|p| p.send(Grant.reflect_on_association(:permission).primary_key_name)}
    @permissions = Permission.all(:conditions => "parent > 0").group_by(&:parent)
  end
  
  def update
    @role = Role.find(params[:role_id])
    @existing_grants = @role.grants.group_by(&Grant.reflect_on_association(:permission).primary_key_name.to_sym)
    @role.grants = params[:grants].collect do |permission_id, grant_attributes|
      next unless grant_attributes[:permission_id]
      grant = @existing_grants[permission_id.to_i].to_a.first || @role.grants.build
      grant.attributes = grant_attributes
      grant
    end.compact
    @role.save!
    redirect_to grants_path
  end
  
  protected
  
  def module_name
    'shell_permissions'
  end
  
  def functions_hash
    returning(Hash.new{|h,k| k}) do |h|
      h["index"] = "listGroups"
      h["edit"] = ["retrieve"]
      h["update"] = ["editPerm"]
    end
  end
end
