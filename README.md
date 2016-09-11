Maps rebuild

[![Build Status](https://travis-ci.org/it3s/meppit.png?branch=master)](https://travis-ci.org/it3s/meppit)
[![Code Climate](https://codeclimate.com/github/it3s/meppit.png)](https://codeclimate.com/github/it3s/meppit)
[![Coverage Status](https://coveralls.io/repos/it3s/meppit/badge.png)](https://coveralls.io/r/it3s/meppit)

* Ruby version: 2.0.0 (p648)

### System dependencies:

* postgresql 9.4 (with postgis2.1 and postgresql-contrib for hstore)
* redis
* you need to have a execjs runtime (i.e. Nodejs, rhyno, therubyracer)
* imagemagick

### Setup:

* git clone
* `bundle`
* create and configure your database.yml and application.yml (see .yml.sample files)
* `rake db:create db:migrate`
* `rspec` or `rake spec` # run ruby tests
* `rake konacha:serve` # run js tests on the browser (port 3500)

* `./run`  runs foreman with the dev procfile


### Vagrant:

We recomend you to use vagrant:
- `vagrant up`
- `vagrant ssh`
- `cd meppit; ./bootstrap.sh`
