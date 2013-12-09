require 'spec_helper'

if defined?(ActiveRecord::ConnectionAdapters::PostGISAdapter)
  describe 'Postgis' do
    let(:factory) { RGeo::Geos::CAPIFactory.new }
    describe '.where.contains(column: point)' do
      it 'genereates the appropriate where clause' do
        skip

        point = factory.point(1,2)

        query = District.where.contains(coordinates: point)

        query.to_sql.should match /ST_CONTAINS\(\"districts\".\"coordinates\", ST_PointFromText\('POINT\(1.0 2.0\)\)\)/
      end
    end

    describe '.where.contains(column: polygon)' do
      it 'genereates the appropriate where clause' do
        skip

        points = [[0,0],[0,1],[1,1],[0,0]].map{ |coords| factory.point(*coords) }

        

        point = factory.point(1,2)

        query = District.where.contains(coordinates: point)

        query.to_sql.should match /ST_CONTAINS\(\"districts\".\"coordinates\", ST_PointFromText\('POINT\(1.0 2.0\)\)\)/
      end
    end

  end
end
