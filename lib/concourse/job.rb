require_relative 'task'

module Concourse
  class Job
    attr_reader :tasks

    def self.from_manifest(jobs)
      jobs.inject({}) do |j, job|
        j[job.fetch('name')] = Job.new(tasks: job.fetch('plan'))
        j
      end
    end

    def initialize(tasks:)
      @tasks = Task.from_manifest(tasks: tasks)
    end
  end
end
