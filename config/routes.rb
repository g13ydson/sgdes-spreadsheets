Rails.application.routes.draw do
  root to: "static#homepage"
  post "spreadsheet", to: "spreadsheets#create", as: "spreadsheet_creator"
  post "return", to: "spreadsheets#return", as: "spreadsheet_return"
end
