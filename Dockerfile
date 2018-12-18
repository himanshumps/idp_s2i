FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.3

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

RUN subscription-manager attach --auto

RUN yum install -y --disablerepo=\* --enablerepo=jboss-rhel-os --enablerepo=jboss-rhel-rhscl rh-maven35 npm \
    && yum clean all && rm -rf /var/cache/yum && \
    rpm -q  rh-maven35 npm

COPY ./s2i/bin/ /usr/local/s2i

RUN mkdir /deployments

RUN chown -R 185:185 /usr/local/s2i /tmp /deployments /.npm

USER 185	