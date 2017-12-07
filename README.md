# The Mooqita Worklearn Platform
The worklearn platform powers the [Mooqita](https://app.mooqita.org) app. Mooqita is built on [Meteor](https://www.meteor.com/) and deployed on [heroku](https://www.heroku.com) with automatic staging of our [master branch](https://github.com/Mooqita/worklearn/tree/master).

## Local Development
To run your own instance of Mooqita here is a guide how to get it running on your system. We are planning to release a docker of our platform but have not found the time to do so (Help in this department would be highly appreciated).

### Install Meteor
Install the meteor web framework. You find a detailed description of the installation process on their [website](www.meteor.com).

### Downloading Mooqita's Worklearn Platform from Git-Hub
Go to [Mooqita's Worklearn](https://github.com/Mooqita/worklearn) project page on GitHub and clone the repository into a folder on your computer. We will call this folder on your machine _mooqita_folder_ from now on. You find the documentation on how to clone a repository [here](https://help.github.com/articles/cloning-a-repository/)

### First start of Mooqita
After cloning the repository we recommend to adept _settings.json_ to your needs (_mooqita_folder/settings.json_). The following parameters are only parsed if run on your machine under localhost. They are not parsed when the system runs on a server or production system for obvious security reasons. How to run your own version of Mooqita's worklearn platform please refer to section _Server Deployment_ further down in this document.

	"init_default_permissions":true,
	"default_permissions_asset_path":"db/defaultcollections/permissions.json",

	"admin":
	{
	  "email":"YOUR_EMAIL",
	  "password":"YOUR_PASSWORD"
	}

	"init_test_data":true,

 When Meteor is installed and you cloned the repository go to your _mooqita_folder_ and run the following command: 
 
	meteor --s settings.json 
 	
 This command will read _settings.json_ and initialize the database. It will setup the required permissions to run your local instance of Mooqita's worklearn platform. It can also add an admin account and add test data to the database for an easy start. If you already started the worklearn platform you might need to remove the database if the following steps fail. 

### Setting Permissions
Our platform uses a fine grained system to control read and write access. You find details in section _Permissions_ further down in this document. As the rules can become quite complex we provide a way to setup initial rules for local development using two parameters in _settings.json_.

	"init_default_permissions":true,
	"default_permissions_asset_path":"db/defaultcollections/permissions.json",
	
If _init_default_permissions_ is set to true the system searches for the file defined with _default_permissions_asset_path_. It parses its content and adds all permissions from the file to the database. If you change or add permissions it is a good idea to save your permissions to a new file and point _default_permissions_asset_path_ to it. This way you can keep the original file and in case you need to reset the database your permissions are restored easily.

### Setting Up an Admin Account
If you want to change permissions you will need admin access. To easily setup an admin account you can add the following lines to _settings.json_.

	"admin":
	{
	  "email":"YOUR_EMAIL",
	  "password":"YOUR_PASSWORD"
	}

### Generating Test Data
Finally it might be interesting to see how the system looks like for a user. To allow you a quick start you can populate the database with test data using the following parameter.

	"init_test_data":true
	
With this command the system will generate a test challenge and results from nine learners. It will also generate a challenge designer and nine learner accounts including reviews and feedbacks. To access the designer account login with the following credentials:
	
	email: designer@mooqita.org
	password: none
	
The password is indeed the string _none_. You can also access student accounts. Using the following credentials:

	email: x@uni.edu
	password: none

You need to replace the _x_ by a number between 1 and 9 to access an individual learner account.

### Setting Up Email Notification
There are a two more steps until Mooqita is fully ready. You can skip this step if email notification is not important for you. To enable email notification you need to set an environment variable _MAIL_URL_ to let meteor know how to send mails to learners. An excellent description how to setup email sending for meteor can be found [here](https://themeteorchef.com/tutorials/using-the-email-package). For our purpose you only need to set the environment variable and Mooqita will do the rest.

	MAIL_URL=smtp://SEND_MAIL_ADDRESS:@MAIL_PROVIDER:PORT

If the variable is set the server will log the content of the variable on start up.

	[general][info] MAIL_URL set to: smtp://SEND_MAIL_ADDRESS:@MAIL_PROVIDER:PORT

### Drop Box Storage
The final setting is setting up file storage. At the moment we use dropbox to save files user upload to our system. To enable this function for your local installation you first need to sign-up for a dropbox account [here](https://www.dropbox.com/). The next step is to create a dropbox app that allows you to access your storage. You can find a description how to do that [here](https://docs.gravityforms.com/creating-a-custom-dropbox-app/). 

Finally you need to generate a drop box access token as explained [here](https://blogs.dropbox.com/developers/2014/05/generate-an-access-token-for-your-own-account/). Now you can set the last environment variable:

	DROP_BOX_ACCESS_TOKEN=Bearer YOUR_DROPBOX_ACCESS_TOKEN

## Server Deployment
Coming soon.

## Permissions
Coming soon.