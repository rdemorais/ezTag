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

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

VOLUME /var/lib/mysql

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
