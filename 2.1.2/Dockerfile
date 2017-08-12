# docker build -t nawer/blazegraph:2.1.2 .
FROM openjdk:8-alpine
MAINTAINER Erwan Delahaye <erwan.delahaye@gmail.com>

RUN apk add --no-cache bash
# install blazegraph
ADD https://sourceforge.net/projects/bigdata/files/bigdata/2.1.2/blazegraph.jar/download /usr/bin/blazegraph.jar

RUN mkdir /docker-entrypoint-initdb.d

# Config files
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9999
CMD ["blazegraph"]