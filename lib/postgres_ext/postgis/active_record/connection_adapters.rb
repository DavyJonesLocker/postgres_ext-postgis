module PostgresExt::Postgis::ActiveRecord::ConnectionAdapters
  module PostgreSQLColumn
    def self.prepended(klass)
      klass.class_eval do
        attr_reader :geometry_type, :srid
        class << klass
          prepend ClassMethods
        end
      end
    end

    module ClassMethods
      def wkb_parser
        @wkb_parser ||= RGeo::WKRep::WKBParser.new nil, support_ewkb: true
      end

      def wkb_generator
        @wkb_generator ||= RGeo::WKRep::WKBGenerator.new hex_format: true, type_format: :ewkb, emit_ewkb_srid: true
      end

      def wkt_parser
        @wkt_parser ||= RGeo::WKRep::WKTParser.new nil, support_ewkt: true
      end

      def string_to_geometry(value)
        if value.index('(')
          wkt_parser.parse value
        else
          wkb_parser.parse value
        end
      end

      def geometry_to_string(value)
        if RGeo::Feature::Instance
          wkb_generator.generate value
        else
          value
        end
      end
    end

    def initialize(name, default, oid_type, sql_type = nil, null = true)
      super
      if type == :geometry
        @srid          = extract_srid sql_type
        @geometry_type = extract_geometry_type sql_type
      end
    end

    private

    def extract_srid(sql_type)
      if match = geometry_type_regex.match(sql_type)
        match[:srid]
      end
    end

    def extract_geometry_type(sql_type)
      if match = geometry_type_regex.match(sql_type)
        match[:geom_type].downcase.to_sym.inspect
      end
    end

    def geometry_type_regex
      /geometry\((?<geom_type>\w+),(?<srid>\d+)\)/i
    end

    def extract_limit(sql_type)
      case sql_type
      when /^geometry/i
        nil
      else
        super
      end
    end

    def simplified_type(field_type)
      case field_type
      when /geography/
        :geography
      when /geometry(\(\w,\d\))?/
        :geometry
      else
        super
      end
    end
  end
end

require 'postgres_ext/postgis/active_record/connection_adapters/postgresql_adapter'
require 'postgres_ext/postgis/active_record/connection_adapters/postgresql'
