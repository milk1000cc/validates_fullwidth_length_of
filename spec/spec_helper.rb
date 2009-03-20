$KCODE = 'u'
$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'rubygems'
require 'spec'
require 'active_record'
require 'active_record/fixtures'
require File.join(File.dirname(__FILE__), '..', 'init')

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

class ActiveRecord::Base
  def self.define_table(table_name = self.name.tableize, &migration)
    ActiveRecord::Schema.define(:version => 1) do
      create_table(table_name, &migration)
    end
  end
end
