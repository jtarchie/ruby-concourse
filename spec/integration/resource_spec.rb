require 'spec_helper'

module Concourse
  describe 'With the resource pipeline' do
    let(:filename) { File.join('spec', 'fixtures', 'resource.yml') }
    let(:pipeline) { Pipeline.new(filename: filename) }

    context 'with the git resource' do
      it 'can check for new commits' do
        resource = pipeline.resources['empty-git']
        resource.check!

        expect(resource.refs).to eq [
          { 'ref' => '10105bc3bf4f7a2389b21981aee35799f8d1f82c' }
        ]
      end
    end
  end
end

