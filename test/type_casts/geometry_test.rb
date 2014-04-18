require 'test_helper'

describe 'geometry casts' do
  it 'converts WKB from PostgreSQL into RGeo objects' do
    connection.execute <<-SQL
    INSERT INTO places (location)
    VALUES (ST_GeomFromText('POINT(1 1)', 26918));
SQL
    place = Place.first

    (RGeo::Feature::Point === place.location).must_equal true
    place.location.x.must_equal 1
    place.location.y.must_equal 1
    place.location.srid.must_equal 26918
  end

  it 'parses WKT attributes into RGeo objects' do
    place = Place.new

    place.location = 'SRID=4623;POINT(1 1)'
    (RGeo::Feature::Point === place.location).must_equal true
    place.location.x.must_equal 1
    place.location.y.must_equal 1
    place.location.srid.must_equal 4623
  end

  it 'enables roundtripping from the database' do
    place = Place.new

    place.location = 'SRID=1;POINT(2 2)'
    place.save
    place.reload
    (RGeo::Feature::Point === place.location).must_equal true
    place.location.x.must_equal 2
    place.location.y.must_equal 2
    place.location.srid.must_equal 1
  end
end

describe 'geography casts' do
  it 'converts WKB from PostgreSQL into RGeo objects' do
    connection.execute <<-SQL
    INSERT INTO places (location_2)
    VALUES (ST_GeographyFromText('POINT(1 1)'));
SQL
    place = Place.first

    (RGeo::Feature::Point === place.location_2).must_equal true
    place.location_2.x.must_equal 1
    place.location_2.y.must_equal 1
    place.location_2.srid.must_equal 4326
  end

  it 'parses WKT attributes into RGeo objects' do
    place = Place.new

    place.location_2 = 'SRID=4623;POINT(1 1)'
    (RGeo::Feature::Point === place.location_2).must_equal true
    place.location_2.x.must_equal 1
    place.location_2.y.must_equal 1
    place.location_2.srid.must_equal 4623
  end
end
