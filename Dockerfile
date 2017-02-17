FROM centos:5
MAINTAINER alexander.neundorf@sharpreflections.com

# install a bunch of development packages
RUN yum update -y && \
    yum install libidn libXext mc joe nano wget strace subversion sudo -y && \
    yum install apr-devel apr-util-devel -y && \
    yum groupinstall "Development Tools" -y && \
    yum install libX11-devel libSM-devel libxml2-devel libjpeg-devel mesa-libGLU-devel freetype-devel -y


# install cmake
WORKDIR /opt
RUN mkdir -p /tmp/dl && \
    wget -P /tmp/dl --no-check-certificate https://cmake.org/files/v3.6/cmake-3.6.3-Linux-x86_64.tar.gz && \
    wget -P /tmp/dl --no-check-certificate https://cmake.org/files/v3.1/cmake-3.1.3-Linux-x86_64.tar.gz && \
    tar -zxvf /tmp/dl/cmake-3.6.3-Linux-x86_64.tar.gz && \
    tar -zxvf /tmp/dl/cmake-3.1.3-Linux-x86_64.tar.gz && \
    rm /tmp/dl/*


# build svn 1.7.22
RUN mkdir -p /tmp/src/

# get a recent enough sqlite:
WORKDIR /tmp/src
RUN wget http://www.sqlite.org/2016/sqlite-autoconf-3150100.tar.gz && \
    tar -zxvf sqlite-autoconf-3150100.tar.gz

# get Apache runtime
WORKDIR /tmp/src
RUN svn co http://svn.apache.org/repos/asf/apr/apr/branches/1.3.x apr-1.3 && \
    cd apr-1.3 && \
    ./buildconf && \
    ./configure --prefix=/opt/apr-1.3 --enable-shared --disable-static && \
    make -j4 && \
    make install

# get Apache apr-util
WORKDIR /tmp/src
RUN svn co  http://svn.apache.org/repos/asf/apr/apr-util/branches/1.3.x  apr-util-1.3  && \
    cd apr-util-1.3 && \
    ./buildconf --with-apr=../apr-1.3 && \
    ./configure --prefix=/opt/apr-1.3 --with-apr=../apr-1.3/ --enable-shared --disable-static && \
    make -j4 && \
    make install


# build svn 1.7
WORKDIR /tmp/src
RUN wget wget http://archive.apache.org/dist/subversion/subversion-1.7.22.tar.gz  &&  \
    tar -zxvf subversion-1.7.22.tar.gz && \
    mkdir /tmp/src/subversion-1.7.22/sqlite-amalgamation && \
    cp sqlite-autoconf-3150100/sqlite3.c /tmp/src/subversion-1.7.22/sqlite-amalgamation/    && \
    cd subversion-1.7.22 && \
    ./configure --prefix=/opt/svn-1.7 --without-berkeley-db --without-apxs --without-swig --with-ssl  --with-apr=/opt/apr-1.3/ --with-apr-util=/opt/apr-1.3/    && \
    nice make -j6 && \
    make install


# build svn 1.8
WORKDIR /tmp/src
RUN wget wget http://archive.apache.org/dist/subversion/subversion-1.8.16.tar.gz  && \
    tar -zxvf subversion-1.8.16.tar.gz && \
    cp -R sqlite-autoconf-3150100 subversion-1.8.16/sqlite-amalgamation && \
    cd subversion-1.8.16 && \
    ./configure --prefix=/opt/svn-1.8 --without-berkeley-db --without-apxs --without-swig --with-ssl --with-apr=/opt/apr-1.3/ --with-apr-util=/opt/apr-1.3/    && \
    nice make -j4 && \
    make install

# build git
WORKDIR /tmp/src
# wget from www.kernel.org failed with an ssl error. source packages in newer distros are usually xz, which we can't unpack on centos5
RUN wget http://ftp5.gwdg.de/pub/linux/slackware/slackware-12.2/source/d/git/git-1.6.0.3.tar.bz2 && \
    tar -jxvf git-1.6.0.3.tar.bz2 && \
    cd git-1.6.0.3 && \
    ./configure --prefix=/opt/git  && \
    make -j4 && \
    make install

# cleanup
RUN rm -rf /tmp/src
