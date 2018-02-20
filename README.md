{\rtf1\ansi\ansicpg1252\cocoartf1561\cocoasubrtf200
{\fonttbl\f0\froman\fcharset0 Times-Roman;\f1\froman\fcharset0 Times-Bold;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red255\green255\blue255;\red70\green137\blue204;
\red202\green202\blue202;\red194\green126\blue101;\red26\green26\blue26;\red11\green85\blue25;\red202\green202\blue202;
\red27\green31\blue34;\red26\green26\blue26;\red255\green255\blue255;\red27\green31\blue34;\red0\green0\blue0;
}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;\cssrgb\c100000\c100000\c100000;\cssrgb\c33725\c61176\c83922;
\cssrgb\c83137\c83137\c83137;\cssrgb\c80784\c56863\c47059;\cssrgb\c13333\c13333\c13333;\cssrgb\c0\c40000\c12941;\cssrgb\c83137\c83137\c83137;
\cssrgb\c14118\c16078\c18039;\cssrgb\c13333\c13333\c13333;\cssrgb\c100000\c100000\c100000;\cssrgb\c14118\c16078\c18039;\csgray\c0\c0;
}
\margl1440\margr1440\vieww25400\viewh16000\viewkind0
\deftab720
\pard\pardeftab720\sl360\partightenfactor0

\f0\b\fs24 \cf2 \cb3 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec4 # The Mooqita Worklearn Platform
\b0 \strokec5 \
The worklearn platform powers the [\strokec6 Mooqita\strokec5 ](\ul https://app.mooqita.org\ulnone ) app. Mooqita is built on [\strokec6 Meteor\strokec5 ](\ul https://www.meteor.com/\ulnone ) and most of this repository is forked from [Mooqita\'92s Worklearn]({\field{\*\fldinst{HYPERLINK "https://github.com/Mooqita/worklearn"}}{\fldrslt https://github.com/Mooqita/worklearn}}) project page. \
\

\b ## Local Development
\b0 \
As part of University of Nebraska at Omaha\'92s \strokec7 ITIN4440-001 Agile Development Methods class in collaboration with the non-profits: [Siena Francis House](https://\strokec8 sienafrancis.org\strokec7 ) and [Mooqita]({\field{\*\fldinst{HYPERLINK "https://www.mooqita.org/"}}{\fldrslt https://www.mooqita.org/}}); we have created a development environment for building on the worklearn platform with \cf2 \outl0\strokewidth0 [Docker]({\field{\*\fldinst{HYPERLINK "https://www.docker.com/get-docker"}}{\fldrslt \kerning1\expnd0\expndtw0 https://www.docker.com/}}).\
\

\b \cf2 ### Install Docker
\b0 \
\pard\pardeftab720\sl360\partightenfactor0
\cf2 \outl0\strokewidth0 \strokec10 To run your own instance of Mooqita here is a guide how to get it running on your system. Before you get started please have at least 5 GB or more of storage available.\
\
\kerning1\expnd0\expndtw0 \outl0\strokewidth0 Download the Stable Docker Community Edition that matches your operating system from their [website]({\field{\*\fldinst{HYPERLINK "https://www.docker.com/get-docker"}}{\fldrslt \cf2 https://www.docker.com/get-docker}}). Operating systems below are linked to the prospective install guides. Please note system requirements before install and run.\cf2 \expnd0\expndtw0\kerning0
\
\pard\pardeftab720\sl360\partightenfactor0
\cf2 \outl0\strokewidth0 \strokec7 \
[Windows and Docker notes]({\field{\*\fldinst{HYPERLINK "https://docs.docker.com/docker-for-windows/install/"}}{\fldrslt https://docs.docker.com/docker-for-windows/install/}}): Docker for Windows requires Windows 10 and Windows Server 2016, check the notes to see what you need to know before you install. \
If you install the Docker Toolbox the installer automatically installs Oracle VirtualBox to run Docker. [Here is a useful video for configuring the VirtualBox and troubleshooting Windows with Docker]({\field{\*\fldinst{HYPERLINK "https://www.youtube.com/watch?v=ymlWt1MqURY"}}{\fldrslt \cf2 \outl0\strokewidth0 https://www.youtube.com/watch?v=ymlWt1MqURY}}). \
\
[MacOS and Docker notes]({\field{\*\fldinst{HYPERLINK "https://docs.docker.com/docker-for-mac/install/"}}{\fldrslt https://docs.docker.com/docker-for-mac/install/}}): Docker.app requires at least macOS Yosemite or El Capitan as well as permissions. You do not need the Docker Toolbox. Upon installing Docker click the app to run Docker daemon. Click the whale icon to get Preferences and then the Advanced tab - its helpful to have at least 2 CPUs and 4 or more GB memory.\
\
[Debian and Docker notes]({\field{\*\fldinst{HYPERLINK "https://docs.docker.com/install/linux/docker-ce/debian/"}}{\fldrslt https://docs.docker.com/install/linux/docker-ce/debian/}})\
[Ubuntu and Docker notes]({\field{\*\fldinst{HYPERLINK "https://docs.docker.com/install/linux/docker-ce/ubuntu/"}}{\fldrslt https://docs.docker.com/install/linux/docker-ce/ubuntu/}})\
\
Validate you have installed and running with \'93docker --version\'94 in a command prompt.\
\

\b ### Install Node and NPM\

\b0 When you install Node.js, npm is automatically installed. 
\b \

\b0 Check to see if you have Node installed by running \'93node -v\'94 in your command prompt.\
Check to see if you have NPM installed by running \'93npm -v\'94 in your command prompt.\
\
Install Node.js and NPM for [Windows]({\field{\*\fldinst{HYPERLINK "http://blog.teamtreehouse.com/install-node-js-npm-windows"}}{\fldrslt http://blog.teamtreehouse.com/install-node-js-npm-windows}}): Will require restart.\
\
Install Node.js and NPM for [Mac]({\field{\*\fldinst{HYPERLINK "http://blog.teamtreehouse.com/install-node-js-npm-mac"}}{\fldrslt http://blog.teamtreehouse.com/install-node-js-npm-mac}}): Homebrew is quickest and easiest.\
\
Install Node.js and NPM for [Ubuntu]({\field{\*\fldinst{HYPERLINK "https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04"}}{\fldrslt https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04}})\
\
Verify you have both Node.js and npm installed with \'93node -v && npm -v\'94\
\

\b \strokec4 ### Downloading MooqitaSFH from Git-Hub
\b0 \strokec5 \
Go to [MooquitaSFH]\cf2 \cb12 \outl0\strokewidth0 (\ul https://github.com/MooqitaSFH/worklearn/\ulnone ) project page \cf2 \cb3 \outl0\strokewidth0 \strokec5 on GitHub and clone the repository into a folder someplace on your computer. Name this folder  _mooqita_folder_ .\
You can find the documentation on how to clone a repository [\strokec6 here\strokec5 ](\ul https://help.github.com/articles/cloning-a-repository/\ulnone ).\
\

\b ### Connecting to GitHub with SSH
\b0 \
In order to easily commit your changes and better familiarize yourself with github please follow this [SSH guide]({\field{\*\fldinst{HYPERLINK "https://help.github.com/articles/connecting-to-github-with-ssh/"}}{\fldrslt https://help.github.com/articles/connecting-to-github-with-ssh/}}).\
\
\pard\pardeftab720\sl360\partightenfactor0

\f1\b \cf2 \strokec10 ### Building and Running Development Environment
\f0\b0 \cf2 \cb12 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf2 If you have already gotten the above dependencies I love you and promise to never hurt you again.\cf2 \cb3 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec10 \
\
\pard\pardeftab720\sl360\partightenfactor0
\cf2 In your command prompt navigate to the \cf2 \cb12 \outl0\strokewidth0 _mooqita_folder_  you created and change directory to _worklearn_ then run \cf2 \cb3 \outl0\strokewidth0 \strokec10 \'93npm run clean && docker-compose up\'94. If you see 
\f1\b Permission Denied
\f0\b0  run \'93sudo \cf2 \cb12 \outl0\strokewidth0 npm run clean && docker-compose up\cf2 \cb3 \outl0\strokewidth0 \strokec10 \'94\
\
If you don\'92t have any Docker containers, images, or volumes, the scripts will fail but don\'92t panic. \cf2 \cb12 \outl0\strokewidth0 Run \'93docker-compose up\'94 and make yourself a drink. This command will download additional dependencies, build the environment, and deploy locally in about 10 beers time.\
\
When you see \'93App running at: http://\cf2 \cb14 localhost:3000\cf2 \cb12 \'94 kiss your computer and g\cb14 o to http://localhost:3000 in your browser. Admin login credentials: \'93\cf2 \outl0\strokewidth0 \strokec6 admin@mooqita-sfh.org\'94,\'93password\'94.\
Navigate around the app, create and register as an organization. Familiarize yourself and try to edit one of pages by opening up the \cf2 \cb12 \outl0\strokewidth0 _worklearn_ folder in your favorite editor and modifying one of the html pages in the  _views_ directory.\
Save the file you modified, refresh localhost, and find the change you made!\cf2 \cb14 \
\
\cf2 \cb3 \outl0\strokewidth0 \strokec10 When you\'92ve had enough use ctrl + c in your command prompt to gracefully stop and close the application. Quickly forcing the application to stop will result in sadness.\
\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf2 \cb12 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 You can always work on the app by starting Docker then running \'93docker-compose up\'94 in the _worklearn_ directory. \
\pard\pardeftab720\sl360\partightenfactor0
\cf2 \cb3 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec10 \
\pard\pardeftab720\sl360\partightenfactor0

\b \cf2 \strokec7 ## Known Challenges
\b0 \
\pard\pardeftab720\sl360\partightenfactor0
\cf10 \cb12 \strokec10 We are aware of some issues people experienced installing the system here is a list of known issues and how to solve them:\
\
Critical Docker issues with modules, images, or containers: clean and rebuild development environment.\cf2 \cb12 \outl0\strokewidth0 \
\cf2 \cb3 \kerning1\expnd0\expndtw0 When all else fails - restart.\
\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf2 \
}