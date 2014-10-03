class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
      add_index :users, :email, unique: true  #建立索引並保持唯一
  end
end
