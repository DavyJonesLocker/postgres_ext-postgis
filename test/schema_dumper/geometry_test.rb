require 'test_helper'

describe 'geometry schema dump' do
  after { connection.drop_table :testings }

  it 'generates the geometry column statements' do
    stream = StringIO.new

    connection.create_table :testings do |t|
      t.geometry :geo
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.must_match /t\.geometry "geo"/
  end
end
