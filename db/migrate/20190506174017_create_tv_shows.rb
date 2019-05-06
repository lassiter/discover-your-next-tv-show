class CreateTvShows < ActiveRecord::Migration[6.0]
  def change
    create_table :tv_shows do |t|
      t.string :title
      t.index :title
      t.decimal :popularity, precision: 9, scale: 6
      t.timestamps
    end
  end
end
