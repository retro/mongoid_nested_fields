# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mongoid_nested_fields}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["retro"]
  s.date = %q{2010-12-26}
  s.description = %q{MongoidNestedFields allows you to handle complex data structures inside one field in MongoDB. It also validates whole object graph on field validation}
  s.email = %q{konjevic@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".autotest",
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/mongoid_nested_fields.rb",
    "lib/mongoid_nested_fields/errors.rb",
    "lib/mongoid_nested_fields/errors/unexpected_type.rb",
    "lib/mongoid_nested_fields/nested_field_hash.rb",
    "lib/mongoid_nested_fields/nested_field_holder.rb",
    "lib/mongoid_nested_fields/nested_field_part.rb",
    "lib/mongoid_nested_fields/nested_field_setter.rb",
    "mongoid_nested_fields.gemspec",
    "test/helper.rb",
    "test/test_mongoid_nested_fields.rb"
  ]
  s.homepage = %q{http://github.com/retro/mongoid_nested_fields}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{MongoidNestedFields allows you to handle complex data structures inside one field in MongoDB.}
  s.test_files = [
    "test/helper.rb",
    "test/test_mongoid_nested_fields.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongoid>, ["= 2.0.0.beta.20"])
      s.add_runtime_dependency(%q<bson_ext>, ["= 1.1.5"])
      s.add_runtime_dependency(%q<yajl-ruby>, [">= 0.7.8"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.3"])
      s.add_runtime_dependency(%q<activemodel>, [">= 3.0.3"])
      s.add_development_dependency(%q<autotest>, [">= 0"])
      s.add_development_dependency(%q<autotest-growl>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<mongoid>, ["= 2.0.0.beta.20"])
      s.add_dependency(%q<bson_ext>, ["= 1.1.5"])
      s.add_dependency(%q<yajl-ruby>, [">= 0.7.8"])
      s.add_dependency(%q<activesupport>, [">= 3.0.3"])
      s.add_dependency(%q<activemodel>, [">= 3.0.3"])
      s.add_dependency(%q<autotest>, [">= 0"])
      s.add_dependency(%q<autotest-growl>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<mongoid>, ["= 2.0.0.beta.20"])
    s.add_dependency(%q<bson_ext>, ["= 1.1.5"])
    s.add_dependency(%q<yajl-ruby>, [">= 0.7.8"])
    s.add_dependency(%q<activesupport>, [">= 3.0.3"])
    s.add_dependency(%q<activemodel>, [">= 3.0.3"])
    s.add_dependency(%q<autotest>, [">= 0"])
    s.add_dependency(%q<autotest-growl>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

