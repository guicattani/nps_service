# frozen_string_literal: true

Rails.application.routes.draw do
  resources :net_promoter_score, only: :index
  resources :net_promoter_score, only: :update, param: :token
end
