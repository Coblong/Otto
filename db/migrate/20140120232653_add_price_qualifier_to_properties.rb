class AddPriceQualifierToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :price_qualifier, :string
    add_column :properties, :sstc_count, :integer
    Property.all.each do |p|
      p.update_attributes(sstc_count: 0)
    end
  end
end
