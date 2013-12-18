require 'active_record'
require 'bourne'
require 'postgres_ext/postgis'
require 'rgeo'
require 'database_cleaner'

if defined?(M)
  require 'minitest/spec'
else
  require 'minitest/autorun'
end

unless ENV['CI'] || RUBY_PLATFORM =~ /java/
  require 'byebug'
end

require 'dotenv'
Dotenv.load

class Place < ActiveRecord::Base
end

ActiveRecord::Base.establish_connection
DatabaseCleaner.strategy = :deletion

class MiniTest::Spec
  class << self
    alias :context :describe
  end

  before do
    DatabaseCleaner.clean
  end

  after do
    DatabaseCleaner.clean
  end
end

def connection
  ActiveRecord::Base.connection
end
