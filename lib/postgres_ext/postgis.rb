
module PostgresExt
  module Postgis
  end
end

require 'postgres_ext/postgis/version'
require 'postgres_ext/postgis/active_record'
require 'active_record/connection_adapters/postgresql_adapter'
require 'active_record/schema_dumper'

ActiveRecord::SchemaDumper.ignore_tables << 'spatial_ref_sys'

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:prepend, PostgresExt::Postgis::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
ActiveRecord::ConnectionAdapters::PostgreSQLColumn.send(:prepend, PostgresExt::Postgis::ActiveRecord::ConnectionAdapters::PostgreSQLColumn)
