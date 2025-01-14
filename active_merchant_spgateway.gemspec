# frozen_string_literal: true

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_merchant_spgateway/version'

Gem::Specification.new do |spec|
  spec.name          = "active_merchant_spgateway"
  spec.version       = ActiveMerchantSpgateway::VERSION
  spec.authors       = ["RJ", "CHH"]
  spec.email         = ["chh@backer-founder.com"]

  spec.summary       = %q{Unofficial Spgateway(智付通) gem base on active_merchant and inspired by https://github.com/imgarylai/active_merchant_pay2go}
  spec.description   = %q{This is an unofficial SpGateway(智付通) gateway gem base on active_merchant, including helper form helper methods and gateway}
  spec.homepage      = "https://github.com/BackerFounder/active_merchant_spgateway"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activemerchant', '~> 1.88.0'
  spec.add_dependency 'offsite_payments', '~> 2'
  spec.add_dependency 'money', '~> 6.13', '>= 6.13.8'

  spec.add_development_dependency "bundler", ">= 1.11"
  spec.add_development_dependency "pry", "~> 0.10.4"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rails', '>= 3.2.6', '< 6'
  spec.add_development_dependency 'test-unit', '~> 3.0'
end
