# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{affected_on_destroy}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcin Urbanski"]
  s.date = %q{2009-06-26}
  s.description = %q{Rails plugin showing which related records will be deleted from DB when :dependent => :destroy is used}
  s.email = %q{marcin@urbanski.vdl.pl}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION",
     "lib/affected_on_destroy.rb",
     "rails/init.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/murbanski/affected_on_destroy}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Rails plugin showing which related records will be deleted from DB when :dependent => :destroy is used}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
