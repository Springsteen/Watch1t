class ChangeDataTypeForCheckMail < ActiveRecord::Migration
  def change
    change_column :users, :email_check, :binary
  end
end
