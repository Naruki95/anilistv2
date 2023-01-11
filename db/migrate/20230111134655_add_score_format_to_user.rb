class AddScoreFormatToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :score_format, :string
  end
end
