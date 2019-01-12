FROM jenkins/jenkins:lts

#ENV proxy_url "myproxy"
#ENV proxy_port 8080
#ENV http_proxy "http://${proxy_url}:${proxy_port}"
#ENV https_proxy=${http_proxy}

#ENV JAVA_OPTS="-Xmx8192m -Djenkins.install.runSetupWizard=false -Dhttp.proxyHost=${proxy_url} -Dhttp.proxyPort=${proxy_port} -Dhttps.proxyHost=${proxy_url} -Dhttps.proxyPort=${proxy_port}"
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_OPTS=" --handlerCountMax=300"

WORKDIR /var/jenkins_home
USER jenkins

#COPY proxy.xml /tmp/
#RUN cat /tmp/proxy.xml >> proxy.xml
COPY setup/security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY setup/plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN	/usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
