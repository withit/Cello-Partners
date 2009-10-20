class AddStockStatusToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :stock_status, :string
  end

  def self.down
    remove_column :orders, :stock_status
  end
end
