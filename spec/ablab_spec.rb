require 'spec_helper'

describe ABLab do
  it 'has a version number' do
    expect(ABLab::VERSION).not_to be nil
  end

  describe '.experiment' do
    let(:ab) do
      Module.new { extend ABLab::ModuleMethods }
    end

    it 'creates an experiment' do
      ab.experiment :foo_bar do; end
      expect(ab.experiments[:foo_bar]).to be_a(ABLab::Experiment)
    end
  end

  describe ABLab::Experiment do
    let(:experiment) do
      ABLab::Experiment.new(:foo) do; end
    end

    describe '#description' do
      it 'sets the description' do
        experiment.description 'foo bar'
        expect(experiment.description).to eq('foo bar')
      end
    end

    describe '#bucket' do
      it 'creates a bucket' do
        experiment.bucket :a, description: 'foo bar baz'
        expect(experiment.buckets.last).to be_a(ABLab::Bucket)
        expect(experiment.buckets.last.name).to eq(:a)
      end
    end
  end

  describe ABLab::Experiment do
    let(:experiment) do
      ABLab::Experiment.new(:foo) do
        bucket :a
        bucket :b
        bucket :c
      end
    end

    it 'gets assigned to the right bucket' do
      a = ABLab::Run.new(experiment, 0)
      b = ABLab::Run.new(experiment, 334)
      c = ABLab::Run.new(experiment, 999)
      expect(a).to be_in_bucket(:a)
      expect(b).to be_in_bucket(:b)
      expect(c).to be_in_bucket(:c)
    end
  end
end
