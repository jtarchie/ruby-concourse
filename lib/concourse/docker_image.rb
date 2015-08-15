module Concourse
  class DockerImage
    attr_reader :image

    def initialize(image: )
      @image, @tag = image.dup.sub('docker:///','').split('#')
    end

    def to_s
      "#{image}:#{tag}"
    end

    def tag
      @tag || "latest"
    end
  end
end
