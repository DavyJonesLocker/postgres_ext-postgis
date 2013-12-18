require 'test_helper'

describe 'where.contains(geometry)' do
  it 'genereates the appropriate where clause' do
    point = Place.new(location: 'POINT(1 2)').location

    query = Place.where.contains(location: point)

    query.to_sql.must_match /ST_CONTAINS\(\"places\".\"location\", 0020000001000000003ff00000000000004000000000000000\)/
  end
end
