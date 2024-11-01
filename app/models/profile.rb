# The Profile represents all the user's information relevant for the business logic
class Profile < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  # To validate #presence in boolean attributes, we need to use #inclusion instead.
  # This is because #presence uses #is_blank? under the hood, which always returns false for the value "false".
  validates :is_manager, inclusion: [false, true]
  validates :user, uniqueness: true
end
