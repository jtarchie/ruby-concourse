require_relative 'task'

module Concourse
  class Plan
    attr_reader :output, :steps

    def initialize(steps:)
      @steps = Task.from_manifest(tasks: steps)
    end

    def tasks
      @steps
    end

    def execute!
      @output ||= steps.collect do |name, step|
        step.execute!
        step.output
      end
    end
  end
end
