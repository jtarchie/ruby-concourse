require 'spec_helper'

module Concourse
  describe 'With the hello_world pipeline' do
    let(:pipeline) { Pipeline.new(filename: File.join('spec', 'fixtures', 'hello-world.yml')) }

    context 'when the task say-hello has run' do
      it 'has an output' do
        task = pipeline.jobs['hello-world'].tasks['say-hello']
        task.execute!

        expect(task.output.chomp).to eq 'Hello, world!'
      end
    end
  end
end
