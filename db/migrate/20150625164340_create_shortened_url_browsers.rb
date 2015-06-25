class CreateShortenedUrlBrowsers < ActiveRecord::Migration
  def change
    create_table :shortened_url_browsers do |t|
      t.integer :shortened_url_id
      t.string :browser_name
      t.integer :count, :default => 0

      t.timestamps null: false
    end

    add_index(:shortened_url_browsers, :shortened_url_id)
    add_index(:shortened_url_browsers, :browser_name)
  end
end
