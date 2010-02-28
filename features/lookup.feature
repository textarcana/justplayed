Feature: Lookup
  In order to find out what songs I heard earlier
  As a radio listener with network access
  I want to look up the songs I bookmarked

  Scenario: Looking up a snap
    Given a list of radio stations "KNRK"
    And a test server
    And the following snaps:
      | station | time     |
      | KNRK    | 12:00 PM |
    When I look up my snaps
    Then I should see the following snaps:
      | title                | artist           |
      | Been Caught Stealing | Jane's Addiction |

  @restart
  Scenario: Partial success
    Given a list of radio stations "KNRK"
    And a test server
    And the following snaps:
      | station | time     |
      | KNRK    | 2:00 PM  |
      | KNRK    | 12:00 PM |
    When I look up my snaps
    Then I should be reminded to look up 1 song later
    Then I should see the following snaps:
      | title                | subtitle         |
      | KNRK                 | 2:00 PM          |
      | Been Caught Stealing | Jane's Addiction |
    # Check for post-lookup saving bug
    When I restart the app
    Then I should see the following snaps:
      | title                | subtitle         |
      | KNRK                 | 2:00 PM          |
      | Been Caught Stealing | Jane's Addiction |

  Scenario: Nothing to look up
    Given the following snaps:
      | title | artist    | link |
      | 4'33" | John Cage | yes  |
    And I look up my snaps
    Then the app should not be downloading anything

  Scenario: City names with spaces
    Given a city name of "Southeast Portland"
    And a test server
    When I look up my stations
    Then I should see the stations "KNRK,KOPB"

  Scenario: Empty city name
    Given a list of radio stations "KNRK"
    And a city name of ""
    And a test server
    When I look up my stations
    Then the app should not be downloading anything
    And I should not see a network warning
    And I should see the stations "KNRK"
