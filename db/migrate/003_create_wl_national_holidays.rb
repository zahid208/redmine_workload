class CreateWlNationalHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table  :wl_national_holidays do |t|
      t.date      :start,  :null => false
      t.date      :end,  :null => false
      t.string    :reason,  :null => false
    end
  end
end
