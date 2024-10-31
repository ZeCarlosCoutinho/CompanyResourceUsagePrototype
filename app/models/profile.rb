# The Profile represents all the user's information relevant for the business logic
class Profile < ApplicationRecord
  belongs_to :user
end
