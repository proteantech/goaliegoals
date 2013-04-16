class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :action
      t.decimal :quantity
      t.string :unit
      t.decimal :frequency
      t.string :frequency_unit
      t.date :start
      t.date :end

      t.timestamps
    end
  end
end
