# PostgresExt::Postgis

## Installation

Add this line to your application's Gemfile:

    gem 'postgres_ext-postgis'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install postgres_ext-postgis

## Usage

Just `require 'postgres_ext/postgis'` and use ActiveRecord as you normally would!
postgres\ext extends ActiveRecord's data type handling and query methods
in both Arel and ActiveRecord.

### Migrations
Adding a geomtry column to your table is simple! You can create a plain
geometry column, or specify your spatial type and projection:

```ruby
create_table :districts do |t|
  t.geometry :location
  t.geometry :district_boundries, spatial_type: :multipolygon, srid: 4326
end
```

### Type Casting

PostGIS geometry types are converted to [RGeo]() objects. You can set
your PostGIS types in ActiveRecord using either the Extended Well-Known Binary
(WKB) or Extended Well-Known Text (WKT) representation:

```ruby
user.location = 'SRID=4623;POINT(1 1)'
```

### Querying

#### Contains
Using the [contains querying interface from postgres\_ext](), we can
query if geometry column contains the specified object

```ruby
District.where.contains(district_boundries: user.location)
```
## Authors ##

* [Dan McClain](http://twitter.com/_danmcclain)

[We are very thankful for the many
contributors](https://github.com/dockyard/postgres_ext-postgis/graphs/contributors)

## Versioning ##

This gem follows [Semantic Versioning](http://semver.org)

## Want to help? ##

Please do! We are always looking to improve this gem. Please see our
[Contribution
Guidelines](https://github.com/dockyard/postgre_ext-postgis/blob/master/CONTRIBUTING.md)
on how to properly submit issues and pull requests.

## Legal ##

[DockYard](http://dockyard.com), Inc. &copy; 2014

[@dockyard](http://twitter.com/dockyard)

[Licensed under the MIT
license](http://www.opensource.org/licenses/mit-license.php)

