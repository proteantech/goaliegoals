class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.date :log_date
      t.decimal :quantity
      t.string :description
      t.references :goal, null: false
      t.timestamps
    end
  end
end
