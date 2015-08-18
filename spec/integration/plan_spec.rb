require 'spec_helper'

module Concourse
  describe 'With the hello_world pipeline' do
    let(:filename) { File.join('spec', 'fixtures', 'hello-world.yml') }
    let(:pipeline) { Pipeline.new(filename: filename) }

    context 'when the plan has run' do
      it 'has multiple outputs' do
        plan = pipeline.jobs['hello-world'].plan
        plan.execute!(pipeline: pipeline)

        expect(plan.output).to eq ["Hello, world!\n"]
      end
    end
  end
end
