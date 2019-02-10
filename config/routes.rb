Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/resumes', to: 'resumes#create'
  get '/resumes/:user_id', to: 'resumes#user_resumes', as: "user_resumes"
  get '/resumes/:user_id/:title/:revision', to: 'resumes#fetch_specific_resume', as: "fetch_specific_resume"
  delete '/resumes/:user_id/:title/:revision', to: 'resumes#delete_specific_resume', as: "delete_specific_resume"
  patch '/resumes/:id', to: 'resumes#update_specific_resume', as: "update_specific_resume"
end
