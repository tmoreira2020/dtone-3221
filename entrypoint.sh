#!/bin/bash

set -o errexit

main() {
  entrypoint-process-monitor.sh
  exec entrypoint-run-portal.sh
}

main "$@"