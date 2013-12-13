module PostgresExt::Postgis::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  POSTGIS_DATABASE_TYPES = {
    geometry: { name: 'geometry' }
  }

  def self.prepended(klass)
    klass::NATIVE_DATABASE_TYPES.merge! POSTGIS_DATABASE_TYPES
    klass::TableDefinition.send :prepend, TableDefinition
    klass::ColumnDefinition.send :prepend, ColumnDefinition
    klass::SchemaCreation.send :prepend, SchemaCreation
    klass::OID.send :prepend, OID
    klass.send :prepend, Quoting
  end

  module ColumnMethods
    def geometry(name, options = {})
      column(name, 'geometry', options)
    end
  end

  module ColumnDefinition
    attr_accessor :spatial_type, :srid
  end

  module TableDefinition
    include ColumnMethods

    def column(name, type, options = {})
      super
      column = self[name]

      if type.to_s == 'geometry'
        column.srid = options[:srid]
        column.spatial_type = options[:spatial_type]
      end

      self
    end
  end

  module Quoting
    def type_cast(value, column, array_member = false)
      return super unless column

      case value
      when RGeo::Feature::Instance
        return super unless /geometry/ =~ column.sql_type
        ActiveRecord::ConnectionAdapters::PostgreSQLColumn.geometry_to_string(value)
      else
        super
      end
    end
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
