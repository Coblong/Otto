class MergeUrlAndExternalRefOnProperties < ActiveRecord::Migration
  def change
    Property.all.each do |p|
      p.update_attributes(url: p.url.to_s + p.external_ref.to_s)
    end
  end
end
