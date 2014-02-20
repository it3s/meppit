Maps rebuild

* Ruby version: 2.0.0

### System dependencies:

* postgresql
* you need to have a execjs runtime (i.e. Nodejs, rhyno, therubyracer)

### Setup:

* git clone
* `bundle`
* create and configure your database.yml and secrets.yml (see .yml.sample files)
* `rake db:create db:migrate`
* `rspec` # run tests
* `rails server`  OR  `foreman start` # start server
