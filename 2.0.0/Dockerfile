# docker build -t nawer/blazegraph:2.0.0 .
FROM openjdk:8-alpine
MAINTAINER Erwan Delahaye <erwan.delahaye@gmail.com>

RUN apk add --no-cache bash
# install blazegraph
ADD https://github.com/blazegraph/database/releases/download/BLAZEGRAPH_RELEASE_2_0_0/blazegraph.jar /usr/bin/blazegraph.jar

RUN mkdir /docker-entrypoint-initdb.d
RUN mkdir /var/lib/blazegraph

# Config files
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9999
CMD ["blazegraph"]