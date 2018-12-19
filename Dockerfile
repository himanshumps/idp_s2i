FROM alexsuch/angular-cli:6.2

# Labels
LABEL \
      description="Source To Image (S2I) image for IDP"  \
      io.k8s.description="Platform for building and running plain IDP application"  \
      io.k8s.display-name="IDP Applications"  \
      io.openshift.expose-services="8778/tcp:uec,8080/tcp:webcache,8443/tcp:pcsync-https"  \
      io.openshift.s2i.destination="/tmp"  \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"  \
	  io.s2i.scripts-url=image:///usr/libexec/s2i \
      io.openshift.tags="builder,java,idp"  \
      name="idp-openshift"  \
      org.jboss.deployments-dir="/deployments"  \
      summary="Source To Image (S2I) image for IDP"  \
      version="1.0"

EXPOSE 8778 8080 8443

ENV MAVEN_VERSION 3.5.4

ENV MAVEN_HOME /usr/lib/mvn

ENV PATH $MAVEN_HOME/bin:/usr/libexec/s2i:$PATH

#ENV NPM_CONFIG_PREFIX /npm

ENV M2_HOME /usr/lib/mvn

RUN mkdir -p /deployments /npm /npm/lib/node_modules/@angular/cli/node_modules/node-sass/vendor  /.npm  /.config && chmod -R 777 /tmp /deployments /npm  /.npm /.config

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u181

ENV JAVA_ALPINE_VERSION 8.181.13-r0

RUN set -x \
	&& apk add --no-cache \
		openjdk8="$JAVA_ALPINE_VERSION" \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]
	
	
COPY ./s2i/bin/ / 

RUN ls -al /usr/libexec/s2i

RUN chown -R 185:185 /usr/libexec/s2i

RUN chmod -R 777 /usr/libexec/s2i /tmp /deployments /npm /.npm  /.config

RUN ls -al /usr/libexec/s2i

USER 185	