# The Mooqita Worklearn Platform
The worklearn platform powers the [Mooqita](https://app.mooqita.org) app. Mooqita is built on [Meteor](https://www.meteor.com/) and deployed on [heroku](https://www.heroku.com) with automatic staging of our [master branch](https://github.com/Mooqita/worklearn/tree/master).

## Local Development

### Install Meteor
Install the meteor web framework. You find a detailed description of the installation process on their [website](www.meteor.com).

### Downloading Mooqita's Worklearn Platform from Git-Hub
Go to [Mooqita's Worklearn](https://github.com/Mooqita/worklearn) project page on GitHub and clone the repository into a folder on your computer. We will call this folder on your machine _mooqita_folder_ from now on. You find the documentation on how to clone a repository [here](https://help.github.com/articles/cloning-a-repository/)

### Setting Up an Admin Account
When Meteor is installed go to your _mooqita_folder_ and run the following command: "meteor --settings settings.json". This command will initialize the database with the required permissions to run your local instance of Mooqita. 


and crete an admin user:
Until we switch to a proper "first start procedure": consider adjusting ./server/server.coffee for generating an admin user

