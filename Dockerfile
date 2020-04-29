FROM debian:10

RUN apt update

RUN apt install ruby-full build-essential zlib1g-dev default-libmysqlclient-dev wget lsb-release -y

RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.13-1_all.deb && \
    dpkg -i mysql-apt-config* && \
    apt update && \
    apt install mariadb-server-10.3 -y

ADD . /opt

WORKDIR /opt

RUN gem install bundler && \
    bundle install --path vendor/cache 

COPY docker/entrypoint.sh /usr/bin/

# RUN adduser 1000 --force-badname --no-create-home --disabled-login --disabled-password --gecos "" && \
#     chown -R 1000:1000 /var/lib/mysql && \
#     chown -R 1000:1000 /var/log/mysql && \
#     sed -i '16d' /etc/mysql/mariadb.conf.d/50-server.cnf && \
#     echo $'\n\
#     [mysqld] \n\
#     user=1000' >> /etc/mysql/my.cnf && \
#     mkdir /var/run/mysqld/ && \
#     chown -R 1000:1000 /var/run/mysqld

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

VOLUME /var/lib/mysql

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
