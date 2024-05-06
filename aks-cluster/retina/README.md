# Microsoft Retina

Here is a quick setup for the Retina Kubernetes Network Observability stack, using Prometheus as storage

> These steps are aimed at rapid setup and teardown!
> The deployments are neither highly available nor do they offer persistence 

## Retina Agent

The first part of the observability stack in the Retina Agent:

- `00-roles.yaml` has the agent service account and role bindings
- `01-config.yaml` has the agent configuration
- `02-deployment.yaml` has the agent daemon set and service

## Retina Operator

To enable Pod metrics and packet capture, we'll install the Retina Operator:

- `10-roles.yaml` has the operator service account and role bindings
- `11-config.yaml` has the operator configuration
- `12-deployment.yaml` has the operator deployment

## Retina Dashboards

To review the collected metrics, we'll use Grafana dashboards:

- `dashboards` has adapted dashboards

Happy Ranching!

