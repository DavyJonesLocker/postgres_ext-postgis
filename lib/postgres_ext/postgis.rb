module PostgresExt
  module Postgis
  end
end

require 'rgeo'
require 'postgres_ext'
require 'postgres_ext/postgis/version'
require 'active_record/connection_adapters/postgresql_adapter'
require 'postgres_ext/postgis/active_record'
require 'postgres_ext/postgis/arel'
require 'active_record/schema_dumper'

ActiveRecord::SchemaDumper.ignore_tables << 'spatial_ref_sys'

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:prepend, PostgresExt::Postgis::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
ActiveRecord::ConnectionAdapters::PostgreSQLColumn.send(:prepend, PostgresExt::Postgis::ActiveRecord::ConnectionAdapters::PostgreSQLColumn)

require 'arel/visitors/postgresql'

Arel::Visitors::PostgreSQL.send(:prepend, PostgresExt::Postgis::Arel::Visitors::PostgreSQL)
