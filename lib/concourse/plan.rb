require_relative 'step'
require_relative 'task'

module Concourse
  class Plan
    attr_reader :output, :steps

    def initialize(steps:)
      @steps = Step.from_manifest(steps: steps)
    end

    def tasks
      @tasks ||= steps.inject({}) do |tasks, step|
        tasks[step.name] = step if step.is_a? Task
        tasks
      end
    end

    def execute!(pipeline:)
      @output ||= steps.collect do |step|
        step.execute!(pipeline: pipeline)
        step.output
      end
    end
  end
end
