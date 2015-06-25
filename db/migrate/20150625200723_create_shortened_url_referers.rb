class CreateShortenedUrlReferers < ActiveRecord::Migration
  def change
    create_table :shortened_url_referers do |t|
      t.integer :shortened_url_id
      t.string :domain
      t.integer :count, :default => 0

      t.timestamps null: false
    end

    add_index(:shortened_url_referers, :shortened_url_id)
    add_index(:shortened_url_referers, :domain)
  end
end
