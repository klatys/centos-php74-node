FROM registry.centos.org/centos:latest

ENV INSTALL_PKGS="git wget curl unzip rpm-build rpmdevtools libsodium MariaDB-client"
ENV NODE_VERSION 14

RUN curl --silent --location https://rpm.nodesource.com/setup_$NODE_VERSION.x | bash - && \
    yum -y install wget curl unzip dos2unix rpm-build rpmdevtools git nodejs bzip2 freetype-devel fontconfig-devel openssh-clients epel-release https://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi && \
    yum -y install vips vips-devel make gcc-c++.x86_64 && \
    yum clean all && \
    npm install -g yarn --no-progress

RUN echo $'[mariadb]\nname = MariaDB\nbaseurl = http://yum.mariadb.org/10.2/centos7-amd64\nenabled = 1\ngpgcheck = 1' > /etc/yum.repos.d/MariaDB.repo && \
    rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && \
    yum -y install --setopt=tsflags=nodocs https://centos7.iuscommunity.org/ius-release.rpm epel-release && \
    yum -y update --setopt=tsflags=nodocs && \
    yum -y install --setopt=tsflags=nodocs $INSTALL_PKGS && \
    yum -y clean all

RUN yum update -y \
    && yum install -y xml-common \
    && yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum-config-manager --enable remi-php74 \
    && yum install -y gd gd-devel php php-common php-opcache php-mcrypt php-cli php-fpm php-gd php-curl php-mysqld php-pdo php-mysqlnd php-mysqli php-intl \
    && yum install -y php-zip php74-php-imap php74-php-xml php-xml php-process php-bcmath php-json php74-php-zip php74-php-mbstring php-mbstring php-pecl-redis

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    composer global require hirak/prestissimo

