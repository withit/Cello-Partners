class AddSapCodesToProductReels < ActiveRecord::Migration
  def self.up
    add_column :product_reels, :sap_code, :string
    add_column :product_reels, :sap_alt_code_1, :string
    add_column :product_reels, :sap_alt_code_2, :string
  end

  def self.down
    remove_column :product_reels, :sap_alt_code_2
    remove_column :product_reels, :sap_alt_code_1
    remove_column :product_reels, :sap_code
  end
end
