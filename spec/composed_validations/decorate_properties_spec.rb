require 'spec_helper'

RSpec.describe ComposedValidations::DecorateProperties do
  subject { described_class.new(resource, property_mapper) }
  let(:resource) { double("ValidatableAsset") }
  let(:property_mapper) do
    {
      :title => [
        validator,
        validator2
      ]
    }
  end
  let(:validator) { fake_validator(true) }
  let(:validator2) { fake_validator(true) }

  describe "#run" do
    before do
      allow(ComposedValidations::WithValidatedProperty).to receive(:new).and_call_original
    end
    it "should decorate the given properties" do
      result = subject.run

      expect(ComposedValidations::WithValidatedProperty).to have_received(:new).with(resource, :title, validator)
      expect(ComposedValidations::WithValidatedProperty).to have_received(:new).with(result.__getobj__, :title, validator2)
    end
  end

  describe "#validators" do
    it "should give back the properties" do
      expect(subject.run.validators).to eq property_mapper
    end
    it "should give back accessors as keys if given a ValidatedProperty" do
      result = described_class.new(resource, {ComposedValidations::ValidatedProperty.new(:lcsubject, :lcsubject_ids) => validator}).run
      expect(result.validators).to eq ({:lcsubject => [validator]})
    end
  end

  def fake_validator(result=true)
    v = double("Validator")
    allow(v).to receive(:valid?).with(resource).and_return(result)
    allow(v).to receive(:message).and_return("has a bad validation")
    v
  end
end
