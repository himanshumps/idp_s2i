FROM fedora

ENV \
    PATH="$PATH:"/usr/local/s2i":"/.npm/bin""
	
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

ENV MAVEN_VERSION 3.5.4 \
    
RUN curl -sSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
&& mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
&& ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN yum -y install tar gzip java java-devel bzip2 python python2 python-pip gcc-c++ make && yum clean all

RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -

RUN yum install -y nodejs

ENV JAVA_HOME /usr/lib/jvm/java-openjdk 

ENV NPM_CONFIG_PREFIX /.npm

ENV M2_HOME /usr/share/maven

COPY ./s2i/bin/ /usr/local/s2i

RUN mkdir /deployments /.npm 

RUN npm install -g @angular/cli@1.6.8 && npm link @angular/cli@1.6.8

RUN chown -R 185:185 /usr/local/s2i /tmp /deployments /.npm && chmod -R 777 /usr/local/s2i /tmp /deployments /.npm /usr/lib/node_modules

USER 185	