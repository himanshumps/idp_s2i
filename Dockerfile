FROM fedora

ENV \
    PATH="$PATH:"/usr/local/s2i""
	
# Labels
LABEL \
      description="Source To Image (S2I) image for IDP"  \
      io.k8s.description="Platform for building and running plain IDP application"  \
      io.k8s.display-name="IDP Applications"  \
      io.openshift.expose-services="8778/tcp:uec,8080/tcp:webcache,8443/tcp:pcsync-https"  \
      io.openshift.s2i.destination="/tmp"  \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i"  \
      io.openshift.tags="builder,java,idp"  \
      name="idp-openshift"  \
      org.jboss.deployments-dir="/deployments"  \
      summary="Source To Image (S2I) image for IDP"  \
      version="1.0"

EXPOSE 8778 8080 8443

USER root

ENV MAVEN_VERSION 3.5.4

RUN curl -sSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
&& mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
&& ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN yum -y install tar gzip java java-devel nodejs npm bzip2 && yum clean all

ENV JAVA_HOME /usr/lib/jvm/java-openjdk

ENV M2_HOME /usr/share/maven

COPY ./s2i/bin/ /usr/local/s2i

RUN mkdir /deployments /.npm /usr/lib/node_modules

RUN chown -R 185:185 /usr/local/s2i /tmp /deployments /.npm && chmod -R 777 /usr/local/s2i /tmp /deployments /.npm /usr/lib/node_modules

RUN npm install -g @angular/cli@1.6.8 && npm link @angular/cli@1.6.8

USER 185	