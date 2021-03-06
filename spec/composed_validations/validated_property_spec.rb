require 'spec_helper'

RSpec.describe ComposedValidations::ValidatedProperty do
  subject { described_class.new(:validated_property, :property_accessor) }
  describe "#validated_property" do
    it "should return the validated property" do
      expect(subject.validated_property).to eq :validated_property
    end
  end
  describe "#property_accessor" do
    it "should return the property accessor" do
      expect(subject.property_accessor).to eq :property_accessor
    end
  end

  describe "#to_sym" do
    it "should return the validated property" do
      expect(subject.to_sym).to eq :validated_property
    end
  end

  describe "Caster" do
    subject { ComposedValidations::ValidatedProperty(value) }
    context "when given a string" do
      let(:value) { "test" }
      it "should return with both attributes set to its symbol" do
        expect(subject.validated_property).to eq :test
        expect(subject.property_accessor).to eq :test
      end
    end
    context "when given a validated property" do
      let(:value) { described_class.new(:test, :test2) }
      it "should return it back" do
        expect(subject).to eq value
      end
    end
  end
end
