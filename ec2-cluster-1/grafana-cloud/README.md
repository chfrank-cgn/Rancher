# Deconstructing Grafana Cloud

SUSE Rancher includes an operator-based Prometheus installation in the Apps Marketplace. For long-term storage, it can be beneficial to use a central instance for logging and monitoring, such as the Grafana Cloud.

## Prometheus

We install Prometheus from the Rancher Marketplace and make sure that the remote write feature is enabled and pointing to our Grafana Cloud tenant:

- `files/values.yaml` has the configuration

With a central store for metrics and logs, we can safely disable persistence and reduce retention.

## Events

To capture Kubernetes events, we will install the Grafana Agent first:

- `00-roles.yaml` has the service account and role bindings
- `01-config.yaml` has the config map
- `02-deployment.yaml` has the actual deployment

## Costs

For cost analysis, we will then install kubecost:

- `10-roles.yaml` has the service account and role bindings
- `11-config.yaml` has the config map
- `12-deployment.yaml` has the actual deployment
- `13-monitor.yaml` has the service monitor

## Longhorn backup

To allow backups from Longhorn, we configure a backup target:

- `files/values-longhorn.yaml` has the configuration
- `22-deployment.yaml` has a small NFS service for backup

## OPA Gatekeeper metrics

To collect metrics from OPA Gatekeeper, we will deploy a service and a service monitor:

- `32-deployment.yaml` has the service
- `33-monitor.yaml` has the service monitor

## Network Observability

To monitor the cluster network, we will install Retina from Microsoft:

- `40-roles.yaml` has the service account and role bindings
- `41-config.yaml` has the config map
- `42-deployment.yaml` has the daemonset
- `43-monitor.yaml` has the service monitor

## Syslog forwarding 

To forward the system and pod logs to Grafana Cloud, we will need to configure Rancher's logging operator:

- `51-config.yaml` has the cluster flow and output

## Navigation Link

As a finishing touch, we will put a navigation link to our Grafana Cloud tenant into the Rancher UI:

- `99-navlink.yaml` has the navigation link

Happy Ranching!

