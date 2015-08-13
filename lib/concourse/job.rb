require_relative 'plan'

module Concourse
  class Job
    attr_reader :plan

    def self.from_manifest(jobs:)
      jobs.inject({}) do |j, job|
        j[job.fetch('name')] = Job.new(steps: job.fetch('plan'))
        j
      end
    end

    def initialize(steps:)
      @plan = Plan.new(steps: steps)
    end
  end
end
