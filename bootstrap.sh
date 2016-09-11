#!/usr/bin/env bash

if [ ! -f ~/.runonce ]
then
  # ============================
  echo "-- UPDATE"
  sudo apt-get -y update
  sudo apt-get -y upgrade

  # ============================
  # Install dependencies
  echo "-- SETUP DEPS"
  sudo apt-get install -y curl vim build-essential libtool checkinstall python-pip python-dev gcc make sqlite3 libcurl4-openssl-dev ruby-dev libssl-dev openssl libreadline-dev git
  sudo apt-get install -y redis-server libpq-dev nodejs phantomjs libxslt1.1 imagemagick libjson0-dev libxml2-dev libproj-dev python2.7-dev swig libgeos-3.4.2 libgeos-dev gdal-bin libgdal1-1.10.1-grass libgdal1-dev
  sudo apt-get install --reinstall -y language-pack-en language-pack-pt
  git config --global color.ui true

  # ============================
  # setup rbenv
  echo "-- SETUP RBENV"
  git clone git://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.bashrc
  echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bashrc
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"

  # setup ruby-build
  echo "-- SETUP RUBY-BUILD"
  git clone git://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build

  # setup ruby
  echo "-- SETUP RUBY"
  source /home/vagrant/.bashrc
  rbenv install 2.0.0-p648
  rbenv global 2.0.0-p648
  rbenv rehash
  gem install bundler

  # ============================
  # setup postgresql 9.4 and postgis 2.1
  echo "-- SETUP POSTGRES"
  echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" | sudo tee -a /etc/apt/sources.list.d/pgdg.list
  wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc |  sudo apt-key add -
  sudo apt-get update

  sudo apt-get install -y postgresql-9.4 postgresql-server-dev-9.4 postgresql-contrib-9.4 postgresql-client-9.4 postgresql-9.4-postgis-2.1 postgresql-9.4-postgis-2.1-scripts

  sudo -u postgres createuser -r -s -d vagrant
  sudo -u postgres createdb vagrant -O vagrant
  sudo -u postgres psql -c "ALTER USER vagrant WITH PASSWORD 'vagrant';"
  sudo -u postgres psql -c "ALTER USER vagrant SUPERUSER;"

  # ============================
  echo "-- LINK PROJECT"
  cd /home/vagrant/
  ln -s /vagrant /home/vagrant/meppit

  cd meppit
  if [ ! -f config/application.yml ]
  then
    cp config/application.yml.sample config/application.yml
  fi

  if [ ! -f config/database.yml ]
  then
    cp config/database.yml.sample config/database.yml
    sed -i '' -e 's/username: postgres/username: vagrant/g' config/database.yml
  fi
  source /home/vagrant/.bashrc

  # ============================
  echo "-- RUBY DEPS"
  cd ~/meppit
  bundle
  bundle exec rake db:create db:migrate
  bundle exec rake db:create db:migrate RAILS_ENV=test
  bundle exec rspec

  touch ~/.runonce
fi
