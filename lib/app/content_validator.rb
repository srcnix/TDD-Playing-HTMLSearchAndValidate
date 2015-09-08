class ContentValidator
  attr_reader :validator

  def initialize(validator: 'W3CMarkup')
    self.validator = validator
  end

  def validate_content(content)
    self.validator.validate_content(content)
  end

  def validator=(validator)
    validator_class_str = "Validators::#{validator}"

    unless Class.const_defined?(validator_class_str)
      raise ContentValidator::Exception, "#{validator_class_str} undefined"
    end

    @validator = Class.const_get(
      validator_class_str
    ).new
  end

  class Exception < ::Exception; end
end
