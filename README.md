# Foreword
While functional, this project is very much a work-in-progress and it will take a considerable amount of further work for me to be content with it. Currently there are no specs, no Gemfile, and little-to-no documentation.

My main goals moving forwards would be to:
* Refactor `FareCalculator`, moving some of the code into a new `ZoneCalculator`.
* Refactor the `calculate_farest_zones` method if possible, or at the least document it well.
* Reduce reliance on raising and rescuing exceptions to manage code flow. I cannot stress enough that this is not my standard practice, and is a result of a poor design decision that I made early on but did not have the time to correct. I would much rather create a custom error handling mechanism that `return`s and error state, rather than `raise`ing a custom exception. It works, but it feels like it would lead to issues in the future.
* Refactor menu outputs into a shared `printer` to reduce repetition of `puts` to print menus.
* Add specs (using RSpec) to acheive 100% code coverage tested with SimpleCov, and use RuboCop to manage code quality.
* Add Bundler/a Gemfile.
* Clean up `require_relative`s.

Eventual goals:
* Add a GUI to better display menu screens.
* Display tube station options when entering origin and destination stations (would likely be a part of the GUI work).

# Usage
1. Run `./script/start.rb`
2. You'll need to register a new card at the Top Up Kiosk before you'll be able to use your card.
3. Do what you like!

As in the real Oyster system, if you do not have enough money on your card to complete a journey, you will be allowed to go into negative credit.  While in negative credit, you will not be able to make any journeys (until you top-up your card again).
