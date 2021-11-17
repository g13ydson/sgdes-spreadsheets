Rails.application.routes.draw do
  root to: 'static#homepage'
  post 'spreadsheet', to: 'spreadsheets#create', as: 'spreadsheet_creator'
end
