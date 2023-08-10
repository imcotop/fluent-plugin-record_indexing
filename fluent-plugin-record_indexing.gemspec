# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-record_indexing"
  spec.version       = "0.2.1"
  spec.authors       = ["imcotop"]
  spec.email         = ["imcotop@icloud.com"]

  spec.summary       = %{A fluentd filter plugin that will be used to Iterate over the object with its index and returns the value of the given object.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/imcotop/fluent-plugin-record_indexing"
  spec.license       = "apache2"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "fluentd", [">= 0.12.0", "< 0.15.0"]
end
