require 'yaml'
require_relative 'job'
require_relative 'resource'

module Concourse
  class Pipeline
    attr_reader :jobs, :resources

    def initialize(filename:)
      @filename = filename
      @jobs = Job.from_manifest(jobs: manifest['jobs'] || [])
      @resources = Resource.from_manifest(resources: manifest['resources'] || [])
    end

    private

    def manifest
      @manifest ||= YAML.load_file(@filename)
    end
  end
end
