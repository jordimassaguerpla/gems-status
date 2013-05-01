[![Build Status](https://travis-ci.org/jordimassaguerpla/gems-status.png)](https://travis-ci.org/jordimassaguerpla/gems-status)
[![Dependency Status](https://gemnasium.com/jordimassaguerpla/gems-status.png)](https://gemnasium.com/jordimassaguerpla/gems-status)
[![Code Climate](https://codeclimate.com/github/jordimassaguerpla/gems-status.png)](https://codeclimate.com/github/jordimassaguerpla/gems-status)
[![Coverage Status](https://coveralls.io/repos/jordimassaguerpla/gems-status/badge.png?branch=master)](https://coveralls.io/r/jordimassaguerpla/gems-status)
[![Gem Version](https://badge.fury.io/rb/gems-status.png)](http://badge.fury.io/rb/gems-status)

gem-status gets the list of gems you use from Gemfile.lock file and runs some checks on those gems.

Checks that can be run are:

- Does it has a license? If it does not, it can be a problem for distributing your software with this gem.
- Is it Gpl? If it is, it can be a problem if your software or other gems are not GPL compatible.
- Is the same in Rubygems.org? This is for people who uses his own gem server. This checks the gems are the same.
- Does it has security alerts? This will search into the commits and into security mailing lists for possible security messages.

In the case for the security messages, you can specify which messages have been fixed and in which version at the configuration file (see conf/test.yaml.example).

By specifying the version where a security issue was fixed, gems-status will only report the cases where the version is lower, that is, that the gem needs to be updated in order to apply that fix.

The security check, looks for messages on the source repo for the gem. The source repo is guessed using the information on the gem server. However, there are cases where the information is not enough so the source repo can not be guessed. In those cases, you can specify the source repo on the configuration file (see conf/test.yaml.example).


# Instructions

First of all you need to create a configuration file where you specify your sources.
In order to do that you can copy the conf/test.yaml.example and use it as a template.

After you have a configuration file, you can run it with:

`bin/gems-status.rb conf_file > output.txt 2> error`

have fun!


# Extending gems-status

Gems-status follows the composite command pattern in a way that there are two command classes:

- GemsCommand
- GemsChecker

GemsCommand is the base class for the classes that represent a gem source, i.e. LockFileGems (gems from a Gemfile.lock). GemsCommand has a method called execute that should store the results on an object variable called result. 

GemsChecker is the base class for the classes that run a check, like NotASecurityAlertChecker. GemsChecker has a method called check? that returns true or false depending on the result of the check, and a method called description, that contains the description in case the check returned false.

In order to extend gems-status with new sources or checks, extend those classes and then add them to the configuration file.

A part from that, there are two other main classes, that are:

GemsCompositeCommand
TextView

GemsCompositeCommand is the class that will run all the commands (GemsCommands and GemsCheckers) that are specified in the configuration file, and then, with the results of them it will call the TextView methods in order to create the final report.

TextView contains the implementation for printing the report. 

Feel free to send me a pull request!

jordi massaguer pla - jmassaguerpla@suse.de

