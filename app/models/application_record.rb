class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def self.execute_sql(*sql_array)     
   connection.execute(send(:sanitize_sql_array, sql_array))
  end
end
