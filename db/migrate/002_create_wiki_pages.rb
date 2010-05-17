class CreateWikiPages < ActiveRecord::Migration
	def self.up
		create_table :wiki_pages do |t|
			t.integer  :user_id
			t.integer  :wiki_id
			t.string   :author
			t.string   :name
			t.string   :address
			t.text     :content
			t.string   :ip
			t.timestamps
		end

		WikiPage.create_versioned_table
	end

	def self.down
		WikiPage.drop_versioned_table
		drop_table :wiki_pages
	end
end
