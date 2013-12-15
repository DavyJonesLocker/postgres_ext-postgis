module PostgresExt::Postgis::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::SchemaCreation
  private

  def add_column_options!(sql, options)
    if spatial_type_option = options[:spatial_type] || options[:column].try(:spatial_type)
      srid = options[:srid] || options[:column].try(:srid)
      sql << "(#{postgis_spatial_type spatial_type_option}, #{srid})"
    end

    super
  end

  def postgis_spatial_type(option)
    POSTGIS_SPATIAL_TYPES[option]
  end

  POSTGIS_SPATIAL_TYPES = {
    point:               'Point',
    pointm:              'PointM',
    linestring:          'LineString',
    linestringm:         'LineStringM',
    polygon:             'Polygon',
    polygonm:            'PolygonM',
    multipoint:          'MultiPoint',
    multipointm:         'MultiPointM',
    multilinestring:     'MultiLineString',
    multilinestringm:    'MultiLineStringM',
    multipolygon:        'MultiPolygon',
    multipolygonm:       'MultiPolygonM',
    geometrycollection:  'GeometryCollection',
    geometrycollectionm: 'GeometryCollectionM',
    geometry:            'Geometry'
  }
end
