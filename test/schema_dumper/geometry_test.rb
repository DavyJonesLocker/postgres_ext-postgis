require 'test_helper'

describe 'geometry schema dump' do
  let(:stream) { StringIO.new }
  let(:schema) { stream.string }

  before do
    connection.create_table :testings do |t|
      t.geometry :geo
      t.geometry :lines, spatial_type: :linestring, srid: 4326
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
  end

  after { connection.drop_table :testings }

  it 'does not include the spatial_ref_sys table' do
    schema.wont_match /create_table \"spatial_ref_sys\"/
  end

  it 'generates the geometry column statements' do
    schema.must_match /t\.geometry "geo"/
  end

  it 'captures geometry settings in column statments' do
    schema.must_match /t\.geometry "lines", srid: 4326, geometry_type: :linestring/
  end
end
