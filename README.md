# csweb-resources
CSWeb (docker and installation documentation)

## Background
CSWeb is a web application that allows users to securely transfer cases (questionnaires) or files between client devices running CSEntry and a web server. CSWeb requires a web server running PHP and MySQL. 

![CSWeb](https://www.csprousers.org/help/CSWeb/synchronization_flow.png)

CSWeb eliminates the need to transfer data files by allowing users to instead transfer cases between client devices and a web server. CSEntry data entry applications that are configured to use CSWeb synchronization take advantage of Smart Synchronization, a feature that transfers only cases that are added or modified since the last successful synchronization. Smart Synchronization reduces data transfer costs and Internet bandwidth usage.
CSWeb uses a MySQL database on the server to store the cases for the census or survey data entry instrument. Unlike a file based synchronization that requires application designers to manage the concatenation of data files, CSWeb allows users to download a single file containing all the cases for the data entry instrument (once the cases are transferred from the client devices to the server).

## Installation in Ubuntu Server
### Apache
Apache is the most popular and stable web server for Ubuntu Linux. The Apache HTTP server for Ubuntu 20 provided by the apache2 package. To install apache2 on Ubuntu, open the terminal and execute:
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

Then copy and paste the above text just before “</VirtualHost>” closing tag using this command:
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
Next, we are going to install MySQL Server as our Database server. Installing MySQL Server on Ubuntu 20.04 is straightforward. Open the terminal update the package list and install the mysql-server package:

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
Grant permission to database csweb for user csweb:
```
mysql>GRANT ALL ON mysql.csweb TO 'csweb_user'@'localhost';
```
Exit mysql:
```
mysql>exit
```
Restart mysql:
```
$ sudo service mysql restart
```