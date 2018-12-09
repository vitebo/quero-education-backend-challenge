class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.integer   :bill_id
      t.numeric   :value
      t.string    :status

      t.timestamps
    end
  end
end
