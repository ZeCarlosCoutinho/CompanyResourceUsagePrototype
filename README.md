# Company Resource Usage Dashboard

This system was developed as an assignment for a technical interview.
It is comprised of a simple Rails app connected to a Postgres database.

The system is meant to keep track of the resource usage of a company.
Employees can log in to create gauges, which store several measurements of a specific resource for a period of time, and in each gauge, they can log how much a company used of that resource in a certain time slot (day, month, etc.).
Managers can log in to review the values logged by the employees, and approve them in case they are correct.

The system has the following pages:
- **Log in page**: use the premade credentials to log in.
- **Gauge list page**: lists all the gauges created until now.
- **New Gauge page**: shows a form to create a new gauge.
- **Gauge details page**: shows all the logs of a certain gauge. Employees can log/edit values here, and Managers can approve them.

## Installation

All you need to run this system locally is have Docker (and Docker Compose) installed.
The rest is taken care of by Docker.

You should also have a `.env` file with the following variables set to whatever you prefer:
```
POSTGRES_DATABASE=<db_name>
POSTGRES_USERNAME=<db_username>
POSTGRES_PASSWORD=<db_password>
POSTGRES_HOST=db
```

## Running the system

1. Run `docker compose up`, to start the system.
2. Run `bin/be rails db:seed`, to populate the database with test accounts.
3. Go go `localhost` on your browser, to try the website.

You can find the credentials for the test accounts in `db/seeds.rb`.

If you want to make changes to the files and have the server restart automatically, then use `docker compose watch` instead in step 1.

## Running the tests

To run the test suite, run `bin/rspec-docker` while the docker containers are up.

## Further development (aka TODO)
- Features
  - Allow Gauges to work with time ranges other than `daily`.
    - _Note: It would be quite more complex if the system had to take into account time slots with varying sizes, so, given the time available, I opted by only supporting daily time slots and implementing other features that would make the product more complete._
  - Register new users.
  - Delete Gauges and Logs.
  - Edit Gauges.
  - Sort the Logs by date in the Gauge details view.
  - Show the currently logged in user.
  - Make it pretty with CSS (probably add Bootstrap)
  - Improve how error statuses are handled.
  - Run CI with a Postgres DB
- Controllers & Routing
  - Write the Gauge controller tests.
    - _Note: Given the limited time available, I could not write the tests for all controllers. However, I tried to write at least some examples of controller tests (Gauge Log controller) and some examples of system tests._
  - Use RESTful routes instead of the old fashioned ones that were coded.
    - _Note: This would make the code more modern and standardized. But since rails generated the old fashioned routes by default and the resourceful/RESTful routes were giving some errors which I could not solve, I decided to skip this._
- Testing
  - Develop system and controller tests for the unauthenticated users.
  - Return the error messages on the controller, so that we can test for sure that it returned the correct error.
- Refactoring
  - Refactor `is_<something>?` methods to just `<something?>`. It is more Ruby-like.

---
---
# Preparation
This section of the README is more focused on the assignment itself. It will describe the planning that happened before the coding started and the development process that happened during coding.

In broad terms, this was the process that I planned on doing:
1. [Gather user requirements](#user-requirements)
2. [Understand which UI pages and Controllers/actions must exist.](#ui-pages)
3. [Make a draft data model.](#data-model)
4. [Make a very rough planning and time estimation.](#plan)
5. Start development

## User Requirements
Below is the list of user requirements that were extracted from the assignment text.
The list is divided between _mandatory_ (explicitly mentioned in the text) and _optional_ (extras added by me).

### Stories
#### Mandatory
- As a user, I want to log in.
- As a user, I want to log out.
- As a user, I want to be associated with a company, so that I see only the data of that company.
- As an employee, I want to see which gauges the company has and their values, so that I know which values have already been filled in.
- As an employee, I want to see which gauges have values that have to be filled in, so that I know which data I still have to report.
- As an employee, I want to see which values have been approved, so that I know that those values require no more action on my side.
- As an employee, I want to see which values are pending, so that I know that the manager still has to act upon them.
- As an employee, I want to add a value to a gauge for a specific time slot, so I report a value that the manager can verify.
- As an employee, I want to edit a non-approved value in a gauge, so that I can correct a mistake in filling in the data.
- As an employee, I want to create a gauge, so that me and other employees can fill in values for a certain resource.
- As a manager, I want to see which gauges the company has and their values, so that I know what kind of data I have to verify.
- As a manager, I want to approve a value for a specific gauge and time slot, so that I indicate that the value is indeed correct and can be locked.

#### Optional
- As a user, I want to create an account. (For now, we can create the accounts in the seeds)
- As an employee, I want to see which values have been rejected, so that I know that those values need my attention.
- As an employee, I want to know which manager approved/rejected a inputted value, so I can discuss with them in real life if needed.
- As an employee, I want to see the date and time when a value has been approved/rejected, so I can use it as reference.
- As a manager, I want to reject a value for a specific gauge and time slot, so that I indicate that the value is not correct and needs more investigation from the employee.
- As a manager, I want to see who logged a value in a gauge, so I know which employee to contact in real life if needed.
- As a user, I want to be able to switch between companies.
- As a user, I want to see if all the values of a gauge are already filled in and approved, so that I know that that gauge requires no more action.

### UI Pages
From the mandatory users stories above, the following list, which contains the necessary UI pages, was created.

1. Login page
  1. Write user and password
2. Company Gauges overview page
  1. List all the gauges
  2. Show name and unit of each gauge
  3. Show button to open the details
3. Gauges detail page
  - Show the name, unit, time slot type and begin-end date.
  - Show the list of all the possible logs up until now.
    - Each logs shows the time slot, the current value (and an input to change it)
    - Also, if not yet approved, for the employee, it shows a button to save, and for the manager it shows a button to approve.

## Controller actions
These were the desired controller actions during the planning phase.

- User Controller
  - Login
  - Logout
- Profile Controller
  - Index
- Gauges Controller
  - Index
  - Create
  - (Delete?)
  - (Update?)
    - Only the name.
- Gauge Log Controller
  - Create
  - Update
  - Approve

## General dev log

Installed Rails locally.
Generated a Rails project using the Rails utility.
Planned the features and DB model
Setup Docker with Postgres
  Had some issues here with starting Docker given the production configs.
Setup Devise
Setup RSpec and FactoryBot
  Having some hiccups here with automatic import of factories.
  Solved by using rspec-rails instead of rspec
Implementing the User and Profile model
  Having issues with DB cleaning before/after the tests.
  Solved by adding the DatabaseCleaner gem.
(After this point I stopped recording more logs. It went mostly smoothly, implementing controllers and views)

## Plan

This was the original plan that was conceived. It was _very_ optimistic.

- Define the requirements (0.5 hours)
- Define the data model (0.5 hours)
- Define the UI pages (and user flows?) (0.5 hours)
- Setup system (Docker, Compose, Postgres) (0.5 hour)
- Implement data model (with tests!) (3h)
- Setup Capybara (1h)
- Implement frontend (with Capybara tests!) (2h)


### Data Model
Users
  - Email
  - Password
Companies
Profiles (Manager/Employee)
  - Name
  - IsManager # In case we want to add more types, we can easily do a migration to convert `false`->`employee` and `true`->`manager`.
  - FK: User
  - FK: Company # For now, this suffices. Even if we want a user to be able to be associated with multiple companies, they can already do it by creating more than one account.
Gauges
  - Units
  - Time slot type
  - Begin + End date
  - Name
GaugeLog (Gauge-Employee)
GaugeLogReview (GaugeLog-Manager)
  The GaugeLogReview is not necessary with the current basic requirements. It suffices to add an `approved_by` field to GaugeLog.
  However, for expansions purposes, it might be useful. For example, if we want multiple Managers to approve a GaugeLog, or if we want to associate extra info to the review of a Manager, or even if we want to keep track of the history of approvals/rejections.

## Time log

- Oct 28th (1h 35m)
  - Setup: 16:10 - 16:30
  - Planning: 16:30 -16:40
  - Requirements: 16:40 - 17:00
  - Data Model definition: 17:20 - 17:45
  - Data Model definition: 18:10 - 18:20
  - Requirements: 18:20 - 18:30
- Oct 29th (1h 35m)
  - Setup: 18:15 - 19:15
  - Setup: 20:00 - 20:10
  - Setup (devise): 20:10 - 20:35
- Oct 30th (30m)
  - Setup(db): 18:00 - 18:30
- Oct 31st (4h 10m)
  - Setup(tests): 12:00 - 14:30
  - Setup(tests): 14:50 - 15:20
  - Setup(tests): 19:00 - 19:10
  - User and Profile model: 19:30 - 20:30
- Nov 1st
  - User and Profile model: 20:05 - 21:05
  - Gauge model: 21:05 - 22:00
  - Gauge model: 22:00 - 22:30
  - Gauge model: 23:05 - 23:55
- Nov 2nd
  - Gauge model: 10:00 - 12:05
  - Capybara setup: 14:40 - 17:00
  - Gauge system tests: 17:00 - 19:30
- Nov 3rd
  - Gauge actions (index, new and create): 9:25 - 13:45
  - Gauge actions (show): 15:00 - 16:05
  - Gauge log action (approve, create, update): 16:15 - 0:15
  - Navigation and Docs: 0:30 - 2:30