# ChewyKiqqer

This is an alternative udpate/callback mechanism for [Chewy](https://github.com/toptal/chewy). It queues the updates as [Sidekiq](https://github.com/mperham/sidekiq) jobs.

Unlike the standard update_index mechnism it will **always** use the record's index for updates (at this time at least). If you need to do bulk updates, just use chewy's built-in mechanisms.

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
      
      async_update_index index: 'users#user', queue: :other_than_default
    end

You can also include the mixin into ActiveRecord::Base in an initializer if it should be generally available.
The queue name is optional. You can also set a default queue name for your application with:
    
    ChewyKiqqer.default_queue = :my_queue

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
