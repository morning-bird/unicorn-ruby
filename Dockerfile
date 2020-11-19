FROM phusion/baseimage:18.04-1.0.0-amd64
RUN apt-get update
# preparing environment
RUN apt-get install -y software-properties-common
RUN apt-get install -y \
    nginx nginx-common \
    git \
    libpng-dev libglib2.0-dev zlib1g-dev libbz2-dev libtiff5-dev libjpeg8-dev libpng16-16 zlib1g-dev \
    imagemagick imagemagick-common \
    dirmngr gnupg \
    curl \
    openssl \
    apt-transport-https ca-certificates \
    nodejs \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'
RUN apt-get update
RUN apt-get install -y libnginx-mod-http-passenger make
RUN ln -sf /usr/bin/nodejs /usr/local/bin/node
# install RVM, Ruby, and Bundler
RUN /bin/bash -l -c "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB"
RUN \curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "source /usr/local/rvm/scripts/rvm"
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.2.10-dev"
RUN /bin/bash -l -c "rvm --default use 2.2.10-dev"
RUN /bin/bash -l -c "gem install bcrypt"
RUN /bin/bash -l -c "gem install bundler -v 1.17.3 --no-ri --no-rdoc"
RUN echo '. /usr/local/rvm/scripts/rvm' >> ~/.bashrc
RUN echo 'rvm --default use 2.2.10-dev' >> ~/.bashrc
RUN apt-get install -y libmysqld-dev libmysqlclient-dev mysql-client
RUN mkdir /tmp/pids && mkdir /tmp/sockets
RUN /bin/bash -l -c "systemctl enable nginx"