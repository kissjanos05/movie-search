FROM almalinux:9.1
RUN dnf update -y
RUN dnf install -y --allowerasing git gnupg2 git-core zlib zlib-devel gcc-c++ patch readline readline-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison tar initscripts
RUN dnf install -y which procps
RUN dnf install -y ruby-devel nodejs
RUN gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm pkg install openssl"
RUN /bin/bash -l -c "rvm install 2.7.2 --with-openssl-dir=/usr/local/rvm/usr"

RUN echo \ 
$'[mongodb-org-6.0]\n\
name=MongoDB Repository\n\
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/6.0/x86_64/\n\
gpgcheck=1\n\
enabled=1\n\
gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc' > /etc/yum.repos.d/mongodb.repo

RUN dnf install -y mongodb-org
RUN mkdir -p /data/db
RUN mkdir -p /var/log/mongodb/

ENV RAILS_LOG_TO_STDOUT true

WORKDIR /app
COPY .ruby-version /app
COPY .ruby-gemset /app
RUN /bin/bash -l -c "rvm --default use ruby-2.7.2@movie_search"
RUN /bin/bash -l -c "rvm gemset use ruby-2.7.2@movie_search"
RUN cd /app && /bin/bash -l -c "gem install bundler"
COPY Gemfile* .
RUN cd /app && /bin/bash -l -c "bundle install"
COPY . .
RUN /bin/bash -l -c "bundle exec rake assets:clobber assets:precompile"
CMD mongod --fork --logpath /var/log/mongodb/mongod.log && cd /app && /bin/bash -l -c "bundle exec puma -p $PORT"
