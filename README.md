[![Build Status](https://travis-ci.org/jordimassaguerpla/gems-status.png)](https://travis-ci.org/jordimassaguerpla/gems-status)
[![Dependency Status](https://gemnasium.com/jordimassaguerpla/gems-status.png)](https://gemnasium.com/jordimassaguerpla/gems-status)
[![Code Climate](https://codeclimate.com/github/jordimassaguerpla/gems-status.png)](https://codeclimate.com/github/jordimassaguerpla/gems-status)

gem-status compares rubygems information from different sources and runs some checks on those gems.

The goal is to create a report where one can see which gems are outdated, which gems are "patched", 
that is that the versions are the same but not the md5sums, and which do not pass the checks.

Source can be:

- OpenSUSE BuildService
- Rubygems.org
- Gemfile.lock file

NOTE: In OBS, when it founds a link it follows that. However, having patches in links that affect the gem file is not supported.

Data compared is:

- version
- md5sum

Checks that can be run are:

- does it have security messages on the commits?
- is it a native gem?
- does this gem exists upstream?
- does this gem depends on rails?

In the case for the security messages, you can specify which messages have been fixed and in which version at the configuration file (see conf/test.yaml.example).

By specifying the version where a security issue was fixed, gems-status will only report the cases where the version is lower, that is, that the gem needs to be updated in order to apply that fix.

The security check, looks for messages on the source repo for the gem. The source repo is guessed using the information on the gem server. However, there are cases where the information is not enough so the source repo can not be guessed. In those cases, you can specify the source repo on the configuration file (see conf/test.yaml.example).


# Instructions

First of all you need to create a configuration file where you specify your sources.
In order to do that you can copy the conf/test.yaml.example and use it as a template.

If you want to use the obs you need to change the credentials (username/password)
 to yours in the build service at the configuration file.

After you have a configuration file, you can run it by:

`bin/gems-status.rb conf_file > output.html 2> error`

have fun!


# Extending gems-status

Gems-status follows the composite command pattern in a way that there are two command classes:

GemsCommand
GemsChecker

GemsCommand is the base class for the classes that represent a gem source, like ObsGems (openbuildservice gems), or LockFileGems (gems from a Gemfile.lock). GemsCommand has a method called execute that should store the results on an object variable called result. 

GemsChecker is the base class for the classes that run a check, like NotASecurityAlertChecker. GemsChecker has a method called check? that returns true or false depending on the result of the check, and a method called description, that contains the description in case the check returned false.

In order to extend gems-status with new sources or checks, extend those classes and then add them to the configuration file.

A part from that, there are two other main classes, that are:

GemsCompositeCommand
ViewResults

GemsCompositeCommand is the class that will run all the commands (GemsCommands and GemsCheckers) that are specified in the configuration file, and then, with the results of them it will call the ViewResults methods in order to create the final report.

ViewResults contains the implementation for printing the report. 

I know the report is not very nice and that the ViewResults class looks a little messy. Feel free to send me a pull request with a better/nicer implemenation :) .

jordi massaguer pla - jmassaguerpla@suse.de

