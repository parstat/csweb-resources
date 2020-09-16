# csweb-resources
CSWeb (docker and installation documentation)

##Background
CSWeb is a web application that allows users to securely transfer cases (questionnaires) or files between client devices running CSEntry and a web server. CSWeb requires a web server running PHP and MySQL. 

![CSWeb](https://www.csprousers.org/help/CSWeb/synchronization_flow.png)

CSWeb eliminates the need to transfer data files by allowing users to instead transfer cases between client devices and a web server. CSEntry data entry applications that are configured to use CSWeb synchronization take advantage of Smart Synchronization, a feature that transfers only cases that are added or modified since the last successful synchronization. Smart Synchronization reduces data transfer costs and Internet bandwidth usage.
CSWeb uses a MySQL database on the server to store the cases for the census or survey data entry instrument. Unlike a file based synchronization that requires application designers to manage the concatenation of data files, CSWeb allows users to download a single file containing all the cases for the data entry instrument (once the cases are transferred from the client devices to the server).

##Installation in Ubuntu Server
###Apache
Apache is the most popular and stable web server for Ubuntu Linux. The Apache HTTP server for Ubuntu 20 provided by the apache2 package. To install apache2 on Ubuntu, open the terminal and execute:
'$ sudo apt-get update'
'$ sudo apt-get install apache2'