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

  def prepare_column_options(column, types)
    spec = super

    if column.type == :geometry
      if column.srid
        spec[:srid] = column.srid
        spec[:geometry_type] = column.geometry_type
      end
    end

    spec
  end

  def migration_keys
    super + [:srid, :geometry_type]
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
    def quote(value, column = nil)
      if column && column.type == :geometry
        ActiveRecord::ConnectionAdapters::PostgreSQLColumn.geometry_to_string(value)
      else
        super
      end
    end

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
