class CreateShortenedUrlLogs < ActiveRecord::Migration
  def change
    create_table :shortened_url_logs do |t|
      t.integer :shortened_url_id
      t.string :browser
      t.string :platform
      t.string :country_code
      t.string :referer_domain

      t.timestamps null: false
    end

    add_index(:shortened_url_logs, :shortened_url_id)
  end
end
