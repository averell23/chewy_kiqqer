# ChewyKiqqer

[![Build Status](https://travis-ci.org/averell23/chewy_kiqqer.svg?branch=master)](https://travis-ci.org/averell23/chewy_kiqqer)
[![Code Climate](https://codeclimate.com/github/averell23/chewy_kiqqer.png)](https://codeclimate.com/github/averell23/chewy_kiqqer)
[![Test Coverage](https://codeclimate.com/github/averell23/chewy_kiqqer/coverage.png)](https://codeclimate.com/github/averell23/chewy_kiqqer)

This is an alternative update/callback mechanism for [Chewy](https://github.com/toptal/chewy). It queues the updates as [Sidekiq](https://github.com/mperham/sidekiq) jobs.

You can pass backrefs like with the standard chewy mechanism, but the job itself will always receive an array of ids.

It is possible to install more multiple update hooks.

## Installation

Add this line to your application's Gemfile:

    gem 'chewy_kiqqer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chewy_kiqqer

## Usage

Just add the module and set it up:

    class User < ActiveRecord::Base
      include ChewyKiqqer::Mixin
      
      async_update_index index: 'users#user', queue: :other_than_default, backref: :something
    end

You can also include the mixin into ActiveRecord::Base in an initializer if it should be generally available.
The queue name is optional. You can also set a default queue name for your application with:
    
    ChewyKiqqer.default_queue = :my_queue

Giving a backref is also optional (also check the chewy docs for the concept). The backref is the element
which will be indexed. The default is to use the current record.

    # use the current record for the backref
    ... backref: :self
    # call a method on the current record to get the backref
    ... backref: :some_method
    # Pass a proc. It will be called with the current record to get the backref
    ... backref: -> (rec) { |rec| rec.do_something }

## Update handling

The kiqqer does *not* use Chewy's `atomic` update, since that functionality is deeply linked with Chewy's syncronous update mechanism.

Instead, ChewyKiqqer will bind itself to the `#after_commit` callback, which means that it will only trigger a new job after a complete database transaction. This behaviour also ensures that only one job is enqueued per transaction.

However, if you have multiple database transactions, the kiqqer will still queue multiple jobs. The same is true when you enqueue jobs manually.

ChewyKiqqer uses locking via redis to ensure that all updates for one database record are run sequentially. This prevents race conditions which could lead to outdated data being written to the index otherwise.

## Logging

Logging is disabled by default, but you can set `ChewyKiqqer.logger` if you need log output (e.g. `ChewyKiqqer.logger = Rails.logger`). ChewyKiqqer uses ActiveSupport notifications, which you can also subscribe to.
See `log_subscriber.rb` for more info.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
