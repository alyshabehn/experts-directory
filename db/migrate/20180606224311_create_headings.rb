class CreateHeadings < ActiveRecord::Migration[5.2]
  def change
    create_table :headings do |t|
      t.string :heading
      t.references :member, foreign_key: true

      t.timestamps
    end
  end
end
