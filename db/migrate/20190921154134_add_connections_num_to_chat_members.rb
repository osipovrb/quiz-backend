class AddConnectionsNumToChatMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :chat_members, :connections_num, :integer, default: 0, unsigned: true
  end
end
