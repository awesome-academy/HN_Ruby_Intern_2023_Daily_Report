class DatetimeValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    return if value.blank?

    options.with_defaults(
      check: :eql, to: :date
    ) => {check:, to:, **pivots}

    value = value.send("to_#{to}") if value.respond_to? "to_#{to}"

    pass = true
    if value.respond_to? "#{check}?"
      params = value.method("#{check}?").parameters
      pass = if params.blank?
               value.send("#{check}?")
             else
               value.send("#{check}?", *pivots.values[0...params.length])
             end
    end

    return if pass

    record.errors.add attribute,
                      I18n.t("validations.datetime.#{to}_#{check}", **pivots)
  end
end
