require 'postgres_ext/postgis/version'

module PostgresExt
  module Postgis
  end
end

require 'postgres_ext/postgis/active_record'
require 'active_record/connection_adapters/postgresql_adapter'

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:prepend, PostgresExt::Postgis::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
