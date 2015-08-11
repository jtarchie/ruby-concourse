require 'docker'

module Concourse
  class Task
    attr_reader :config, :container, :name

    def self.from_manifest(tasks:)
      tasks.inject({}) do |t, task|
        t[task['task']] = Task.new(name: task['task'], config: task['config'])
        t
      end
    end

    def initialize(name: ,config:)
      @name   = name
      @config = config
    end

    def output
      @output ||= container.tap(&:start!).logs(stdout: true)
    end

    def execute!
      @container ||= begin
                    command   = [config['run']['path']] + config['run']['args']
                    image     = config['image'].sub('docker:///', '')
                    container = Docker::Container.create('Cmd' => command, 'Image' => image, 'Tty' => true)
                    container.rename("concourse-task-#{name}")
                    container
                  end
    end
  end
end
