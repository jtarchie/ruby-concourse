require 'json'
require_relative 'docker_container'

module Concourse
  class Resource
    attr :container, :name, :refs, :source, :type

    RESOURCES = {
      'git' => 'concourse/git-resource'
    }

    def self.from_manifest(resources:)
      resources.inject({}) do |r, resource|
        r[resource['name']] = Resource.new(
          name: resource['name'],
          type: resource['type'],
          source: resource['source']
        )
        r
      end
    end

    def initialize(name:, type:, source:)
      @name   = name
      @type   = type
      @source = source
    end

    def refs
      @refs ||= JSON.parse(container.output)
    end

    def check!
      @container ||= begin
                       command    = ['/opt/resource/check']
                       image_type = RESOURCES.fetch(type)
                       DockerContainer.new(
                         image: image_type,
                         command: command,
                         name: "concourse-resource-#{name}-#{Time.now.to_i}",
                         stdin: JSON.generate({
                           source: source
                         })
                       )
                     end
    end
  end
end
