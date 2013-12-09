module PostgresExt::Postgis::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  POSTGIS_DATABASE_TYPES = {
    geometry: { name: 'geometry' }
  }

  def self.prepended(klass)
    klass::NATIVE_DATABASE_TYPES.merge! POSTGIS_DATABASE_TYPES
    klass::TableDefinition.send(:prepend, TableDefinition)
  end

  module ColumnMethods
    def geometry(name, options = {})
      column(name, 'geometry', options)
    end
  end

  module TableDefinition
    include ColumnMethods
  end
end
