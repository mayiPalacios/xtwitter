class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
     
      t.timestamps
    end
  end
end
