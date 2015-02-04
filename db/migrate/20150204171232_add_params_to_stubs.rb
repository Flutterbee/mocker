class AddParamsToStubs < ActiveRecord::Migration
  def change
    add_column :stubs, :params, :string
  end
end
