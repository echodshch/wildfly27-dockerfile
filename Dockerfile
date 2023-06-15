FROM <docker image red-based os>
LABEL org.label-schema.schema-version=7.3.2 org.label-schema.name=REDOS_Base_Image
CMD ["/bin/bash"]
RUN dnf update -y && dnf -y install curl augeas bsdtar unzip && dnf clean all
RUN update-ca-trust
COPY russian_trusted_root_ca_pem.crt /usr/share/pki/ca-trust-source/anchors/russian_trusted_root_ca_pem.crt
COPY russian_trusted_sub_ca_pem.crt /usr/share/pki/ca-trust-source/anchors/russian_trusted_sub_ca_pem.crt
RUN update-ca-trust
RUN groupadd -r wildfly -g 1000 && useradd -u 1000 -r -g wildfly -m -d /opt/wildfly -s /sbin/nologin -c "Wildfly user" wildfly &&     chmod 755 /opt/wildfly
USER wildfly
USER root
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV JAVA_VERSION=jdk-17.0.7+7
COPY OpenJDK17U-jdk_x64_linux_hotspot_17.0.7_7.tar.gz OpenJDK17U-jdk_x64_linux_hotspot_17.0.7_7.tar.gz
RUN mkdir -p "$JAVA_HOME" && tar xf OpenJDK17U-jdk_x64_linux_hotspot_17.0.7_7.tar.gz && mv jdk-17.0.7+7/* $JAVA_HOME && rm OpenJDK17U-jdk_x64_linux_hotspot_17.0.7_7.tar.gz;
RUN echo Verifying install ... && fileEncoding="$(echo 'System.out.println(System.getProperty("file.encoding"))' | jshell -s -)"; [ "$fileEncoding" = 'UTF-8' ]; rm -rf ~/.java && echo javac --version && javac --version && echo java --version && java --version && echo Complete.
CMD ["jshell"]
USER wildfly
WORKDIR /opt/wildfly
ENV WILDFLY_VERSION=27.0.0.Final
ENV WILDFLY_SHA1=31106643002ae570444b4e30e376e27fff23cc2f
ENV JBOSS_HOME=/opt/wildfly
USER root
RUN cd $HOME && curl -L -O https://github.com/wildfly/wildfly/releases/download/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 && tar xf wildfly-$WILDFLY_VERSION.tar.gz && mv $HOME/wildfly-$WILDFLY_VERSION/* $JBOSS_HOME && rm wildfly-$WILDFLY_VERSION.tar.gz && chown -R wildfly:0 ${JBOSS_HOME} && chmod -R g+rw ${JBOSS_HOME} # buildkit
ENV LAUNCH_WILDFLY_IN_BACKGROUND=true
USER wildfly
EXPOSE 8080
CMD ["/opt/wildfly/bin/standalone.sh" "-b" "0.0.0.0"]
