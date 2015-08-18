require_relative 'docker_image'
require 'shellwords'

module Concourse
  class DockerContainer
    def initialize(image:, command:, stdin: "", name:, volumes: [])
      @image     = image
      @command   = command
      @name      = name
      @stdin     = stdin
      @volumes   = volumes
    end

    def image
      @docker_image ||= DockerImage.new(image: @image)
    end

    def output
      @output ||= `echo #{Shellwords.escape(@stdin)} | docker run \
        -i \
        --name #{@name} \
        #{image.to_s} \
        #{@command.shelljoin}
      `
    end

    private

    def volumes_as_cli
      @volumes.collect do |volume|
        "-v"
      end
    end
  end
end
