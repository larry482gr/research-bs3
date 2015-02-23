class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :locale, {limit: 5, null: false}
      t.string :language, {limit: 20, null: false}
    end
  end
end
