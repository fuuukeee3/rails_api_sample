class CreateRequestCounters < ActiveRecord::Migration[7.0]
  def change
    create_table :request_counters do |t|
      t.string :access_token
      t.integer :count
      t.datetime :start_at

      t.timestamps
    end
  end
end
