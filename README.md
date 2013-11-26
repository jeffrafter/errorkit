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

After you run the generator you need to migrate the database:

    $ rails db:migrate

You can override the default configuration in config/initializers/errorkit.rb.

## Custom Views

From this point you can customize most things. Errorkit handles errors
that occur within your application and displays a corresponding template.
By default, it uses app/views/errors/error.html.erb which you should
customize. If you want to have specific templates for specific pages
you can create them by name:

    bad_request.html.erb
    forbidden.html.erb
    internal_server_error.html.erb
    method_not_allowed.html.erb
    not_acceptable.html.erb
    not_found.html.erb
    not_implemented.html.erb
    unauthorized.html.erb
    unprocessable_entity.html.erb

You can extend this list of defaults as well. See
http://guides.rubyonrails.org/layouts_and_rendering.html for more information.

It is also possible to customize the notification template found at
app/views/errors/notification.html.erb.

## Custom Errors Controller

You can override the errors_controller by creating a new one in your application:

    class MyController < Errorkit::ErrorsController
    end

You can even make this descend from your own application controller (though
this may generate additional errors if there is a problem in your controller)

    class MyController < ApplicationController
      def show
        # You must implement show
      end
    end

Once created, you must tell Errorkit to use this controller in the initializer:

    config.errors_controller = MyController

## Custom Errors Mailer

You can override the errors_mailer by creating a new one in your application:

    class MyMailer < Errorkit::ErrorsMailer
    end

You can descend from ActionMailer::Base if you want to completely override the
behavior. However you must implement error_notification:

    class MyMailer < ActionMailer::Base
      def error_notification(error_id)
        # You must implement error_notification
      end
    end

Once created, you must tell Errorkit to use this mailer in the initializer:

    config.errors_mailer = MyMailer

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


https://github.com/rails/rails/blob/f886fe2d8ccc900cde2629577e5c0be8c7d4c67f/actionpack/lib/action_dispatch/middleware/exception_wrapper.rb
https://github.com/rails/rails/blob/c2cb83b1447fee6cee496acd0816c0117b68b687/guides/source/layouts_and_rendering.md
http://stackoverflow.com/questions/15459143/how-to-rescue-from-actiondispatchparamsparserparseerror-in-rails-4
