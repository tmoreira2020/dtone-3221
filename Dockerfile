FROM tomcat:9.0.6

USER root

ADD ./entrypoint-* /usr/local/bin/
ADD ./entrypoint.sh /usr/local/bin/entrypoint

RUN set -x && \
  apt-get update -y && \
  apt-get -qq install -y \
    jq

#
# Dynatrace installation
#
ARG DT_TENANT
ARG DT_API_TOKEN
ARG DT_ONEAGENT_OPTIONS="flavor=default&include=java"
ARG DT_ONEAGENT_DOWNLOAD_URL="https://${DT_TENANT}.live.dynatrace.com/api/v1/deployment/installer/agent/unix/paas/latest?Api-Token=${DT_API_TOKEN}&${DT_ONEAGENT_OPTIONS}"

RUN if [ "x${DT_TENANT}" = "x" ]; then echo "=> ERROR: DT_TENANT not set as 'arg'!"; return 1; fi
RUN if [ "x${DT_API_TOKEN}" = "x" ]; then echo "=> ERROR: DT_API_TOKEN not set as 'arg'!"; return 1; fi

ENV DT_HOME="/opt/dynatrace/oneagent"

RUN install --verbose --owner root --group root --directory ${DT_HOME}

RUN curl --output "${DT_HOME}/oneagent.zip" "${DT_ONEAGENT_DOWNLOAD_URL}" && \
  unzip -d "${DT_HOME}" "${DT_HOME}/oneagent.zip" && \
  cat /opt/dynatrace/oneagent/dynatrace-env.sh && \
  sed -i -e "s/${DT_TENANT}/tenant-to-replace/g" /opt/dynatrace/oneagent/dynatrace-env.sh && \
  sed -i -e "s/DT_TENANTTOKEN:-[[:alnum:]]*/DT_TENANTTOKEN:-token-to-replace/g" /opt/dynatrace/oneagent/dynatrace-env.sh && \
  sed -i -Ee "s/DT_CONNECTION_POINT:-\"([[:alnum:]]|:|\/|-|\.|;)*\"/DT_CONNECTION_POINT:-\"connectionpoint-to-replace\"/g" /opt/dynatrace/oneagent/dynatrace-env.sh && \
  sed -i -e "s/${DT_TENANT}/tenant-to-replace/g" /opt/dynatrace/oneagent/manifest.json && \
  sed -i -e "s/tenantToken\" : \"[[:alnum:]]*/tenantToken\" : \"token-to-replace/g" /opt/dynatrace/oneagent/manifest.json && \
  sed -i -Ee "s/communicationEndpoints\" : \[(\"|[[:alnum:]]|[[:space:]]|:|\/|-|\.|,)*\]/communicationEndpoints\" : \[\"connectionpoint-to-replace\"\]/g" /opt/dynatrace/oneagent/manifest.json && \
  cat /opt/dynatrace/oneagent/dynatrace-env.sh && \
  rm "${DT_HOME}/oneagent.zip"

ENTRYPOINT ["entrypoint"]