require 'erb'
require 'ostruct'
require 'yaml'
require 'active_support/core_ext'

module Bosher
  class Bosher
    class ErbalT < OpenStruct
      def render(template)
        ERB.new(template).result(binding)
      end

      def p(key)
        key.split('.').reduce(self) do |memo, k|
          memo[k]
        end
      end

      def spec
        OpenStruct.new(networks: OpenStruct.new({
          default: OpenStruct.new(
            ip: "13.17.19.23",
            dns: ["13.17.19.29", "13.17.19.31"],
          )
        }))
      end
    end

    def bosh(manifest, spec, template, job_name)
      spec_defaults = spec_defaults(spec)
      defaults = nestify(spec_defaults)
      ErbalT.new(defaults.deep_merge(properties(manifest, job_name))).render(template)
    end

    private

    def nestify(hsh)
      if hsh.keys.size == 1 && hsh.keys.first.empty?
        return hsh.values.first
      end
      hsh.reduce({}) do |memo, kv|
        parts = kv[0].split('.')
        key = parts[0]
        value = kv[1]
        memo.deep_merge({key => nestify(parts.drop(1).join('.') => value)})
      end
    end

    def spec_defaults(spec)
      spec['properties'].reduce({}) do |memo, kv|
        memo.merge({kv[0] => kv[1]['default']})
      end
    end

    def properties(manifest, job_name)
      manifest['jobs'].detect do |job|
        job['name'] == job_name
      end['properties']
    end
  end
end
