# TeamTat

### Publication
Rezarta Islamaj, Dongseop Kwon, Sun Kim, Zhiyong Lu, TeamTat: a collaborative text annotation tool, Nucleic Acids Research, 2020, gkaa333, 
https://doi.org/10.1093/nar/gkaa333

## How to build

### Prerequisite 
You need to install the following software packages in your server or computer.

- Ruby 2.5 
- MySQL 5.7 
- Git
- NodeJS

For more detailed instructions, please find the following articles.

- Windows:
  - https://medium.com/ruby-on-rails-web-application-development/how-to-install-rubyonrails-on-windows-7-8-10-complete-tutorial-2017-fc95720ee059
  - https://gorails.com/setup/windows/10
- Mac: https://gorails.com/setup/osx/10.14-mojave
- Linux: https://gorails.com/setup/ubuntu/19.04


### before Install
We need to install Docsplit to process PDF properly.
http://documentcloud.github.io/docsplit/
```
apt-get install -y graphicsmagick
apt-get install -y poppler-utils poppler-data
apt-get install -y ghostscript
apt-get install -y pdftk
```

### Basic Setup

1. Download the source code from the Git repository. Currently the repository is private. So you need a permission to access it. Soon, it will be transferred to a public repository such as NCBI GitHub repository.
```
  git clone git@github.com:ncbi-nlp/TeamTat.git
```

2. Configure config/database.yml 


3. You need to generate a new key and secrets. First, remove the credential file, then you need to input the following information.

```
rm ./config/credentials.yml.enc
EDITOR=vim rails credentials:edit
```

example
```
secret_key_base: << your secret key: will be auto-generated >>
google:
  client_id: << your google OAuth 2.0 client id - need for google login >>
  secret: << your google OAuth 2.0 client secret >>
recaptcha:
  site_key: << your recaptcha site key - for prevent spammer >> 
  secret: << your recaptcha secret - for prevent spammer >>
mailgun:
  key: << your mailgun key - for sending email from the server >>
```

You can generate your own google id from https://console.developers.google.com and reCAPTCHA key from https://www.google.com/recaptcha/admin.


4. Install ruby packages and create database
```
bundle install
rake db:create
rake db:migrate
```

5. Run the server on the local computer

```
rails s
```

6. Open the site from you web browser, such as Google Chrome
```
http://localhost:3000
```
### Deploy

The basic setup is suitable only for testing or small group. If you want to use the software in a production environment, you need to deploy the software. Please refer the following links for the detailed.

- Deploy Ruby On Rails: Ubuntu 18.04 Bionic Beaver in 2019 https://gorails.com/deploy/ubuntu/
- Deploying a Rails Application to Elastic Beanstalk: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/ruby-rails-tutorial.html


### Appendix: Deploy with Capistrano

https://capistranorb.com/documentation/getting-started/authentication-and-authorisation/
Add deploy user to the remote 
```
root@remote $ adduser deploy
root@remote $ passwd -l deploy

root@remote $ su - deploy
deploy@remote $ cd ~
deploy@remote $ mkdir .ssh
deploy@remote $ echo "ssh-rsa jccXJ/JRfGxnkh/8iL........dbfCH/9cDiKa0Dw8XGAo01mU/w== /Users/me/.ssh/id_rsa" >> .ssh/authorized_keys
deploy@remote $ chmod 700 .ssh
deploy@remote $ chmod 600 .ssh/authorized_keys


```

Ubuntu 19.04
https://gorails.com/setup/ubuntu/19.04 
``` sh
sudo apt install curl
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update
sudo apt-get install -y git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn

sudo apt-get -y install mysql-server mysql-client libmysqlclient-dev

sudo apt-get -y install nginx
sudo ufw app list
sudo ufw allow 'Nginx FULL'
sudo service nginx start

cd
su - deploy

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.5.1
rbenv global 2.5.1
ruby -v

gem install bundler
gem install bundler -v '2.0.1'
gem install rails -v 5.2.3

```

Database Setup
```
sudo mysql_secure_installation
mysql -u root -p
CREATE DATABASE pubqrator_production CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'deploy'@'localhost' IDENTIFIED BY '$omeFancyPassword123';
GRANT ALL PRIVILEGES ON pubqrator_production.* TO 'deploy'@'localhost';
FLUSH PRIVILEGES;
```

Deploy with Capistrano
```
ssh-add
cap production deploy
```
