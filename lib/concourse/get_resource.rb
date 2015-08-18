module Concourse
  class GetResource
    attr_reader :name, :output, :params

    def self.from_manifest(step:)
      GetResource.new(name: step['get'], params: step['params'])
    end

    def initialize(name:, params:)
      @name = name
      @params = params
    end

    def execute!(pipeline:)
      @output ||= begin
                    resource = pipeline.resources.fetch(name)
                    resource.in!(
                      params: params,
                      resource.refs.last.fetch(:ref)
                    )
                    resource.output
                  end
    end
  end
end
