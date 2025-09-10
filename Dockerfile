FROM jenkins/jenkins:2.441-alpine-jdk21
USER root
# Pipeline


# RUN jenkins-plugin-cli --plugins "workflow-aggregator github ws-cleanup greenballs simple-theme-plugin kubernetes docker-workflow kubernetes-cli github-branch-source" 
RUN jenkins-plugin-cli --plugins \
    github:latest \
    workflow-aggregator:latest \
    ws-cleanup:latest \
    simple-theme-plugin:latest \
    kubernetes:latest \
    pipeline-stage-view:latest \
    github-branch-source:latest


# install Maven, Java, Docker
RUN apk add --no-cache maven \
    openjdk17 \
    docker \
    gettext

# Kubectl
RUN     curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

# See https://github.com/kubernetes/minikube/issues/956.
# THIS IS FOR TESTING ONLY - it is not production standard (we're running as root!)
RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref
