# Welcome to Movie Search!

# Prerequisites
 - Ruby 2.7.2
 - RVM
 - MongoDb 4.4

# Installation
For development environment
#### Clone the application
> git clone https://github.com/kissjanos05/movie-search

#### Set the RVM environment
1. cd into the application root
2. copy .ruby-verison.example as .ruby-verison (don't recommend to change version)
3. copy .ruby-gemset.example as .ruby-gemset (you can change the name of gemset as long as it is unique)
4. reopen the application root to create the new environment

#### Install ruby gems
Run
> gem install bundler

  then  

> bundle install

#### Configuration
In the configuration files you can set different environments. (production, development, test)

1. Copy config/mongoid.yml.example to config/mongoid.example

> This file is a default configuration. For details see [mongoid documentation](https://www.mongodb.com/docs/mongoid/8.0/tutorials/getting-started-rails7/index.html?_ga=2.94403292.1711009242.1679514770-758219275.1679134778#configure-for-self-managed-mongodb)

2. Copy config/tmdb.yml.example to config/tmdb.yml

> You have to add you TMDB API key in this file.  Get your API key [here] (https://www.themoviedb.org/settings/api) (registration required)

#### Start the application
You can start the application now.

Run:
> rails s
