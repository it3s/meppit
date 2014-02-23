Maps rebuild

[![Build Status](https://travis-ci.org/it3s/meppit.png?branch=master)](https://travis-ci.org/it3s/meppit)
[![Code Climate](https://codeclimate.com/github/it3s/meppit.png)](https://codeclimate.com/github/it3s/meppit)

* Ruby version: 2.0.0

### System dependencies:

* postgresql
* redis
* you need to have a execjs runtime (i.e. Nodejs, rhyno, therubyracer)

### Setup:

* git clone
* `bundle`
* create and configure your database.yml and secrets.yml (see .yml.sample files)
* `rake db:create db:migrate`

* `rspec` or `rake spec` # run ruby tests
* `rake konacha:run` # run js tests on the terminal
* `rake konacha:serve` # run js tests on the browser

* `foreman start`
