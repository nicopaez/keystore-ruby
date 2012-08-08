Feature: view pages

  Background: Login
    Given I am on "the login page"
    When I fill in "name" with "user"
    When I fill in "email" with "user@something.com"
    When I press "Sign In"
    Then I should see "Key Store"

  Scenario: Display home page
    Given I am on "the home page"
    Then I should see "Key Store"

  @javascript
  Scenario: Create new note
    Given I am on "the home page"
    When I press "New"
    Then I should see "Note"
    When I fill in "key" with "key#1"
    When I fill in "value" with "value#1"
    When I press "Save changes"
    Then I should see "Changes successfully saved"



