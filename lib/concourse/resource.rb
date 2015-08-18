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
                       DockerContainer.new(
                         image: image_type,
                         command: command,
                         name: container_name,
                         stdin: JSON.generate({
                           source: source
                         })
                       )
                     end
    end

    def in!(params:, ref:)
      @container ||= begin
                       Dir.mktmpdir do |tmp_dir|
                         command = ['/opt/resource/in', tmp_dir]
                         DockerContainer.new(
                           image: image_type,
                           command: command,
                           name: container_name,
                           stdin: JSON.generate({
                             params: params,
                             source: source,
                             version: { ref: ref }
                           })
                         )
                       end
                     end
    end

    private

    def image_type
      RESOURCES.fetch(type)
    end

    def container_name
      "concourse-resource-#{name}-#{Time.now.to_i}"
    end
  end
end
