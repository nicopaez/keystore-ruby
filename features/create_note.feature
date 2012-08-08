Feature: Create new note

  Background: Login
    Given the note "key0", "value0" exists
    Given I am on "the login page"
    When I fill in "name" with "user"
    When I fill in "email" with "user@something.com"
    When I press "Sign In"
    Then I should see "Key Store"


  @javascript
  Scenario: Happy path
    Given I am on "the home page"
    When I press "New"
    Then I should see "Note"
    When I fill in "key" with "key1"
    When I fill in "value" with "value1"
    When I press "Save changes"
    Then I should see "Changes successfully saved"

  @javascript
  Scenario: Key already exists
    Given I am on "the home page"
    When I press "New"
    Then I should see "Note"
    When I fill in "key" with "key0"
    When I fill in "value" with "value0"
    When I press "Save changes"
    Then I should see "Duplicated key"


