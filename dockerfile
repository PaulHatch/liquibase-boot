FROM openjdk:8-jre-alpine AS liquibase

RUN apk add --no-cache bash

# download liquibase
ADD https://github.com/liquibase/liquibase/releases/download/v3.9.0/liquibase-3.9.0.tar.gz /tmp/liquibase-3.9.0.tar.gz

# Create a directory for liquibase
RUN mkdir /opt/liquibase

# Unpack the distribution
RUN tar -xzf /tmp/liquibase-3.9.0.tar.gz -C /opt/liquibase
RUN chmod +x /opt/liquibase/liquibase

# Symlink to liquibase to be on the path
RUN ln -s /opt/liquibase/liquibase /usr/local/bin/

# Get the postgres JDBC driver from http://jdbc.postgresql.org/download.html
ADD https://jdbc.postgresql.org/download/postgresql-42.2.12.jar /opt/jdbc_drivers/

# Add SnakeYaml so we can support YAML changelogs
ADD https://repo1.maven.org/maven2/org/yaml/snakeyaml/1.26/snakeyaml-1.26.jar /lib

RUN ln -s /opt/jdbc_drivers/postgresql-42.2.12.jar /usr/local/bin/

ADD liquibase.properties /liquibase.properties

# Add command scripts
ADD docker-init.sh /docker-init.sh

FROM liquibase

ENV DB_HOST=postgres
ENV DB_NAME=postgres
ENV DB_PORT=5432
ENV ROLLBACK=0
ENV VERSION=NONE

COPY changelog /changelog

WORKDIR /

ENTRYPOINT ["/bin/bash","docker-init.sh"]