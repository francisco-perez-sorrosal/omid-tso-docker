FROM java:8 

MAINTAINER Satan

RUN apt-get update

RUN echo "===> Install the basics..." \
 && DEBIAN_FRONTEND=noninteractive apt-get update \
 && apt-get install -yq --force-yes \
      gcc \
      g++ \
      make \
      sudo \
      vim \
      libprotobuf-dev \
      openssh-server \
      openssh-client \
 && apt-get clean && rm -rf \
      /var/lib/apt/lists/*

RUN echo "===> Install Maven..." \
 && apt-get update \
 && apt-get install -y maven

RUN echo "===> Install Protobuf..." \
 && wget https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz \
 && tar -xzvf protobuf-2.5.0.tar.gz \
 && cd protobuf-2.5.0 \
 && ./configure --prefix=/usr \
 && make \
 && sudo make install \
 && cd ..

RUN echo "===> Install Omid..." \
 && curl -o apache-omid-incubating-0.8.2.0-src.tar.gz https://dist.apache.org/repos/dist/release/incubator/omid/omid-incubating-0.8.2.0/apache-omid-incubating-0.8.2.0-src.tar.gz \
 && tar xvfz apache-omid-incubating-0.8.2.0-src.tar.gz \
 && cd apache-omid-incubating-0.8.2.0-src \
 && mvn clean install -Phbase-0 -DskipTests

WORKDIR /apache-omid-incubating-0.8.2.0-src

EXPOSE 54758

ADD omid-conf/log4j.xml /apache-omid-incubating-0.8.2.0-src/tso-server/conf
ADD omid-conf/omid.yml /apache-omid-incubating-0.8.2.0-src/tso-server/conf

CMD ["./tso-server/bin/omid.sh", "tso"]
