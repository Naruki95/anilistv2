class AddUsernameandAnilistAccountToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string, null: false
    add_column :users, :anilist_account, :string
  end
end
