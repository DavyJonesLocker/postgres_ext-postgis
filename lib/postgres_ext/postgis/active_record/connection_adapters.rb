module PostgresExt::Postgis::ActiveRecord::ConnectionAdapters
  module PostgreSQLColumn
    def self.prepended(klass)
      klass.class_eval do
        class << klass
          attr_reader :geometry_type, :srid
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

    private

    def simplified_type(field_type)
      case field_type
      when 'geometry'
        :geometry
      else
        super
      end
    end
  end
end

require 'postgres_ext/postgis/active_record/connection_adapters/postgresql_adapter'
require 'postgres_ext/postgis/active_record/connection_adapters/postgresql'
