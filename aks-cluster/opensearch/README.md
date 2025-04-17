# OpenSearch

Here is a quick setup for OpenSearch and the OpenTelemetry collector

> These steps are aimed at rapid setup and teardown!
> The deployments are neither highly available nor do they offer persistence 

## OpenSearch

The first piece of software we'll install is OpenSearch:

- `01-config.yaml` has the configuration
- `02-deployment.yaml` has the actual deployment

## Dashboard

Now that we have the data source, we'll install the Dashboard for analysis:

- `12-deployment.yaml` has the actual deployment

## Data Prepper

To process OpenTelemetry data in OpenSearch, we'll install Data Prepper:

- `21-config.yaml` has the configuration
- `22-deployment.yaml` has the actual deployment

## OpenTelemetry Contributed Collector - Metrics

To collect Kubernetes metrics, we'll install the contributed OpenTelemetry collector:

- `30-roles.yaml` has the service account and role bindings
- `31-config.yaml` has the configuration
- `32-deployment.yaml` has the actual daemon set

## OpenTelemetry Collector - Traces

To collect application traces, we'll install the regular OpenTelemetry collector:

- `41-config.yaml` has the configuration
- `42-deployment.yaml` has the actual deployment

## Jaeger v2

To visualize traces, we'll install Jaeger:

- `50-roles.yaml` has the service account and role bindings
- `51-config.yaml` has the configuration
- `52-deployment.yaml` has the actual deployment

## OpenTelemetry Contributed Collector - Events

To collect Kubernetes events, we'll install the contributed OpenTelemetry collector:

- `60-roles.yaml` has the service account and role bindings
- `61-config.yaml` has the configuration
- `62-deployment.yaml` has the actual daemon set

## Syslog forwarding 

To collect logs, we will configure Rancher's logging operator:

- `71-config.yaml` has the cluster flow and output

## Navigation Link

As a finishing touch, we will put a navigation link to the Dashboard into the Rancher UI:

- `99-navlink.yaml` has the navigation link

Happy Ranching!

