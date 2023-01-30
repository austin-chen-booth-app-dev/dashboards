Rails.application.routes.draw do
  # get("/", { :controller => "application", :action => "homepage" })

  # Forex
  get("/forex", { :controller => "currencies", :action => "first_currency" })
  get("/forex/:currency", { :controller => "currencies", :action => "specific_currency" })
  get("/forex/:root_currency/:target_currency", { :controller => "currencies", :action => "currency_conversion" })

  # Covid
  get("/covid", { :controller => "covid", :action => "get_covid_status" })
  get("/covid/:specific_state", { :controller => "covid", :action => "get_specific_state_info" })
end
