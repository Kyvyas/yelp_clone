require 'factory_girl'

FactoryGirl.define do

  factory :user do
    email 'katya@test.com'
    password '12345678'
    password_confirmation '12345678'
  end

  # factory :user_2, parent: :user do
  #   email 'owen@test.com'
  #   password ''
  #   password_confirmation '12345'
  #   name 'Owen'
  # end
  
end
