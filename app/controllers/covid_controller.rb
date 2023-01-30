class CovidController < ApplicationController
  def get_covid_status
    @parsed_data = JSON.parse(open("https://api.covidtracking.com/v1/states/current.json").read)

    @state_info = Hash.new

    numeric_date = JSON.parse(open("https://api.covidtracking.com/v1/us/current.json").read)[0]["date"]

    @date_formatted = Date.new(numeric_date.to_s[0..3].to_i, numeric_date.to_s[4..5].to_i, numeric_date.to_s[6..7].to_i)
    day_formatted = @date_formatted.day
    @date_string = @date_formatted.strftime("%B #{day_formatted}th, %Y")

    @parsed_data.each do |state|
      state_data = Hash.new

      state_data["state"] = state["state"]
      state_data["positive_increase"] = state["positiveIncrease"]
      state_data["total_test_results_increase"] = state["totalTestResultsIncrease"]
      if state_data["total_test_results_increase"].to_i == 0
        state_data["percentage_positive"] = "No tests"
      else
        state_data["percentage_positive"] = "#{"%.3f" % ((state_data["positive_increase"].to_f / state_data["total_test_results_increase"].to_f) * 100).round(3)}%"
      end

      if state_data["percentage_positive"] == "No tests"
        state_data["style_color"] = "red"
      elsif state_data["percentage_positive"][0..-2].to_f < 5
        state_data["style_color"] = "grey"
      elsif state_data["percentage_positive"][0..-2].to_f >= 5 and state_data["percentage_positive"][0..-2].to_f < 10
        state_data["style_color"] = "lightsalmon"
      elsif state_data["percentage_positive"][0..-2].to_f >= 10
        state_data["style_color"] = "firebrick"
      end

      @state_info[state_data["state"]] = state_data
    end

    render({ :template => "covid_templates/covid_report.html.erb" })
  end

  def get_specific_state_info
    @specific_state = params.fetch("specific_state")

    @data_array = Array.new
    @data_array.append(["Date", "Percent of new tests comprised of new positive cases"])

    @parsed_data = JSON.parse(open("https://api.covidtracking.com/v1/states/daily.json").read)

    @parsed_data.reverse_each do |day|
      daily_percentage = Array.new
      date_year = day["date"].to_s[0..3].to_i
      date_month = day["date"].to_s[4..5].to_i
      date_day = day["date"].to_s[6..7].to_i
      date_formatted = Date.new(date_year, date_month, date_day)

      daily_percentage.append(date_formatted)
      daily_percentage.append(day["positiveIncrease"].to_f / day["totalTestResultsIncrease"].to_f)

      @data_array.append(daily_percentage)
    end

    render({ :template => "covid_templates/state_graph.html.erb" })
  end
end
