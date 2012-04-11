# `Dao::Conducer` Example

This is an example Rails application utilizing [ahoward's](https://github.com/ahoward) Dao library. More to the point, it's using the `Dao::Conducer` class to act as a combination of a presenter and a conductor.

* presenter -- it builds plain-old data for use in the view
* conductor -- it validates attributes built from models/params before save

## Domain Model

This app models dog walkers and their dogs. The `ActiveRecord` models and schema are dead simple. The controller is responsible for loading data from the database and passing it into the conducer with HTTP params.

## Relevant Files

* `app/conducers/dog_walker_conducer.rb`
* `test/unit/app/conducers/dog_walker_conducer_test.rb`
* `lib/active_record/base.rb` (See: [https://gist.github.com/2347973](https://gist.github.com/2347973))

## Libraries

* `dao` -- [https://github.com/ahoward/dao](https://github.com/ahoward/dao)

## TODO

* build out example views/forms utilizing bootstrap
