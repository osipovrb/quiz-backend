class CreateChannelSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :channel_subscriptions do |t|
      t.string :channel
      t.integer :subscriptions_num, unsigned: true, default: 0
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
