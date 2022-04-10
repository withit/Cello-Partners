class AddReelInfoToProductReels < ActiveRecord::Migration
  def self.up
    add_column :product_reels, :reel_info, :string
  end

  def self.down
    remove_column :product_reels, :reel_info
  end
end
