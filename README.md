Maps rebuild

[![Build Status](https://travis-ci.org/it3s/meppit.png?branch=master)](https://travis-ci.org/it3s/meppit)
[![Code Climate](https://codeclimate.com/github/it3s/meppit.png)](https://codeclimate.com/github/it3s/meppit)
[![Coverage Status](https://coveralls.io/repos/it3s/meppit/badge.png)](https://coveralls.io/r/it3s/meppit)

* Ruby version: 2.0.0

### System dependencies:

* postgresql 9.3 (with postgis2.x and postgresql-contrib for hstore)
* redis
* you need to have a execjs runtime (i.e. Nodejs, rhyno, therubyracer)
* imagemagick

### Setup:

* git clone
* `bundle`
* create and configure your database.yml and secrets.yml (see .yml.sample files)
* `rake db:create db:migrate`

* You must set a `.env` file with environemnt configs

```
PORT=3000
RAILS_ENV=development
```

* `rspec` or `rake spec` # run ruby tests
* `rake konacha:serve` # run js tests on the browser (port 3500)

* `foreman start`


### Vagrant:

We recomend you to use vagrant. Just `vagrant up` and everything is set up.
