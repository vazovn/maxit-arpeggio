FROM ubuntu AS standalone

ARG version=11.100

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
        bison \
        build-essential \
        ca-certificates \
        curl \
        flex \
        tcsh \
 && rm -rf /var/lib/apt/lists/*

RUN cd /opt \
 && curl -L https://sw-tools.rcsb.org/apps/MAXIT/maxit-v${version}-prod-src.tar.gz | tar xz

ENV RCSBROOT=/opt/maxit-v${version}-prod-src
ENV PATH=${PATH}:${RCSBROOT}/bin

RUN cd ${RCSBROOT} \
 && make \
 && make binary

COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

################################################################################

FROM standalone AS server

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
        openjdk-11-jdk-headless \
        maven \
 && rm -rf /var/lib/apt/lists/*

ARG jar=target/maxit-server-*.jar

COPY ${jar} /maxit-server.jar

CMD ["java", "-jar", "/maxit-server.jar"]
