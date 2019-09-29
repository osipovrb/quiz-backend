class DropChatMembers < ActiveRecord::Migration[6.0]
  def change
    drop_table :chat_members, if_exists: true
  end
end
