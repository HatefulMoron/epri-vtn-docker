FROM ubuntu:18.04

# Use bash for sourcing the RVM file
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get upgrade -y

# Install RVM
RUN apt-get install -y software-properties-common wget tar make git &&\
  apt-add-repository -y ppa:rael-gc/rvm &&\
  apt-get update &&\
  apt-get install -y rvm &&\
  source /usr/share/rvm/scripts/rvm &&\
  rvm list

# Download a known good ruby-install version
RUN wget -O ruby-install-0.8.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.8.3.tar.gz &&\
  tar -xzvf ruby-install-0.8.3.tar.gz &&\
  cd ruby-install-0.8.3/ &&\
  make install 

# We need an old version of jruby (1.7.10) for executing the VTN, but we also
# need a recent version of jruby (9.2.9.0) to be able to actually download gems
# from the internet (the website rejects old versions because they don't
# support TLS 1.2)
RUN ruby-install jruby-1.7.10 &&\
  source /usr/share/rvm/scripts/rvm &&\
  rvm install jruby-9.2.9.0 &&\
  rvm use jruby-9.2.9.0 &&\
  gem install bundler:1.12.5

#RUN ls /usr/share/rvm/gems/jruby-9.2.9.0/gems/bundler-1.12.5/

# Get the VTN code, install bundle 1.12.5 so that we can get torquebox
# (Torquebox is discontinued, and can't be downloaded normally. The entire
# point of messing with the versions so far has been to get to this point.)
RUN source /usr/share/rvm/scripts/rvm &&\
  git clone https://github.com/epri-dev/OpenADR-Virtual-Top-Node ./epri &&\
  cd epri/ &&\
  bundle _1.12.5_ install &&\
  rvm install "jruby-1.7.10" &&\
  rvm gemset copy 9.2.9.0@oadr 1.7.10@oadr

RUN source /usr/share/rvm/scripts/rvm &&\
  rvm use jruby-1.7.10

RUN source /usr/share/rvm/scripts/rvm &&\
  cd epri/ &&\
  rake assets:precompile

RUN source /usr/share/rvm/scripts/rvm &&\
  cd epri/ &&\
  cp config/torquebox.yml.example config/torquebox.yml

RUN source /usr/share/rvm/scripts/rvm &&\
  cd epri/ &&\
  cp config/database.yml.example config/database.yml &&\
  sed -i 's/database: epri_oadr/database: ecogy-vtn/g' config/database.yml &&\
  sed -i 's/username: epri/username: ecogy/g' config/database.yml &&\
  sed -i 's/password: epri/password: ecogy/g' config/database.yml &&\
  sed -i 's/host: localhost/host: database/g' config/database.yml &&\
  cat config/database.yml

RUN source /usr/share/rvm/scripts/rvm &&\
  cd epri/ &&\
  cp config/initializers/secret_token.rb.example config/initializers/secret_token.rb &&\
  sed -i '$d' config/initializers/secret_token.rb &&\ 
  printf "Oadr::Application.config.secret_token = '" >> config/initializers/secret_token.rb &&\
  rake secret | tr -d '\n' >> config/initializers/secret_token.rb &&\
  printf "'\n" >> config/initializers/secret_token.rb 

RUN cat epri/config/initializers/secret_token.rb 

# Gah, Java 8 just hangs on start up. Java 7 works, but it's not in the
# repositories anymore. The suggested workaround for recent versions of Ubuntu
# doesn't work either, so we download the deb manually.

RUN wget https://cdn.azul.com/zulu/bin/zulu7.54.0.13-ca-jdk7.0.342-linux_amd64.deb &&\
  apt install -y ./zulu7.54.0.13-ca-jdk7.0.342-linux_amd64.deb

# Make sure we're using the right version

RUN java -version && find / -name java 

# Why do we use a separate file? Because the build process uses the database
# server. Docker-compose doesn't give us network access to the database server
# during build, so we have to do the final steps in the script.
ADD start.sh epri/start.sh
CMD ["bash", "epri/start.sh"]

