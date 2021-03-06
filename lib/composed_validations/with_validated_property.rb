module ComposedValidations
  class WithValidatedProperty < ::SimpleDelegator
    attr_reader :property, :validator
    def initialize(resource, property, validator)
      super(resource)
      @property = ComposedValidations::ValidatedProperty(property)
      @validator = validator
    end

    def class
      __getobj__.class
    end

    def valid?(*args)
      __getobj__.valid?(*args)
      unless validator.valid_value?(result)
        errors.add(property.validated_property, validator.message)
      end
      errors.blank?
    end

    def save(*args)
      return false unless valid?
      __getobj__.save(*args)
    end

    private

    def result
      __send__(property.property_accessor)
    end
  end
end
