FROM jenkins/jenkins:lts-alpine

USER root

# Instalar dependencias: Maven, Docker CLI, gettext
RUN apk add --no-cache maven docker gettext

# Instalar kubectl con checksum
RUN curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" \
    && echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c - \
    && chmod +x kubectl && mv kubectl /usr/local/bin/ \
    && rm kubectl.sha256

# Plugins Jenkins (con lista controlada)
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Ajustar permisos
RUN chown -R jenkins:jenkins "$JENKINS_HOME" /usr/share/jenkins/ref

USER jenkins
