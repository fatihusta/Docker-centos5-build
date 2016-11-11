FROM centos:5
MAINTAINER alexander.neundorf@sharpreflections.com

# install a bunch of packages
RUN yum update -y && \
    yum install libidn libXext mc joe wget strace subversion -y && \
    yum install apr-devel apr-util-devel -y && \
    yum groupinstall "Development Tools" -y && \
    yum install libX11-devel libSM-devel libxml2-devel libjpeg-devel mesa-libGLU-devel -y
#    yum remove kernel-devel -y


RUN mkdir -p /tmp/dl

# install cmake
WORKDIR /opt
RUN wget -P /tmp/dl --no-check-certificate https://cmake.org/files/v3.6/cmake-3.6.3-Linux-x86_64.tar.gz && \
    wget -P /tmp/dl --no-check-certificate https://cmake.org/files/v3.1/cmake-3.1.3-Linux-x86_64.tar.gz && \
    tar -zxvf /tmp/dl/cmake-3.6.3-Linux-x86_64.tar.gz && \
    tar -zxvf /tmp/dl/cmake-3.1.3-Linux-x86_64.tar.gz && \
    rm /tmp/dl/*


## build svn 1.7.22
# WORKDIR /tmp/
# RUN mkdir /tmp/src/ && \
#    cd /tmp/src && \
#    # get a recent enough sqlite: \
#    wget http://www.sqlite.org/2016/sqlite-autoconf-3150100.tar.gz && \
#    tar -zxvf sqlite-autoconf-3150100.tar.gz && \
#\
#    wget http://apache.mirror.iphh.net/subversion/subversion-1.7.22.tar.gz  &&  \
#    tar -zxvf subversion-1.7.22.tar.gz && \
#    mkdir /tmp/src/subversion-1.7.22/sqlite-amalgamation && \
#    cp sqlite-autoconf-3150100/sqlite3.c /tmp/src/subversion-1.7.22/sqlite-amalgamation/    && \
#    cd subversion-1.7.22 && \
#    ./configure --prefix=/opt/svn-1.7 --without-berkeley-db --without-apxs --without-swig --with-ssl  && \
#    nice make -j6 && \
#    make install && \
#\
#    cd /tmp/src && \
#    wget http://apache.mirror.iphh.net/subversion/subversion-1.8.16.tar.gz  && \
#    tar -zxvf subversion-1.8.16.tar.gz && \
#    cp -R sqlite-autoconf-3150100 subversion-1.8.16/sqlite-amalgamation && \
#    cd subversion-1.8.16 && \
#    ./configure --prefix=/opt/svn-1.8  --without-berkeley-db --without-apxs  --without-swig --with-ssl    && \
#    nice make -j4 && \
#    make install



#    # get Apache runtime \
#    cd /tmp/src/subversion-1.7.22/ && \
#    svn co http://svn.apache.org/repos/asf/apr/apr/branches/1.3.x apr && \
#    cd apr && \
#    ./buildconf && \
#    cd .. && \
#\
#    svn co  http://svn.apache.org/repos/asf/apr/apr-util/branches/1.3.x  apr-util  && \
#    cd apr-util && \
#    ./buildconf && \
#    cd .. && \



# get a more recent kernel sources. 3.10 is the LTS kernel used by RHEL7
#WORKDIR /usr/include
#RUN wget -P /tmp http://ftp.hosteurope.de/mirror/ftp.kernel.org/pub/linux/kernel/v3.0/linux-3.10.104.tar.gz
#    tar -zxvf /tmp/linux-3.10.104.tar.gz




#USER ${LOGNAME}
