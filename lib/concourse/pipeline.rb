require 'yaml'
require_relative 'job'

module Concourse
  class Pipeline
    attr_reader :jobs

    def initialize(filename:)
      @filename = filename
      @jobs = Job.from_manifest(jobs: manifest['jobs'])
    end

    private

    def manifest
      @manifest ||= YAML.load_file(@filename)
    end
  end
end
