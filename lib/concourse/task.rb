require_relative 'docker_container'

module Concourse
  class Task
    attr_reader :config, :container, :name

    def self.from_manifest(tasks:)
      tasks.inject({}) do |t, task|
        t[task['task']] = Task.new(name: task['task'], config: task['config'])
        t
      end
    end

    def initialize(name:, config:)
      @name   = name
      @config = config
    end

    def output
      @output ||= container.output
    end

    def execute!
      @container ||= begin
                    command   = [config['run']['path']] + config['run']['args']
                    DockerContainer.new(
                      image: config['image'],
                      command: command,
                      name: "concourse-task-#{name}-#{Time.now.to_i}",
                    )
                  end
    end
  end
end
