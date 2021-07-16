from ros:noetic

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get -y update
RUN apt -y install make gcc g++ git wget vim curl openssh-server
RUN apt -y install gazebo11 libgazebo11-dev libjansson-dev libboost-dev imagemagick libtinyxml-dev mercurial cmake build-essential

RUN cd ~ && git clone https://github.com/osrf/gzweb
RUN cd ~/gzweb && git checkout gzweb_1.4.1

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && source /usr/share/gazebo/setup.sh \
    && cd ~/gzweb/ \
    && npm run deploy --- -m


ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH


RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 rosuser 
RUN echo 'rosuser:password' | chpasswd
RUN service ssh start

EXPOSE 22
EXPOSE 8080
EXPOSE 7681

CMD ["/usr/sbin/sshd","-D"]

ENTRYPOINT bash


