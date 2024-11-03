# The Profile represents all the user's information relevant for the business logic
class Profile < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  # To validate #presence in boolean attributes, we need to use #inclusion instead.
  # This is because #presence uses #is_blank? under the hood, which always returns false for the value "false".
  validates :is_manager, inclusion: [ false, true ]
  validates :user, uniqueness: true

  # This method seems redundant given that `!is_manager()` is currently the same as `is_employee?()`.
  # However, using !is_manager() directly to check if a profile is an Employee is not the most correct thing to do
  # because, if we add a new type of user in the future, !is_manager() could return true even though the
  # profile is NOT an Employee.
  # So, using this method would make it easy in the future to change how we check if a user is employee or not
  # and avoid bugs.
  def is_employee?
    !is_manager
  end
end
