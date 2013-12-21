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

require 'minitest/hell' unless ENV['DEBUG']

module MTest
  def before_setup
    ActiveRecord::Base.connection.execute 'BEGIN'
    super
  end

  def after_teardown
    super
    
    ActiveRecord::Base.connection.execute 'ROLLBACK'
  end
end

MiniTest::Unit::TestCase.send :include, MTest

unless ENV['CI'] || RUBY_PLATFORM =~ /java/
  require 'byebug'
end

require 'dotenv'
Dotenv.load

class Place < ActiveRecord::Base
end

ActiveRecord::Base.establish_connection
ActiveRecord::Base.connection.class.class_eval do
  def begin_db_transaction
  end

  def commit_db_transaction
  end
end

class MiniTest::Spec
  class << self
    alias :context :describe
  end

  before do
    # DatabaseCleaner.clean
  end

  after do
    # DatabaseCleaner.clean
  end
end

def connection
  ActiveRecord::Base.connection
end
