module PostgresExt::Postgis::ActiveRecord::ConnectionAdapters
  module PostgreSQLColumn
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
