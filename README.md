# fluent-plugin-record_indexing

[Fluentd](https://fluentd.org/) Filter plugin to spin entry with an array field into multiple entries.

## Examples
```
<filter test**>
    @type                 record_indexing
    check_all_key         false
    key_name              baz
    key_prefix            baz_0
</filter>

In:
{"foo" => "bar", "baz" => [{"a" => 1}, {"a" => 2}, {"b" => 3}]}
Out:
{"foo"=>"bar", "baz"=>{"baz_0"=> {"a" => 1} , "baz_1"=> {"a" => 2}, "baz_2"=>{"b"=>3}}}
```
```
<filter test**>
    @type                 record_indexing
    check_all_key         false
    key_name              baz
</filter>

In:
{"foo" => "bar", "baz" => [{"a" => 1}, {"a" => 2}, {"b" => 3}],  "daz" => [{"a"=>1}, {"a"=>2}, {"b"=>3}]}
Out:
{"foo"=>"bar", "baz"=>{"0"=> {"a" => 1} , "1"=>{"a" => 2}, "2"=>{"b"=>3}},  "daz" => [{"a"=>1}, {"a"=>2}, {"b"=>3}]}

```
```
<filter test**>
    @type                 record_indexing
</filter>

In:
{"foo" => "bar", "baz"=>[{"a"=>1}, {"a"=>2}, {"b"=>3}] , "daz" => [{"a"=>1}, {"a"=>2}, {"b"=>3}]}
Out:
{"foo"=>"bar", "baz"=>{"0"=>{"a"=>1} , "1"=>{"a"=>2}, "2"=>{"b"=>3}}, "daz"=>{"0"=>{"a"=>1} , "1"=>{"a"=>2}, "2"=>{"b"=>3}}}
```
```
<filter test**>
    @type                 record_indexing
    check_all_key         false
    key_name              baz,daz
</filter>

In:
{"foo" => "bar", "baz"=>[{"a"=>1}, {"a"=>2}, {"b"=>3}] , "daz" => [{"a"=>1}, {"a"=>2}, {"b"=>3}]}
Out:
{"foo"=>"bar", "baz"=>{"0"=>{"a"=>1} , "1"=>{"a"=>2}, "2"=>{"b"=>3}}, "daz"=>{"0"=>{"a"=>1} , "1"=>{"a"=>2}, "2"=>{"b"=>3}}}
```
```
<filter test**>
    @type                record_indexing
    exclude_keys         baz
</filter>

In:
{"foo" => "bar", "baz"=>[{"a"=>1}, {"a"=>2}, {"b"=>3}] , "daz" => [{"a"=>1}, {"a"=>2}, {"b"=>3}]}
Out:
{"foo"=>"bar", "baz"=>[{"a"=>1}, {"a"=>2}, {"b"=>3}], "2"=>{"b"=>3}}, "daz"=>{"0"=>{"a"=>1} , "1"=>{"a"=>2}, "2"=>{"b"=>3}}}
```

## Installation

### RubyGems

```
$ gem install fluent-plugin-record_indexing
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

* **key_name** (array) default: []
* **key_prefix** (string) default: nil
* **exclude_keys** (array) default: [] Use this parameter if you need to keep the value as is without indexing
* **check_all_key**  (bool) default: true


## Copyright

* Copyright(c) 2017, Tema Novikov
* License
  * Apache License, Version 2.0
