# Resume Revision
* Ruby version 2.6.1


## Description

* Responsible for uploading resumes and attaching them to users.
* Have title and revision per resume that could be changed.
* Responsible for returning a list of resumes per user and attaching new resumes for a user.


## How to run?

* Run `bundle install` to fetch and install the gems.
* For locally testing the database, setup postgresql and run `bundle exec rails db:setup`.
* Run `bundle exec rails server` to run the Rails server.


## Deployment on Heroku

* Releases on master branches are automatically deployed to Heroku.
* Pull requests are tested on Travis before being deployed to a QA Heroku instance.
