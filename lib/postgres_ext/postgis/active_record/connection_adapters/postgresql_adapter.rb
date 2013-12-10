module PostgresExt::Postgis::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  POSTGIS_DATABASE_TYPES = {
    geometry: { name: 'geometry' }
  }

  def self.prepended(klass)
    klass::NATIVE_DATABASE_TYPES.merge! POSTGIS_DATABASE_TYPES
    klass::TableDefinition.send :prepend, TableDefinition
    klass::OID.send :prepend, OID
  end

  module ColumnMethods
    def geometry(name, options = {})
      column(name, 'geometry', options)
    end
  end

  module TableDefinition
    include ColumnMethods
  end

  module OID
    def self.prepended(klass)
      klass.register_type 'geometry', OID::Geometry.new
    end

    class Geometry < ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::OID::Type
      def type_cast(value)
        if String === value
          ActiveRecord::ConnectionAdapters::PostgreSQLColumn.string_to_geometry value
        else
          value
        end
      end
    end
  end
end
