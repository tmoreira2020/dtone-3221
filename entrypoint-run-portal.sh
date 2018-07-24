#!/bin/bash

set -o errexit

run_portal() {
  if [ "$WEDEPLOY_PROJECT_MONITOR_DYNATRACE_TENANT" -a "$WEDEPLOY_PROJECT_MONITOR_DYNATRACE_TOKEN" ]; then
    exec /opt/dynatrace/oneagent/dynatrace-agent64.sh catalina.sh run
  else
    exec catalina.sh run
  fi
}

run_portal "$@"
