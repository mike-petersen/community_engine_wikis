class CreateWikis < ActiveRecord::Migration
	def self.up
		create_table :wikis do |t|
			t.string  :name
			t.text    :short_description
			t.text    :long_description
			t.boolean :public, :default => true
			t.integer :owner_id
			t.integer :avatar_id
			t.timestamps
		end
	end

	def self.down
		drop_table :wikis
	end
end
