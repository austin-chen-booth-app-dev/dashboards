class CurrenciesController < ApplicationController
  def first_currency
    # Read a string of all the contents. I bet we have to unmarshal it.

    @parsed_data = JSON.parse(open("https://api.exchangerate.host/symbols").read)

    symbols_hash = @parsed_data.fetch("symbols")

    @array_of_symbols = symbols_hash.keys
    render({ :template => "currency_templates/step_one.html.erb" })
  end

  def specific_currency
    # Read a string of all the contents. I bet we have to unmarshal it.

    @parsed_data = JSON.parse(open("https://api.exchangerate.host/symbols").read)

    symbols_hash = @parsed_data.fetch("symbols")

    @specific_currency = params.fetch("currency")

    @array_of_symbols = symbols_hash.keys
    render({ :template => "currency_templates/specific_currency.html.erb" })
  end

  def currency_conversion
    # Read a string of all the contents. I bet we have to unmarshal it.

    @root_currency = params.fetch("root_currency")
    @target_currency = params.fetch("target_currency")

    @parsed_data = JSON.parse(open("https://api.exchangerate.host/convert?from=#{@root_currency}&to=#{@target_currency}").read)

    @conversion_rate = @parsed_data.fetch("result")

    render({ :template => "currency_templates/conversion.html.erb" })
  end
end
