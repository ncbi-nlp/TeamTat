Rails.application.routes.draw do
  resources :audits
  get 'statistics/index'
  get '/sessions/:session_str', to: 'users#sessions'
  get '/about' => "home#about"
  get '/stat' => "home#stat"
  resources :relation_types
  resources :api_keys
  resources :relations
  resources :annotations
  resources :assigns do
    resources :annotations 
  end
  resources :project_users
  resources :tasks
  resources :models
  resources :lexicons
  resources :lexicon_groups
  resources :entity_types
  resources :documents do 
    collection do 
      get 'check'
    end
    member do
      get 'verify'
      get 'partial'
      post 'delete_all_annotations'
      post 'done'
      post 'curatable'
      get 'reorder'
      get 'correct_pmc_id'
      post 'attach'
      post 'detach'
      post 'start_round'
      post 'start_round2'
      post 'simple_merge'
      post 'final_merge'
      get 'prev'
      get 'next'
    end
    resources :relations 
    resources :annotations 
  end
  resources :projects do
    collection do
      get 'partial'
      post 'load_samples'
    end
    member do
      get 'download'
      post 'empty'
      post 'done_all'
      post 'delete_all_annotations'
      get 'reorder'
      get 'start_round'
      get 'start_round2'
      post 'cancel_round'
      get 'end_round'
      get 'final_merge'
      post 'lock'
      post 'unlock'
      get 'buttons'
    end
    resources :statistics do 
      collection do 
        get 'entities'
      end
    end
    resources :audits
    resources :documents
    resources :assigns do
      collection do
        get 'download'
        post 'upload'
      end
    end
    resources :entity_types do
      collection do
        post 'import_default_color'
        post 'import'
      end
    end

    resources :relation_types do
      collection do 
        post 'import'
      end
    end

    resources :project_users
    resources :tasks do
      collection do
        get 'partial'
      end
    end
    resources :models
    resources :lexicon_groups do
      collection do 
        post 'load_samples'
      end
    end
  end

  resources :lexicon_groups do
    resources :lexicons do
      collection do
        post 'upload'
      end
    end
  end

  get 'home/index'
  get 'home/sitemap'
  get 'home/proxy'
  get 'home/tos'
  get 'home/privacy'
  devise_for :users, path: 'account', path_names: {
    sign_in: 'new',
    sign_out: 'destroy',    
  },:controllers => { 
    :omniauth_callbacks => "users/omniauth_callbacks",
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :users do
    member do
      get 'become'
    end
    collection do 
      post 'sendmail'
      post 'generate'
    end
    resources :projects do
      collection do
        get 'partial'
        post 'load_samples'
      end
      resources :tasks do
        collection do
          get 'partial'
        end
      end
      resources :documents
      resources :entity_types
      member do
        get 'download'
        post 'empty'
        post 'done_all'
        post 'delete_all_annotations'
      end
    end
  end

  root to: "home#index"
end
