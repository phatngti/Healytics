FROM jenkins/jenkins:lts-jdk17

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      openssh-client \
      rsync \
    && rm -rf /var/lib/apt/lists/*

USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Jenkins Configuration as Code — auto-create nodes, credentials, etc.
# IMPORTANT: Do NOT place this under /var/jenkins_home — that path is
# overwritten at runtime by the docker-compose named volume mount.
COPY casc.yml /usr/share/jenkins/ref/casc.yml
ENV CASC_JENKINS_CONFIG=/usr/share/jenkins/ref/casc.yml

# Skip the manual setup wizard — JCasC handles admin user + plugins
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
