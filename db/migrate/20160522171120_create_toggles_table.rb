class CreateTogglesTable < ActiveRecord::Migration
  def change
  	create_table :toggles do |t|
  		t.boolean :toggled
  		t.text :content
  		t.timestamps
  	end
  end
end
