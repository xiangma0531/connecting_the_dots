class CreateDots < ActiveRecord::Migration[6.0]
  def change
    create_table :dots do |t|

      t.timestamps
    end
  end
end
