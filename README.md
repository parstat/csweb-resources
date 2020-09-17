# csweb-resources
CSWeb (docker and installation documentation)

## Background
CSWeb is a web application that allows users to securely transfer cases (questionnaires) or files between client devices running CSEntry and a web server. CSWeb requires a web server running PHP and MySQL. 

![CSWeb](https://www.csprousers.org/help/CSWeb/synchronization_flow.png)

CSWeb eliminates the need to transfer data files by allowing users to instead transfer cases between client devices and a web server. CSEntry data entry applications that are configured to use CSWeb synchronization take advantage of Smart Synchronization, a feature that transfers only cases that are added or modified since the last successful synchronization. Smart Synchronization reduces data transfer costs and Internet bandwidth usage.
CSWeb uses a MySQL database on the server to store the cases for the census or survey data entry instrument. Unlike a file based synchronization that requires application designers to manage the concatenation of data files, CSWeb allows users to download a single file containing all the cases for the data entry instrument (once the cases are transferred from the client devices to the server).

## Installation on Ubuntu 20.04
### Apache
Apache is the most popular and stable web server for Ubuntu Linux. The Apache HTTP server for Ubuntu 20 is provided by the apache2 package. To install apache2 on Ubuntu, open the terminal and execute:
```
$ sudo apt-get update
$ sudo apt-get install apache2
```

Enable rewrite module:
```
$ sudo a2enmod rewrite
```

By default, Apache does not allow the use of ‘.htaccess’ file so you will need to edit the configuration of each website’s virtual host file by adding the following code:

```
<Directory /var/www/html>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
</Directory>
```

Then copy and paste the above text just before `</VirtualHost>` closing tag using this command:
```
$ sudo vi /etc/apache2/sites-available/000-default.conf
```

Restart the server
```
$ sudo service apache2 restart
```

### PHP
PHP is a programming language for developing web applications and essential part of the Ubuntu LAMP Stack. To install PHP on Ubuntu 20.04, Run:
```
$ sudo apt-get update
$ sudo apt-get install php
```

Some extensions that needs to be separately installed:
```
$ sudo apt-get install php-xml (php dom extension)
$ sudo apt-get install php-mysql (php pod_mysql extension)
$ sudo apt-get install php-zip (php zip extension)
```

Uncomment these lines in /etc/php/7.4/apache2/php.ini
```
extension=curl
extension=fileinfo
extension=openssl
extension=pdo_mysql
```

Add this line in /etc/php/7.4/apache2/php.ini
```
extension=zip
```

Save php.ini and restart apache:
```
$ sudo service apache2 restart
```

### MySQL Server
Installing MySQL Server on Ubuntu 20.04 is straightforward. Open the terminal update the package list and install the mysql-server package:

```
$ sudo apt-get install mysql-server
```

Enter mysql command line tool:
```
$ sudo mysql
```
Create the database:
```
mysql>CREATE DATABASE csweb;
```
Create the csweb_user:
```
mysql>CREATE USER 'csweb_user'@'localhost' IDENTIFIED BY 'password';
```
Grant permission to database csweb for user csweb_user:
```
mysql>GRANT ALL ON csweb.* TO 'csweb_user'@'localhost';
```
Exit mysql:
```
mysql>exit
```
Restart mysql:
```
$ sudo service mysql restart
```

### CSWeb
Navigate to /var/www/html
```
$ cd /var/www/html
```
Create “csweb” folder:
```
$ sudo mkdir csweb
```
Enter the newly created folder:
```
$ cd /var/www/html/csweb
```
Download csweb package:
```
$ sudo wget https://www2.census.gov/software/cspro/download/csweb.zip 
```
Unzip the package:
```
$ sudo unzip csweb.zip 
```
Remove the unnecessary zip file:
```
$ sudo rm -rf csweb.zip
```
Change owner for csweb folder:
```
$ sudo chown www-data:www-data -R /var/www/html/csweb
```
Change permissions for csweb folder:
```
$ sudo chmod -R 775 /var/www/html/csweb
```

Open your default browser and navigate to `http://{UBUNTU_SERVER_IP}/csweb/setup`

The server requirements page will appear by default, you can not continue to the next step if some of the requirements are not met. You can go back to the above steps to check if you missed some of the configurations.

Next step is the configuration page, add the user credentials you have configured during MySQL setup.
After a successful configuration you will be redirected to the login page.

## Docker installation
Clone this repository and build the image.
Using PowerShell or a Terminal, navigate to the cloned repository on your computer.
Build the image:
```
$ docker image build -t {dockerhub_username_or_private_repository}/{your_image_name}:{your_tag} .
```
Start the local testing environment by running (Replace image name in the docker-compose.yml file with your assigned image name, also you can choose your own database name, user and password)
```
$ docker-compose up
```
Open your browser and navigate to the mapped port, in the repository case:
`http://localhost:8099/csweb` 
If it is the first time you are running `docker-compose up` you will be redirected to the setup page of csweb. Check if every requirement is met and continue with database configuration page. Fulfill the required data (database, host, database user, password, and admin password). Remember to put the docker-compose chosen hostnames in the configuration. 
Also the api url should be the docker internal hostname: `http://{csweb_hostname}/csweb/api` 
In the example of this repository: `http://csweb-php/csweb/api`.

### Live environment
Remember to replace plain text passwords in the docker-compose.yml file with docker secrets (`https://docs.docker.com/engine/swarm/secrets/`)

Initialize docker swarm:
```
$ docker swarm init
```

*You can add other swarm nodes using the token provided when the master node is initalized.*

Clone the csweb-resources repository in the server (only docker-compose.yml file is really needed if the csweb image is downloaded from docker-hub or some other private repository)
```
$ git clone https://github.com/parstat/csweb-resources.git
```

Navigate inside csweb-resources folder and run the stack deploy command, use option --with-registry-auth if the image is located into a private docker repository.
Or you can build the image inside the live server but is highly recommended to use a repository
```
$ docker stack deploy --compose-file docker-compose.yml --with-registry-auth csweb
```

You can access and configure the live environment in the following url:
```
https://{YOUR_SERVER_URL}:{MAPPED_PORT_OR_EMPTY_IF_80}/csweb
```
