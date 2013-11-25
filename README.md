# Errorkit

ErrorKit allows you to track errors within your application and generate a
notification when they happen.

ErrorKit is based on exception_notification and takes a similar approach. It allows
you to install Rack middleware that catches exceptions and allows you to notify a
list of recipients.

ErrorKit also allows you to record the errors to your database and resolve them
as necessary. This allows error handling to become an application concern and expects
that you will attach application specific information to the errors when possible
(such as the user that performed the action or the priority level of the error).

ErrorKit provides a generator to build the default Error model.

You can ignore specific exception classes and specific user agents. Additionally,
ErrorKit can throttle error notifications to prevent overwhelming your inbox.

Finally, ErrorKit keeps track of how many successful responses are made as well
so that it can track your error rate per server and per release.

## Kinds of errors
Errorkit::Notifier
  server_error
  background_error
  javascript_error

errors # views

error_controller for javascript?
error.rb for activerecord

mark the error notification at, if missing there was an error creating it


## Installation

Add this line to your application's Gemfile:

    gem 'errorkit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install errorkit

## Usage

Once you have installed the gem, you need to run the generator:

    $ rails g errorkit:install

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Acknowledgements

http://geekmonkey.org/articles/29-exception-applications-in-rails-3-2
https://github.com/sheerun/rails4-bootstrap/issues/26
https://github.com/sheerun/rails4-bootstrap/commit/5c2df5a108ad204bc407183b959bb355ff5ed53d
http://stackoverflow.com/questions/15459143/how-to-rescue-from-actiondispatchparamsparserparseerror-in-rails-4
https://github.com/mirego/gaffe
https://github.com/mirego/gaffe/blob/master/lib/gaffe/errors.rb
