class CreateAnimes < ActiveRecord::Migration[7.0]
  def change
    create_table :animes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :anime_url
      t.float :my_score
      t.integer :repeat

      t.timestamps
    end
  end
end
