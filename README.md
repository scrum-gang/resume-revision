# Resume Revision
* Ruby version 2.6.1
* Rails

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
* Pull requests are tested on Travis before being deployed to a Heroku instance.

## API Documentation
* All requests are expected to include the following headers:
```json
"Content-type": "application/json"
"Authorization": "Bearer [token]"
```
* All requests would not allow a user to access another user's data.
* All parameters are to be stored in the request body as JSON.

#### POST `/resumes`
* Create a new resume
* Params: 
    * `user_id`: Foreign key
    * `user_name` 
    * `revision`
    * `title`
    * `resume_data`: Base64 of the PDF
    
#### GET `/resumes/:user_id`
* List all resumes for a specific user

#### PATCH `/resumes/:id`
* Update resume with the new title and the new revision passed
* Params:
    * `title`
    * `revision`


#### GET `/resumes/:user_id/:title/:revision`
* List a specific resume 

#### DELETE `/resumes/:user_id/:title/:revision`
* Delete a specific resume
