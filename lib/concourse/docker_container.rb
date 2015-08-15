require_relative 'docker_image'
require 'shellwords'

module Concourse
  class DockerContainer
    def initialize(image:, command:, stdin: "", name:)
      @image     = image
      @command   = command
      @name      = name
      @stdin     = stdin
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
  end
end
