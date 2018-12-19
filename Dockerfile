FROM fedora

ENV \
    PATH="$PATH:"/usr/local/s2i":"/npm/bin""
	
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

ENV MAVEN_VERSION 3.5.4

ENV NPM_CONFIG_PREFIX /npm

ENV JAVA_HOME /usr/lib/jvm/java-openjdk

ENV M2_HOME /usr/share/maven

RUN mkdir -p /deployments /npm /npm/lib/node_modules/@angular/cli/node_modules/node-sass/vendor /usr/local/s2i /.npm  /.config && chmod -R 777 /tmp /deployments /npm /usr/local/s2i /.npm  /.config

RUN curl -sSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
&& mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
&& ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -

RUN yum -y install java java-devel bzip2 nodejs && yum clean all

#RUN sudo chmod -R 777 /npm && npm install -g @angular/cli@1.6.8 && npm link @angular/cli@1.6.8

COPY ./s2i/bin/ /usr/local/s2i 

RUN chmod -R 777 /usr/local/s2i /tmp /deployments /npm /.npm  /.config

USER 185	