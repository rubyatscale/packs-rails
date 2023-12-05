class CreateFoo < ActiveRecord::Migration[7.0]
  def change
    create_table :foos do |t|
      t.string :name
      t.timestamps
    end
  end
end
