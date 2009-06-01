Feature: Lookup
  In order to find out what songs I heard earlier
  As a radio listener with network access
  I want to look up the songs I bookmarked

  Scenario: Looking up a snap
    Given a list of radio stations "KNRK"
    And a server at http://localhost:4567
    And the following snaps:
      | station | time     |
      | KNRK    | 12:00 PM |
    When I look up my snaps
    Then I should see the following snaps:
      | title                | artist           |
      | Been Caught Stealing | Jane's Addiction |

  Scenario: Partial success
    Given a list of radio stations "KNRK"
    And a server at http://localhost:4567
    And the following snaps:
      | station | time     |
      | KNRK    | 2:00 PM  |
      | KNRK    | 12:00 PM |
    When I look up my snaps
    Then I should see the following snaps:
      | title                | subtitle         |
      | KNRK                 | 2:00 PM          |
      | Been Caught Stealing | Jane's Addiction |

    # Check saving bug:
    When I restart the app
    Then I should see the following snaps:
      | title                | subtitle         |
      | KNRK                 | 2:00 PM          |
      | Been Caught Stealing | Jane's Addiction |
