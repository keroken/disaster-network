class AddColumnMicroposts < ActiveRecord::Migration
  def up
    add_column :microposts, :title, :string
    add_column :microposts, :address, :string
    add_column :microposts, :latitude, :float 
    add_column :microposts, :longitude, :float
  end
end
