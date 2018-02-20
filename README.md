# README
# The Mooqita Worklearn Platform
The worklearn platform powers the [Mooqita](https://app.mooqita.org) app. Mooqita is built on [Meteor](https://www.meteor.com/) and most of this repository is forked from [Mooqita’s Worklearn](https://github.com/Mooqita/worklearn) project page. 

## Local Development
As part of University of Nebraska at Omaha’s ITIN4440-001 Agile Development Methods class in collaboration with the non-profits: [Siena Francis House](https://sienafrancis.org) and [Mooqita](https://www.mooqita.org/); we have created a development environment for building on the worklearn platform with [Docker](https://www.docker.com/).

### Install Docker
To run your own instance of Mooqita here is a guide how to get it running on your system. **Before you get started please have at least 5 GB or more of storage available.**

Download the Stable Docker Community Edition that matches your operating system from their [website](https://www.docker.com/get-docker). Operating systems below are linked to the prospective install guides. **Please note system requirements before install and run.**

[Windows and Docker notes](https://docs.docker.com/docker-for-windows/install/): Docker for Windows requires Windows 10 or Windows Server 2016, check the notes to see what you need to know before you install. 
If you install the Docker Toolbox the installer automatically installs Oracle VirtualBox to run Docker. [Here is a useful video for configuring the VirtualBox and troubleshooting Windows with Docker](https://www.youtube.com/watch?v=ymlWt1MqURY). 

[MacOS and Docker notes](https://docs.docker.com/docker-for-mac/install/): Docker.app requires at least macOS Yosemite or El Capitan as well as permissions. You do not need the Docker Toolbox. Upon installing Docker click the app to run Docker daemon. Click the whale icon to get Preferences and then the Advanced tab - its helpful to have at least 2 CPUs and 4 or more GB memory.

[Debian and Docker notes](https://docs.docker.com/install/linux/docker-ce/debian/)

[Ubuntu and Docker notes](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

Validate you have installed Docker by running:
`docker --version`

### Install Node and NPM
When you install Node.js, npm is automatically installed. 
Check to see if you have Node and/or npm with this command:

`node -v && npm -v`

[Install Node.js and NPM for Windows](http://blog.teamtreehouse.com/install-node-js-npm-windows): Will require restart.

[Install Node.js and NPM for Mac](http://blog.teamtreehouse.com/install-node-js-npm-mac): Homebrew is quickest and easiest.

[Install Node.js and NPM for Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04)

Verify you have both Node.js and npm installed with `node -v && npm -v`

### Downloading MooqitaSFH from Git-Hub
Go to [MooquitaSFH](https://github.com/MooqitaSFH/worklearn/) project page on GitHub and clone the repository into a folder someplace on your computer. Name this folder  _mooqita_folder_ 

You can find the documentation on how to clone a repository [here](https://help.github.com/articles/cloning-a-repository/).

### Connecting to GitHub with SSH
In order to easily commit your changes and better familiarize yourself with github please follow this [SSH guide](https://help.github.com/articles/connecting-to-github-with-ssh/).


### Building and Running Development Environment
If you have already gotten the above dependencies I love you and promise to never hurt you again.

In your command prompt navigate to the _mooqita_folder_  you created and change directory to _worklearn_ then run:

`npm run clean && docker-compose up`

If you see Permission Denied run: 

`sudo npm run clean && docker-compose up`

If you don’t have any Docker containers, images, or volumes, the scripts will fail but don’t panic. Next, run:

`docker-compose up`

Now make yourself a drink. This command will download additional dependencies, build the environment, and deploy locally in about 10 beers time.

When you see “App running at: http://localhost:3000” kiss your computer and go to http://localhost:3000 in your browser. Admin login credentials:

+ admin@mooqita-sfh.org
+ password   

Navigate around the app, create and register as an organization. Familiarize yourself and try to edit one of pages by opening up the _worklearn_ folder in your favorite editor and modifying one of the html pages in the  _views_ directory.
Save the file you modified, refresh localhost, and find the change you made!

When you’ve had enough use ctrl + c in your command prompt to gracefully stop and close the application. Quickly forcing the application to stop will result in sadness.

You can always work on the app by restarting Docker then navigate to the _worklearn_ directory and run:

`docker-compose up`

## Known Challenges
We are aware of some issues people experienced installing the system here is a list of known issues and how to solve them:

Critical Docker issues with modules, images, or containers: clean and rebuild development environment.

When all else fails - restart.


