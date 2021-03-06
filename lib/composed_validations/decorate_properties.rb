##
# Takes a resource and a hash with properties as the keys and validators as the
# values and decorates those validations onto the resource.
module ComposedValidations
  class DecorateProperties
    pattr_initialize :resource, :property_mapper

    def run
      temp_resource = resource
      property_mapper.to_a.map{|x| PropertyValidator.new(*x) }.each do |p|
        temp_resource = p.decorate_resource(temp_resource)
      end
      Decorator.new(temp_resource, property_mapper)
    end
  end

  class Decorator < SimpleDelegator
    def initialize(resource, validators)
      @validators = validators
      super(resource)
    end

    def validators
      @validator_return ||= begin
                              Hash[@validators.map do |property, validators|
                                [property.to_sym, Array(validators)]
                              end]
                            end
    end

    def class
      __getobj__.class
    end
  end

end
