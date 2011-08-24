class GuestCustomField < ActiveRecord::Base
  belongs_to :guest

  CUSTOM_FIELDS = {"String" => "string", "Integer" => "integer", "Float" => "float", "Text" => "text", "Boolean" => "boolean"}
  def self.get_columns
    column_hash = {}
    columns = GuestCustomField.columns
    column_names = columns.map(&:name)
    for column_name in column_names
      if !['id', 'guest_id', 'created_at', 'updated_at'].include?(column_name)
        index = column_names.index(column_name)
        column_hash[column_name] = self.get_column_type(columns[index].sql_type)
      end
    end
    return column_hash
  end

  def self.get_column_type(sql_type)
    if sql_type.to_s.include?('tinyint')
      'boolean'
    elsif sql_type.to_s.include?('int')
      'integer'
    elsif sql_type.to_s.include?('varchar') or sql_type.to_s.include?('char')
      'string'
    elsif sql_type.to_s.include?('float')
      'float'
    elsif sql_type.to_s.include?('boolean')
      'float'
    elsif sql_type.to_s.include?('text')
      'text'

    end
  end

  def display_field_value(field_name, field_type)
    if field_type == 'boolean'
      self.send(field_name) ? 'Yes' : 'No'
    else
      self.send(field_name)
    end
  end
end
