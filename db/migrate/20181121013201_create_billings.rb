class CreateBillings < ActiveRecord::Migration[5.2]
  def change
    create_table :billings do |t|
      t.integer :student_id
      t.numeric :total_amount
      t.integer :desired_due_day
      t.integer :installments_count
      t.string  :payment_method
      t.string  :status

      t.timestamps
    end
  end
end
