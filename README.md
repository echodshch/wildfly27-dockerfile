Это Dockerfile для сборки Wildfly 27.0.0.Final на базе redhat-подобных дистрибутивов и с добавлением российских удостоверяющих центров. Сам дистриб нужно вписать в строку с FROM, тк я использовала RED OS, для которого отсутствует официальный образ.
jdk OpenJDK17U-jdk_x64_linux_hotspot_17.0.7_7 temurin;
user, group wildfly uid1000 gid1000
CMD ["/opt/wildfly/bin/standalone.sh" "-b" "0.0.0.0"]
JAVA_HOME=/opt/java/openjdk
WILDFLY_HOME=/opt/wildfly
