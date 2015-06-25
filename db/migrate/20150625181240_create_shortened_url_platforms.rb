class CreateShortenedUrlPlatforms < ActiveRecord::Migration
  def change
    create_table :shortened_url_platforms do |t|
      t.integer :shortened_url_id
      t.string :platform
      t.integer :count, :default => 0

      t.timestamps null: false
    end

    add_index(:shortened_url_platforms, :shortened_url_id)
    add_index(:shortened_url_platforms, :platform)
  end
end
