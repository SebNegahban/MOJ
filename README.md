# Foreword
With a bit more time, I have been able to get this project to a point where I am more satisfied with it as a task submission.  
There are still some significant improvements that I would make if I were to completely restart the project, and some further improvements that I would make if I were taking the project further.

My main goals moving forwards would be to:
* Add a MySQL database to allow persistence of stations, card numbers, and add tracking of card owners. This would of course result in a large amount of refactoring, but would be a change for the better of the program.
* Reduce reliance on raising and rescuing exceptions to manage code flow. I cannot stress enough that this is not my standard practice, and is a result of a poor design decision that I made early on but did not have the time to correct. I would much rather create a custom error handling mechanism that `return`s an error state, rather than `raise`ing a custom exception. It works, but it feels like it could lead to issues in the future.

Eventual goals:
* Add a GUI to better display menu screens.
* Display tube station options when entering origin and destination stations (would likely be a part of the GUI work).

# Usage
1. Run `bundle install` to install the few dependencies in the project
2. Run `./script/start.rb`
3. You'll need to register a new card at the Top Up Kiosk before you'll be able to use your card
4. Do what you'd like!

As in the real Oyster system, if you do not have enough money on your card to complete a journey, you will be allowed to go into negative credit.  While in negative credit, you will not be able to make any journeys (until you top-up your card again).

# Specs
I have written specs to cover 96.63% of the code, the only lines that are excluded are those that print the three menus to the user.
I had some difficulty finding a way to write specs for these as the methods are automatically recursive, and I was unable to find a way to call the original method once, then stub all subsquent calls. If I were able to find a way to do this, I would aim for 100% code coverage.  
To run the specs, simply run `bundle exec rspec .`. After having run this, you will be able to find the code coverage report in `/coverage/`. To view the report, open `/coverage/index.html` in your browser of choice.

# Code quality
Code quality is managed using Rubocop. I have elected to disable some of the coding rules purely based on personal preference, these customisations can be found in `.rubocop.yml`.

# Dependencies
This project is very light on dependencies, the following gems have been installed:

* *RSpec* - For automated tests
* *SimpleCov* - For code coverage
* *Rubocop* - For code styling