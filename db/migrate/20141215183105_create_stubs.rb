class CreateStubs < ActiveRecord::Migration
  def change
    create_table :stubs do |t|
      t.string :path
      t.text :response
      t.boolean :is_active

      t.timestamps
    end
  end
end
