# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## General log

Installed Rails locally.


## Time log

- Oct 28th
  - Setup: 16:10 - 16:30
  - Planning: 16:30 -16:40
  - Requirements: 16:40 - 17:00
  - Data Model definition: 17:20 - 17:45
  - Data Model definition: 18:10 - 18:20
  - Requirements: 18:20 - 18:30

## TODO

- Define the requirements (0.5 hours)
- Define the data model (0.5 hours)
- Define the UI pages (and user flows?) (0.5 hours)
- Setup system (Docker, Compose, Postgres) (0.5 hour)
- Implement data model (with tests!) (3h)
- Setup Capybara (1h)
- Implement frontend (with Capybara tests!) (2h)


## User Requirements

### Mandatory
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

### Optional
- As a user, I want to create an account. (For now, we can create the accounts in the seeds)
- As an employee, I want to see which values have been rejected, so that I know that those values need my attention.
- As an employee, I want to know which manager approved/rejected a inputted value, so I can discuss with them in real life if needed.
- As an employee, I want to see the date and time when a value has been approved/rejected, so I can use it as reference.
- As a manager, I want to reject a value for a specific gauge and time slot, so that I indicate that the value is not correct and needs more investigation from the employee.
- As a manager, I want to see who logged a value in a gauge, so I know which employee to contact in real life if needed.
- As a user, I want to be able to switch between companies.
- As a user, I want to see if all the values of a gauge are already filled in and approved, so that I know that that gauge requires no more action.


## UI Pages
A) Login page
  - Write user and password
B) Company Gauges overview page
  - List all the gauges
    - Show name and unit of each gauge
    - Button to open the details
C) Gauges detail page
  - Show the name, unit, time slot type and begin-end date.
  - Show the list of all the possible logs up until now.
    - Each logs shows the time slot, the current value (and an input to change it)
    - Also, if not yet approved, for the employee, it shows a button to save, and for the manager it shows a button to approve.


## Feature requirements
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


# Data Model
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
