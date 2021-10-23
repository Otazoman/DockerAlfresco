ARG ALFRESCO_TAG
FROM alfresco/alfresco-content-repository-community:${ALFRESCO_TAG}

ARG TOMCAT_DIR=/usr/local/tomcat

USER root

# Add services configuration to alfresco-global.properties
ARG POSTGRE_USER
ARG POSTGRE_PASSWD
ARG POSTGRE_DB_NAME
ARG AD_SERVER
ARG AD_SERVER_IP
ARG NGINX_SERVER_NAME
ARG MAIL_HOST
ARG MAIL_USERNAME
ARG MAIL_PASSWORD
ARG MAIL_FROM
ARG MAIL_TEST_TO
ARG AD_SERVER
ARG AD_USER
ARG AD_DOMAIN
ARG AD_GLDOMAIN
ARG AD_PASSWD

RUN echo -e "\n\
db.username=${POSTGRE_USER}\n\
db.password=${POSTGRE_PASSWD}\n\
db.name=${POSTGRE_DB_NAME}\n\
system.serverMode=production\n\
\n\
#Attack protection\n\
authentication.protection.enabled=true\n\
authentication.protection.limit=5\n\
authentication.protection.periodSeconds=15\n\
\n\
#Trashcan Cleaner\n\
system.content.orphanProtectDays=14\n\
trashcan-cleaner.cron=0 30 * * * ?\n\
trashcan-cleaner.keepPeriod=P1D\n\
trashcan-cleaner.deleteBatchCount=1000\n\
\n\
#HTTPS NGIX PROXY SITE NAME\n\
#alfresco.context=alfresco\n\
#alfresco.host=${NGINX_SERVER_NAME}\n\
#alfresco.port=443\n\
#alfresco.protocol=https\n\
#share.context=share\n\
#share.host=${NGINX_SERVER_NAME}\n\
#share.port=443\n\
#share.protocol=https\n\
\n\
### E-mail site invitation setting ###\n\
notification.email.siteinvite=true\n\
\n\
### OUTbound smtp ###\n\
mail.host=${MAIL_HOST}\n\
mail.port=587\n\
mail.username=${MAIL_USERNAME}\n\
mail.password=${MAIL_PASSWORD}\n\
mail.encoding=UTF-8\n\
mail.from.default=${MAIL_FROM}\n\
mail.from.enabled=false\n\
mail.smtp.starttls.enable=false\n\
mail.smtp.auth=true\n\
mail.smtp.timeout=30000\n\
mail.testmessage.send=false\n\
mail.smtp.debug=false\n\
mail.testmessage.to=${MAIL_TEST_TO}\n\
\n\
### Auth and sync samba-ad ###\n\
authentication.chain=ldap-ad1:ldap-ad\n\
ntlm.authentication.sso.enabled=false\n\
ldap.authentication.active=true\n\
ldap.authentication.userNameFormat=%s@${AD_DOMAIN}.${AD_GLDOMAIN}\n\
ldap.authentication.java.naming.provider.url=ldap://${AD_SERVER}:389\n\
ldap.authentication.defaultAdministratorUserNames=${AD_USER}\n\
## First and last name reversal ###\n\
ldap.synchronization.active=true\n\
ldap.synchronization.java.naming.security.authentication=simple\n\
ldap.synchronization.java.naming.security.principal=${AD_USER}@${AD_DOMAIN}.${AD_GLDOMAIN}\n\
ldap.synchronization.java.naming.security.credentials=${AD_PASSWD}\n\
\n\
ldap.synchronization.userSearchBase=cn\=Users,dc\=${AD_DOMAIN},dc\=${AD_GLDOMAIN}\n\
ldap.synchronization.personQuery=(&(objectclass\=user)(userAccountControl\:1.2.840.113556.1.4.803\:\=512))\n\
ldap.synchronization.personDifferentialQuery=(&(objectclass\=user)(userAccountControl\:1.2.840.113556.1.4.803\:\=512)(!(whenChanged<\={0})))\n\
ldap.synchronization.userFirstNameAttributeName=sn\n\
ldap.synchronization.userLastNameAttributeName=givenName\n\
ldap.synchronization.userEmailAttributeName=mail\n\
ldap.synchronization.groupSearchBase=cn\=Users,dc\=${AD_DOMAIN},dc\=${AD_GLDOMAIN}\n\
ldap.synchronization.groupQuery=(&(objectclass\=group)(!(isCriticalSystemObject=true)))\n\
ldap.synchronization.groupDifferentialQuery=(&(objectclass\=group)(!(isCriticalSystemObject=true))(!(whenChanged<\={0})))\n\
ldap.synchronization.groupDisplayNameAttributeName=description\n\
ldap.synchronization.modifyTimestampAttributeName=whenChanged\n\
ldap.synchronization.timestampFormat=yyyyMMddHHmmss'.0Z'\n\
" >> $TOMCAT_DIR/shared/classes/alfresco-global.properties


# Install modules and addons
RUN mkdir -p $TOMCAT_DIR/amps
COPY modules/amps $TOMCAT_DIR/amps
COPY modules/jars $TOMCAT_DIR/webapps/alfresco/WEB-INF/lib

RUN java -jar $TOMCAT_DIR/alfresco-mmt/alfresco-mmt*.jar install \
    $TOMCAT_DIR/amps $TOMCAT_DIR/webapps/alfresco -directory -nobackup -force

# Install api-explorer webapp for REST API
ARG API_EXPLORER_TAG
ENV API_EXPLORER_TAG $API_EXPLORER_TAG
RUN yum -y update && \
 yum -y install wget && \
 yum clean all && \
 set -x \
    && wget https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/api-explorer/${API_EXPLORER_TAG}/api-explorer-${API_EXPLORER_TAG}.war \
    -O /usr/local/tomcat/webapps/api-explorer.war --no-check-certificate

# DATABASE
ARG DB
ENV DB $DB

# Install mysql JDBC driver
RUN if [ "$DB" == "mariadb" ] ; then \
    set -x \
        && yum install -y wget \
        && yum clean all \
        && wget -P /tmp/ http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.13.tar.gz \
        && tar xvf /tmp/mysql-connector-java-8.0.13.tar.gz -C /tmp/ \
        && cp /tmp/mysql-connector-java-8.0.13/mysql-connector-java-8.0.13.jar $TOMCAT_DIR/lib/ \
        && rm -rf /tmp/mysql-connector-java-8.0.13.tar.gz /tmp/mysql-connector-java-8.0.13; \
fi

