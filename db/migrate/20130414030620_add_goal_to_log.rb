class AddGoalToLog < ActiveRecord::Migration
  def change
    add_column :logs, :goal, :belongs_to
  end
end
