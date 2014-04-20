#!/usr/bin/env bash

if [ ! -f ~/runonce ]
then
  # Update
  apt-get update
  apt-get upgrade -y

  # Install dependencies
  apt-get install -y git ruby2.0 ruby2.0-dev redis-server postgresql-9.1 postgresql-contrib-9.1 postgresql-server-dev-9.1 libpq-dev nodejs libxslt1.1 imagemagick build-essential libtool checkinstall libjson0-dev libxml2-dev libproj-dev python2.7-dev swig libgeos-3.3.3 libgeos-dev gdal-bin libgdal1-1.9.0-grass libgdal1-dev

  # ========================
  # compile postgis
  cd /home/vagrant/
  wget http://download.osgeo.org/postgis/source/postgis-2.0.3.tar.gz
  tar xzf postgis-2.0.3.tar.gz
  cd postgis-2.0.3
  ./configure
  make
  make install


  # ============================
  # Ruby dependencies
  gem install bundler

  # Create postgres user
  sudo -u postgres createuser -r -s -d vagrant
  sudo -u postgres createdb vagrant -O vagrant

  # Clone the Meppit repo
  cd /home/vagrant/
  sudo -u vagrant git clone https://github.com/it3s/meppit.git meppit

  # Configure Meppit
  cd meppit
  sudo -u vagrant cp config/secrets.yml.sample config/secrets.yml
  sudo -u vagrant cp config/database.yml.sample config/database.yml
  sudo -u vagrant sed -i -e 's/username: postgres/username: vagrant/g' config/database.yml

  # Setup
  bundle
  sudo -u vagrant rake db:create db:migrate
  sudo -u vagrant rake db:create db:migrate RAILS_ENV=test
  sudo -u vagrant rspec

  touch ~/runonce
fi
