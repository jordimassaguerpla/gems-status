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



# Disc usage and emails

gems-status gets emails from a gmail account and stores them in disc. Every time it downloads an email, it marks that as read so that it won't download it again. This is better in performance than reading all the emails from gmail each time and having them stored locally means you can run gems-status several times and gems-status will look into all the emails, not only the unread ones, thus these local email messages can be reused within different gems-status runs (i.e. for differen Gemfile.locks.).

However, this has a drawback. Disc usage increases over time.

My recomandation is that you remove files older than a year, for example, running:

find tmp/utils/mail/ -mtime +365 -delete

If, for any reason, you won't to reset the emails, you can remove the ones in your filesystem under tmp/utils/mail and go to your gmail account and mark all your emails as unread.


Feel free to send me a pull request!

jordi massaguer pla - jmassaguerpla@suse.de
