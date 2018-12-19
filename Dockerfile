FROM centos/nodejs-8-centos7

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

ENV MAVEN_HOME /usr/local/src/apache-maven

ENV M2_HOME /usr/local/src/apache-maven

ENV PATH $MAVEN_HOME/bin:/usr/libexec/s2i:$PATH

RUN mkdir -p /deployments /npm /npm/lib/node_modules/@angular/cli/node_modules/node-sass/vendor  /.npm  /.config && chmod -R 777 /tmp /deployments /npm  /.npm /.config

RUN cd /usr/local/src && wget http://www-us.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz && tar -xf apache-maven-3.5.4-bin.tar.gz && mv apache-maven-3.5.4/ apache-maven/ 

RUN yum install -y java-1.8.0-openjdk-devel

COPY ./s2i/bin/ /usr/libexec/s2i/

RUN ls -al /usr/libexec/s2i/

RUN chown -R 1001:1001 /usr/libexec/s2i/

RUN chmod -R 777 /usr/libexec/s2i/ /tmp /deployments /npm /.npm  /.config

RUN ls -al /usr/libexec/s2i/

USER 185	

RUN ls -al /usr/libexec/s2i/