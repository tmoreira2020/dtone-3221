How to test

```
docker run \
  -e WEDEPLOY_PROJECT_MONITOR_DYNATRACE_TENANT=???? \
  -e WEDEPLOY_PROJECT_MONITOR_DYNATRACE_TOKEN=???? \
  -p 8080:8080 \
  --memory=4096m \
  tmoreira2020/dtone-3221:latest
```
