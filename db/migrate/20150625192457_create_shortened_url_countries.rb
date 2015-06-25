class CreateShortenedUrlCountries < ActiveRecord::Migration
  def change
    create_table :shortened_url_countries do |t|
      t.integer :shortened_url_id
      t.string :country_code
      t.integer :count, :default => 0

      t.timestamps null: false
    end

    add_index(:shortened_url_countries, :shortened_url_id)
    add_index(:shortened_url_countries, :country_code)
  end
end
