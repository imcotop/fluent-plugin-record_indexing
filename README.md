# fluent-plugin-record_indexing

[Fluentd](https://fluentd.org/) Filter plugin to spin entry with an array field into multiple entries.

## Examples

In:
```json
{"foo" => "bar", "baz" => [{"a" => 1}, {"a" => 2}, {"b" => 3}]}
```
Out:
```json
{"foo"=>"bar", "baz"=>{"baz_0"=>1, "baz_1"=>1, "baz_2"=>{"b"=>3}}}
```


## Installation

### RubyGems

```
$ gem install fluent-plugin-array-spin
```

### Bundler

Add the following line to your Gemfile:

```ruby
gem "fluent-plugin-record_indexing"
```

And then execute:

```
$ bundle
```

## Configuration

* **key_name** (string) (required): Key name to spin

* See also: [Filter Plugin Overview](https://docs.fluentd.org/v0.14/articles/filter-plugin-overview)

## Copyright

* Copyright(c) 2017, Tema Novikov
* License
  * Apache License, Version 2.0
