class AddMissingFieldsToImports < ActiveRecord::Migration
  def change
    add_column    :imports, :imported,          :boolean, default: false
    add_column    :imports, :imported_data_ids, :text,    array: true, default: "{}"
    add_reference :imports, :map,                         index: true
  end
end
