Rails.application.routes.draw do
  # get("/", { :controller => "application", :action => "homepage" })

  get("/forex", { :controller => "currencies", :action => "first_currency" })
  get("/forex/:currency", { :controller => "currencies", :action => "specific_currency" })
  get("/forex/:root_currency/:target_currency", { :controller => "currencies", :action => "currency_conversion" })
end
