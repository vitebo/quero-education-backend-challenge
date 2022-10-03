# Challenge integrated admission

Test version: **(2022_10_03)**

The project focuses on creating an API to manage admission, billings, and bills fees for students.

## API documentation

All API documentation can be found here:
[documenter.getpostman.com](https://documenter.getpostman.com/view/4286436/RzfiGoXE)

Postman file with all request models
[postman_collection.json](https://github.com/vitebo/challenge-integrated-admission/blob/master/challenge-integrated-admission.postman_collection.json)

## System dependencies

- Ruby version: 2.5.1
- Yarn
- Node

## Relationship in the database

![Database](https://raw.githubusercontent.com/vitebo/challenge-integrated-admission/master/app/assets/images/db-tables.png)

## Running the project

1. clone the repository
    ```bash
    $ git@github.com:vitebo/challenge-integrated-admission.git
    $ cd challenge-integrated-admission/
    ```

2. install all dependencies
    ```bash
    $ gem install bundler
    $ bundler install
    $ yarn install
    ```

3. start the application
    ```bash
    $ rails db:create
    $ rails db:migrate
    $ rails s
    ```
    