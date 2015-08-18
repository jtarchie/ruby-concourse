require_relative 'task'
require_relative 'get_resource'

module Concourse
  class Step
    def self.from_manifest(steps:)
      steps.collect do |step|
        if step['task']
          Task.from_manifest(task: step)
        elsif step['get']
          GetResource.from_manifest(step: step)
        else
          raise "Unsupported step: #{step}"
        end
      end
    end
  end
end
