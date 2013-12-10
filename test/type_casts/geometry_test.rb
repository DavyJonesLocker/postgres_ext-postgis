require 'test_helper'

describe 'geometry casts' do
  before do
    connection.execute <<-SQL
    INSERT INTO places (location)
    VALUES (ST_GeomFromText('POINT(1 1)', 0));
SQL
  end

  it 'converts WKB from PostgreSQL into RGeo objects' do
    place = Place.first

    place.location.must_be_kind_of RGeo::Geos::CAPIPointImpl
    place.location.x.must_equal 1
    place.location.y.must_equal 1
  end
end
