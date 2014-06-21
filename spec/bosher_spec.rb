require 'rspec'
require 'yaml'
require_relative '../lib/bosher/bosher'

describe 'bosher' do
  it 'works with manifest, spec, template' do
    manifest = YAML.load(<<MANIFEST)
---
jobs:
  - name: the-job
    properties:
      property1: 7
      bosh:
        dns: [8.8.8.8]
MANIFEST
    spec = YAML.load(<<SPEC)
---
properties:
  property1:
    description: whatever
  property2:
    default: three
  bosh.dns:
    default: [7.7.7.7]
  bosh.fns:
    default: [6.6.6.6]
SPEC
    template = <<TEMPLATE
<%= p('property1') %>
<%= p('property2') %>
<%= spec.networks.default.ip %>
<%= spec.networks.default.dns %>
<%= p('bosh.dns') %>
<%= p('bosh.fns') %>
TEMPLATE

    asset = Bosher::Bosher.new.bosh manifest, spec, template, 'the-job'
    asset.should == <<ASSET
7
three
13.17.19.23
["13.17.19.29", "13.17.19.31"]
["8.8.8.8"]
["6.6.6.6"]
ASSET
  end

  it "blows up if spec doesn't have a property" do
    manifest = YAML.load(<<MANIFEST)
---
jobs:
  - name: the-job
    properties:
      property1: 7
      missing:
        from:
          spec: 5
      missing_from_spec: 17
      bosh:
        dns: [8.8.8.8]
MANIFEST
    spec = YAML.load(<<SPEC)
---
properties:
  property1:
    description: whatever
SPEC
    template = <<TEMPLATE
<%= p('missing.from.spec') %>
TEMPLATE

    expect {
    Bosher::Bosher.new.bosh manifest, spec, template, 'the-job'
    }.to raise_error(MissingPropertyInSpec)
  end
end
