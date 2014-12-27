#!/usr/bin/env bash

if [ ! -f ~/runonce ]
then
  # Update
  apt-get update
  apt-get upgrade -y

  # Install dependencies
  apt-get install -y git ruby2.0 ruby2.0-dev redis-server libpq-dev nodejs libxslt1.1 imagemagick build-essential libtool checkinstall libjson0-dev libxml2-dev libproj-dev python2.7-dev swig libgeos-3.3.3 libgeos-dev gdal-bin libgdal1-1.9.0-grass libgdal1-dev
  apt-get install --reinstall -y language-pack-en language-pack-pt

  # postgresql 9.3
  echo "deb http://apt.postgresql.org/pub/repos/apt/ saucy-pgdg main"  >> /etc/apt/sources.list.d/pgdg.list
  apt-get install -y wget ca-certificates
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
  apt-get update
  apt-get upgrade -y
  apt-get install -y postgresql-9.3 postgresql-contrib-9.3 postgresql-client-9.3 postgresql-server-dev-9.3 postgresql-9.3-postgis-2.1 postgresql-9.3-postgis-2.1-scripts



  # Create postgres user
  sudo -u postgres createuser -r -s -d vagrant
  sudo -u postgres createdb vagrant -O vagrant

  # Configure Meppit
  cd /home/vagrant/
  sudo -u vagrant ln -s /vagrant /home/vagrant/meppit

  cd meppit
  if [ ! -f config/application.yml ]
  then
    sudo -u vagrant cp config/application.yml.sample config/application.yml
  fi

  if [ ! -f config/database.yml ]
  then
    sudo -u vagrant cp config/database.yml.sample config/database.yml
    sudo -u vagrant sed -i -e 's/username: postgres/username: vagrant/g' config/database.yml
  fi

  # ============================
  # Ruby dependencies
  gem install bundler

  # Setup
  sudo su - vagrant -c "cd ~/meppit && bundle"
  sudo su - vagrant -c "cd ~/meppit && bundle exec rake db:create db:migrate"
  sudo su - vagrant -c "cd ~/meppit && bundle exec rake db:create db:migrate RAILS_ENV=test"
  sudo su - vagrant -c "cd ~/meppit && bundle exec rspec"

  touch ~/runonce
fi
