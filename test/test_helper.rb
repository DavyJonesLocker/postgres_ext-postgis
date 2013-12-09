require 'active_record'
require 'minitest/autorun'
require 'bourne'
require 'postgres_ext/postgis'
require 'database_cleaner'
unless ENV['CI'] || RUBY_PLATFORM =~ /java/
  require 'byebug'
end

require 'dotenv'
Dotenv.load

ActiveRecord::Base.establish_connection
DatabaseCleaner.strategy = :deletion

class MiniTest::Spec
  class << self
    alias :context :describe
  end

  before do
    DatabaseCleaner.clean
  end
end
