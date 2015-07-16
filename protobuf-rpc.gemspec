# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'protobuf/rpc/version'

Gem::Specification.new do |spec|
  spec.name          = "protobuf-rpc"
  spec.version       = Protobuf::Rpc::VERSION
  spec.authors       = ["Garrett Thornburg"]
  spec.email         = ["film42@gmail.com"]
  spec.summary       = "Google Protocol Buffers RPC implementation for Ruby."
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '>= 3.2'
  spec.add_dependency 'middleware'
  spec.add_dependency 'thor'
  spec.add_dependency 'thread_safe'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'ffi-rzmq'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'rspec', '>= 3.0'

  # debuggers only work in MRI
  if RUBY_ENGINE.to_sym == :ruby
    # we don't support MRI < 1.9.3
    pry_debugger = if RUBY_VERSION < '2.0.0'
                     'pry-debugger'
                   else
                     'pry-byebug'
                   end

    spec.add_development_dependency pry_debugger
    spec.add_development_dependency 'pry-stack_explorer'
  else
    spec.add_development_dependency 'pry'
  end

  spec.add_development_dependency 'ruby-prof' if RUBY_ENGINE.to_sym == :ruby
end
