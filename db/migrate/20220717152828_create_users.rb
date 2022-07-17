class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :access_token
      t.integer :api_rate_limit

      t.timestamps
    end
  end
end
